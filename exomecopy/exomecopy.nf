process EXOMECOPY {
    tag "${cohort}:${gene}:${test_key}"

    label 'simple'
    label 'exomecopy'

    publishDir("${params.output_dir}/calls/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(gene),
          val(test_key), path(test_counts),
            val(ref_key), path(ref_counts),
            val(tool)

    output:
    tuple val(cohort), val(gene), val(test_key), val(tool),
          path("${cohort}.${gene}.${test_key}.cnv.tsv"),
          path("${cohort}.${gene}.${test_key}.cnv.rds", optional: true),
          path("${cohort}.*.${test_key}.cnv.png", optional: true),
          env(nmarker)

    script:
    """
    #!/bin/bash
    exomecopy.R ${cohort} ${gene} ${test_key} ${test_counts} ${ref_key.join(',')} ${ref_counts.join(',')} ${params.prob}
	nmarker=\$(grep -vc '^#' ${cohort}.${gene}.${test_key}.cnv.tsv || true)
    """
}
