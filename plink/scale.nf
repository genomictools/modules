process SCALE {
    tag "${ref}:${cohort}:${mode}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/scaled", mode: 'copy')

    input:
    tuple val(ref), val(cohort),
          path(bim), path(bed), path(fam), path(log), 
          val(n_samples), val(n_variants),
          path(pop),
          val(mode)

    output:
    tuple val(ref), val(cohort), val(mode),
          path("${ref}.${cohort}.${mode}.txt"),
          path("${ref}.${cohort}.${mode}.pop"),
          path("${ref}.${cohort}.${mode}.log")

    script:
    if (mode == 'clusters') {
        """
        #!/bin/bash
        # Return population file, and extract clusters
        if [ "${params.family_ids}" = "false" ]; then
            cat ${pop} | awk '{print "0", \$2, \$3, \$4, \$5}' > ${ref}.${cohort}.${mode}.pop
        else
            cat ${pop} > ${ref}.${cohort}.${mode}.pop
        fi

        cat ${ref}.${cohort}.${mode}.pop | awk '{ print "0", \$2, \$3}' > populations.txt
        cat ${ref}.${cohort}.${mode}.pop | awk '{ print \$3}' | sort -u | grep -v "NA" | grep -v "0" > clusters.txt
        
        # Perform PCA with clusters
        plink --bfile ${bim.baseName} \
            --pca ${params.dimension} \
            --pca-clusters clusters.txt \
            --within populations.txt \
            --write-cluster \
            --out ${ref}.${cohort}.${mode}
        
        cp ${ref}.${cohort}.${mode}.eigenvec ${ref}.${cohort}.${mode}.txt
        """
    } else if (mode == 'noclusters') {
        """
        #!/bin/bash        
        # Return population file
        if [ "${params.family_ids}" = "false" ]; then
            cat ${pop} | awk '{print "0", \$2, \$3, \$4, \$5}' > ${ref}.${cohort}.${mode}.pop
        else
            cat ${pop} > ${ref}.${cohort}.${mode}.pop
        fi

        # Perform PCA with no clusters
        plink --bfile ${bim.baseName} \
            --pca ${params.dimension} \
            --out ${ref}.${cohort}.${mode}
        
        cp ${ref}.${cohort}.${mode}.eigenvec ${ref}.${cohort}.${mode}.txt
        """
    } else if (mode == 'mds') {
        """
        #!/bin/bash
        # Return population file
        if [ "${params.family_ids}" = "false" ]; then
            cat ${pop} | awk '{print "0", \$2, \$3, \$4, \$5}' > ${ref}.${cohort}.${mode}.pop
        else
            cat ${pop} > ${ref}.${cohort}.${mode}.pop
        fi

        # Perform MDS
        plink --bfile ${bim.baseName} \
            --genome \
            --out ${ref}.${cohort}.${mode}
        
        plink --bfile ${bim.baseName} \
            --read-genome ${ref}.${cohort}.${mode}.genome \
            --cluster \
            --mds-plot ${params.dimension} \
            --out ${ref}.${cohort}.${mode}

        cat ${ref}.${cohort}.${mode}.mds | tail -n +2 | awk '{print \$1,\$2,\$3,\$4,\$5}' > ${ref}.${cohort}.${mode}.txt
        """
    } else {
        throw new Exception("Unknown mode: ${mode}")
    }
}
