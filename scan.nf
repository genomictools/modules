process SCAN {
    tag "${cohort}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/scanned", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(cnv), path(ref_gene), path(ref_link)

    output:
    tuple val(cohort),
          path("${cohort}.cnv"),
          path("${cohort}.gene.cnv")
        
    script:
    """
    #!/bin/bash

    cat ${cnv} > ${cohort}.cnv

    scan_region.pl \
        ${cohort}.cnv \
        ${ref_gene} \
        -refgene -reflink ${ref_link} \
        > ${cohort}.gene.cnv
    """
}