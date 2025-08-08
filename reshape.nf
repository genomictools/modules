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
	# Create header file
	echo "##INFO=<ID=${tool},Number=.,Type=String,Description=\"AlphaGenome predictions. Format: \$(head -1 ${file} | cut -f 6- | tr '\t' '|')\">" > header.txt

	# Convert to VCF format
	bcftools convert \
		-c CHROM,POS,REF,ALT,ID \
		--tsv2vcf ${file} \
		-f ${params.fasta} | \
	bcftools norm -d none \
		--threads ${task.cpus} \
		-Oz -o ${species}.${tool}.${version}.${id}.variants.vcf.gz
	tabix ${species}.${tool}.${version}.${id}.variants.vcf.gz

	# Extract AlphaGenome scores
    tail -n +2 ${file} | \
	sed 's/, /\\//g' | \
	sed 's/ /\\_/g' | \
	awk '{
		printf "%s\t%s\t%s\t%s\t%s\t", \$1, \$2, \$3, \$4, \$5;
		for(i=6;i<=NF;i++) {
			printf "%s%s", \$i, (i<NF ? "|" : "\\n")
		}
	}' | \
	sort -k1,1 -k2,2n | \
	bgzip -c > ${species}.${tool}.${version}.${id}.annotations.tsv.gz
    
	tabix -s1 -b2 -e2 ${species}.${tool}.${version}.${id}.annotations.tsv.gz

	# Annotate VCF
	bcftools annotate \
		-h header.txt \
		-a ${species}.${tool}.${version}.${id}.annotations.tsv.gz \
		-c CHROM,POS,REF,ALT,ID,${tool} \
		--merge-logic ${tool}:unique \
		${species}.${tool}.${version}.${id}.variants.vcf.gz \
		--threads ${task.cpus} \
		-Oz -o ${species}.${tool}.${version}.${id}.scores.vcf.gz

	tabix ${species}.${tool}.${version}.${id}.scores.vcf.gz
    """
}
