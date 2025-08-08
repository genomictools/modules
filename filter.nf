process FILTER {
    tag "${cohort}:${category}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/filtered", mode: 'copy')

    input:
    tuple val(cohort), val(category),
          path(bim), path(bed), path(fam), path(nosex), path(log)

    output:
    tuple val(cohort), val(category),
          path("${cohort}.${category}.filtered.bim"),
          path("${cohort}.${category}.filtered.bed"),
          path("${cohort}.${category}.filtered.fam"),
          path("${cohort}.${category}.filtered.nosex"),
          path("${cohort}.${category}.filtered.log")

    script:
    """
    #!/bin/bash
    # Filter variants
    plink \
        --bfile ${bim.baseName} \
        --mind ${params.mind} \
        --geno ${params.geno} \
        --maf ${params.maf} \
        --hwe ${params.hwe} \
        --make-bed \
        --out ${cohort}.${category}.filtered
    """
}
