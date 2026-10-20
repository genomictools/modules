process FILTER {
    tag "${cohort}:${family}:${chrom}:${frequency}"

    label 'simple'
    label 'bcftools'

    def type = 'filter'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(file), path(index),
          val(n_samples),
          val(n_variants),
          val(frequency)

    output:
    tuple val(cohort), val(family), val(chrom), val(frequency),
          path("${cohort}.${family}.${chrom}.${frequency}.vcf.gz"),
          path("${cohort}.${family}.${chrom}.${frequency}.vcf.gz.tbi"),
          env(n_samples),
          env(n_variants)

    script:
    """
    #!/bin/bash
    # Filter based on population AF and polymorphism in cohort
    if [ "${frequency}" = "common" ]; then
        bcftools norm -Ou -m -any ${file} | \
        bcftools view -Ou -v snps -m2 -M2 -c ${params.mac}:minor | \
        if [ "${params.annotate}" = "true" ]; then \
            bcftools view -Ou -i "ID != '.' && INFO/${params.af_tag}[0] >= ${params.maf} && INFO/${params.af_tag}[1] >= ${params.maf} && INFO/${params.af_tag}[1] <= ${params.max}"; \
        else \
            bcftools view -Ou -i "INFO/${params.af_tag}[1] >= ${params.maf} && INFO/${params.af_tag}[1] <= ${params.max}"; \
        fi | \
        bcftools view --threads ${task.cpus} -Oz -o ${cohort}.${family}.${chrom}.${frequency}.vcf.gz
    else
        bcftools norm -Ou -m -any ${file} | \
        bcftools view -Ou -v snps -m2 -M2 | \
        bcftools view -Ou -i "INFO/${params.af_tag}[1] <= ${params.maf}" | \
        bcftools view --threads ${task.cpus} -Oz -o ${cohort}.${family}.${chrom}.${frequency}.vcf.gz
    fi

    # Index vcf
    tabix ${cohort}.${family}.${chrom}.${frequency}.vcf.gz
      
    # Count the number of samples and variants
    n_samples=\$(bcftools query -l ${cohort}.${family}.${chrom}.${frequency}.vcf.gz | wc -l)
    n_variants=\$(bcftools index -n ${cohort}.${family}.${chrom}.${frequency}.vcf.gz)
    """
}

