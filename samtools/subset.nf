
process SUBSET {
    tag "${cohort}:${key}:${sample}:${sample_type}"

    label 'simple'
    label 'samtools'

    publishDir("${params.output_dir}/subsets", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(sample), val(sample_type),
          path(bam), path(bam_index)

    output:
    tuple val(cohort), val(key), val(sample), val(sample_type),
          path("${cohort}.${key}.${sample}.${sample_type}.bam"),
          path("${cohort}.${key}.${sample}.${sample_type}.bam.bai"),
          env(n_reads)

    script:
    """
    #!/bin/bash
    samtools view -b -h -o ${cohort}.${key}.${sample}.${sample_type}.bam ${bam} ${key}
    samtools index ${cohort}.${key}.${sample}.${sample_type}.bam
    n_reads=\$(samtools idxstats ${cohort}.${key}.${sample}.${sample_type}.bam | cut -f3 | awk '{s+=\$1} END {print s}')
    """
}
