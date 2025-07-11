process TEST {
    tag "${cohort}:${test}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/tests", mode: 'copy')

    input:
    tuple val(cohort), path(bim), path(bed), path(fam), path(log), val(test)

    output:
    tuple val(cohort), val(test), path("${cohort}.${test}"), path("${cohort}.${test}.log")

    script:
    """
    #!/bin/bash
    # Run test
    plink \
        --bfile ${bim.baseName} \
        --${test} \
        --out tmp
    cat tmp.assoc | tr -s '\r[:blank:]' '\t' > ${cohort}.${test}
    cat tmp.log > ${cohort}.${test}.log
    """
}
