process CLEAN {
    tag "${cohort}:${key}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/clean", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type), path(cnv), path(cnv_log),
          val(dbsnp), path(txt), path(pfb)

    output:
    tuple val(cohort), val(key), val(type),
          path("${cohort}.${key}.clean.${type}"),
          path("${cohort}.${key}.clean.${type}.log")

    script:
    """
    #!/bin/bash
    clean_cnv.pl \
        combineseg \
        --fraction ${params.fraction} \
        --signalfile ${pfb} \
        ${cnv} \
        --output ${cohort}.${key}.clean.${type} \
        &> ${cohort}.${key}.clean.${type}.log
    """
}