process CONVERT {
    tag "${cohort}:${key}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/converted", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(vcf), path(index), path(samples)

    output:
    tuple val(cohort), val(key),
          path("${cohort}.${key}.bim"), 
          path("${cohort}.${key}.bed"), 
          path("${cohort}.${key}.fam"), 
          path("${cohort}.${key}.log")

    script:
    """
    #!/bin/bash
    # Extract phenotypes
    cat ${samples} | awk '{print \$1,\$2,\$4 }' >  phenotype.tsv
    cat ${samples} | awk '{print \$1,\$2,\$3 }'  >  sex.tsv

    # Convert VCF to PLINK
    plink \
        --vcf ${vcf} \
        --make-bed \
        --const-fid \
        --update-sex sex.tsv \
        --pheno phenotype.tsv \
        --out ${cohort}.${key}
    """
}