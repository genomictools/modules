process SELECT {
    tag "${cohort}:${key}"

    label 'simple'
    label 'exomedepth'

    publishDir("${params.output_dir}/select", mode: 'copy')

    input:
    tuple val(cohort), 
          val(key), path(test_counts),
          val(ref), path(ref_counts)

    output:
    tuple val(cohort), val(key),
          path("${cohort}.${key}.stats.tsv")

    script:
    """
    #!/bin/bash
    select_ref.R ${test_counts} ${ref_counts.join(',')} ${params.bins} ${cohort}.${key}.stats.tsv
    """
}
