process SUBSET {
    tag "${cohort}:${family}:${chunk}"

    label 'simple'
    label 'bcftools'

    def type = 'subset'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), path(file), path(index),
          path(pedigree),
          val(chunk)

    output:
    tuple val(cohort), val(family), val(chunk), val("${type}"),
          path("${cohort}.${family}.${chunk}.${type}.vcf.gz"),
          path("${cohort}.${family}.${chunk}.${type}.vcf.gz.tbi"),
          env(n_samples),
          env(n_variants)

    script:
    """
    #!/bin/bash
    # Extract samples from pedigree file
    awk 'NR > 1 {print \$1}' ${pedigree} | sort -u > samples.txt

    # Subset vcf
    bcftools view \
        -c 1:minor \
        -S samples.txt --force-samples \
        -r ${chunk} \
        --threads ${task.cpus} \
        -Oz -o ${cohort}.${family}.${chunk}.${type}.vcf.gz \
        ${file}

    # Index vcf
    tabix ${cohort}.${family}.${chunk}.${type}.vcf.gz

    # Count the number of samples and variants
    n_samples=\$(bcftools query -l ${cohort}.${family}.${chunk}.${type}.vcf.gz | wc -l)
    n_variants=\$(bcftools index -n ${cohort}.${family}.${chunk}.${type}.vcf.gz)
    """
}
