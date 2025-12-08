process CONVERT {
    tag "${cohort}:${key}:${region}"

    label 'simple'
    label 'samtools'

    publishDir("${params.output_dir}/bam", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(region)

    output:
    tuple val(cohort), val(key), val(level),
          path("${cohort}.${key}.${region.replaceAll(/[:\-]/, '_')}.bam{,.bai}"),
          path("${cohort}.${key}.${region.replaceAll(/[:\-]/, '_')}.bam.log"),
          env(nmarkers),
          val(region)

    script:
    def region_safe = region.replaceAll(/[:\-]/, '_')
    """
    #!/bin/bash
    samtools view -b -T "${file(params.fasta)}" -o "${cohort}.${key}.${region_safe}.bam" ${file[0]} ${region} 2> "${cohort}.${key}.${region_safe}.bam.log"
    samtools index "${cohort}.${key}.${region_safe}.bam"
    nmarkers=\$(samtools view -c "${cohort}.${key}.${region_safe}.bam")
    """
}
