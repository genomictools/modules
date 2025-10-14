process PLOT {
    tag "${cohort}:${test}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(cohort), val(category), val(test), val(phenotype),
          path(test_file), path(test_log)

    output:
    tuple val(cohort), val(category), val(test), val(phenotype),
          path("${cohort}.${category}.${test}.${phenotype}.png")

    script:
    """
    #!/bin/bash
    plot_manhattan.R ${cohort} ${category} ${test} ${phenotype} ${test_file}
    """
}