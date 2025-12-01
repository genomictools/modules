process RGADA {
    tag "${cohort}:${key}:${level}"

    label 'simple'
    label 'rgada'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(tool)
          

    output:
    tuple val(cohort), val(key), val(tool),
          path("${cohort}.${key}.${tool}.cnv"),
          path("${cohort}.${key}.${tool}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Call GADA
    RGadaIndividual.R ${file} ${params.a_alpha} ${params.t_statistic} ${params.numsnp} ${cohort}.${key}.${tool} >& ${cohort}.${key}.${tool}.log
	# Count the number of markers
	nmarkers="\$(wc -l < "${cohort}.${key}.${tool}.cnv")"
	"""
}

