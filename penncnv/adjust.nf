process ADJUST {
    tag "${cohort}:${key}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/adjusted", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          path(gcm)

    output:
    tuple val(cohort), val(key), val('adjusted'),
          path("${file.toString()}.adjusted"),
          path("${file.toString()}.adjusted.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    genomic_wave.pl \
        -adjust \
        -gcmodelfile ${gcm} \
        -distance ${params.distance} \
        ${file} \
        &> "${file.toString()}.adjusted.log"

    nmarkers=\$(wc -l < "${file.toString()}.adjusted")
    """
}