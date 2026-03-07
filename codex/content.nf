process CONTENT {
    tag "${gene}"

    label 'simple'
    label 'codex'

    publishDir("${params.output_dir}/content", mode: 'copy')

    input:
    tuple val(gene), path(gene_coords), path(exon_coords)

    output:
    tuple val(gene), val("gc,pmap"),
          path("${gene}.{gc,pmap}.bed")

    script:
    """
    #!/bin/bash
    get_content.R "${gene}" "${exon_coords}" "${params.genome}" "${params.style}"
    """
}

