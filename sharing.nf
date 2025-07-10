process SHARING {
    tag "${famid}:${category}"

    label 'simple'
    label 'rvs'

    publishDir("${params.output_dir}/sharing", mode: 'copy')

    input:
    tuple val(famid), val(category),
          path(snplist), path(rlist), path(freq), path(annotation),
          path(cases), path(ped), path(blacklist)
            
    output:
    tuple val(famid), val(category),
          path("${famid}.${category}.tsv")

    script:
    """
    #!/bin/bash
    sharing.R ${famid} ${category} ${snplist} ${rlist} ${freq} ${annotation} ${cases} ${ped} ${blacklist}
    """
}
