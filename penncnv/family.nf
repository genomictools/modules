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
    # Create symlinks to match pedigree sample names
    for f in ${file.join(' ')}; do
        sample_name=\$(basename "\$f" .txt.adjusted)
        ln -s "\$f" "\${sample_name}"
    done

    # Get linked file names for detect_cnv.pl
    linked_files=\$(for f in ${file.join(' ')}; do basename "\$f" .txt.adjusted; done)

    # Apply test
    detect_cnv.pl \
        --${test} \
        --cnvfile ${cnv} \
        --pfbfile ${pfb} \
        -hmm ${file(params.hmm)} \
        \$linked_files \
        > ${cohort}.${tool}.${type}.${test} \
        2> ${cohort}.${tool}.${type}.${test}.log

    nmarkers=\$(wc -l < "${cohort}.${tool}.${type}.${test}")
    """
}
