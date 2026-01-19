process ROH {
    tag "${cohort}:${tool}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/roh", mode: 'copy')

    input:
    tuple val(cohort), val(tool),
          path(bim), path(bed), path(fam), path(log),
          env(n_samples), env(n_variants)

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
      -bfile ${bim.baseName} \
      --out "${cohort}.${tool}.roh"

    # Count the number of markers
    nmarkers=\$(wc -l < "${cohort}.${tool}.roh.hom")
    """
}
