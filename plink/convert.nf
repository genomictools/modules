process CONVERT {
    tag "${cohort}:${type}:${chunk}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/plinked", mode: 'copy')

    input:
    tuple val(cohort), val(type), val(chunk),
          path(vcf_in), path(index_in),
          env(n_vars)

    output:
    tuple val(cohort), val(type), val(chunk),
          path("${cohort}.${type}.${chunk}.bim"),
          path("${cohort}.${type}.${chunk}.bed"),
          path("${cohort}.${type}.${chunk}.fam"),
          path("${cohort}.${type}.${chunk}.nosex"),
          path("${cohort}.${type}.${chunk}.log")

    script:
    """
    #!/bin/bash
    echo '.' > tmp.exclude
    plink \
        --vcf ${vcf_in} \
        --make-bed \
        --const-fid 0 \
        --exclude tmp.exclude \
        --out ${cohort}.${type}.${chunk}
    """
}