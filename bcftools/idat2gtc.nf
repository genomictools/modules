process IDAT2GTC {
    tag "${cohort}:${key}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/gtc", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(file)

    output:
    tuple val(cohort), val(key), path("*.gtc")

    script:
    """
    #!/bin/bash
    bcftools +idat2gtc \
		--bpm ${file(params.bpm)} \
		--egt ${file(params.egt)} \
		--idats . \
		--output .
    """
}
