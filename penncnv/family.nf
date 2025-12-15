process FAMILY {
    tag "${cohort}:${tool}:${type}:${test}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/tests", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(cnv), path(cnv_log), val(cnv_nmarkers),
          val(indid), val(size), val(famid), val(test),
          val(level), path(file), path(log), val(nmarkers),
          path(pedigree),
          path(pfb)

    output:
    tuple val(cohort), val(tool), val(type), val(test),
          path("${cohort}.${tool}.${type}.${test}"),
          path("${cohort}.${tool}.${type}.${test}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Apply test
    detect_cnv.pl \
        --${test} \
        --cnvfile ${cnv} \
        --pfbfile ${pfb} \
        -hmm ${file(params.hmm)} \
        ${file.join(' ')} \
        > ${cohort}.${tool}.${type}.${test} \
        2> ${cohort}.${tool}.${type}.${test}.log

    nmarkers=\$(wc -l < "${cohort}.${tool}.${type}.${test}")
    """
}
