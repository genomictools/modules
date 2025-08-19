process DETECT {
    tag "${cohort}:${key}:${level}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(type), file(hmm),
          val(dbspn), val(txt), file(pfb)
          

    output:
    tuple val(cohort), val(key), val(type),
          path("${cohort}.${key}.${type}"),
          path("${cohort}.${key}.${type}.log"),
          env(nmarkers)

    script:
    def args = []
    if ( type == 'cnv' ) { args << "-test" }
    if ( type == 'loh' ) { args << "-test -loh" }
    def args_str = args.join(' ')

    """
    #!/bin/bash
    detect_cnv.pl \
        ${args_str} \
        -hmm ${hmm} \
        -pfb ${pfb} \
        --confidence \
        ${file} \
        -log ${cohort}.${key}.${type}.log \
        -out ${cohort}.${key}.${type}

    nmarkers=\$(wc -l < "${cohort}.${key}.${type}")
    """
}
