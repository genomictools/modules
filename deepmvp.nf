process DEEPMVP {
    tag "${params.assembly}:${params.tool}:${params.version}:${id}"

    label 'simple'
    label 'deepmvp'

    publishDir("${params.output_dir}/annotations/${params.tool}", mode: 'copy')

    input:
    tuple val(id), path(file), path(index), val(n_variants)

    output:
    tuple val("${params.assembly}"), val("${params.tool}"), val("${params.version}"), val(id),
          path("${params.assembly}.${params.tool}.${params.version}.${id}.header.txt"),
          path("${params.assembly}.${params.tool}.${params.version}.${id}.scores.tsv.gz"),
          path("${params.assembly}.${params.tool}.${params.version}.${id}.scores.tsv.gz.tbi"),
          env(n_variants)

    script:
    """
    #!/bin/bash
    # Extract variants
    bcftools view -H ${file} | cut -f 1-5 > ${id}.variants.tsv

    # Translate protein consequences
    python /DeepMVP/DeepMVP.py translate \
        -i ${id}.variants.tsv \
        -o ${id}.protvar.tsv
    
    # call deepmvp
    python /DeepMVP/DeepMVP.py predict \
        -i ${id}.protvar.tsv \
        -m ${params.models}/ \
        -d ${params.uniprot} \
        -t 1 \
        -o .

    # Create header file
	echo "##INFO=<ID=${params.tool},Number=.,Type=String,Description=\"Format: \$(head -1 deepmvp-mutation_impact.tsv | tr '\t' '|')\">" > ${params.assembly}.${params.tool}.${params.version}.${id}.header.txt

    # Format output
    cat deepmvp-mutation_impact.tsv | \
    awk 'BEGIN{OFS="\t"} NR==1{print "CHROM","POS","REF","ALT",\$0; next} {split(\$1,a,":"); print a[1],a[2],a[3],a[4],\$0}' | \
    tail -n +2 | \
    sort -k1,1 -k2,2n | \
	bgzip -c > ${params.assembly}.${params.tool}.${params.version}.${id}.scores.tsv.gz
    
    # Index the output
	tabix -s1 -b2 -e2 ${params.assembly}.${params.tool}.${params.version}.${id}.scores.tsv.gz
    
    # Count the number of variants
    n_variants=\$(zcat ${params.assembly}.${params.tool}.${params.version}.${id}.scores.tsv.gz | wc -l)
    """
}
