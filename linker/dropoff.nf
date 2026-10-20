process DROPOFF {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'linker'

    def type = 'dropoff'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(counts_bed)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.bed"),
          path("${cohort}.${family}.${chrom}.${type}.segment.bed"),
          path("${cohort}.${family}.${chrom}.${type}.log"),
          env(n_segments)

    script:
    """
    #!/bin/bash
    dropoff.R \
        ${counts_bed} \
        ${chrom} \
        "${cohort}.${family}.${chrom}.${type}.bed" \
        "${cohort}.${family}.${chrom}.${type}.segment.bed" \
        > "${cohort}.${family}.${chrom}.${type}.log" 2>&1

    # Count recommended segments
    n_segments=\$( [ -s "${cohort}.${family}.${chrom}.${type}.segment.bed" ] && wc -l < "${cohort}.${family}.${chrom}.${type}.segment.bed" || echo 0 )
    """
}

