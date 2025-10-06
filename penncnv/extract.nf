process EXTRACT {
    tag "${cohort}:${key}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/signal", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level), path(file),
          val(dbspn), val(txt), file(pfb)

    output:
    tuple val(cohort), val(key), val('genotype,merged,raw'),
          path("${cohort}.${key}.{raw.txt,genotype.lgen,merged.txt}")

    script:
    """
    #!/bin/bash
    awk '
    BEGIN { FS="\\t"; OFS="\\t" }
    /^\\[Header\\]/ { in_header=1; in_data=0; next }
    /^\\[Data\\]/ { 
        in_header=0; 
        in_data=1; 
        print "Name", "B Allele Freq", "Log R Ratio" > "${cohort}.${key}.raw.txt"
        print "SNP Name", "Chromosome", "Position", "Log R Ratio", "B Allele Frequency" > "${cohort}.${key}.merged.txt"
        next 
    }
    in_data && NF > 0 && !/^SNP Name/ {
        print \$1, \$15, \$16 > "${cohort}.${key}.raw.txt"
        print "${key}", "${key}", \$1, \$7, \$8 > "${cohort}.${key}.genotype.lgen"
    }
    ' ${file}

    # Join by first column
    join -1 1 -2 1 -t \$'\t' -o 1.1,1.2,1.3,2.2,2.3 \
        <(sort -k1,1 ${pfb}) \
        <(sort -k1,1 ${cohort}.${key}.raw.txt) \
        >> ${cohort}.${key}.merged.txt
    """
}
