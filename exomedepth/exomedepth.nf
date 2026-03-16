process EXOMEDEPTH {
    tag "${cohort}:${gene}:${key}"

    label 'simple'
    label 'exomedepth'

    publishDir("${params.output_dir}/calls/${tool}/", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(key),
          path(test_counts),
          path(ref_counts),
          val(tool)

    output:
    tuple val(cohort), val(gene), val(key), val(tool),
          path("${cohort}.${gene}.${key}.cnv.tsv"),
          env(nmarker), emit: calls, optional: true

    tuple val(cohort), val(gene), val(key), val(tool),
          path("${cohort}.${gene}.${key}.cnv.rds"), emit: rds, optional: true

    tuple val(cohort), val(gene), val(key), val(tool),
          path("${cohort}.*.${key}.cnv.png"), emit: plots, optional: true

    script:
    """
    #!/bin/bash
    exomedepth.R ${cohort} ${gene} ${key} ${test_counts} ${ref_counts.join(',')} ${params.prob}
	nmarker=\$(grep -vc '^#' ${cohort}.${gene}.${key}.cnv.tsv || true)
    """
}
