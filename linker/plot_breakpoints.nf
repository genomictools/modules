process PLOT_BREAKPOINTS {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'linker'

    def type = 'plot_breakpoints'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(merlin_type), val(branch),
          path(flows), path(merlin_logs), val(n_flow),
          val(sum_type), path(segments), path(top_segments), path(sum_log), val(n_segments),
          path(markers)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.bed"),
          path("${cohort}.${family}.${chrom}.${type}.png"),
          path("${cohort}.${family}.${chrom}.${type}.log")

    script:
    """
    #!/bin/bash
    plot_breakpoints.R \
        ${markers} \
        ${flows} \
        ${top_segments} \
        ${chrom} \
        "${cohort}.${family}.${chrom}.${type}.bed" \
        "${cohort}.${family}.${chrom}.${type}.png" \
        > "${cohort}.${family}.${chrom}.${type}.log" 2>&1
    """
}
