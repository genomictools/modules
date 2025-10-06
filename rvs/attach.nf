process ATTACH {
    tag "${famid}:${category}"

    label 'simple'
    label 'rvs'

    publishDir("${params.output_dir}/markers/", mode: 'copy')

    input:
    tuple val(famid), val(category), path(rlist), path(annotation),
          path(cases), path(pedigree)

    output:
    tuple val(famid), val(category),
          path("${famid}.${category}.marked.ped"),
          path("${famid}.aff.txt"),
          path("${famid}.carr.txt"),
          path("${famid}.star.txt")

    script:
    """
    #!/bin/bash
    attach.R ${famid} ${category} ${rlist} ${cases} ${pedigree}
    """
}
