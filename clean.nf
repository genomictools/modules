process CLEAN {
    tag "${cohort}:${key}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/clean", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(cnv), 
          val(dbsnp), path(txt), path(pfb)

    output:
    tuple val(cohort), val(key), path("${cohort}.${key}.clean.cnv")

    script:
    """
    #!/bin/bash
    clean_cnv.pl \
        combineseg \
        --fraction ${params.fraction} \
        --signalfile ${pfb} \
        ${cnv} \
        --output ${cohort}.${key}.clean.cnv
    """
}