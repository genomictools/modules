process DRAW {
    tag "${famid}:${gene}"

    label 'simple'
    label 'rvs'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(famid),
          path(pedigree), path(affected), path(carrier), path(starred),
          val(gene), val(variant)

    output:
    tuple val(famid), val(gene),
          path("${famid}.${gene}.png")

    script:
    """
    #!/bin/bash
    draw.R ${famid} ${pedigree} ${affected} ${carrier} ${starred} ${gene} ${variant.join(',')}
    """
}
