process VISUALIZE {
    tag "${cohort}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/tables", mode: 'copy')

    input:
    tuple val(cohort), path(cnv), path(annotated), val(format)

    output:
    tuple val(cohort), path("${cohort}.${format}")

    script:
    """
    #!/bin/bash
    visualize_cnv.pl \
        ${cnv} \
        -format ${format} \
        -track "${cohort}" \
        > ${cohort}.${format}
    """
}