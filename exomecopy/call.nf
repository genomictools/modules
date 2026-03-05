process CALL {
    tag "${cohort}:${gene}:${test_key}"

    label 'simple'
    label 'exomecopy'

    publishDir("${params.output_dir}/calls/exome_copy", mode: 'copy')

    input:
    tuple val(cohort), val(gene), 
          val(test_key), path(test_counts),
          val(ref_key), path(ref_counts)

    output:
    tuple val(cohort), val(gene), val(test_key), val("exomecopy"),
          path("${cohort}.${gene}.${test_key}.cnv.tsv"),
          path("${cohort}.${gene}.${test_key}.cnv.rds"),
          path("${cohort}.${gene}.${test_key}.cnv.png"),
          env(nmarker)

    script:
    """
    #!/bin/bash
    exomecopy.R ${cohort} ${gene} ${test_key} ${test_counts} ${ref_key.join(',')} ${ref_counts.join(',')} ${params.prob}
	nmarker=\$(grep -v '^#' ${cohort}.${gene}.${test_key}.cnv.tsv | wc -l)
    """
}   
