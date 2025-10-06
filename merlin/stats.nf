process STATS {
    tag "${famid}:${pheno}:${chrom}"

    label 'simple'

    container = params.merlin

    publishDir("${params.output_dir}/stats", mode: 'copy')

    input:
    tuple val(famid), val(pheno), val(chrom), path(freq),
           path(dat), path(map), path(ped), path(log)

    output:
    tuple val(famid), val(pheno), val(chrom), path(freq), path(map),
          path("${famid}.${pheno}.${chrom}.modified.dat"),
          path("${famid}.${pheno}.${chrom}.modified.ped"),
          path("${famid}.${pheno}.${chrom}.modified.markerinfo"),
          path("${famid}.${pheno}.${chrom}.modified.log")
  
    script:
    """
    #!/bin/bash
    pedstats \
        -d ${dat} \
        -p ${ped} \
        --markerTables --ignoreMendelianErrors --rewrite \
        > ${famid}.${pheno}.${chrom}.modified.log

    mv pedstats.dat ${famid}.${pheno}.${chrom}.modified.dat
    mv pedstats.ped ${famid}.${pheno}.${chrom}.modified.ped
    mv pedstats.markerinfo ${famid}.${pheno}.${chrom}.modified.markerinfo
    """
}

// --rewritePedigree