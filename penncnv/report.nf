process REPORT {
    tag "${cohort}:${tool}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/report", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(cnv), path(cnv_log), val(nmarkers)

    output:
    tuple val(cohort), val(tool), val(type),
          path("${cohort}.${tool}.${type}.report.tsv")

    script:
    """
    #!/bin/bash
    filter_cnv.pl \
        ${cnv} \
        --qclogfile ${cnv_log} \
        --qcsumout ${cohort}.${tool}.${type}.report.tsv
    """
}
