process TRIM {
    tag "${cohort}:${key}:${category}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/trimmed", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(category),
          path(file), path(index),
          val(n_samples), val(n_variants)

    output:
    tuple val(cohort), val(key), val(category),
          path("${cohort}.${key}.${category}.trimmed.vcf.gz"),
          path("${cohort}.${key}.${category}.trimmed.vcf.gz.tbi"),
          env(n_samples), env(n_variants)

    script:
    """
    #!/bin/bash
    bcftools view ${file} | \
    if [ "${params.het_only}"       = "true" ]; then bcftools view -g het; else bcftools view; fi | \
    if [ "${params.snp_only}"       = "true" ]; then bcftools view --types snps; else bcftools view; fi | \
    if [ "${params.biallelic_only}" = "true" ]; then bcftools view -m 2 -M 2; else bcftools view; fi | \
    if [ "${params.remove_dups}"    = "true" ]; then bcftools norm -d both; else bcftools view; fi | \
    if [ "${params.rename_ids}"     = "true" ]; then bcftools annotate --set-id '%CHROM:%POS:%REF:%ALT'; else bcftools view; fi | \
    bcftools view --threads ${task.cpus} -Oz -o ${cohort}.${key}.${category}.trimmed.vcf.gz

    tabix ${cohort}.${key}.${category}.trimmed.vcf.gz
    
    # Return summary
    n_samples=\$(bcftools query -l ${cohort}.${key}.${category}.trimmed.vcf.gz | wc -l)
    n_variants=\$(bcftools index -n ${cohort}.${key}.${category}.trimmed.vcf.gz)
    """
}






