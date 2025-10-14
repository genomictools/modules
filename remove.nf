process REMOVE {
    tag "${cohort}:${category}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/removed", mode: 'copy')

    input:
    tuple val(cohort), val(category),
          path(bim), path(bed), path(fam), path(log),
          val(n_samples), val(n_variants)

    output:
    tuple val(cohort), val(category),
          path("${cohort}.${category}.removed.bim"),
          path("${cohort}.${category}.removed.bed"),
          path("${cohort}.${category}.removed.fam"),
          path("${cohort}.${category}.removed.log"),
          env(n_samples), env(n_variants)

    script:
    def args = []
    if ( params.nonfounders ) { args << "--nonfounders" }
    if ( params.allow_novariants ) { args << "--allow-no-vars" }
    if ( params.allow_nosamples )  { args << "--allow-no-samples" }
    def args_str = args.join(' ')

    """
    # Filter variants
    plink --bfile ${bim.baseName} \
        --mind ${params.mind} \
        --rel-cutoff ${params.relatedness} \
        ${args_str} \
        --make-bed \
        --out ${cohort}.${category}.removed
    
    n_samples=\$(wc -l < "${cohort}.${category}.removed.fam")
    n_variants=\$(wc -l < "${cohort}.${category}.removed.bim")
    """
}
