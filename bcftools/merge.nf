process MERGE {
    tag "${cohort}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/combined", mode: 'copy')

    input:
    tuple val(id), path(files), path(indexes), val(cohort)

    output:
    tuple val(cohort),
          path("${cohort}.vcf.gz"), path("${cohort}.vcf.gz.tbi")

    script:
    """
    #!/bin/bash
    # Merge
    bcftools merge \
        ${files.join(' ')} \
        --threads ${task.cpus} \
        -Oz -o ${cohort}.vcf.gz

    # Index
    tabix ${cohort}.vcf.gz
    """
}
