process PLOT_LINKAGE {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'linker'

    def type = 'plot_linkage'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(segments), path(top_segments), path(log), val(n_segments)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.png"),
          path("${cohort}.${family}.${chrom}.${type}.log")

    script:
    """
    #!/bin/bash
    set -euo pipefail
    plot_linkage.R \
        ${chrom} \
        ${segments} \
        "${cohort}.${family}.${chrom}.${type}.png" \
        ${top_segments} \
        > "${cohort}.${family}.${chrom}.${type}.log" 2>&1
    """
}
