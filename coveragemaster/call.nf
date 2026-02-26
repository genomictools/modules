process CALL {
    tag "${cohort}:${gene}:${key}"

    label 'simple'
    label 'coveragemaster'

    publishDir("${params.output_dir}/calls/coveragemaster", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(key),
          path(depth), path(stats),
          path(ref_depth), path(ref_stats),
          path(ref_list), path(ref_aggregate)

    output:
    tuple val(cohort), val(gene), val(key), 
          path("${cohort}.${gene}.${key}.{CMcalls,CMreport,CMpositives.pdf,CM.log}")

    script:
    """
    #!/bin/bash
    # call cnvs
    python /opt/coverageMaster/coverageMaster.py \
        ${depth} \
        ${stats} \
        ${gene} \
        -c ${ref_list} \
        -r ${ref_aggregate} \
        -o ${cohort}.${gene}.${key}
    """
}
