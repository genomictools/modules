process SELECT {
    tag "${cohort}:${gene}:${key}"

    label 'simple'
    label 'coveragemaster'

    publishDir("${params.output_dir}/select/coveragemaster", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(key),
          path(depth), path(stats),
          path(ref_depth), path(ref_stats)

    output:
    tuple val(cohort), val(gene), val(key), 
          path("${cohort}.${key}.case.cov"),
          path("${cohort}.${key}.case.report.txt"),
          path("${cohort}.*.control.cov"),
          path("${cohort}.*.control.report.txt"),
          path("${cohort}.${key}.control_list.txt"),
          path("${cohort}.${key}.mean_sd.cov")

    script:
    """
    #!/bin/bash
    set -euo pipefail

    # prepare coverage files for cases and controls
    for i in ${depth} ${ref_depth.join(' ')}; do
        out=\$(basename \${i} .${gene}.gene.bed)
        cat \${i} | cut -f 1,2,5 > \${out}.cov
    done
    ls *.control.cov > ${cohort}.${key}.control_list.txt

    # prepare stats files for cases and controls
    for i in ${stats} ${ref_stats.join(' ')}; do
        out=\$(basename \${i} .flagstats.txt)
        cat \${i} | cut -f 1,2,5 > \${out}.report.txt
    done
    ls *.control.report.txt > ${cohort}.${key}.report_list.txt

    # aggregate reference samples
    awk -f ${projectDir}/bin/aggregate_cov.awk ${cohort}.${key}.control_list.txt ${cohort}.${key}.report_list.txt | \
        sort -k1,1 -k2,2n \
        > ${cohort}.${key}.mean_sd.cov
    """
}
