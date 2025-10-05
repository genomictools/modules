process ATSNP {
    tag "${params.species}:${tool}:${params.version}:${id}"

    label 'simple'
    label 'atsnp'

    publishDir("${params.output_dir}/annotations/${tool}", mode: 'copy')

    input:
    tuple val(id), path(file), path(index), val(tool)

    output:
    tuple val("${params.species}"), val("${tool}"), val("${params.version}"), val(id),
          path("${params.species}.${tool}.${params.version}.${id}.scores.tsv.gz"),
          path("${params.species}.${tool}.${params.version}.${id}.scores.tsv.gz.tbi"),
          env(nvariants)

    script:
    """
    #!/bin/bash
    atsnp.R ${file} ${params.motifs} ${params.species}.${tool}.${params.version}.${id}.scores.tsv

    bgzip -c ${params.species}.${tool}.${params.version}.${id}.scores.tsv > ${params.species}.${tool}.${params.version}.${id}.scores.tsv.gz
    tabix -s1 -b2 -e2 ${params.species}.${tool}.${params.version}.${id}.scores.tsv.gz
    
    nvariants=\$(cat ${params.species}.${tool}.${params.version}.${id}.scores.tsv | wc -l)
    """
}
