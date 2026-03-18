process COORDINATES {
    tag "${gene}"

    label 'simple'
    label 'bioconductor'

    publishDir("${params.output_dir}/coordinates", mode: 'copy')

    input:
    tuple val(gene), path(genes_list)

    output:
    tuple val(gene), path("${gene}.gene.bed"), path("${gene}.exon.bed")

    script:
    """
    #!/bin/bash
    get_coordinates.R "${gene}" "${genes_list}" "${gene == 'reference' ? params.bins : 1 }" "${params.species}" "${params.genome}" "${params.style}"
    """
}
