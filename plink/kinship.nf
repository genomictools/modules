process KINSHIP {
    tag "${cohort}:${key}:${level}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/kinship", mode: 'copy')

    input:
    tuple val(cohort), val(level),
          path(bim), path(bed), path(fam), path(log),
          val(nmarkers)

    output:
    tuple val(cohort), val(level),
          path("${cohort}.${level}.*")

    script:
    """
    #!/bin/bash
    plink \
      --genome \
      -bfile ${bim.baseName} \
      --out "${cohort}.${level}"
    """
}
