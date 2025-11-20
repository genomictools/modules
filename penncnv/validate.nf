process VALIDATE {
    tag "${cohort}:${type}:${test}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/tests", mode: 'copy')

    input:
    tuple val(cohort), val(type), 
          path(cnvr), path(candidates), path(cnvr_log), val(cnvr_nmarkers),
          val(test),
          val(dbsnp), path(txt), path(pfb),
          path(hmm),
          val(key), val(level), path(file), path(log), env(nmarkers)

    output:
    tuple val(cohort), val(type), val(test),
          path("${cohort}.${type}.${test}.tsv"),
          path("${cohort}.${type}.${test}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Apply test
    detect_cnv.pl \
        --validate \
        --candlist ${candidates} \
        --hmmfile ${hmm} \
        --pfbfile ${pfb} \
        ${file.join(' ')} \
        > ${cohort}.${type}.${test}.tsv \
        2> ${cohort}.${type}.${test}.log

    nmarkers=\$(wc -l < "${cohort}.${type}.${test}.tsv")
    """
}
