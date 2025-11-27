process CONVERT {
    tag "${cohort}:${tool}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(tool), path(cnv),
          path(pfb)

    output:
    tuple val(cohort), val(tool),
          path("${cohort}.${tool}.converted.cnv"),
          path("${cohort}.${tool}.converted.cnv.log"),
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
        > ${cohort}.${tool}.converted.cnv \
        2> ${cohort}.${tool}.converted.cnv.log

    nmarkers=\$(wc -l < "${cohort}.${tool}.converted.cnv")
    """
}
