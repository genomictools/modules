process PREDICT {
    tag "${cohort}:${variant}:${ontology}:${assay}:${sequence_length}"

    label 'simple'
    label 'alphagenome'

    publishDir("${params.output_dir}/predictions", mode: 'copy')

    input:
    tuple val(cohort), val(variant), val(ontology), val(assay), val(sequence_length)

    output:
    tuple val(cohort), val(variant), val(ontology), val(assay), val(sequence_length),
          path("${cohort}.${variant}.${ontology}.${assay}.${sequence_length}.reference.txt"),
          path("${cohort}.${variant}.${ontology}.${assay}.${sequence_length}.alternate.txt"),
          path("${cohort}.${variant}.${ontology}.${assay}.${sequence_length}.status.txt")
    
    secret 'API_KEY'
    // nextflow secret set API_KEY <api_key>

    script:
    """
    #!/bin/bash
    predict_variant.py \
        --api_key \$API_KEY \
        --variant ${variant} \
        --ontology ${ontology} \
        --assay ${assay} \
        --sequence_length ${sequence_length} \
        --reference ${cohort}.${variant}.${ontology}.${assay}.${sequence_length}.reference.txt \
        --alternate ${cohort}.${variant}.${ontology}.${assay}.${sequence_length}.alternate.txt \
        --status ${cohort}.${variant}.${ontology}.${assay}.${sequence_length}.status.txt
    """
}
