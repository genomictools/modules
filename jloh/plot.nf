process PLOT {
    tag "${cohort}:${key}:${sample}:${sample_type}"

    label 'simple'
    label 'jloh'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(sample), val(sample_type),
		  path(loh_blocks), path(het_blocks), path(log)

    output:
    tuple val(cohort), val(key), val(sample), val(sample_type),
          path("plots/*.png"),
          path("${cohort}.${key}.${sample}.${sample_type}.log")

    script:
    def args = []
    if (params.one_ref) { 
        args << "--one-ref"
    } else {
        args << "--two-refs"
    }
    if (params.by_sample) { args << "--by-sample" }

    args_str = args.join(" ")
    
    """
    #!/bin/bash
    jloh plot \
        --loh ${loh_blocks} \
        --het ${het_blocks} \
        --output-dir . \
        --contrast ${params.contrast} \
        ${args_str} \
		2> ${cohort}.${key}.${sample}.${sample_type}.log
    """
}
