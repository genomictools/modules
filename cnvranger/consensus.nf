process CONSENSUS {
    tag "${cohort}:${gene}"

    label 'simple'
    label 'cnvranger'

    publishDir("${params.output_dir}/consensus", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(key), val(tool),
          path(cnv), val(nmarker)

    output:
    tuple val(cohort), val(gene),
          path("${cohort}.${gene}.consensus.tsv"),
          env(nmarker)

    script:
    """
    #!/bin/bash
    create_consensus.R ${cnv.join(',')} ${params.cn} ${params.ratio} ${params.stats} ${params.width} "${params.style}" ${cohort}.${gene}.consensus.tsv
    nmarker=\$(grep -vc '^#' ${cohort}.${gene}.consensus.tsv || true)
    """
}
