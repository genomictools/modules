process CALL {
    tag "${cohort}:${gene}:${key}"

    label 'simple'
    label 'coveragemaster'

    publishDir("${params.output_dir}/calls/coveragemaster", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(key),
          path(depth), path(stats),
          path(ref_depth), path(ref_stats),
          path(ref_list), path(ref_aggregate)

    output:
    tuple val(cohort), val(gene), val(key), val("coveragemaster"),
          path("${cohort}.${gene}.${key}.cnv.tsv"),
          path("${cohort}.${gene}.${key}.CMcalls"),
          path("${cohort}.${gene}.${key}.CMreport"),
          path("${cohort}.${gene}.${key}.CMpositives.pdf"),
          path("${cohort}.${gene}.${key}.CM.log")

    script:
    """
    #!/bin/bash
    # call cnvs
    python /opt/coverageMaster/coverageMaster.py \
        ${depth} \
        ${stats} \
        ${gene} \
        -c ${ref_list} \
        -r ${ref_aggregate} \
        -o ${cohort}.${gene}.${key}

    awk -v cohort=${cohort} -v gene=${gene} -v key=${key} '
        BEGIN {
            OFS="\t"
            print "seqnames","start","end","exon_start","exon_end","cn","cov","norm_cov","ratio","stats","cohort","key","gene"
        }
        {
            for (i=1; i<=NF-4; i++) {
                if (\$i ~ /^chr[0-9XYM]+\$/ && \$(i+1) ~ /^[0-9]+\$/ && \$(i+2) ~ /^[0-9]+\$/ && (\$(i+3)=="DUP" || \$(i+3)=="DEL") && \$(i+4) ~ /^[0-9]+\$/) {
                    print \$i, \$(i+1), \$(i+2), "NA", "NA", (\$(i+3)=="DUP" ? 3 : 1), "NA", "NA", "NA", "NA", cohort, key, gene
                }
            }
        }
    ' ${cohort}.${gene}.${key}.CMcalls > ${cohort}.${gene}.${key}.cnv.tsv
    """
}
