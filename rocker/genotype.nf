process GENOTYPE {
    tag "${cohort}:${key}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/genotypes", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          path(pfb),
          path(pedigree)

    output:
    tuple val(cohort), val(key), val('genotype'),
          path("${cohort}.${key}.genotype.lgen"),
          path("${cohort}.${key}.genotype.map"),
          path("${cohort}.${key}.genotype.fam"),
          path("${cohort}.${key}.genotype.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Create .fam file from pedigree
    grep ${key} ${pedigree} >> "${cohort}.${key}.genotype.fam"
    
    # Extract family id and sample id
    famid=\$(awk '{ print \$1 }' "${cohort}.${key}.genotype.fam" | head -n 1)
    sampleid=\$(awk '{ print \$2 }' "${cohort}.${key}.genotype.fam" | head -n 1)

    echo "EXTRACT ${cohort}:${key} started \$(date)" > "${cohort}.${key}.genotype.log"
    awk -v famid="\$famid" -v sampleid="\$sampleid" '
    BEGIN { FS="\\t"; OFS="\\t"; marker_count = 0 }
    /^\\[Header\\]/ { in_header=1; in_data=0; next }
    /^\\[Data\\]/ { 
        in_header=0; 
        in_data=1; 
        next 
    }
    in_data && NF > 0 && !/^SNP Name/ {
        print famid, sampleid, \$${params.name_col}, \$${params.a1_col}, \$${params.a2_col} > "${cohort}.${key}.genotype.lgen"
        marker_count++
    }
    END {
        print marker_count > "marker_count.txt"
    }
    ' ${file}

    nmarkers=\$(cat marker_count.txt)
    echo "Genotypes extracted: \$nmarkers" >> "${cohort}.${key}.genotype.log"
    echo "GENOTYPE ${cohort}:${key} completed \$(date)" >> "${cohort}.${key}.genotype.log"

    echo "Extracting info from .map" >> "${cohort}.${key}.genotype.log"
    tail -n +2 ${pfb} | \
    awk '
    BEGIN { FS="\\t"; OFS="\\t" }
    {
        print \$2, \$1, "0", \$3
    }
    ' > "${cohort}.${key}.genotype.map"
    """
}