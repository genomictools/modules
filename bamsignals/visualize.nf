process VISUALIZE {
    tag "${cohort}:${gene}:${test_key}"

    label 'simple'
    label 'bamsignals'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(cohort), val(test_key), val(type), path(test_cov),
          val(ref_key), path(ref_coverage),
          val(gene)

    output:
    tuple val(cohort), val(gene), val(test_key),
          path("${cohort}.${gene}.${test_key}.cov.png")

    script:
    """
    #!/bin/bash
    visualize_bam.R ${cohort} ${gene} ${test_key} ${test_cov} ${ref_key.join(',')} ${ref_coverage.join(',')} ${cohort}.${gene}.${test_key}.cov.png
    """
}
