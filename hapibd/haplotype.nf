process HAPLOTYPE {
    tag "${cohort}:${family}:${chrom}"

    label 'simple'
    label 'hapibd'

    def type = 'haplotype'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(type),
          path(file), path(index), path(log),
          val(n_samples), val(n_variants),
          path(gmap)

    output:
    tuple val(cohort), val(family), val(chrom), val("${type}"),
          path("${cohort}.${family}.${chrom}.${type}.hbd"),
          path("${cohort}.${family}.${chrom}.${type}.ibd"),
          path("${cohort}.${family}.${chrom}.${type}.log"),
          env(n_segments)

    script:
    """
    #!/bin/bash
    # Convert genetic map to plink format
    zcat ${gmap} | awk 'NR > 1 {print "chr"\$2, ".", \$3, \$1}' > plink_format.map

    # Run hap-ibd
    hap-ibd \
        gt=${file} \
        map=plink_format.map \
        out="${cohort}.${family}.${chrom}.${type}" \
        nthreads=${task.cpus} \
        min-mac=${params.mac} \
        min-markers=${params.markers} \
        min-output=${params.output} \
        min-seed=${params.seed} \
        min-extend=${params.extend}

    # Unzip the output files
    gunzip -f "${cohort}.${family}.${chrom}.${type}.hbd.gz" "${cohort}.${family}.${chrom}.${type}.ibd.gz"

    # Count the number of segments in the IBD file
    n_segments=\$(cat "${cohort}.${family}.${chrom}.${type}.ibd" | wc -l | awk '{print \$1}')
    """
}
