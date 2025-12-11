process GTC2VCF {
    tag "${cohort}:${key}:${level}"

    label 'simple'
    label 'bcftools2'

    publishDir("${params.output_dir}/signal", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers)

    output:
    tuple val(cohort), val(key), val("vcf"),
		  path("${cohort}.${key}.vcf.gz{,.csi}"),
		  path("${cohort}.${key}.vcf.log"),
		  env(nmarkers)

    script:
    """
    #!/bin/bash
	bcftools +gtc2vcf \
		"${file}" \
		--bpm "${file(params.manifest)}" \
		--csv "${file(params.probes)}" \
		--egt "${file(params.clusters)}" \
		--fasta-ref "${file(params.fasta)}" \
		--do-not-check-bpm | \
	bcftools sort | \
	bcftools norm \
		-c x \
		-f "${file(params.fasta)}" \
		-Oz -o "${cohort}.${key}.vcf.gz" \
		2> "${cohort}.${key}.vcf.log"

	bcftools index "${cohort}.${key}.vcf.gz"

	nmarkers=\$(bcftools view -H "${cohort}.${key}.vcf.gz" | wc -l)
    """
}
