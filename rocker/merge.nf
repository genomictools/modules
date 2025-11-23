process MERGE {
    tag "${cohort}:${key}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/signal", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level), 
          path(file), path(log), val(nmarkers),
          path(pfb)

    output:
    tuple val(cohort), val(key), val('merged'),
          path("${cohort}.${key}.merged.txt"),
          path("${cohort}.${key}.merge.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    echo "MERGE ${cohort}:${key} started \$(date)" > "${cohort}.${key}.merge.log"
    
    echo -e "SNP Name\\tChromosome\\tPosition\\tLog R Ratio\\tB Allele Frequency" > "${cohort}.${key}.merged.txt"
    
    # Join by first column
    join -1 1 -2 1 -t \$'\\t' -o 1.1,1.2,1.3,2.2,2.3 \\
        <(sort -k1,1 ${pfb}) \\
        <(sort -k1,1 ${file}) \\
        >> "${cohort}.${key}.merged.txt"
    
    nmarkers=\$(tail -n +2 "${cohort}.${key}.merged.txt" | wc -l)
    echo "Markers merged: \$nmarkers" >> "${cohort}.${key}.merge.log"
    echo "MERGE ${cohort}:${key} completed \$(date)" >> "${cohort}.${key}.merge.log"
    """
}