process MERGE {
    tag "${cohort}:${assembly}"

    label 'simple'
    label 'gatk'

    publishDir("${params.output_dir}/merged", mode: 'copy')

    input:
    tuple val(cohort), val(assembly), val(chrom), val(start), val(end),
          path(file), path(index)

    output:
    tuple val(cohort), val(assembly),
          path("${cohort}.${assembly}.merged.vcf.gz"),
          path("${cohort}.${assembly}.merged.vcf.gz.tbi")

    script:
    def args = []
    file.each { file -> args.add("-I ${file}") }
    def args_str = args.join(' ')
    """
    #!/bin/bash
    gatk MergeVcfs \
        --CREATE_INDEX \
        ${args_str} \
        -O ${cohort}.${assembly}.merged.vcf.gz
    """
}
