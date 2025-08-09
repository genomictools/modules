process DETECT {
    tag "${cohort}:${key}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(file), 
          val(dbspn), val(txt), file(pfb),
          file(hmm), file(hmm0),
          val(type)

    output:
    tuple val(cohort), val(key), val(type),
          path("${cohort}.${key}.${type}"),
          path("${cohort}.${key}.log")

    script:
    if (type == 'cnv') {
        """
        #!/bin/bash
        detect_cnv.pl \
            -test \
            -hmm ${hmm} \
            -pfb ${pfb} \
            ${file} \
            -log ${cohort}.${key}.log \
            -out ${cohort}.${key}.${type}
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
            -log ${cohort}.${key}.log \
            -out ${cohort}.${key}.${type}
        """
    } else {
        error "Unknown type: ${type}"
    }
}
