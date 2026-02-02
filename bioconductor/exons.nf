process EXONS {
    tag "${gene}"

    label 'simple'
    label 'bioconductor'

    publishDir("${params.output_dir}/exons", mode: 'copy')

    input:
    val(gene)

    output:
    tuple val(gene), path("${params.species}.${params.genome}.${params.style}.${gene}.exons.bed")

    script:
    """
    #!/bin/bash
    get_exons.R "${gene}" "${params.bins}" "${params.species}" "${params.genome}" "${params.style}" "${params.regions != null ? file(params.regions) : 'null'}"
    """
}
