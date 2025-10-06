process STATS {
    tag "${cohort}:${key}:${sample}:${sample_type}"

    label 'simple'
    label 'jloh'

    publishDir("${params.output_dir}/stats", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(sample), val(sample_type),
		  path(vcf), path(vcf_index)

    output:
    tuple val(cohort), val(key), val(sample), val(sample_type),
          path("${cohort}.${key}.${sample}.${sample_type}.txt")

    script:
    """
    #!/bin/bash
	jloh stats \
        --vcf ${vcf} \
        2> ${cohort}.${key}.${sample}.${sample_type}.txt
    """
}
