process SUM {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'linker'

    def type = 'linkage_sum'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type), val(branch),
          path(parametric_tbls), path(log), val(n_markers),
          path(markers)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.bed"),
          path("${cohort}.${family}.${chrom}.${type}.segment.bed"),
          path("${cohort}.${family}.${chrom}.${type}.log"),
          env(n_segments)

    script:
    """
    #!/bin/bash
    set -euo pipefail

    sum.R \
        ${markers} \
        ${parametric_tbls} \
        ${chrom} \
        "${cohort}.${family}.${chrom}.${type}.bed" \
        "${cohort}.${family}.${chrom}.${type}.segment.bed" \
        ${params.min_linkage} \
        > "${cohort}.${family}.${chrom}.${type}.log" 2>&1

    # Count number of recommended segments
    n_segments=\$(wc -l < "${cohort}.${family}.${chrom}.${type}.segment.bed")
    """
}
