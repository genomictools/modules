process PRUNE {
    tag "${cohort}:${key}:${category}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/pruned", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(category),
          path(bim), path(bed), path(fam), path(nosex), path(log)

    output:
    tuple val(cohort), val(key), val(category),
          path("${cohort}.${key}.${category}.pruned.bim"),
          path("${cohort}.${key}.${category}.pruned.bed"),
          path("${cohort}.${key}.${category}.pruned.fam"),
          path("${cohort}.${key}.${category}.nosex"),
          path("${cohort}.${key}.${category}.pruned.log")

    script:
    """
    #!/bin/bash        
    plink --bfile ${bim.baseName} \
        --indep-pairwise ${params.window} ${params.step} ${params.rsquared} \
        --out plink_tmp
    
    plink --bfile ${bim.baseName} \
        --extract plink_tmp.prune.in \
        --make-bed \
        --out ${cohort}.${key}.${category}.pruned

    # Explicitly rename output files
    mv plink_tmp.prune.in  ${cohort}.${key}.${category}.pruned.in
    mv plink_tmp.prune.out ${cohort}.${key}.${category}.pruned.out
    """
}
        // --exclude range ld_regions.bed \
