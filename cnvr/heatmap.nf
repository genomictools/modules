process HEATMAP {
    tag "${cohort}:${tool}:${feature}:${type}"

    label 'simple'
    label 'cnvr'

    publishDir("${params.output_dir}/heatmaps", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(feature), val(type),
          path(cnv), path(cnv_log), val(cnv_nmarkers),
          val(features), val(feature_list)

    output:
    tuple val(cohort), val(tool), val(feature), val(type),
          path("${cohort}.${tool}.${feature}.${type}.heatmap.png"),
          path("${cohort}.${tool}.${feature}.${type}.heatmap.log")

    script:
    """
    #!/bin/bash
    heatmap.R ${cohort} ${tool} ${feature} ${cnv} ${type} ${feature_list.join(',')} ${params.n_samples} ${params.n_genes} 2> ${cohort}.${tool}.${feature}.${type}.heatmap.log
    """
}
