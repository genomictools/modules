process DRAW {
    tag "${famid}:${category}:${gene}"

    label 'simple'
    label 'rvs'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(famid), val(category),
          path(ped), path(affected), path(carrier),
          val(gene), val(variant)

    output:
    tuple val(famid), val(category), val(gene),
          path("${famid}.${category}.${gene}.png")

    script:
    """
    #!/bin/bash
    draw.R ${famid} ${category} ${ped} ${affected} ${carrier} ${gene} ${variant}
    """
}
