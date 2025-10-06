process PLINK {
    tag "${cohort}:${key}:${tool}:${type}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log),
          val(nmarkers),
          val(tool), val(type)

    output:
    tuple val(cohort), val(key), val(tool), val(type),
          path("${cohort}.${key}.${tool}.${type}.*"),
          path("${cohort}.${key}.${tool}.${type}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    plink \
      --homozyg \
      --homozyg-snp ${params.numsnp} \
      --homozyg-density ${params.window} \
      --homozyg-window-snp ${params.window} \
      --homozyg-kb ${params.length.toInteger() / 1000} \
      --homozyg-gap ${params.maxlength.toInteger() / 1000} \
      -lfile ${file[0].baseName} \
      --out "${cohort}.${key}.${tool}.${type}"

    # Count the number of markers
    nmarkers=\$(wc -l < "${cohort}.${key}.${tool}.${type}.hom")
    """
}
