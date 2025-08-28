process MERGE {
    tag "${cohort}:${key}"

    label 'simple'

    publishDir("${params.output_dir}/merged", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(dbspn), val(txt), file(pfb)
          

    output:
    tuple val(cohort), val(key), val('merged'),
          path("${cohort}.${key}.data.txt.merged"),
          path("${cohort}.${key}.merged.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Create a merge file
    echo -e "SNP Name\tChromosome\tPosition\tLog R Ratio\tB Allele Frequency" \
        > ${cohort}.${key}.data.txt.merged
    
    # Join by first column
    join -1 1 -2 1 -t \$'\t' -o 1.1,1.2,1.3,2.2,2.3 \
        <(sort -k1,1 ${pfb}) \
        <(sort -k1,1 ${file}) \
        >> ${cohort}.${key}.data.txt.merged

    # Create a log file
    touch ${cohort}.${key}.merged.log

    nmarkers=\$(wc -l < "${cohort}.${key}.data.txt.merged")
    """
}
