process ATTACH {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'linker'

    def type = 'attach'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(file), path(index),
          val(n_samples), val(n_variants),
          path(pedigree),
          path(phenotype)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("*.{ped,dat,freq,map,model}"),
          path("counts.tsv"),
          path("markers.tsv"),
          path("${cohort}.${family}.${chrom}.${type}.log"),
          env(n_markers)

    def max_markers = params.max_markers ?: 120
    """
    #!/bin/bash
    set -euo pipefail

    attach.R \
        ${file} \
        ${pedigree} \
        ${phenotype} \
        ${chrom} \
        "./" \
        ${max_markers} \
        > "${cohort}.${family}.${chrom}.${type}.log" 2>&1

    n_markers=\$(awk 'NR==2 {print \$2}' counts.tsv || echo 0)
    """
}
