process TEST {
    tag "${cohort}:${test}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/tests", mode: 'copy')

    input:
    tuple val(cohort), val(category),
          path(bim), path(bed), path(fam), path(log),
          val(n_samples), val(n_variants),
          val(test),
          path(phenotypes),
          path(covariates)

    output:
    tuple val(cohort), val(category), val(test),
          path("${cohort}.${category}.*.${test}"),
          path("${cohort}.${category}.${test}.log")

    script:
    // Named flags
    def test_flags = []
    if ( params.test_flags[test] == null ) { test_flags << " "}
    def test_flags_str = test_flags.join(' ')

    // Flags
    def args = []
    if ( params.allow_nosex ) { args << "--allow-no-sex" }
    if ( params.all_pheno )   { args << "--all-pheno" }
    if ( params.adjust != 'none' ) { args << "--covar ${covariates}" }
    def args_str = args.join(' ')

    """
    #!/bin/bash
    # Run test
    plink \
        --bfile ${bim.baseName} \
        --${test} ${test_flags_str} \
        --pheno ${phenotypes} \
        --out ${cohort}.${category} \
        ${args_str} \
        > ${cohort}.${category}.${test}.log 2>&1
    """
}
