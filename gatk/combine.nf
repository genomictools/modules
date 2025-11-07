process COMBINE {
    tag "${cohort}:${assembly}:${chrom}:${start}-${end}"

    label 'heavy'
    label 'gatk'

    publishDir("${params.output_dir}/combined", mode: 'copy')

    input:
    tuple val(cohort), 
          val(id), path(file), path(index),
          val(assembly), path(fasta),
          val(chrom), val(start), val(end)

    output:
    tuple val(cohort), val(assembly), val(chrom), val(start), val(end),
          path("${cohort}.${assembly}.${chrom}:${start}-${end}.combined.g.vcf.gz"),
          path("${cohort}.${assembly}.${chrom}:${start}-${end}.combined.g.vcf.gz.tbi")

    script:
    def args = []
    file.each { file -> args.add("--variant ${file}") }
    def args_str = args.join(' ')
    """
    #!/bin/bash
    gatk CombineGVCFs \
        -R ${assembly}.fasta \
        ${args_str} \
        --intervals ${chrom}:${start}-${end} \
        --create-output-variant-index \
        -O ${cohort}.${assembly}.${chrom}:${start}-${end}.combined.g.vcf.gz
    """
}
