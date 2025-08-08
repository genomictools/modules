process ATSNP {
    tag "${params.species}:${params.tool}:${params.version}:${id}"

    label 'simple'
    label 'atsnp'

    publishDir("${params.output_dir}/annotations", mode: 'copy')

    input:
    tuple val(id), path(file), path(index)

    output:
    tuple val("${params.species}"), val("${params.tool}"), val("${params.version}"),
          val(id),
          path("${params.species}.${params.tool}.${params.version}.${id}.scores.tsv")
    
    script:
    """
    #!/bin/bash
    atsnp.R ${file} ${params.motifs} ${params.species}.${params.tool}.${params.version}.${id}.scores.tsv
    """
}
