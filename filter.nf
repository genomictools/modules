process FILTER {
    tag "${cohort}:${key}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/filtered", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type),
          path(cnv), path(cnv_log)

    output:
    tuple val(cohort), val(key), val(type),
          path("${cohort}.${key}.filtered.${type}"),
          path("${cohort}.${key}.filtered.${type}.log")

    script:
    """
    #!/bin/bash
    filter_cnv.pl \
        --numsnp ${params.numsnp} \
 	    --maxnumsnp ${params.maxnumsnp} \
        --length ${params.length} \
 	    --maxlength ${params.maxlength} \
 	    --confidence ${params.confidence} \
 	    --maxconfidence ${params.maxconfidence} \
        ${cnv} \
        --output ${cohort}.${key}.filtered.${type} \
        &> ${cohort}.${key}.filtered.${type}.log
    """
}
