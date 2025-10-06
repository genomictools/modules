process FILTER {
    tag "${cohort}:${tool}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/filtered", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(cnv), path(cnv_log), val(nmarkers)

    output:
    tuple val(cohort), val(tool), val(type),
          path("${cohort}.${tool}.filtered.${type}"),
          path("${cohort}.${tool}.filtered.${type}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    filter_cnv.pl \
        ${cnv} \
        --numsnp ${params.numsnp} \
 	    --maxnumsnp ${params.maxnumsnp} \
        --length ${params.length} \
 	    --maxlength ${params.maxlength} \
 	    --confidence ${params.confidence[tool]} \
 	    --maxconfidence ${params.maxconfidence[tool]} \
        --output ${cohort}.${tool}.filtered.${type} \
        2> ${cohort}.${tool}.filtered.${type}.log

    nmarkers=\$(wc -l < "${cohort}.${tool}.filtered.${type}")
    """
}
