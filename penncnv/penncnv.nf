process PENNCNV {
    tag "${cohort}:${key}:${tool}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(tool), val(type), file(pfb)
          

    output:
    tuple val(cohort), val(key), val(tool), val(type),
          path("${cohort}.${key}.${tool}.${type}"),
          path("${cohort}.${key}.${tool}.${type}.log"),
          env(nmarkers)

    script:
    def args = []
    if ( type == 'cnv' ) { args << "-test -hmm ${file(params.hmm)}" }
    if ( type == 'loh' ) { args << "-test -loh -hmm ${file(params.hmm0)}" }
    def args_str = args.join(' ')

    """
    #!/bin/bash
    detect_cnv.pl \
        ${args_str} \
        -pfb ${pfb} \
        --confidence \
        ${file} \
        -log ${cohort}.${key}.${tool}.${type}.log \
        -out ${cohort}.${key}.${tool}.${type}

    nmarkers=\$(wc -l < "${cohort}.${key}.${tool}.${type}")
    """
}
