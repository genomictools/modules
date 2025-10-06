process SHARING {
    tag "${famid}:${category}"

    label 'simple'
    label 'rvs'

    publishDir("${params.output_dir}/sharing", mode: 'copy')

    input:
    tuple val(famid), val(category), path(rlist), path(annotation),
          path(cases), path(pedigree), path(blacklist)

    output:
    tuple val(famid), val(category),
          path("${famid}.${category}.tsv")

    script:
    """
    #!/bin/bash
    sharing.R ${famid} ${category} ${rlist} ${annotation} ${cases} ${pedigree} ${blacklist}
    """
}
