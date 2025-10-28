process GATHER {
    tag "${cohort}:${assembly}"

    label 'simple'
    label 'gatk'

    publishDir("${params.output_dir}/gathered", mode: 'copy')

    input:
    tuple val(assembly), val(fasta_id), val(cohort), path(file), path(index)

    output:
    tuple val(assembly), val(cohort),
          path("${assembly}.${cohort}.joint_called.vcf.gz"),
          path("${assembly}.${cohort}.joint_called.vcf.gz.tbi")

    script:
    def args = []
    file.each { file -> args.add("-I ${file}") }
    def args_str = args.join(' ')
    """
    #!/bin/bash
    gatk MergeVcfs \
        --CREATE_INDEX \
        ${args_str} \
        -O ${assembly}.${cohort}.joint_called.vcf.gz
    """
}
