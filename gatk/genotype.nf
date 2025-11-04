process GENOTYPE {
    tag "${cohort}:${assembly}:${chrom}:${start}-${end}"

    label 'simple'
    label 'gatk'

    publishDir("${params.output_dir}/genotyped", mode: 'copy')

    input:
    tuple val(cohort), val(assembly), val(chrom), val(start), val(end),
          path(file), path(index),
          val(assembly), path(fasta)

    output:
    tuple val(cohort), val(assembly), val(chrom), val(start), val(end),
          path("${cohort}.${assembly}.${chrom}:${start}-${end}.genotyped.vcf.gz"),
          path("${cohort}.${assembly}.${chrom}:${start}-${end}.genotyped.vcf.gz.tbi")

    script:
    """
    #!/bin/bash
    gatk GenotypeGVCFs \
        -R ${assembly}.fasta \
        -V ${file} \
        --intervals ${chrom}:${start}-${end} \
        --create-output-variant-index \
        --allow-old-rms-mapping-quality-annotation-data \
        -O ${cohort}.${assembly}.${chrom}:${start}-${end}.genotyped.vcf.gz
    """
}
