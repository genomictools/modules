process CODEX {
    tag "${cohort}:${gene}:${test_key}"

    label 'simple'
    label 'codex'

    publishDir("${params.output_dir}/calls/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(gene),
          val(test_key), path(test_counts),
          val(ref_key), path(ref_counts),
          path(gc), path(pmap),
          val(tool)

    output:
    tuple val(cohort), val(gene), val(test_key), val(tool),
          path("${cohort}.${gene}.${test_key}.cnv.tsv"),
          env(nmarker), emit: calls, optional: true

    tuple val(cohort), val(gene), val(test_key), val(tool),
          path("${cohort}.${gene}.${test_key}.cnv.rds"), emit: rds, optional: true

    tuple val(cohort), val(gene), val(test_key), val(tool),
          path("${cohort}.*.${test_key}.cnv.png"), emit: plots, optional: true

    script:
    """
    #!/bin/bash
    codex.R ${cohort} ${gene} ${test_key} ${test_counts} ${ref_key.join(',')} ${ref_counts.join(',')} ${gc} ${pmap}
    export nmarker=\$(grep -vc '^#' ${cohort}.${gene}.${test_key}.cnv.tsv || true)
    """
}
