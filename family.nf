process FAMILY {
    tag "${cohort}:${tool}:${type}:${test}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/tests", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(cnv), path(cnv_log),
          env(cnv_nmarkers),
          val(test),
          file(hmm),
          val(dbsnp), path(txt), path(pfb),
          path(pedigree),
          val(key), val(level), path(file), path(log), env(nmarkers)

    output:
    tuple val(cohort), val(tool), val(test),
          path("${cohort}.${tool}.${type}.${test}"),
          path("${cohort}.${tool}.${type}.${test}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    N=\$(wc -l < "${pedigree}")
    if [ "\$N" -eq 3 ]; then
        famType="trio"
    elif [ "\$N" -eq 4 ]; then
        famType="quartet"
    else
        famType="unknown"
    fi

    # Apply test
    detect_cnv.pl \
        --\${famType} \
        --cnvfile ${cnv} \
        --hmmfile ${hmm} \
        --pfbfile ${pfb} \
        ${file.join(' ')} \
        > ${cohort}.${tool}.${type}.${test} \
        2> ${cohort}.${tool}.${type}.${test}.log

    nmarkers=\$(wc -l < "${cohort}.${tool}.${type}.${test}")
    """
}
