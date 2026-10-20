process COMBINE {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'bcftools'

    def type = 'combine'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(file), path(index),
          val(n_samples),
          val(n_variants)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.vcf.gz"),
          path("${cohort}.${family}.${chrom}.${type}.vcf.gz.tbi"),
          env(n_samples),
          env(n_variants)

    script:
    """
    #!/bin/bash
    # Sort chunk VCFs in natural coordinate order and concatenate
    bcftools concat \$(ls -v *.vcf.gz) -Ou | \
    bcftools +fill-tags -Ou -- -t AC,AN,AC_Het | \
    bcftools view --threads ${task.cpus} -Oz -o ${cohort}.${family}.${chrom}.${type}.vcf.gz

    # Index the combined VCF
    tabix ${cohort}.${family}.${chrom}.${type}.vcf.gz

    # Count the number of samples and variants
    n_samples=\$(bcftools query -l ${cohort}.${family}.${chrom}.${type}.vcf.gz | wc -l)
    n_variants=\$(bcftools index -n ${cohort}.${family}.${chrom}.${type}.vcf.gz)
    """
}
