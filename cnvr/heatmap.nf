process HEATMAP {
    tag "${cohort}:${tool}:${feature}:${type}"

    label 'simple'
    label 'cnvr'

    publishDir("${params.output_dir}/heatmaps", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(feature), val(type),
          path(cnv), path(cnv_log), val(cnv_nmarkers)
      //     ,
      //     val(feature_list)

    output:
    tuple val(cohort), val(tool), val(feature), val(type),
          path("${cohort}.${tool}.${feature}.${type}.heatmap.png"),
          path("${cohort}.${tool}.${feature}.${type}.heatmap.log")

    script:
	def feature_list = []
	if ( params.genelist && feature == 'refgene' ) {
		feature_list = file(params.genelist).readLines()
	} else if ( params.bandlist && feature == 'anno' ) {
		feature_list = file(params.bandlist).readLines()
	} else {
		feature_list = []
	}
    """
    #!/bin/bash
    heatmap.R ${cohort} ${tool} ${feature} ${type} ${cnv} ${feature_list.join(',')} ${params.n_samples} ${params.n_genes} 2> ${cohort}.${tool}.${feature}.${type}.heatmap.log
    """
}
