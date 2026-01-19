process GENOTYPE {
    tag "${cohort}:${tool}:${key}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/genotypes", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(tool), val(type),
          path(file), val(nmarkers),
          path(pfb),
          path(pedigree)

    output:
    tuple val(cohort), val(tool), val(key),
          path("${cohort}.${key}.${tool}.bim"),
          path("${cohort}.${key}.${tool}.bed"),
          path("${cohort}.${key}.${tool}.fam"),
          path("${cohort}.${key}.${tool}.log"),
          env(n_samples), env(n_variants)

    script:
    """
    #!/bin/bash
    # Create .fam file from pedigree
    awk '\$2 == "${key}"' ${pedigree} > "${cohort}.${key}.${tool}.tmp.fam"
    
    # Create .lgen file from genotype file
    # Update the family ids based on .fam file
    # Replace missing genotypes (- or N) with (0)
    # If one allele is missing, replace both with 0
    awk 'NR==FNR {fam[\$2]=\$1; next} 
         {if(\$2 in fam) \$1=fam[\$2]; print}' \
         OFS="\\t" "${cohort}.${key}.${tool}.tmp.fam" ${file} | \
    awk '{
        # Replace missing alleles only in genotype fields (columns >= 3)
        for(i=4; i<=NF; i++) {
            if(\$i == "-" || \$i == "N") \$i = "0"
        }
        # If one allele in a pair is missing, set both to 0
        for(i=3; i<=NF; i+=2) {
            if(\$i == "0" || \$(i+1) == "0") {
                \$i = "0"; \$(i+1) = "0"
            }
        }
        print
    }' OFS="\\t" \
    > "${cohort}.${key}.${tool}.tmp.lgen"

    # Create a map file from pfb
    tail -n +2 ${pfb} | \
    awk '
    BEGIN { FS="\\t"; OFS="\\t" }
    {
        print \$2, \$1, "0", \$3
    }
    ' > "${cohort}.${key}.${tool}.tmp.map"
    
    # Conver to plink binary files
    plink \
        --make-bed \
        --lgen ${cohort}.${key}.${tool}.tmp.lgen\
        --map ${cohort}.${key}.${tool}.tmp.map \
        --fam ${cohort}.${key}.${tool}.tmp.fam \
        --out ${cohort}.${key}.${tool}

    # Count markers
    n_samples=\$(wc -l < "${cohort}.${key}.${tool}.fam")
    n_variants=\$(wc -l < "${cohort}.${key}.${tool}.bim")
    """
}