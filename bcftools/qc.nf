process QC {
    tag "${cohort}:${family}:${chunk}"

    label 'simple'
    label 'bcftools'

    def type = 'qc'

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
    # Normalize, QC genotypes, and filter by AC and F_MISSING
    bcftools view -Ou ${file} | \
    bcftools view -Ou -i 'FILTER="PASS"' | \
    bcftools +setGT -Ou -- -t q -n . -i 'FMT/GQ < ${params.gq} || FMT/DP < ${params.dp}' | \
    bcftools +fill-tags -Ou -- -t AC,AN,F_MISSING | \
    bcftools view -Ou -i 'AC >= ${params.mac} && F_MISSING <= ${params.missing}' | \
    bcftools view --threads ${task.cpus} -Oz -o ${cohort}.${family}.${chunk}.${type}.vcf.gz

    # Index vcf
    tabix ${cohort}.${family}.${chunk}.${type}.vcf.gz

	# Count the number of samples and variants
    n_samples=\$(bcftools query -l ${cohort}.${family}.${chunk}.${type}.vcf.gz | wc -l)
    n_variants=\$(bcftools index -n ${cohort}.${family}.${chunk}.${type}.vcf.gz)
    """
}
