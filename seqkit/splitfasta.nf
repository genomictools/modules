process SPLITFASTA {
    tag "${assembly}"

    label 'simple'
    label 'seqkit'

    publishDir("${params.output_dir}/fasta", mode: 'copy')

    input:
    tuple val(assembly), path(fasta)

    output:
    tuple val(assembly), path("${assembly}.*.fasta")

    script:
    """
    #!/bin/bash
    seqkit split \
        ${fasta} \
        --by-id \
        --by-id-prefix "${assembly}." \
        --out-dir .
    """
}

