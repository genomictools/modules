process SUBSET {
    tag "${cohort}:${key}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/subsets", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(vcf), path(index), path(samples)

    output:
    tuple val(cohort), val(key),
          path("${cohort}.${key}.subset.vcf.gz"),
          path("${cohort}.${key}.subset.vcf.gz.tbi"),
          path(samples)

    script:
    """
    #!/bin/bash
    # Subset pheno
    bcftools view \
        -r ${key} \
        -S <(awk '{print \$2}' ${samples}) \
        -i 'FILTER="PASS"' \
        -g het \
        ${vcf} | \
    bcftools norm -m -any | \
    bcftools +fill-tags -- -t all | \
    bcftools +setGT -- -t . -n 0 | \
    bcftools +setGT -- -t q -n 0 -i 'FMT/GQ < ${params.GQ} | FMT/DP < ${params.DP} | VAF < ${params.VAF}' | \
    bcftools +fill-tags -- -t all | \
    bcftools view -g het --threads ${task.cpu} -Oz -o ${cohort}.${key}.subset.vcf.gz

    tabix ${cohort}.${key}.subset.vcf.gz
    """
}
