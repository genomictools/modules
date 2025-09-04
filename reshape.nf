process RESHAPE2 {
    tag "${params.species}:${params.tool}:${params.version}:${id}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/annotations/${tool}", mode: 'copy')

    input:
    tuple val(species), val(tool), val(version),
		  val(id), path(header), path(file), path(index),
		  val(n_variants)

    output:
    tuple val(species), val(tool), val(version), val(id),
          path("${species}.${tool}.${version}.${id}.annotated.vcf.gz"),
          path("${species}.${tool}.${version}.${id}.annotated.vcf.gz.tbi")

    script:
    """
    #!/bin/bash
	# Convert to VCF format
	bcftools convert \
		--tsv2vcf ${file} \
		-c CHROM,POS,REF,ALT,ID \
		-f ${params.fasta} | \
	bcftools annotate \
		-a ${file} \
		-c CHROM,POS,REF,ALT,ID,${tool} \
		-h ${header} \
		--merge-logic ${tool}:unique \
		--threads ${task.cpus} \
		-Oz -o ${species}.${tool}.${version}.${id}.annotated.vcf.gz
	tabix ${species}.${tool}.${version}.${id}.annotated.vcf.gz 
    """
}
