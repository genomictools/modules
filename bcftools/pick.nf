process PICK {
    tag "${cohort}:${type}:${chunk}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/picked", mode: 'copy')

    input:
    tuple val(cohort), val(type), path(file), path(index),
          val(chunk), path(snplist),
          path(population)

    output:
    tuple val(cohort), val(type), val(chunk),
          path("${cohort}.${type}.${chunk}.picked.vcf.gz"),
          path("${cohort}.${type}.${chunk}.picked.vcf.gz.tbi"),
          env(n_vars)
     
    script:
    """
    #!/bin/bash
    bcftools view \
        -S <(awk '{print \$2}' ${population}) \
        -R ${snplist} \
        ${file} \
        --threads ${task.cpus} \
        -Oz -o ${cohort}.${type}.${chunk}.picked.vcf.gz

    tabix ${cohort}.${type}.${chunk}.picked.vcf.gz
    n_vars=\$(bcftools index -n ${cohort}.${type}.${chunk}.picked.vcf.gz)
    """
}
