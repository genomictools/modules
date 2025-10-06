process LINKAGE {
    tag "${famid}:${pheno}:${chrom}"

    label 'simple'

    container = params.merlin

    publishDir("${params.output_dir}/linkage", mode: 'copy')

    input:
    tuple val(famid), val(pheno), val(chrom), path(freq), path(map),
           path(dat), path(ped),
           path(markers), path(log),
           val(test)

    output:
    tuple val(famid), val(chrom), val(pheno),
          path("${famid}.${pheno}.${chrom}.pdf"),
          path("${famid}.${pheno}.${chrom}-${test}-*.tbl")
      
    script:
    """
    #!/bin/bash
    merlin \
        -d ${dat} \
        -p ${ped} \
        -m ${map} \
        -f ${freq} \
        --prefix ${famid}.${pheno}.${chrom} \
        --pdf --tabulate \
        --${params.test} --grid ${params.grid} 
    """
}
