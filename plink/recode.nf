process RECODE {
    tag "${famid}:${pheno}:${chrom}"

    label 'simple'

    container = params.plink

    publishDir("${params.output_dir}/recoded", mode: 'copy')

    input:
    tuple val(famid), val(pheno), val(chrom), path(freq),
          path(bim), path(bed), path(fam)

    output:
    tuple val(famid), val(pheno), val(chrom), path(freq),
          path("${famid}.${pheno}.${chrom}.dat"),
          path("${famid}.${pheno}.${chrom}.map"),
          path("${famid}.${pheno}.${chrom}.ped"),
          path("${famid}.${pheno}.${chrom}.log")

    script:
    """
    #!/bin/bash
    # Recaode plink files
    plink \
        --bfile ${bim.baseName} \
        --allow-no-sex \
        --recode \
        --out recoded
    
    echo -e "T\tWTNB" > ${famid}.${pheno}.${chrom}.dat
    cat recoded.map | awk '{print "M\t"\$2}' >> ${famid}.${pheno}.${chrom}.dat
    cat recoded.map | awk '{print \$1,\$2,\$4/1000000}' > ${famid}.${pheno}.${chrom}.map 
    cat recoded.ped > ${famid}.${pheno}.${chrom}.ped
    cat recoded.log > ${famid}.${pheno}.${chrom}.log
    """
}
