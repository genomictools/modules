process COUNT_HETS {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'bcftools'

    def type = 'count_hets'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(file), path(index),
          val(n_samples), val(n_variants)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.bed")

    script:
    """
    #!/bin/bash
    # Standard BED format: #chrom start end variant_id carrier_count
    printf "#chrom\\tstart\\tend\\tvariant_id\\tcarrier_count\\n" > "${cohort}.${family}.${chrom}.${type}.bed"
    bcftools query -f '%CHROM\\t%POS0\\t%POS\\t%ID\\t%INFO/AC_Het\\n' ${file} >> "${cohort}.${family}.${chrom}.${type}.bed"
    """
}
