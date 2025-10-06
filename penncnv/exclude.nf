process EXCLUDE {
    tag "${cohort}::${tool}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/excluded", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(cnv), path(cnv_log), val(nmarkers),
          path(exclude)

    output:
    tuple val(cohort), val(tool), val(type),
          path("${cohort}.${tool}.excluded.${type}"),
          path("${cohort}.${tool}.excluded.${type}.log"),
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
        &> ${cohort}.${tool}.excluded.${type}.log

    # exclude regions
    fgrep -v -f to_remove.txt ${cnv} > ${cohort}.${tool}.excluded.${type}

    nmarkers=\$(wc -l < "${cohort}.${tool}.excluded.${type}")
    """
}
