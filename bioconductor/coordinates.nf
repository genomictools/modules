process COORDINATES {
    tag "${gene}"

    label 'simple'
    label 'bioconductor'

    publishDir("${params.output_dir}/coordinates", mode: 'copy')

    input:
    val(gene)

    output:
    tuple val(gene), path("${gene}.gene.bed"), path("${gene}.exon.bed")

    script:
    """
    #!/bin/bash
    get_coordinates.R "${gene}" "${gene == 'reference' ? params.bins : 1 }" "${params.species}" "${params.genome}" "${params.style}"
    """
}
