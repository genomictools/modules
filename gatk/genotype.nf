process GENOTYPE {
    tag "${assembly}:${cohort}:${chunk}"

    label 'simple'
    label 'gatk'

    publishDir("${params.output_dir}/genotyped", mode: 'copy')

    input:
    tuple val(assembly), val(cohort), val(chunk),
          path(db), path(fasta)

    output:
    tuple val(assembly), val(cohort), val(chunk),
          path("${assembly}.${cohort}.${chunk}.genotyped.vcf.gz"),
          path("${assembly}.${cohort}.${chunk}.genotyped.vcf.gz.tbi")

    script:
    """
    #!/bin/bash
    set -euo pipefail
    
    gatk --java-options "-Xmx8g -XX:ParallelGCThreads=2" GenotypeGVCFs \
        -R ${fasta.last()} \
        -V gendb://${db} \
        --allow-old-rms-mapping-quality-annotation-data \
        --create-output-variant-index \
        -O ${assembly}.${cohort}.${chunk}.genotyped.vcf.gz
    """
}