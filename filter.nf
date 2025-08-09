process FILTER {
    tag "${cohort}:${key}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/filtered", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type),
          path(cnv), path(cnv_log)

    output:
    tuple val(cohort), val(key), path("${cohort}.${key}.filtered.cnv")

    script:
    """
    #!/bin/bash
    filter_cnv.pl \
        -numsnp ${params.numsnp} \
        -length ${params.length} \
        ${cnv} \
        --output ${cohort}.${key}.filtered.cnv
    """
}
