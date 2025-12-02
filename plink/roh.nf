process ROH {
    tag "${cohort}:${tool}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/roh", mode: 'copy')

    input:
    tuple val(cohort), val(tool),
          path(lgen), path(map), path(fam), path(log),
          val(nmarkers)

    output:
    tuple val(cohort), val(tool),
          path("${cohort}.${tool}.roh.hom"),
          path("${cohort}.${tool}.roh.log"),
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
      --out "${cohort}.${tool}.roh"

    # Count the number of markers
    nmarkers=\$(wc -l < "${cohort}.${tool}.roh.hom")
    """
}
