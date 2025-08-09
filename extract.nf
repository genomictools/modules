process EXTRACT {
    tag "${cohort}:${key}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/signal", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(file)

    output:
    tuple val(cohort), val(key), path("${cohort}.${key}.signal.txt")

    script:
    """
    #!/bin/bash
    echo -e "Name\tB Allele Freq\tLog R Ratio" > ${cohort}.${key}.signal.txt
    cat ${file} | tail -n +13 | cut -f 1,15,16 >> ${cohort}.${key}.signal.txt
    """
}