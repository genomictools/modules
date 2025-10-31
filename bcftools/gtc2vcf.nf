process GTC2VCF {
    tag "${cohort}:${key}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/vcf", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(file)

    output:
    tuple val(cohort), val(key),
		path("${cohort}.${key}.vcf.gz"),
		path("${cohort}.${key}.vcf.gz.csi")

    script:
    """
    #!/bin/bash
	bcftools +gtc2vcf \
		${file} \
		--bpm ${file(params.bpm)} \
		--csv ${file(params.csv)} \
		--egt ${file(params.egt)} \
		--fasta-ref ${file(params.fasta)} \
		--do-not-check-bpm | \
	bcftools sort | \
	bcftools norm \
		-c x \
		-f ${file(params.fasta)} \
		-Oz -o ${cohort}.${key}.vcf.gz

	bcftools index ${cohort}.${key}.vcf.gz
    """
}
