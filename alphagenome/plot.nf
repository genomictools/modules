process PLOT {
    tag "${cohort}:${variant}:${ontology}:${assay}:${sequence_length}"

    label 'simple'
    label 'alphagenome'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(cohort), val(variant), val(ontology), val(assay), val(sequence_length),
          path(reference), path(alternate), path(status)

    output:
    tuple val(cohort), val(variant), val(ontology), val(assay), val(sequence_length),
          path("${cohort}.${variant}.${ontology}.${assay}.${sequence_length}.plot.png")

    secret 'API_KEY'
    // nextflow secret set API_KEY <api_key>

    script:
    """
    #!/bin/bash
    plot_variant.py \
        --variant ${variant} \
        --ontology ${ontology} \
        --assay ${assay} \
        --sequence_length ${sequence_length} \
        --reference ${reference} \
        --alternate ${alternate} \
        --gtf ${params.gtf} \
        --plot ${cohort}.${variant}.${ontology}.${assay}.${sequence_length}.plot.png
    """
}
