process ONCOEXTRACT {
    tag "${cohort}:${key}:${sample}"

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
          path("${cohort}.${key}.${sample}.*")

    script:
    def args = []
    if ( params.tumour_only ) {
        args << "--single-mode True"
        args << "--vcf ${vcf}"
        args << "--bam ${bam}"
    } else {
        args << "--vcfs ${vcf.join(' ')}"
        args << "--bams ${bam.join(' ')}"
    }

    args_str = args.join(" ")
    """
    #!/bin/bash
    jloh onco_extract \
        --ref ${fasta} \
        --min_snps ${params.min_snps} \
        --min_snps_het ${params.min_snps_het} \
        --sample ${cohort}.${key}.${sample} \
        --output-dir . \
        --threads ${task.cpus} \
        ${args_str} \
        2> ${cohort}.${key}.${sample}.log
    """
}