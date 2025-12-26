process SCATTER {
    tag "${cohort}:${key}.${type}:${tool}:${feature}:${region}"

    label 'simple'
    label 'cnvr'

    publishDir("${params.output_dir}/scatter", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type), val(tool), val(region),
          val(feature), val(feature_list), val(n_features),
          val(level), path(signal), path(signal_log), val(signal_nmarkers),
       	  path(pfb)

    output:
    tuple val(cohort), val(key), val(type), val(tool), val(feature), val(feature_list), val(region),
		  path("${cohort}.${key}.${type}.${tool}.${feature}.${feature_list.join('_')}.${region}.{lrr,baf}.png"),
		  path("${cohort}.${key}.${type}.${tool}.${feature}.${feature_list.join('_')}.${region}.log")

    script:
    """
    #!/bin/bash
    scatter.R ${signal} ${feature} ${feature_list.join(',')} ${region} ${pfb} ${file(params.anno)} ${cohort}.${key}.${type}.${tool}.${feature}.${feature_list.join('_')}.${region} 2> ${cohort}.${key}.${type}.${tool}.${feature}.${feature_list.join('_')}.${region}.log
    """
}
