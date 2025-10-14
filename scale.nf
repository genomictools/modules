process SCALE {
    tag "${cohort}:${category}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/scaled", mode: 'copy')

    input:
    tuple val(cohort), val(category),
          path(bim), path(bed), path(fam), path(log),
          val(n_samples), val(n_variants)

    output:
    tuple val(cohort), val(category),
          path("${cohort}.${category}.eigenvec"),
          path("${cohort}.${category}.eigenval"),
          path("${cohort}.${category}.log")

    script:
    """
    #!/bin/bash        
    # Perform PCA with no clusters
    plink \
        --bfile ${bim.baseName} \
        --pca ${params.dimension} \
        --out ${cohort}.${category} \
        > ${cohort}.${category}.log 2>&1
    """
}
