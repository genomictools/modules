process MERGE {
    tag "${cohort}"

    label 'max'
    label 'bcftools'

    publishDir("${params.output_dir}/combined", mode: 'copy')

    input:
    tuple val(id), path(files), val(cohort)

    output:
    tuple val(cohort),
          path("${cohort}.vcf.gz"), path("${cohort}.vcf.gz.tbi")

    script:
    """
    #!/bin/bash
    # Merge
    echo "${files.join('\n')}" | grep -v tbi | uniq > ${cohort}.txt
    bcftools merge \
        -l ${cohort}.txt | \
    bcftools view \
        --threads ${task.cpus} \
        -Oz -o ${cohort}.vcf.gz

    # Index
    tabix ${cohort}.vcf.gz
    """
}
