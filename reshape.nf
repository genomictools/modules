process RESHAPE {
    tag "${params.species}:${params.tool}:${params.version}:${id}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/annotations", mode: 'copy')

    input:
    tuple val(species), val(tool), val(version), val(id), path(file)

    output:
    tuple val(species), val(tool), val(version),
          val(id),
          path("${species}.${tool}.${version}.${id}.scores.vcf.gz"),
          path("${species}.${tool}.${version}.${id}.scores.vcf.gz.tbi")

    script:
    """
    #!/bin/bash
	# Extract uniq varaints
    tail -n +2 ${file} | \
	cut -f 1 -d '|' | \
	sort -u | \
	tr ':' '\t' \
	> chr_pos.tsv

	# Extract AlphaGenome scores
    tail -n +2 ${file} | \
	awk -F'|' '{split(\$1, v, ":"); print v[1] "\t" v[2] "\t" v[3] "\t" v[4] "\t" \$0}' | \
	sort -k1,1 -k2,2n | \
	bgzip -c > anno.tsv.gz
    
	tabix -s1 -b2 -e2 anno.tsv.gz
    
	# Convert to VCF format
	bcftools convert \
		-c CHROM,POS,REF,ALT \
		--tsv2vcf chr_pos.tsv \
		-f ${params.fasta} \
		--threads ${task.cpus} \
        -Oz -o tmp.vcf.gz
    
	# Create header file
	echo "##INFO=<ID=AlphaGenome,Number=.,Type=String,Description=\"AlphaGenome predictions. Format: \$(head -n 1 ${file})\">" > header.txt
	
	# Annotate VCF
	bcftools annotate \
		-a anno.tsv.gz \
		-h header.txt \
		-c CHROM,POS,REF,ALT,AlphaGenome \
		-I %CHROM:%POS:%REF:%ALT \
		--merge-logic AlphaGenome:unique \
		tmp.vcf.gz \
		--threads ${task.cpus} \
		-Oz -o ${species}.${tool}.${version}.${id}.scores.vcf.gz

	tabix ${species}.${tool}.${version}.${id}.scores.vcf.gz
    """
}
