process VISUALIZE {
    tag "${cohort}:${feature}:${format}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/tables", mode: 'copy')

    input:
    tuple val(cohort), val(feature), path(cnv), path(cnv_log),
          val(format)

    output:
    tuple val(cohort), val(feature),
          path("${cohort}.${feature}.${format}"),
          path("${cohort}.${feature}.${format}.log")

    script:
    """
    #!/bin/bash
    visualize_cnv.pl \
        ${cnv} \
        -format ${format} \
        -track "${cohort}" \
        > ${cohort}.${feature}.${format} \
        2> ${cohort}.${feature}.${format}.log
    """
}