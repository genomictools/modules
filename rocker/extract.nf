process EXTRACT {
    tag "${cohort}:${key}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/signal", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers)

    output:
    tuple val(cohort), val(key), val('raw'),
          path("${cohort}.${key}.raw.txt"),
          path("${cohort}.${key}.extract.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    echo "EXTRACT ${cohort}:${key} started \$(date)" > "${cohort}.${key}.extract.log"
    
    awk '
    BEGIN { FS="\\t"; OFS="\\t"; marker_count = 0 }
    /^\\[Header\\]/ { in_header=1; in_data=0; next }
    /^\\[Data\\]/ { 
        in_header=0; 
        in_data=1; 
        print "Name\tB Allele Freq\tLog R Ratio" > "${cohort}.${key}.raw.txt"
        next 
    }
    in_data && NF > 0 && !/^SNP Name/ {
        print \$${params.name_col}"\t"\$${params.baf_col}"\t"\$${params.lrr_col} > "${cohort}.${key}.raw.txt"
        marker_count++
    }
    END {
        print marker_count > "marker_count.txt"
    }
    ' ${file}

    nmarkers=\$(cat marker_count.txt)
    echo "Markers extracted: \$nmarkers" >> "${cohort}.${key}.extract.log"
    echo "EXTRACT ${cohort}:${key} completed \$(date)" >> "${cohort}.${key}.extract.log"
    """
}
