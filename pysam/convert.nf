process CONVERT {
    tag "${id}"

    label 'max'
    label 'pysam'

    publishDir("${params.output_dir}/converted", mode: 'copy')

    input:
    tuple val(id), path(files)

    output:
    tuple val(id),
          path("${id}.converted.vcf.gz"),
          path("${id}.converted.vcf.gz.tbi")

    script:
    """
    #!/bin/bash
    pythongvcf_to_vcf.py ${files[0]} ${params.fasta} | bgzip > ${id}.converted.vcf.gz
    touch ${id}.converted.vcf.gz.tbi
    """
}
