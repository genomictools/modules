process SCATTER {
    tag "${cohort}:${gene}:${tool}"

    label 'simple'
    label 'cnvr'

    publishDir("${params.output_dir}/scatter", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(tool), val(cnv),
       	  val(key), val(level), path(signal), path(signal_log), val(signal_nmarkers),
          val(dbsnp), path(txt), path(pfb)

    output:
    tuple val(cohort), val(gene), val(tool),
		  path("${cohort}.${gene}.${tool}.cnv"),
		  path("${cohort}.${gene}.${tool}.*.png"),
		  path("${cohort}.${gene}.${tool}.log")

    script:
    """
    #!/bin/bash
	echo "${cnv.join('\n')}" > ${cohort}.${gene}.${tool}.cnv
    scatter.R ${cohort} ${gene} ${tool} ${cohort}.${gene}.${tool}.cnv ${signal.join(',')} ${pfb} ${params.flank} 2> ${cohort}.${gene}.${tool}.log
    """
}
