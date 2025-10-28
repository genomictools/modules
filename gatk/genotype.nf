process GENOTYPE {
    tag "${cohort}:${assembly}:${fasta_id}"

    label 'simple'
    label 'gatk'

    publishDir("${params.output_dir}/joint_called", mode: 'copy')

    input:
    tuple val(assembly), val(fasta_id), val(cohort), path(file), path(index),
          path(fasta), path(fasta_index), path(fasta_dict)

    output:
    tuple val(assembly), val(fasta_id), val(cohort),
          path("${assembly}.${fasta_id}.${cohort}.joint_called.vcf.gz"),
          path("${assembly}.${fasta_id}.${cohort}.joint_called.vcf.gz.tbi")

    script:
    """
    #!/bin/bash
    gatk GenotypeGVCFs \
        -R ${fasta} \
        -V ${file} \
        --intervals ${fasta_id} \
        --create-output-variant-index \
        --allow-old-rms-mapping-quality-annotation-data \
        -O ${assembly}.${fasta_id}.${cohort}.joint_called.vcf.gz
    """
}
