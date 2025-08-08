process PRUNE {
    tag "${cohort}:${category}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/pruned", mode: 'copy')

    input:
    tuple val(cohort), val(category),
          path(bim), path(bed), path(fam), path(nosex), path(log)

    output:
    tuple val(cohort), val(category),
          path("${cohort}.${category}.pruned.bim"),
          path("${cohort}.${category}.pruned.bed"),
          path("${cohort}.${category}.pruned.fam"),
          path("${cohort}.${category}.pruned.nosex"),
          path("${cohort}.${category}.pruned.log")

    script:
    """
    #!/bin/bash        
    plink --bfile ${bim.baseName} \
        --indep-pairwise ${params.window} ${params.step} ${params.rsquared} \
        --exclude range ${params.ld_regions} \
        --make-bed \
        --out ${cohort}.${category}.pruned
    """
}
