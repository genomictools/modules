process ANNOTATE {
    tag "${cohort}:${tool}:${feature}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/annotated", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(cnv), path(cnv_log),
          env(nmarkers),
          val(feature), path(feature_file)

    output:
    tuple val(cohort), val(tool), val(feature), val(type),
          path("${cohort}.${tool}.${feature}.${type}"),
          path("${cohort}.${tool}.${feature}.${type}.log"),
          env(nmarkers)

    script:
    def args = []
    if ( feature == 'refgene' || feature == 'refexon' ) { args << "--name2" }
    if ( feature == 'anno' ) { args << "--append" }
    def args_str = args.join(' ')

    """
    #!/bin/bash
    scan_region.pl \
        ${cnv} \
        ${feature_file} \
        --${feature} \
        ${args_str} \
        > ${cohort}.${tool}.${feature}.${type} \
        2> ${cohort}.${tool}.${feature}.${type}.log

    nmarkers=\$(wc -l < "${cohort}.${tool}.${feature}.${type}")
    """
}
