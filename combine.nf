process COMBINE {
    tag "${cohort}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/combined", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type),
          path(cnv), path(cnv_log),
          val(nmarkers)

    output:
    tuple val(cohort), val(type),
          path("${cohort}.combined.${type}"),
          path("${cohort}.combined.${type}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # combine calls
    cat ${cnv}     > ${cohort}.combined.${type}
    cat ${cnv_log} > ${cohort}.combined.${type}.log
    nmarkers=\$(wc -l < "${cohort}.combined.${type}")
    """
}