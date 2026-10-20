process ANNOTATE {
    tag "${cohort}:${family}:${chunk}"

    label 'simple'
    label 'bcftools'

    def type = 'annotate'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chunk), val(type),
          path(file), path(index),
          val(n_samples),
          val(n_variants),
          val(dbsnp), path(dbsnp_file), path(dbsnp_index)

    output:
    tuple val(cohort), val(family), val(chunk), val("${type}"),
          path("${cohort}.${family}.${chunk}.${type}.vcf.gz"),
          path("${cohort}.${family}.${chunk}.${type}.vcf.gz.tbi"),
          env(n_samples),
          env(n_variants)

    script:
    """
    #!/bin/bash
    bcftools annotate \
        -r ${chunk} \
        -a ${dbsnp_file} \
        -c ID,INFO/${params.af_tag} \
        --threads ${task.cpus} \
        -Ov ${file} | \
    sed "/^##INFO=<ID=${params.af_tag},/s/Type=String/Type=Float/" | \
    bcftools view --threads ${task.cpus} -Oz -o ${cohort}.${family}.${chunk}.${type}.vcf.gz

    # Index vcf
    tabix ${cohort}.${family}.${chunk}.${type}.vcf.gz

    # Count the number of samples and variants
    n_samples=\$(bcftools query -l ${cohort}.${family}.${chunk}.${type}.vcf.gz | wc -l)
    n_variants=\$(bcftools index -n ${cohort}.${family}.${chunk}.${type}.vcf.gz)
    """
}
