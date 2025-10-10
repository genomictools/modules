process PRUNE {
    tag "${cohort}:${type}:${chunk}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/pruned", mode: 'copy')

    input:
    tuple val(cohort), val(type), val(chunk),
          path(bim), path(bed), path(fam), path(nosex), path(log),
          path(ld_regions)
          
    output:
    tuple val(cohort), val(type), val(chunk),
          path("${cohort}.${type}.${chunk}.prune.bim"),
          path("${cohort}.${type}.${chunk}.prune.bed"),
          path("${cohort}.${type}.${chunk}.prune.fam"),
          path("${cohort}.${type}.${chunk}.prune.nosex"),
          path("${cohort}.${type}.${chunk}.prune.log")

    script:
    """
    #!/bin/bash        
    plink --bfile ${bim.baseName} \
        --exclude range ${ld_regions} \
        --indep-pairwise ${params.window} ${params.step} ${params.rsquared} \
        --const-fid 0 \
        --out plink_tmp
    
    plink --bfile ${bim.baseName} \
        --extract plink_tmp.prune.in \
        --make-bed \
        --const-fid 0 \
        --out ${cohort}.${type}.${chunk}.prune
    
    # Explicitly rename output files
    mv plink_tmp.prune.log ${cohort}.${type}.${chunk}.prune.log
    mv plink_tmp.prune.in  ${cohort}.${type}.${chunk}.prune.in
    mv plink_tmp.prune.out ${cohort}.${type}.${chunk}.prune.out
    """
}
