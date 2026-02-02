process REPORT {
    tag "${cohort}:${type}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/reports", mode: 'copy')

    input:
    tuple val(cohort), val(type), path(stats), val(nlines)

    output:
    tuple val(cohort), val(type),
          path("${cohort}.${type}.*.png")

    script:
    """
    #!/bin/bash
    report_summary.R ${cohort} ${type} ${stats}
    """
}
