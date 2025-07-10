process CLASSIFY {
    tag "${famid}:${category}:${type}"

    label 'simple'
    label 'rvs'

    publishDir("${params.output_dir}/classified", mode: 'copy')

    input:
    tuple val(famid), val(category), path(sharing), val(type)
  
    output:
    tuple val(famid), val(category), val(type), path("${famid}.${category}.${type}.tsv")

    script:
    """
    #!/bin/bash
    classify.R ${famid} ${category} ${sharing.join(',')} ${type}
    """
}
