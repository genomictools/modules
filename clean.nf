process CLEAN {
    tag "${cohort}:${key}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/clean", mode: 'copy')

    input:
    tuple val(cohort), val(type), 
          path(cnv), path(cnv_log), val(nmarkers),
          val(dbsnp), path(txt), path(pfb)

    output:
    tuple val(cohort), val(type),
          path("${cohort}.clean.${type}"),
          path("${cohort}.clean.${type}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    clean_cnv.pl \
        combineseg \
        --fraction ${params.fraction} \
        --signalfile ${pfb} \
        ${cnv} \
        --output ${cohort}.clean.${type} \
        &> ${cohort}.clean.${type}.log

    nmarkers=\$(wc -l < "${cohort}.clean.${type}")
    """
}