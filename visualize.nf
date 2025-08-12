process VISUALIZE {
    tag "${cohort}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/tables", mode: 'copy')

    input:
    tuple val(cohort), val(feature), path(cnv), path(cnv_log),
          val(format)

    output:
    tuple val(cohort), val(feature),
          path("${cohort}.${format}"),
          path("${cohort}.${format}.log")

    script:
    """
    #!/bin/bash
    visualize_cnv.pl \
        ${cnv} \
        -format ${format} \
        -track "${cohort}" \
        > ${cohort}.${format} \
        &> ${cohort}.${format}.log
    """
}