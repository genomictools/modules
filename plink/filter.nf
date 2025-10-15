process FILTER {
    tag "${ref}:${cohort}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/filtered", mode: 'copy')

    input:
    tuple val(ref), val(cohort),
          path(bim), path(bed), path(fam), path(nosex), path(log)

    output:
    tuple val(ref), val(cohort),
          path("${ref}.${cohort}.filtered.bim"),
          path("${ref}.${cohort}.filtered.bed"),
          path("${ref}.${cohort}.filtered.fam"),
          path("${ref}.${cohort}.filtered.nosex"),
          path("${ref}.${cohort}.filtered.log")

    script:
    """
    #!/bin/bash
    # Filter variants
    plink --bfile ${bim.baseName} \
        --mac ${params.MAC} \
        --maf ${params.MAF} \
        --hwe ${params.HWE} \
        --geno ${params.F_MISSING} \
        --make-bed \
        --out ${ref}.${cohort}.filtered
    """
}
