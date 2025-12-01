process CNVR {
    tag "${cohort}:${type}"

    label 'simple'
    label 'cnvr'

    publishDir("${params.output_dir}/cnvr", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(cnv), path(cnv_log),
          val(nmarkers),
		  val(cohort_size)

    output:
    tuple val(cohort), val(type),
          path("${cohort}.cnvr.tsv"),
          path("${cohort}.candidates.tsv"),
          path("${cohort}.cnvr.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Create cnvr
    cnvr.R ${cohort} ${tool.join(',')} ${cnv.join(',')} ${params.fraction} ${cohort_size} 2> ${cohort}.cnvr.log

    nmarkers=\$(wc -l < "${cohort}.cnvr.tsv")
    """
}
