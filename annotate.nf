process ANNOTATE {
    tag "${cohort}:${tool}:${feature}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/annotated", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(cnv), path(cnv_log),
          env(nmarkers),
          path(ref_gene), path(ref_link), val(feature)

    output:
    tuple val(cohort), val(tool), val(feature), val(type),
          path("${cohort}.${tool}.${feature}.${type}"),
          path("${cohort}.${tool}.${feature}.${type}.log"),
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
        > ${cohort}.${tool}.${feature}.${type} \
        2> ${cohort}.${tool}.${feature}.${type}.log

    nmarkers=\$(wc -l < "${cohort}.${tool}.${feature}.${type}")
    """
}
