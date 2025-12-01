process MERGE {
    tag "${cohort}:${key}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/signal", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level), 
          path(file), path(log), val(nmarkers),
          path(pfb)

    output:
    tuple val(cohort), val(key), val('merged'),
          path("${cohort}.${key}.merged.txt"),
          path("${cohort}.${key}.merged.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    merge.R ${file} ${pfb} ${cohort}.${key}.merged.txt >& ${cohort}.${key}.merged.log
    nmarkers=\$(tail -n +2 "${cohort}.${key}.merged.txt" | wc -l)
    """
}