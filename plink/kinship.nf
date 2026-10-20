process KINSHIP {
    tag "${cohort}:${family}"

    label 'simple'
    label 'plink'

    def type = 'kinship'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chroms), val(type),
          path(vcfs), path(indices),
          val(n_samples), val(n_variants)

    output:
    tuple val(cohort), val(family), val("${type}"),
          path("${cohort}.${family}.${type}.genome"),
          path("${cohort}.${family}.${type}.log")

    script:
    """
    #!/bin/bash
    set -e
    i=0
    for v in ${vcfs}; do
        i=\$((i + 1))
        plink --vcf "\$v" --maf 0.05 --geno 0.1 --allow-extra-chr --double-id --make-bed --out "part_\${i}" >> "${cohort}.${family}.${type}.log" 2>&1 || \
        plink --vcf "\$v" --allow-extra-chr --double-id --make-bed --out "part_\${i}" >> "${cohort}.${family}.${type}.log" 2>&1
    done
    ls part_*.bed | sed 's/\\.bed\$//' > bed_list.txt
    first=\$(head -n 1 bed_list.txt)
    if [ \$(wc -l < bed_list.txt) -gt 1 ]; then
        tail -n +2 bed_list.txt > merge_list.txt
        plink --bfile "\$first" --merge-list merge_list.txt --allow-extra-chr --make-bed --out filtered >> "${cohort}.${family}.${type}.log" 2>&1 || {
            cp "\$first.bed" filtered.bed
            cp "\$first.bim" filtered.bim
            cp "\$first.fam" filtered.fam
        }
    else
        cp "\$first.bed" filtered.bed
        cp "\$first.bim" filtered.bim
        cp "\$first.fam" filtered.fam
    fi
    plink --bfile filtered --allow-extra-chr --genome --out "${cohort}.${family}.${type}" >> "${cohort}.${family}.${type}.log" 2>&1
    """
}
