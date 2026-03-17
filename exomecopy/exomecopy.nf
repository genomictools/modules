process EXOMECOPY {
    tag "${cohort}:${gene}:${key}"

    label 'simple'
    label 'exomecopy'

    publishDir("${params.output_dir}/calls/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(gene),
          val(key), path(test_counts),
          val(ref_key), path(ref_counts),
          path(gc), path(pmap),
          val(tool)

    output:
    tuple val(cohort), val(gene), val(key), val(tool),
          path("${cohort}.${gene}.${key}.${tool}.cnv.tsv"),
          env(nmarker), emit: calls, optional: true

    tuple val(cohort), val(gene), val(key), val(tool),
          path("${cohort}.${gene}.${key}.${tool}.cnv.rds"), emit: rds, optional: true

    tuple val(cohort), val(gene), val(key), val(tool),
          path("${cohort}.*.${key}.${tool}.cnv.png"), emit: plots, optional: true

    script:
    """
    #!/bin/bash
    exomecopy.R ${cohort} ${gene} ${key} ${tool} ${test_counts} ${ref_key.join(',')} ${ref_counts.join(',')} ${gc} ${pmap} ${params.prob}
	export nmarker=\$(grep -vc '^#' ${cohort}.${gene}.${key}.${tool}.cnv.tsv || true)
    """
}
