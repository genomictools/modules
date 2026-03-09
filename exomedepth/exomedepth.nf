process EXOMEDEPTH {
    tag "${cohort}:${gene}:${key}"

    label 'simple'
    label 'exomedepth'

    publishDir("${params.output_dir}/calls/${tool}/", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(key),
          path(test_counts),
            path(ref_counts),
            val(tool)

    output:
    tuple val(cohort), val(gene), val(key), val(tool),
          path("${cohort}.${gene}.${key}.cnv.tsv"),
          path("${cohort}.${gene}.${key}.cnv.rds", optional: true),
          path("${cohort}.*.${key}.cnv.png", optional: true),
          env(nmarker)

    script:
    """
    #!/bin/bash
    exomedepth.R ${cohort} ${gene} ${key} ${test_counts} ${ref_counts.join(',')} ${params.prob}
	if ! ls ${cohort}.*.${key}.cnv.png >/dev/null 2>&1; then
	    touch ${cohort}.no_calls.${key}.cnv.png
	fi
	nmarker=\$(grep -vc '^#' ${cohort}.${gene}.${key}.cnv.tsv || true)
    """
}
