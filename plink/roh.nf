process ROH {
    tag "${cohort}:${key}:${level}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/roh", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(lgen), path(map), path(fam), path(log),
          val(nmarkers)

    output:
    tuple val(cohort), val(key), val(level),
          path("${cohort}.${key}.${level}.hom"),
          path("${cohort}.${key}.${level}.roh.log"),
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
      -lfile ${lgen.baseName} \
      --out "${cohort}.${key}.${level}" \
      >> "${cohort}.${key}.${level}.roh.log" 2>&1

    # Count the number of markers
    nmarkers=\$(wc -l < "${cohort}.${key}.${level}.hom")
    """
}
