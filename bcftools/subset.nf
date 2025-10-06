process SUBSET {
    tag "${cohort}:${key}:${sample}:${sample_type}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/subsets", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(sample), val(sample_type),
		  path(vcf), path(vcf_index)

    output:
    tuple val(cohort), val(key), val(sample), val(sample_type),
          path("${cohort}.${key}.${sample}.${sample_type}.vcf.gz"),
          path("${cohort}.${key}.${sample}.${sample_type}.vcf.gz.tbi"),
          env(n_variants)

    script:
    """
    #!/bin/bash
    bcftools view -r ${key} ${vcf} --threads ${task.cpus} -Oz -o ${cohort}.${key}.${sample}.${sample_type}.vcf.gz
    tabix ${cohort}.${key}.${sample}.${sample_type}.vcf.gz
    n_variants=\$(bcftools index -n ${cohort}.${key}.${sample}.${sample_type}.vcf.gz)
    """
}
