process PLOT_COVERAGE {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'linker'

    def type = 'plot_coverage'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(coverage_bed)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.png"),
          path("${cohort}.${family}.${chrom}.${type}.log")

    script:
    """
    #!/bin/bash
    set -e
    coverage.R \
        ${coverage_bed} \
        ${chrom} \
        "${cohort}.${family}.${chrom}.${type}.png" \
        > "${cohort}.${family}.${chrom}.${type}.log" 2>&1
    """
}
