process PLOT_DROPOFF {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'linker'

    def type = 'plot_dropoff'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(segments), path(top_segment),
          path(log), val(n_segments),
          val(counts_type), path(counts)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.png"),
          path("${cohort}.${family}.${chrom}.${type}.log")

    script:
    """
    #!/bin/bash
    plot_dropoff.R \
        ${counts} \
        ${top_segment} \
        ${chrom} \
        "${cohort}.${family}.${chrom}.${type}.png" \
        "${cohort}" \
        "${family}" \
        > "${cohort}.${family}.${chrom}.${type}.log" 2>&1
    """
}
