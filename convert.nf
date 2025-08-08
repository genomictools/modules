process CONVERT {
    tag "${cohort}:${key}:${category}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/plinked", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(category),
          path(file), path(index),
          val(n_samples), val(n_variants),
          path(pedigree)

    output:
    tuple val(cohort), val(key), val(category),
          path("${cohort}.${key}.${category}.bim"),
          path("${cohort}.${key}.${category}.bed"),
          path("${cohort}.${key}.${category}.fam"),
          path("${cohort}.${key}.${category}.nosex"),
          path("${cohort}.${key}.${category}.log")

    script:
    def args = []
    if ( !params.family_ids ) { args << "--const-fid 0" }
    def args_str = args.join(' ')
    """
    #!/bin/bash
    plink \
        --vcf ${file} \
        --update-parents <(awk '{print \$1, \$2, \$3, \$4}') \
        --update-sex <(awk '{print \$1, \$2, \$5}') \
        --pheno <(awk '{print \$1, \$2, \$6}') \
        --make-bed \
        --vcf-half-call ${params.halfcalls} \
        --out ${cohort}.${key}.${category} \
        ${args_str}
    """
}
