process PLOT_KINSHIP {
    tag "${cohort}:${family}"

    label 'simple'
    label 'linker'

    def type = 'plot_kinship'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(type),
          path(genome), val(kin_log),
          path(pedigree)

    output:
    tuple val(cohort), val(family), val("${type}"),
          path("${cohort}.${family}.${type}.png"),
          path("${cohort}.${family}.${type}.plot.log")

    script:
    """
    #!/bin/bash
    kinship.R \
        ${genome} \
        ${pedigree} \
        "${cohort}.${family}.${type}.png" \
        > "${cohort}.${family}.${type}.plot.log" 2>&1
    """
}
