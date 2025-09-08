process GENOTYPE {
    tag "${cohort}:${key}"

    label 'simple'

    publishDir("${params.output_dir}/genotype", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(file),
          val(dbspn), val(txt), file(pfb)

    output:
    tuple val(cohort), val(key), val('genotype'),
          path("${cohort}.${key}.genotype.{lgen,map,fam}"),
          path("${cohort}.${key}.genotype.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    cat ${file} | \
    awk '
    BEGIN { FS="\\t"; OFS="\\t" }
    /^\\[Header\\]/ { in_header=1; in_data=0; next }
    /^\\[Data\\]/ { in_header=0; in_data=1; next }
    in_data && NF > 0 && !/^SNP Name/ {
        print "${key}", "${key}", \$1, \$7, \$8
    }
    ' > ${cohort}.${key}.genotype.lgen

    tail -n +2 ${pfb} | awk '{print \$2, \$1, "0", \$3}' > "${cohort}.${key}.genotype.map"
    echo -e "${key}\t${key}\t0\t0\t0\t-9" > "${cohort}.${key}.genotype.fam"

    touch "${cohort}.${key}.genotype.log"

    # fam and map
    nmarkers=\$(wc -l < "${cohort}.${key}.genotype.lgen")
    """
}
