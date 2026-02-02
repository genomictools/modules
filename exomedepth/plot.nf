process PLOT {
    tag "${cohort}:${gene}:${key}"

    label 'simple'
    label 'exomedepth'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(key),
          path(obj), path(cnv),
          val(nmarker)

    output:
    tuple val(cohort), val(gene), val(key),
          path("${cohort}.${gene}.${key}.cnv.png")

    script:
    """
    #!/bin/bash
    plot_gene.R ${cohort} ${gene} ${key} ${obj} ${params.threshold}
    """
}
