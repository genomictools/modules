process GENOTYPE {
    tag "${cohort}:${key}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/signal", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers)

    output:
    tuple val(cohort), val(key), val('genotype'),
          path("${cohort}.${key}.genotype.lgen"),
          path("${cohort}.${key}.genotype.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    echo "EXTRACT ${cohort}:${key} started \$(date)" > "${cohort}.${key}.genotype.log"
    
    awk '
    BEGIN { FS="\\t"; OFS="\\t"; marker_count = 0 }
    /^\\[Header\\]/ { in_header=1; in_data=0; next }
    /^\\[Data\\]/ { 
        in_header=0; 
        in_data=1; 
        next 
    }
    in_data && NF > 0 && !/^SNP Name/ {
        print \$${params.name_col}, \$${params.a1_col}, \$${params.a2_col} > "${cohort}.${key}.genotype.lgen"
        marker_count++
    }
    END {
        print marker_count > "marker_count.txt"
    }
    ' ${file}

    nmarkers=\$(cat marker_count.txt)
    echo "Genotypes extracted: \$nmarkers" >> "${cohort}.${key}.genotype.log"
    echo "GENOTYPE ${cohort}:${key} completed \$(date)" >> "${cohort}.${key}.genotype.log"
    """
}
