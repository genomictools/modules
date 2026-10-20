process DISJOIN {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'linker'

    def type = 'disjoin'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          val(hbd), path(ibd), val(hap_log),
          val(n_segments)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.bed"),
          path("${cohort}.${family}.${chrom}.${type}.log"),
          env(n_windows)

    script:
    """
    #!/bin/bash
    # Disjoin segments
    disjoin.R \
        ${ibd} \
        "${cohort}.${family}.${chrom}.${type}.bed" \
        > "${cohort}.${family}.${chrom}.${type}.log" 2>&1

    # Count number of disjoined segments
    n_windows=\$( [ -s "${cohort}.${family}.${chrom}.${type}.bed" ] && wc -l < "${cohort}.${family}.${chrom}.${type}.bed" || echo 0 )
    """
}
