process ADJUST {
    tag "${cohort}:${key}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/adjusted", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(file),
          val(dbsnp), file(gcm)

    output:
    tuple val(cohort), val(key), path("${cohort}.${key}.signal.txt.adjusted")

    script:
    """
    #!/bin/bash
    genomic_wave.pl \
        -adjust \
        -gcmodel ${gcm} \
        ${file}
    """
}