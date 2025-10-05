process PANGOLIN {
    tag "${params.assembly}:${params.tool}:${params.version}:${id}"

    label 'simple'
    label 'pangolin'

    publishDir("${params.output_dir}/annotations/${tool}", mode: 'copy')

    input:
    tuple val(id), path(file), path(index), val(tool)

    output:
    tuple val("${params.assembly}"), val("${params.tool}"), val("${params.version}"), val(id),
          path("${params.assembly}.${params.tool}.${params.version}.${id}.vcf.gz"),
          path("${params.assembly}.${params.tool}.${params.version}.${id}.vcf.gz.tbi"),
          env(nvariants)

    script:
    def args = []
    if ( params.masked )           { args << "-m True" }
    if ( params.distance != null ) { args << "-d ${params.distance}" }
    def args_str = args.join(' ')

    """
    #!/bin/bash
    pangolin \
        ${file} \
        ${params.fasta} \
        ${params.annotation} \
        ${params.assembly}.${params.tool}.${params.version}.${id}.vcf.gz \
        ${args_str}

    touch ${params.assembly}.${params.tool}.${params.version}.${id}.vcf.gz.tbi

    nvariants=\$(zcat ${params.assembly}.${params.tool}.${params.version}.${id}.vcf.gz | grep -v '^#' | wc -l)
    """
}
