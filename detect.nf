process DETECT {
    tag "${cohort}:${key}:${level}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(dbspn), val(txt), file(pfb),
          file(hmm), file(hmm0),
          val(type)

    output:
    tuple val(cohort), val(key), val(type),
          path("${cohort}.${key}.${type}"),
          path("${cohort}.${key}.${type}.log"),
          env(nmarkers)

    script:
    if (type == 'cnv') {
        """
        #!/bin/bash
        detect_cnv.pl \
            -test \
            -hmm ${hmm} \
            -pfb ${pfb} \
            --confidence \
            ${file} \
            -log ${cohort}.${key}.${type}.log \
            -out ${cohort}.${key}.${type}

        nmarkers=\$(wc -l < "${cohort}.${key}.${type}")
        """
    } else if (type == 'loh') {
        """
        #!/bin/bash
        detect_cnv.pl \
            -test \
            -loh \
            -tabout \
            -hmm ${hmm0} \
            -pfb ${pfb} \
            ${file} \
            -log ${cohort}.${key}.${type}.log \
            -out ${cohort}.${key}.${type}

        nmarkers=\$(wc -l < "${cohort}.${key}.${type}")
        """
    } else {
        error "Unknown type: ${type}"
    }
}
