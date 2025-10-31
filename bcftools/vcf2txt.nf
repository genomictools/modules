process VCF2TXT {
    tag "${cohort}:${key}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/txt", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(file), path(index)

    output:
    tuple val(cohort), val(key), path("${cohort}.${key}.txt")

    script:
    """
    #!/bin/bash
    echo -e "Name\tB Allele Freq\tLog R Ratio" > ${cohort}.${key}.txt
    bcftools query -f '[%ID\t%BAF\t%LRR]\n' ${file} | \
    if [ "${params.clean}" == "true" ]; then 
        awk '{
            if (match(\$1, /rs[0-9]+/)) {
                rsid = substr(\$1, RSTART, RLENGTH)
                print rsid, \$2, \$3
            } else {
                print \$1, \$2, \$3
            }
        }'
    else 
        cat
    fi >> ${cohort}.${key}.txt
    """
}