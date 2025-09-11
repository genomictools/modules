process DEEPMVP {
    tag "${params.assembly}:${tool}:${params.version}:${id}"

    label 'simple'
    label 'deepmvp'

    publishDir("${params.output_dir}/annotations/${tool}", mode: 'copy')

    input:
    tuple val(id), path(file), path(index), val(n_variants), val(tool)

    output:
    tuple val("${params.assembly}"), val("${tool}"), val("${params.version}"), val(id),
          path("${params.assembly}.${tool}.${params.version}.${id}.scores.tsv"),
          env(n_variants)

    script:
    """
    #!/bin/bash
    # Extract variants
    bcftools view -H ${file} | cut -f 1-5 > ${id}.variants.tsv

    # Translate protein consequences
    python /DeepMVP/DeepMVP.py translate \
        -i ${id}.variants.tsv \
        -o ${id}.protvar.tsv
    
    # call deepmvp
    python /DeepMVP/DeepMVP.py predict \
        -i ${id}.protvar.tsv \
        -m ${params.models}/ \
        -d ${params.uniprot} \
        -t 1 \
        -o .

    # Rename file
    cat deepmvp-mutation_impact.tsv > ${params.assembly}.${tool}.${params.version}.${id}.scores.tsv

    # Count the number of variants
    n_variants=\$(cat ${params.assembly}.${tool}.${params.version}.${id}.scores.tsv | wc -l)
    """
}
