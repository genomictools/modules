process MATRIXEQTL {
    tag "${cohort}:${category}"

    label 'simple'
    label 'matrix_eqtl'

    publishDir("${params.output_dir}/matrix_eqtl", mode: 'copy')

    input:
    tuple val(cohort), val(category),
          path(snps), path(traits), path(cvrt),
          val(tool)

    output:
    tuple val(cohort), val(category), val(tool),
          path("${cohort}.${category}.${tool}.txt"),
          path("${cohort}.${category}.${tool}.log")

    script:
    """
    #!/bin/bash
    # Run tool
    matrix_eqtl.R ${snps} ${traits} ${cvrt} ${cohort}.${category}.${tool}.txt 2> ${cohort}.${category}.${tool}.log
    """
}
