process HEATMAP {
    tag "${cohort}:${feature}:${type}"

    label 'simple'
    label 'cnvr'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(cohort), val(feature), val(type),
          path(cnv), path(cnv_log), val(cnv_nmarkers),
          val(genelist)

    output:
    tuple val(cohort), val(feature), val(type),
          path("${cohort}.${feature}.${type}.heatmap.png"),
          path("${cohort}.${feature}.${type}.heatmap.log")

    script:
    """
    #!/bin/bash
    heatmap.R ${cohort} ${feature} ${cnv} ${type} ${genelist.join(',')} ${params.n_samples} ${params.n_genes} 2> ${cohort}.${feature}.${type}.heatmap.log
    """
}
