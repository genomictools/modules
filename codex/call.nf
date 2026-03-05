process CALL {
    tag "${cohort}:${gene}:${test_key}"

    label 'simple'
    label 'codex'

    publishDir("${params.output_dir}/calls/codex", mode: 'copy')

    input:
    tuple val(cohort), val(gene), 
          val(test_key), path(test_counts),
          val(ref_key), path(ref_counts)

    output:
    tuple val(cohort), val(gene), val(test_key), val("codex"),
          path("${cohort}.${gene}.${test_key}.cnv.tsv"),
          path("${cohort}.${gene}.${test_key}.cnv.png"),
          env(nmarker)

    script:
    """
    #!/bin/bash
    codex.R ${cohort} ${gene} ${test_key} ${test_counts} ${ref_key.join(',')} ${ref_counts.join(',')}
	nmarker=\$(grep -v '^#' ${cohort}.${gene}.${test_key}.cnv.tsv | wc -l)
    """
}   
