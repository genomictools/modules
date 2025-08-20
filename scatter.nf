process SCATTER {
    tag "${cohort}:${gene}"

    label 'simple'
    label 'cnvr'

    publishDir("${params.output_dir}/scatter", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(cnv),
       	  val(key), val(level), path(signal), path(signal_log), val(signal_nmarkers),
          val(dbsnp), path(txt), path(pfb)

    output:
    tuple val(cohort), val(gene),
		  path("${cohort}.${gene}.cnv"),
		  path("${cohort}.${gene}.*.png"),
		  path("${cohort}.${gene}.log")

    script:
    """
    #!/bin/bash
	echo "${cnv.join('\n')}" > ${cohort}.${gene}.cnv
    scatter.R ${cohort} ${gene} ${cohort}.${gene}.cnv ${signal.join(',')} ${pfb} ${params.flank} 2> ${cohort}.${gene}.log
    """
}
