process SPLIT {
    tag "${cohort}:${tool}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(cnv), val(nmarkers)

    output:
    tuple val(cohort), val(tool), val('cnv,loh'),
          path("${cohort}.${tool}.split.{cnv,loh}"),
          path("${cohort}.${tool}.split.{cnv,loh}.log"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # combine calls
    cat ${cnv} | grep -v "cn=2" > ${cohort}.${tool}.split.cnv || touch ${cohort}.${tool}.split.cnv
    cat ${cnv} | grep    "cn=2" > ${cohort}.${tool}.split.loh || touch ${cohort}.${tool}.split.loh
    touch ${cohort}.${tool}.split.cnv.log
    touch ${cohort}.${tool}.split.loh.log

	nmarkers="\$(wc -l < "${cohort}.${tool}.split.cnv"),\$(wc -l < "${cohort}.${tool}.split.loh")"
    """
}