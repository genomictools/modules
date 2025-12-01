process CLEAN {
    tag "${cohort}:${tool}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/clean", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(cnv), path(cnv_log), val(nmarkers),
          path(pfb)

    output:
    tuple val(cohort), val(tool), val(type),
          path("${cohort}.${tool}.clean.${type}"),
          path("${cohort}.${tool}.clean.${type}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    clean_cnv.pl \
        combineseg \
        --fraction ${params.fraction} \
        --signalfile ${pfb} \
        ${cnv} \
        --output ${cohort}.${tool}.clean.${type} \
        &> ${cohort}.${tool}.clean.${type}.log

    nmarkers=\$(wc -l < "${cohort}.${tool}.clean.${type}")
    """
}