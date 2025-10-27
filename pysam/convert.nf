process CONVERT {
    tag "${id}"

    label 'simple'
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
    gvcf_to_vcf.py ${files[0]} ${file(params.fasta)} | bgzip > ${id}.converted.vcf.gz
    tabix ${id}.converted.vcf.gz
    """
}
