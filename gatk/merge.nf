process MERGE {
    tag "${cohort}:${assembly}"

    label 'simple'
    label 'gatk'

    publishDir("${params.output_dir}/merged", mode: 'copy')

    input:
    tuple val(assembly), val(cohort), val(chunk),
          path(files), path(indices),
          path(fasta)

    output:
    tuple val(assembly), val(cohort), 
          path("${assembly}.${cohort}.merged.vcf.gz"),
          path("${assembly}.${cohort}.merged.vcf.gz.tbi")

    script:
    def input_args = files.collect { "-I ${it}" }.join(' ')
    """
    #!/bin/bash
    gatk MergeVcfs \
        -R ${fasta.last()} \
        ${input_args} \
        --CREATE_INDEX \
        -O ${assembly}.${cohort}.merged.vcf.gz
    """
}
