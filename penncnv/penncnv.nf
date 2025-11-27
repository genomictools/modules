process PENNCNV {
    tag "${cohort}:${key}:${tool}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(tool), file(pfb)

    output:
    tuple val(cohort), val(key), val(tool),
          path("${cohort}.${key}.${tool}.cnv"),
          path("${cohort}.${key}.${tool}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    detect_cnv.pl \
        ${file} \
        -test -loh --confidence \
        -hmm ${file(params.hmm)} \
        -pfb ${pfb} \
        -log ${cohort}.${key}.${tool}.log \
        -out ${cohort}.${key}.${tool}.cnv

    nmarkers=\$(wc -l < "${cohort}.${key}.${tool}.cnv")
    """
}

    // -gcmodel ${gcm} \
