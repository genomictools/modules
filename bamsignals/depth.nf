process DEPTH {
    tag "${cohort}:${key}:${type}:${gene}"

    label 'simple'
    label 'bamsignals'

    publishDir("${params.output_dir}/depth", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type),
          path(bam), path(bai),
          val(gene), path(gene_coords), path(exon_coords)

    output:
    tuple val(cohort), val(key), val(type), val(gene), val('count,coverage'),
          path("${cohort}.${key}.${type}.${gene}.{count,coverage}.bed")

    script:
    """
    #!/bin/bash
    get_depth.R "${bam}" "${gene_coords}" "${exon_coords}" "${cohort}.${key}.${type}.${gene}"
    """
}
