process PLOT_HAPLOTYPES {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'linker'

    def type = 'plot_haplotypes'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(hbd), path(ibd), path(log), val(n_segments),
          val(priority_type), path(priority_segments), path(priority_top_segments), path(priority_segments_log), val(n_priority_segments),
          path(pedigree), path(phenotype)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.png"),
          path("${cohort}.${family}.${chrom}.${type}.log")

    script:
    """
    #!/bin/bash
    plot_haplotypes.R \
        ${ibd} \
        ${pedigree} \
        ${phenotype} \
        ${params.allow_phenocopies} \
        "${cohort}.${family}.${chrom}.${type}.png" \
        ${priority_top_segments} \
        > "${cohort}.${family}.${chrom}.${type}.log" 2>&1
    """
}
