process TEST {
    tag "${cohort}:${test}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/tests", mode: 'copy')

    input:
    tuple val(cohort), val(category),
          path(bim), path(bed), path(fam), path(nosex), path(log),
          val(test),
          path(phenotypes)

    output:
    tuple val(cohort), val(category), val(test),
          path("${cohort}.${category}.*.${test}"),
          path("${cohort}.${category}.nosex"),
          path("${cohort}.${category}.log")

    script:
    """
    #!/bin/bash
    # Run test
    plink \
        --bfile ${bim.baseName} \
        --${test} \
        --all-pheno \
        --pheno ${phenotypes} \
        --allow-no-sex \
        --out ${cohort}.${category}
    """
}
