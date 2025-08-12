process ADJUST {
    tag "${cohort}:${key}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/adjusted", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(file), path(log),
          val(dbsnp), file(gcm), file(gcm_log)

    output:
    tuple val(cohort), val(key),
          path("${cohort}.${key}.data.txt.adjusted"),
          path("${cohort}.${key}.adjusted.log")

    script:
    """
    #!/bin/bash
    genomic_wave.pl \
        -adjust \
        -gcmodelfile ${gcm} \
        -distance ${params.distance} \
        ${file} \
        &> ${cohort}.${key}.adjusted.log
    """
}