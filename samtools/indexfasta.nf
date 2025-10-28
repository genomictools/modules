process INDEXFASTA {
    tag "${assembly}:${fasta_id}"

    label 'simple'
    label 'samtools'

    publishDir("${params.output_dir}/fasta", mode: 'copy')

    input:
    tuple val(assembly), val(fasta_id), path(fasta)

    output:
    tuple val(assembly), val(fasta_id), path(fasta),
        path("${assembly}.${fasta_id}.fasta.fai")


    script:
    """
    #!/bin/bash
    samtools faidx ${fasta}
    """
}
