process ASSIGN {
    tag "${ref}:${cohort}:${mode}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/assigned", mode: 'copy')

    input:
    tuple val(ref), val(cohort), val(mode),
          path(file), path(pop), path(log)

    output:
    tuple val(ref), val(cohort), val(mode),
          path(file), path(pop), path(log)
    
    script:
    """
    #!/bin/bash
    assign_pop.R ${ref} ${cohort} ${mode} ${file} ${pop} ${params.dimension}
    """
}