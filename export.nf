process EXPORT {
    tag "${cohort}:${feature}:${type}:${format}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/tables", mode: 'copy')

    input:
    tuple val(cohort), val(feature), val(type),
          path(cnv), path(cnv_log), val(nmarkers),
          val(format)

    output:
    tuple val(cohort), val(feature), val(type),
          path("${cohort}.${feature}.${type}.${format}"),
          path("${cohort}.${feature}.${type}.${format}.log")

    script:
    """
    #!/bin/bash
    visualize_cnv.pl \
        ${cnv} \
        -format ${format} \
        -track "${cohort}" \
        > ${cohort}.${feature}.${type}.${format} \
        2> ${cohort}.${feature}.${type}.${format}.log
    """
}