process EXTRACT {
    tag "${cohort}:${key}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/signal", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(file)

    output:
    tuple val(cohort), val(key), 
          path("${cohort}.${key}.data.txt"),
          path("${cohort}.${key}.data.log")

    script:
    """
    #!/bin/bash
    awk '
    BEGIN { FS="\\t"; OFS="\\t" }
    /^\\[Header\\]/ { in_header=1; in_data=0; next }
    /^\\[Data\\]/ { 
        in_header=0; 
        in_data=1; 
        print "Name", "B Allele Freq", "Log R Ratio" > "${cohort}.${key}.data.txt"
        next 
    }
    in_header && NF > 0 && !/^\\[/ {
        split(\$0, arr, "\\t")
        print arr[1], arr[2] > "${cohort}.${key}.data.log"
    }
    in_data && NF > 0 && !/^SNP Name/ {
        print \$1, \$15, \$16 > "${cohort}.${key}.data.txt"
    }
    ' ${file}
    """
}