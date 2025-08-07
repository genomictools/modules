process PLOT {
    tag "${cohort}:${test}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(cohort), val(category), val(test), path(test_file), path(test_log)

    output:
    tuple val(cohort), val(category), val(test),
          path("${cohort}.${category}.${test}.png")

    script:
    """
    #!/bin/bash
    plot_manhattan.R ${cohort} ${category} ${test} ${test_file}
    """
}