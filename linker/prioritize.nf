process PRIORITIZE {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'linker'

    def type = 'prioritize'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(hbd), path(ibd), path(log), val(n_segments),
          val(count_type), path(count_segments), val(n_count_segments),
          path(pedigree), path(phenotype)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.bed"),
          path("${cohort}.${family}.${chrom}.${type}.segment.bed"),
          path("${cohort}.${family}.${chrom}.${type}.log"),
          env(n_segments)

    script:
    """
    #!/bin/bash
    prioritize.R \
        ${count_segments} \
        ${ibd} \
        ${pedigree} \
        ${phenotype} \
        ${params.allow_mismatch} \
        ${params.allow_phenocopies} \
        "${cohort}.${family}.${chrom}.${type}.bed" \
        "${cohort}.${family}.${chrom}.${type}.segment.bed" \
        > "${cohort}.${family}.${chrom}.${type}.log" 2>&1

    # Count number of recommended segments
    n_segments=\$( [ -s "${cohort}.${family}.${chrom}.${type}.segment.bed" ] && wc -l < "${cohort}.${family}.${chrom}.${type}.segment.bed" || echo 0 )
    """
}
