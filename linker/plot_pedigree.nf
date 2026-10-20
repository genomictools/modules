process PLOT_PEDIGREE {
    tag "${cohort}:${family}"

    label 'simple'
    label 'linker'

    def type = 'plot_pedigree'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chroms), val(type),
          path(files), path(indexes),
          val(n_samples), val(n_variants),
          path(pedigrees), path(phenotypes)

    output:
    tuple val(cohort), val(family), val("${type}"),
          path("${cohort}.${family}.${type}.png"),
          path("${cohort}.${family}.${type}.log")

    script:
    """
    #!/bin/bash
    # Create a list of typed samples for the family
    zgrep -m 1 '^#CHROM' ${files.join(' ')} | \
        cut -f 10- | \
        tr '\t' '\n' | \
        sort -u > "${cohort}.${family}.typed.txt"

    # Plot the pedigree
    plot_pedigree.R \
        "${pedigrees}" \
        "${phenotypes}" \
        "${cohort}.${family}.typed.txt" \
        "${params.shrink_pedigree}" \
        "${cohort} (${family})" \
        "${cohort}.${family}.${type}.png" \
        > "${cohort}.${family}.${type}.log" 2>&1
    """
}
