process FILTER {
    tag "${cohort}:${key}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/filtered/", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(vcf), path(index), path(samples)

    output:
    tuple val(cohort), val(key),
          path("${cohort}.${key}.filtered.vcf.gz"),
          path("${cohort}.${key}.filtered.vcf.gz.tbi"),
          path(samples)
        
    script:
    """
    #!/bin/bash
    # Filter cohort
    bcftools view -e 'HWE < ${params.HWE} || ExcHet < ${params.ExcHet}' ${vcf} | \
    bcftools view -i 'MAF > ${params.MAF}' | \
    bcftools annotate --set-id '%CHROM:%POS:%REF:%ALT' | \
    bcftools view --threads ${task.cpu} -Oz -o ${cohort}.${key}.filtered.vcf.gz

    tabix ${cohort}.${key}.filtered.vcf.gz
    """
}
