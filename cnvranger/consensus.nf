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
    create_consensus.R ${cnv.join(',')} 2 .5 3 ${cohort}.${gene}.consensus.tsv
    nmarker=\$(grep -vc '^#' ${cohort}.${gene}.consensus.tsv || true)
    """
}
//     # create_consensus.R ${tool} ${cnv} ${params.cn} ${params.ratio} ${params.stat} ${cohort}.${gene}.consensus.tsv
