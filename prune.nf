process PRUNE {
    tag "${cohort}:${key}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/pruned", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(bim), path(bed), path(fam), path(log)

    output:
    tuple val(cohort), val(key),
          path("${cohort}.${key}.pruned.bim"),
          path("${cohort}.${key}.pruned.bed"),
          path("${cohort}.${key}.pruned.fam"),
          path("${cohort}.${key}.pruned.log")

    script:
    """
    #!/bin/bash        
    plink --bfile ${bim.baseName} \
        --indep-pairwise ${params.window} ${params.step} ${params.rsquared} \
        --out plink_tmp
    
    plink --bfile ${bim.baseName} \
        --extract plink_tmp.prune.in \
        --make-bed \
        --out ${cohort}.${key}.pruned
    
    # Explicitly rename output files
    mv plink_tmp.prune.in  ${cohort}.${key}.pruned.in
    mv plink_tmp.prune.out ${cohort}.${key}.pruned.out
    """
}
        // --exclude range ld_regions.bed \
