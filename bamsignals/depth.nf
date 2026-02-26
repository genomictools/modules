process DEPTH {
    tag "${cohort}:${key}:${type}:${gene}:${feature}"

    label 'simple'
    label 'bamsignals'

    publishDir("${params.output_dir}/depth", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type),
          path(bam), path(bai),
          val(gene), val(feature), path(coords)

    output:
    tuple val(cohort), val(key), val(type), val(gene), val(feature),
          path("${cohort}.${key}.${type}.${gene}.${feature}.bed")

    script:
    """
    #!/bin/bash
    get_depth.R "${bam}" "${coords}" "${feature}" "${cohort}.${key}.${type}.${gene}.${feature}.bed"
    """
}
