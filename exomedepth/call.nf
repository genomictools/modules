process CALL {
    tag "${cohort}:${gene}:${key}"

    label 'simple'
    label 'exomedepth'

    publishDir("${params.output_dir}/calls", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(key),
          path(test_counts),
          path(ref_counts)

    output:
    tuple val(cohort), val(gene), val(key), 
          path("${cohort}.${gene}.${key}.cnv.rds"),
          path("${cohort}.${gene}.${key}.cnv.tsv"),
          env(nmarker)

    script:
    """
    #!/bin/bash
    call_cnv.R ${cohort} ${gene} ${key} ${test_counts} ${ref_counts.join(',')} ${params.prob}
	nmarker=\$(grep -v '^#' ${cohort}.${gene}.${key}.cnv.tsv | wc -l)
    """
}
