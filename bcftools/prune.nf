process PRUNE {
    tag "${cohort}:${family}:${chunk}"

    label 'simple'
    label 'bcftools'

	def type = 'prune'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chunk), val(type),
          path(file), path(index),
          val(n_samples),
          val(n_variants)

    output:
    tuple val(cohort), val(family), val(chunk), val("${type}"),
          path("${cohort}.${family}.${chunk}.${type}.vcf.gz"),
          path("${cohort}.${family}.${chunk}.${type}.vcf.gz.tbi"),
          env(n_samples),
          env(n_variants)

    script:
    """
    #!/bin/bash
    # Prune variants
    bcftools +prune \
        -w ${params.window}"bp" \
        -n ${params.sites} \
        -N rand \
        --random-seed 42 \
        ${file} \
        -Oz -o ${cohort}.${family}.${chunk}.${type}.vcf.gz

    # Index vcf
    tabix ${cohort}.${family}.${chunk}.${type}.vcf.gz

    # Count the number of samples and variants
    n_samples=\$(bcftools query -l ${cohort}.${family}.${chunk}.${type}.vcf.gz | wc -l)
    n_variants=\$(bcftools index -n ${cohort}.${family}.${chunk}.${type}.vcf.gz)
    """
}
