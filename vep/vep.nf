process VEP {
    tag "${params.assembly}:${tool}:${params.version}:${id}"

    label 'simple'
    label 'vep'

    publishDir("${params.output_dir}/annotations/${tool}", mode: 'copy')

    input:
    tuple val(id), path(file), path(index), val(tool)

    output:
    tuple val("${params.assembly}"), val("${tool}"), val("${params.version}"), val(id),
          path("${params.assembly}.${tool}.${params.version}.${id}.vcf.gz"),
          path("${params.assembly}.${tool}.${params.version}.${id}.vcf.gz.tbi"),
          env(nvariants)

    script:
    def args = []
    if ( params.cadd )     { args << "--plugin CADD,snv=${params.cadd_snv},indels=${params.cadd_indel}" }
    if ( params.spliceai ) { args << "--plugin SpliceAI,snv=${params.spliceai_snv},indel=${params.spliceai_indel}" }
    if ( params.gnomad )   { args << "--custom ${params.gnomad_file},gnomAD,vcf,exact,0,AF" }
    if ( params.species == 'human' )   { args << "--species homo_sapiens" } else { args << "--species ${params.species}" }
    def args_str = args.join(' ')

    """
    #!/bin/bash
    vep \
        -i ${file} \
        -o ${params.assembly}.${tool}.${params.version}.${id}.vcf.gz \
        --assembly ${params.assembly} \
        --cache_version ${params.version} \
        --dir_cache ${params.vep_cache} \
        --fasta ${params.fasta} \
        --vcf_info_field vep \
        --cache \
        --offline \
        --everything \
        --format vcf \
        --vcf \
        --compress_output bgzip \
        --fork ${task.cpus} \
        ${args_str}

    tabix ${params.assembly}.${tool}.${params.version}.${id}.vcf.gz

    nvariants=\$(zcat ${params.assembly}.${tool}.${params.version}.${id}.vcf.gz | grep -v '^#' | wc -l)
    """
}
