process SEVERUS {
    tag "${cohort}:${patient}:${sample}"

    label 'heavy'
    label 'severus'

    publishDir("${params.output_dir}/severus/${patient}/${sample}", mode: 'copy')

    input:
    tuple val(cohort), val(patient), val(sample), val(type), 
          path(file), path(index)

    output:
    tuple val(cohort), val(patient), val(sample), val(type), 
          path("read_qual.txt"),
          path("breakpoints_double.csv"),
          path("all_SVs/breakpoint_clusters.tsv"),
          path("all_SVs/breakpoint_clusters_list.tsv"),
          path("all_SVs/plots/*.html"),
          path("all_SVs/severus_all.vcf"),
          path("severus.log")

    script:
    """
    #!/bin/bash
    severus \
        --target-bam ${file} \
        --out-dir . \
        -t ${task.cpus} \
    """
}

