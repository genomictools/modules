process COMBINE {
    tag "${cohort}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/combined", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(bim), path(bed), path(fam), path(log)

    output:
    tuple val(cohort),
          path("${cohort}.bim"),
          path("${cohort}.bed"),
          path("${cohort}.fam"),
          path("${cohort}.log")

    script:
    """
    #!/bin/bash
    # Create a list of all files
    echo "${bed.join('\n')}" > bed.txt
    echo "${bim.join('\n')}" > bim.txt
    echo "${fam.join('\n')}" > fam.txt
    paste -d ' ' bed.txt bim.txt fam.txt | sort -V > allfiles.txt

    # Merge all files
    plink \
        --make-bed \
        --merge-list allfiles.txt \
        --out ${cohort}
    """
}
