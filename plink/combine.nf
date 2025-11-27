process COMBINE {
    tag "${cohort}:${level}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/genotypes", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(bim), path(bed), path(fam), path(log),
          val(n_variants)

    output:
    tuple val(cohort), val(level),
          path("${cohort}.${level}.combined.*"),
          env(n_variants)

    script:
    """
    #!/bin/bash
    # Create a list of all files
    paste -d ' ' <(echo "${bed.join('\n')}") <(echo "${bim.join('\n')}") <(echo "${fam.join('\n')}") | sort -V > allfiles.txt

    # Merge all files
    plink \
        --flip-scan \
        --write-snplist \
        --merge-list allfiles.txt \
        --out first_pass

    plink \
        --make-bed \
        --flip first_pass.missnp \
        --merge-list allfiles.txt \
        --out ${cohort}.${level}.combined

    n_variants=\$(wc -l < "${cohort}.${level}.combined.bim")
    """
}
