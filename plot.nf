process PLOT {
    tag "${cohort}:${test}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(cohort), val(test), path(test_file), path(test_log)

    output:
    tuple val(cohort), val(test), path("${cohort}.${test}.png")

    script:
    """
    #!/bin/bash
    plot_manhattan.R ${cohort} ${test} ${test_file}
    """
}