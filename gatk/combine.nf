process COMBINE {
    tag "${cohort}:${assembly}:${fasta_id}"

    label 'simple'
    label 'gatk'

    publishDir("${params.output_dir}/combined", mode: 'copy')

    input:
    tuple val(cohort), val(id), path(file), path(index),
          val(assembly), val(fasta_id), path(fasta), path(fasta_index), path(fasta_dict)

    output:
    tuple val(assembly), val(fasta_id), val(cohort),
          path("${assembly}.${fasta_id}.${cohort}.combined.g.vcf.gz"),
          path("${assembly}.${fasta_id}.${cohort}.combined.g.vcf.gz.tbi")

    script:
    def args = []
    file.each { file -> args.add("--variant ${file}") }
    def args_str = args.join(' ')
    """
    #!/bin/bash
    gatk CombineGVCFs \
        -R ${fasta} \
        ${args_str} \
        --intervals ${fasta_id} \
        --create-output-variant-index \
        -O ${assembly}.${fasta_id}.${cohort}.combined.g.vcf.gz
    """
}
