process IDAT2GTC {
    tag "${cohort}:${key}:${level}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/signal", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers)

    output:
    tuple val(cohort), val(key), val("gtc"),
      path("*.gtc"),
      path("${cohort}.${key}.${level}.log"),
      val(0)

    script:
    """
    #!/bin/bash
    bcftools +idat2gtc \
      --bpm ${file(params.manifest)} \
      --egt ${file(params.clusters)} \
      --idats . \
      --output . \
      2> ${cohort}.${key}.${level}.log
    """
}
