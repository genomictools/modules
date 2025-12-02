process EXTRACT {
    tag "${cohort}:${key}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/signal", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers)

    output:
    tuple val(cohort), val(key), val('raw'),
          path("${cohort}.${key}.raw.txt"),
          path("${cohort}.${key}.extract.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    extract.R "${file}" "${params.name_col}" "${params.baf_col}" "${params.lrr_col}" "${params.a1_col}" "${params.a2_col}" "${cohort}.${key}.raw.txt" 2> "${cohort}.${key}.extract.log"
    nmarkers=\$(wc -l < "${cohort}.${key}.raw.txt")
    """
}
