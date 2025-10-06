process CONVERT {
    tag "${cohort}:${tool}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(tool), val(type),
          path(cnv), path(cnv_log),
          val(nmarkers),
          val(dbspn), val(txt), file(pfb)

    output:
    tuple val(cohort), val(key), val(tool), val(type),
          path("${cohort}.${key}.${tool}.converted.${type}"),
          path("${cohort}.${key}.${tool}.converted.${type}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Convert to penncnv
    convert_cnv.pl \
        -snplocfile <(tail -n+2 ${pfb} | awk 'BEGIN{ print "Name\tChr\tPos"}1') \
        -intype birdseye \
        -outtype penncnv \
        ${cnv} \
        > ${cohort}.${key}.${tool}.converted.${type} \
        2> ${cohort}.${key}.${tool}.converted.${type}.log

    nmarkers=\$(wc -l < "${cohort}.${key}.${tool}.converted.${type}")
    """
}
