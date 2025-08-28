process RGADA {
    tag "${cohort}:${key}:${tool}:${type}"

    label 'simple'
    label 'rgada'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(tool), val(type)
          

    output:
    tuple val(cohort), val(key), val(tool), val(type),
          path("${cohort}.${key}.${tool}.${type}"),
          path("${cohort}.${key}.${tool}.${type}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    RGadaIndividual.R \
        --input ${file} \
        --output ${cohort}.${key}.${tool}.${type} \
        --t_statistic ${params.t_statistic} \
        --a_alpha ${params.a_alpha} \
        --min_seg_length ${params.min_seg_length} \
        >& ${cohort}.${key}.${tool}.${type}.log

    nmarkers=\$(wc -l < "${cohort}.${key}.${tool}.${type}")
    """
}

