process SPLIT {
    tag "${assembly}"

    label 'simple'
    label 'bedtools'

    publishDir("${params.output_dir}/beds", mode: 'copy')

    input:
    tuple val(assembly), path(file)

    output:
    tuple val(assembly), path("${assembly}.chunk.*.bed")

    script:
    """
    #!/bin/bash
    # Split the BED file into chunks
    bedtools split \
        -i ${file} \
        -n ${params.chunk} \
        -p ${assembly}.chunk
    
    # Sort each chunk by chromosome and coordinate
    for chunk_file in ${assembly}.chunk.*.bed; do
        if [ -f "\$chunk_file" ]; then
            sort -k1,1 -k2,2n "\$chunk_file" > "\${chunk_file}.sorted"
            mv "\${chunk_file}.sorted" "\$chunk_file"
        fi
    done
    """
}
