process COORDINATES {
    tag "${gene}:${feature}"

    label 'simple'
    label 'bioconductor'

    publishDir("${params.output_dir}/coordinates", mode: 'copy')

    input:
    tuple val(gene), val(feature)

    output:
    tuple val(gene), val(feature), path("${gene}.${feature}.bed")

    script:
    """
    #!/bin/bash
    get_coordinates.R "${gene}" "${feature}" "${gene == 'reference' ? params.bins : 1 }" "${params.species}" "${params.genome}" "${params.style}" "${gene}.${feature}.bed"
    """
}

