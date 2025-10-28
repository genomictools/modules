process DICTFASTA {
    tag "${assembly}:${fasta_id}"

    label 'simple'
    label 'gatk'

    publishDir("${params.output_dir}/fasta", mode: 'copy')

    input:
    tuple val(assembly), val(fasta_id), path(fasta), path(fasta_fai)

    output:
    tuple val(assembly), val(fasta_id), path(fasta), path(fasta_fai),
        path("${assembly}.${fasta_id}.dict")


    script:
    """
    #!/bin/bash
    gatk CreateSequenceDictionary \
        -R ${fasta} \
        -O ${assembly}.${fasta_id}.dict
    """
}
