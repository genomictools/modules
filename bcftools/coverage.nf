process COVERAGE {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'bcftools'

    def type = 'coverage'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(file), path(index),
          val(n_samples),
          val(n_variants)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.bed")  

    script:
    """
    #!/bin/bash
    # Generate coverage bed file
    echo -n "chrom\tpos" > "${cohort}.${family}.${chrom}.${type}.bed"
    bcftools query -f "[\t%SAMPLE]" ${file} | head -1 >> "${cohort}.${family}.${chrom}.${type}.bed"
    printf "\n" >> "${cohort}.${family}.${chrom}.${type}.bed"
    bcftools query -f "%CHROM\t%POS[\t%DP]\n" ${file} >> "${cohort}.${family}.${chrom}.${type}.bed"
    """
}
