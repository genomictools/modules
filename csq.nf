process CSQ {
    tag "${params.assembly}:${params.tool}:${params.version}:${id}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/csq", mode: 'copy')

    input:
    tuple val(id), path(file), path(index)

    output:
    tuple val(id), path("${id}.csq.vcf.gz"), path("${id}.csq.vcf.gz.tbi"),
          env(n_variants)

    script:
    """
    #!/bin/bash
    # Extract missense variants
    bcftools csq --phase a -f ${params.fasta} -g ${params.gff} ${file} | \
    if   [ '${params.missense_only}' = 'true' ]; then bcftools view -i "INFO/BCSQ[*] ~'missense'"; else bcftools view ; fi | \
    bcftools view -Oz -o ${id}.csq.vcf.gz
    
    tabix ${id}.csq.vcf.gz
    n_variants=\$(bcftools index -n ${id}.csq.vcf.gz)
    """
}
