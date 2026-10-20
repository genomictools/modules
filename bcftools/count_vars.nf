process COUNT_VARS {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'bcftools'

    def type = 'count_vars'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(windows_bed), val(windows_log), val(n_windows),
          val(vcf_type), path(vcf), path(vcf_index), val(vcf_n_samples), val(vcf_n_variants)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.bed"),
          env(n_windows)

    script:
    """
    #!/bin/bash
    # Count number of snps in each segment
    if [ -s "${windows_bed}" ]; then
        bcftools query -f '%CHROM\\t%POS\\n' "${vcf}" | \
        annot-tsv -t "${windows_bed}" -c 1,2,2:1,2,3 -a cnt -H \
            > "${cohort}.${family}.${chrom}.${type}.bed"
    else
        : > "${cohort}.${family}.${chrom}.${type}.bed"
    fi

    # Count number of segments
    n_windows=\$(wc -l < "${cohort}.${family}.${chrom}.${type}.bed")
    """
}
