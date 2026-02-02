process COUNT {
    tag "${cohort}:${key}:${type}:${gene}"

    label 'simple'
    label 'exomedepth'

    publishDir("${params.output_dir}/counts", mode: 'copy')

    input:
    tuple val(gene), path(exons),
          val(cohort), val(key), val(type),
          path(bam), path(bai),
          path(fasta)
    
    output:
    tuple val(cohort), val(key), val(type), val(gene),
          path("${cohort}.${key}.${type}.${gene}.counts.bed"),
          env(coverage)

    script:
    """
    #!/bin/bash
    count_exons.R ${bam} ${bai} ${exons} ${key} ${fasta} ${cohort}.${key}.${type}.${gene}.counts.bed
	coverage=\$(awk 'NR > 1 {sum += \$5} END {print sum}' ${cohort}.${key}.${type}.${gene}.counts.bed)
    """
}
