process EXCLUDE {
    tag "${cohort}:${key}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/excluded", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type),
          path(cnv), path(cnv_log), val(nmarkers),
          path(exclude)

    output:
    tuple val(cohort), val(key), val(type),
          path("${cohort}.${key}.excluded.${type}"),
          path("${cohort}.${key}.excluded.${type}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # get regions
    scan_region.pl \
        ${cnv} \
        ${exclude} \
        -minqueryfrac 0.5 \
        > to_remove.txt \
        &> ${cohort}.${key}.excluded.${type}.log
    
    # exclude regions
    fgrep -v -f to_remove.txt ${cnv} > ${cohort}.${key}.excluded.${type}
    
    nmarkers=\$(wc -l < "${cohort}.${key}.excluded.${type}")
    """
}
