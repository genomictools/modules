process VISUALIZE {
    tag "${cohort}:${gene}:${key}"

    label 'simple'
    label 'bamsignals'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(key),
          val(samples), path(coverage)

    output:
    tuple val(cohort), val(gene), val(key),
          path("${cohort}.${gene}.${key}.cov.png")

    script:
    """
    #!/bin/bash
    visualize_bam.R ${cohort} ${gene} ${key} ${samples.join(',')} ${coverage.join(',')} ${cohort}.${gene}.${key}.cov.png
    """
}
