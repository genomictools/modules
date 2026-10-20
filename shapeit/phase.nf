process PHASE {
    tag "${cohort}:${family}:${chrom}"

    label 'heavy'
    label 'shapeit'

    def type = 'phase'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(file), path(index),
          val(n_samples), val(n_variants),
          path(gmap),
          val(ref), path(ref_file), path(ref_index)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.vcf.gz"),
          path("${cohort}.${family}.${chrom}.${type}.vcf.gz.tbi"),
          path("${cohort}.${family}.${chrom}.${type}.log"),
          val(n_samples),
          val(n_variants)

    script:
    def ref_arg = (params.use_reference && ref_file) ? "--reference ${ref_file}" : ""
    """
    #!/bin/bash
    # Run shapeit4
    shapeit4 \
        --input ${file} \
        --region ${chrom} \
        --map ${gmap} \
        ${ref_arg} \
        --thread ${task.cpus} \
        --output "${cohort}.${family}.${chrom}.${type}.vcf.gz" \
        --log "${cohort}.${family}.${chrom}.${type}.log"
    tabix "${cohort}.${family}.${chrom}.${type}.vcf.gz"
    """
}
