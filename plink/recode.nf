process RECODE {
    tag "${cohort}:${key}:${level}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/genotypes", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(lgen), path(map), path(fam), path(log),
          val(nmarkers)

    output:
    tuple val(cohort), val(key), val(level),
          path("${cohort}.${key}.${level}.recoded.bim"),
          path("${cohort}.${key}.${level}.recoded.bed"),
          path("${cohort}.${key}.${level}.recoded.fam"),
          path("${cohort}.${key}.${level}.recoded.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    plink \
      --make-bed \
      --set-hh-missing \
      -lfile ${lgen.baseName} \
      --out "${cohort}.${key}.${level}.recoded"

    # Count the number of markers
    nmarkers=\$(wc -l < "${cohort}.${key}.${level}.recoded.bim")
    """
}
