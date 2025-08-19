process SCAN {
    tag "${cohort}:${feature}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/scanned", mode: 'copy')

    input:
    tuple val(cohort), val(type), path(cnv), path(cnv_log), val(nmarkers),
          path(ref_gene), path(ref_link), val(feature)

    output:
    tuple val(cohort), val(feature), val(type),
          path("${cohort}.${feature}.${type}"),
          path("${cohort}.${feature}.${type}.log"),
          env(nmarkers)

    script:
    def args = []
    if ( feature == 'gene' ) { args << "-refgene" }
    if ( feature == 'exon' ) { args << "-refexon" }
    def args_str = args.join(' ')

    """
    #!/bin/bash
    scan_region.pl \
        ${cnv} \
        ${ref_gene} \
        ${args_str} \
        -reflink ${ref_link} \
        > ${cohort}.${feature}.${type} \
        2> ${cohort}.${feature}.${type}.log

    nmarkers=\$(wc -l < "${cohort}.${feature}.${type}")
    """
}