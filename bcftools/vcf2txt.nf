process VCF2TXT {
    tag "${cohort}:${key}:${level}"

    label 'simple'
    label 'bcftools2'

    publishDir("${params.output_dir}/signal", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers)

    output:
    tuple val(cohort), val(key), val("raw"),
        path("${cohort}.${key}.raw.txt"),
        path("${cohort}.${key}.log"),
        env(nmarkers)

    script:
    """
    #!/bin/bash
    echo -e "Name\tB Allele Freq\tLog R Ratio" > ${cohort}.${key}.raw.txt
    bcftools query -f '[%ID\t%BAF\t%LRR]\n' ${file[0]} >> ${cohort}.${key}.raw.txt 2> ${cohort}.${key}.log
    nmarkers=\$(wc -l < ${cohort}.${key}.raw.txt)
    """
}

    // if [ "${params.clean}" == "true" ]; then 
    //     awk '{
    //         if (match(\$1, /rs[0-9]+/)) {
    //             rsid = substr(\$1, RSTART, RLENGTH)
    //             print rsid, \$2, \$3
    //         } else {
    //             print \$1, \$2, \$3
    //         }
    //     }'
    // else 
    //     cat
    // fi 