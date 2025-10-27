process SCORE {
    tag "${cohort}:${variant}:${organism}:${sequence_length}"

    label 'simple'
    label 'alphagenome'

    publishDir("${params.output_dir}/scores", mode: 'copy')

    input:
    tuple val(cohort), val(variant), val(organism), val(sequence_length)

    output:
    tuple val(cohort), val(variant), val(organism), val(sequence_length),
          path("${cohort}.${variant}.${organism}.${sequence_length}.scores.csv")
    
    secret 'API_KEY'
    // nextflow secret set API_KEY <api_key>

    script:
    """
    #!/bin/bash
    score_variant.py \
        --api_key \$API_KEY \
        --variant ${variant} \
        --organism ${organism} \
        --sequence_length ${sequence_length} \
        --scores ${cohort}.${variant}.${organism}.${sequence_length}.scores.csv
    """
}
