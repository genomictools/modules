process EXPORT {
    tag "${cohort}:${tool}:${feature}:${type}:${format}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/tables", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(feature), val(type),
          path(cnv), path(cnv_log), val(nmarkers),
          val(format)

    output:
    tuple val(cohort), val(tool), val(feature), val(type),
          path("${cohort}.${tool}.${feature}.${type}.${format}"),
          path("${cohort}.${tool}.${feature}.${type}.${format}.log")

    script:
    """
    #!/bin/bash
    visualize_cnv.pl \
        ${cnv} \
        -format ${format} \
        -track "${cohort}" \
        > ${cohort}.${tool}.${feature}.${type}.${format} \
        2> ${cohort}.${tool}.${feature}.${type}.${format}.log
    """
}