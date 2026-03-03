process PLOT {
    tag "${cohort}:${gene}:${test_key}"

    label 'simple'
    label 'exomecopy'

    publishDir("${params.output_dir}/plots/exome_copy", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(test_key), val(tool),
          path(tsv), val(obj), val(nmarkers)

    output:
    tuple val(cohort), val(gene), val(test_key), val(tool),
          path("${cohort}.${gene}.${test_key}.cnv.png")

    script:
    """
    #!/bin/bash
    plot_exomecopy.R ${cohort} ${gene} ${test_key} ${obj}
    """
}   
