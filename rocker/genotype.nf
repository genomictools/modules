process GENOTYPE {
    tag "${cohort}:${tool}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/genotypes", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(file), val(nmarkers),
          path(pfb),
          path(pedigree)

    output:
    tuple val(cohort), val(tool),
          path("${cohort}.${tool}.lgen"),
          path("${cohort}.${tool}.map"),
          path("${cohort}.${tool}.fam"),
          path("${cohort}.${tool}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Create .fam file from pedigree
    cat ${file} | cut -f 2 | sort -u | \
    grep -wFf - ${pedigree} \
    > "${cohort}.${tool}.fam"
    
    # Create .lgen file from genotype file
    # Update the family ids based on .fam file
    # Replace missing genotypes (- or N) with (0)
    # If one allele is missing, replace both with 0
    awk 'NR==FNR {fam[\$2]=\$1; next} 
         {if(\$2 in fam) \$1=fam[\$2]; print}' \
         OFS="\\t" "${cohort}.${tool}.fam" ${file} | \
    sed 's/-/0/g; s/N/0/g' | \
    awk '{
        for(i=3; i<=NF; i+=2) {
            if(\$i == "0" || \$(i+1) == "0") {
                \$i = "0"; \$(i+1) = "0"
            }
        }
        print
    }' OFS="\\t" \
    > "${cohort}.${tool}.lgen"

    # Create a map file from pfb
    tail -n +2 ${pfb} | \
    awk '
    BEGIN { FS="\\t"; OFS="\\t" }
    {
        print \$2, \$1, "0", \$3
    }
    ' > "${cohort}.${tool}.map"
    
    # Count markers
    nmarkers=\$(wc -l < "${cohort}.${tool}.lgen")
    
    # Log
    echo "Processed ${cohort}.${tool}" > "${cohort}.${tool}.log"
    """
}