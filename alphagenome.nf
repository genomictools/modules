process ALPHAGENOME {
    tag "${params.species}:${params.tool}:${params.version}:${id}"

    label 'simple'
    label 'alphagenome'

    publishDir("${params.output_dir}/annotations", mode: 'copy')

    input:
    tuple val(id), path(file), path(index)

    output:
    tuple val("${params.species}"), val("${params.tool}"), val("${params.version}"),
          val(id),
          path("${params.species}.${params.tool}.${params.version}.${id}.scores.csv")
    
    secret 'API_KEY'
    // nextflow secret set API_KEY <api_key>

    script:
    """
    #!/bin/bash
    query_alphagenome.py \
        --api_key \$API_KEY \
        --vcf_file ${file} \
        --organism ${params.species} \
        --sequence_length ${params.distance} \
        --output ${params.species}.${params.tool}.${params.version}.${id}.scores.csv
    """
}
