process COMBINE {
    tag "${cohort}:${tool}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/combined", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(tool), val(type),
          path(cnv), path(cnv_log),
          val(nmarkers)

    output:
    tuple val(cohort), val(tool), val(type),
          path("${cohort}.${tool}.combined.${type}"),
          path("${cohort}.${tool}.combined.${type}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # combine calls
    cat ${cnv}     > ${cohort}.${tool}.combined.${type}
    cat ${cnv_log} > ${cohort}.${tool}.combined.${type}.log
    nmarkers=\$(wc -l < "${cohort}.${tool}.combined.${type}")
    """
}