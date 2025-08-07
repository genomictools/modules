process TEST {
    tag "${cohort}:${test}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/tests", mode: 'copy')

    input:
    tuple val(cohort), val(category),
          path(bim), path(bed), path(fam), path(nosex), path(log),
          val(test)

    output:
    tuple val(cohort), val(category), val(test),
          path("${cohort}.${category}.${test}"),
          path("${cohort}.${category}.${test}.log")

    script:
    """
    #!/bin/bash
    # Run test
    plink \
        --bfile ${bim.baseName} \
        --${test} \
        --allow-no-sex \
        --out tmp
    cat tmp.assoc | tr -s '\r[:blank:]' '\t' > ${cohort}.${category}.${test}
    cat tmp.log > ${cohort}.${category}.${test}.log
    """
}
