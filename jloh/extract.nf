process EXTRACT {
    tag "${cohort}:${key}:${sample}:${sample_type}"

    label 'simple'
    label 'jloh'

    publishDir("${params.output_dir}/extracted", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(sample), val(sample_type),
		  path(vcf), path(vcf_index), val(n_variants),
          path(bam), path(bam_index), val(n_reads),
          path(fasta)

    output:
    tuple val(cohort), val(key), val(sample), val(sample_type),
          path("${cohort}.${key}.${sample}.${sample_type}.LOH_blocks.tsv"),
          path("${cohort}.${key}.${sample}.${sample_type}.exp.het_blocks.bed"),
          path("${cohort}.${key}.${sample}.${sample_type}.log")

    script:
    """
    #!/bin/bash
    jloh extract \
    	--vcf ${vcf} \
        --bam ${bam} \
        --ref ${fasta} \
        --sample ${cohort}.${key}.${sample}.${sample_type} \
        --output-dir . \
        --threads ${task.cpus} \
        --min-snps-kbp ${params.min_snps_kbp} \
      	2> ${cohort}.${key}.${sample}.${sample_type}.log
    """
}
