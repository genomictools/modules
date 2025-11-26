process RGADA {
    tag "${cohort}:${key}:${tool}"

    label 'simple'
    label 'rgada'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(tool), val(type)
          

    output:
    tuple val(cohort), val(key), val(tool), val(type),
          path("${cohort}.${key}.${tool}.{cnv,loh}"),
          path("${cohort}.${key}.${tool}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Call GADA
    RGadaIndividual.R ${file} ${params.a_alpha} ${params.t_statistic} ${params.min_seg_length} ${cohort}.${key}.${tool} >& ${cohort}.${key}.${tool}.log

    # Count the number of markers
	nmarkers="\$(wc -l < "${cohort}.${key}.${tool}.cnv"),\$(wc -l < "${cohort}.${key}.${tool}.loh")"
	"""
}

