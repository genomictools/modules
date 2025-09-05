process ALPHAGENOME {
    tag "${params.species}:${params.tool}:${params.version}:${id}"

    label 'simple'
    label 'alphagenome'

    publishDir("${params.output_dir}/annotations/${params.tool}", mode: 'copy')

    input:
    tuple val(id), path(file), path(index)

    output:
    tuple val("${params.species}"), val("${params.tool}"), val("${params.version}"), val(id),
          path("${params.species}.${params.tool}.${params.version}.${id}.header.txt"),
          path("${params.species}.${params.tool}.${params.version}.${id}.scores.tsv.gz"),
          path("${params.species}.${params.tool}.${params.version}.${id}.scores.tsv.gz.tbi"),
          env(n_variants)
    
    secret 'API_KEY'
    // nextflow secret set API_KEY <api_key>

    script:
    """
    #!/bin/bash
    query_alphagenome.py \
        --api_key \$API_KEY \
        --vcf_file ${file} \
        --organism ${params.species} \
        --sequence_length ${params.distance} \
        --output output.tsv

    # Create header file
    echo "##INFO=<ID=${params.tool},Number=.,Type=String,Description=\"Format: \$(head -1 output.tsv | tr '\t' '|')\">" > ${params.species}.${params.tool}.${params.version}.${id}.header.txt

	# Extract AlphaGenome scores
    tail -n +2 output.tsv | \
	sort -k1,1 -k2,2n | \
	bgzip -c > ${params.species}.${params.tool}.${params.version}.${id}.scores.tsv.gz
    
	tabix -s1 -b2 -e2 ${params.species}.${params.tool}.${params.version}.${id}.scores.tsv.gz

    # Count the number of variants
    n_variants=\$(zcat ${params.species}.${params.tool}.${params.version}.${id}.scores.tsv.gz | wc -l)
    """
}
