process EXCLUDE {
    tag "${cohort}:${type}:${chunk}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/excluded", mode: 'copy')

    input:
    tuple val(cohort), val(type), val(chunk),
          path(bim), path(bed), path(fam), path(nosex), path(log)          
    output:
    tuple val(cohort), val(type), val(chunk),
          path("${cohort}.${type}.${chunk}.excluded.bim"),
          path("${cohort}.${type}.${chunk}.excluded.bed"),
          path("${cohort}.${type}.${chunk}.excluded.fam"),
          path("${cohort}.${type}.${chunk}.excluded.nosex"),
          path("${cohort}.${type}.${chunk}.excluded.log")

    script:
    """
    #!/bin/bash        
    plink --bfile ${bim.baseName} \
        --exclude range ${file(params.exclude_regions)} \
        --make-bed \
        --out ${cohort}.${type}.${chunk}.excluded
    """
}
