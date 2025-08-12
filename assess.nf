// Quality control of CNV calls
process ASSESS {
    tag "${cohort}:${key}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/qc", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(signal), path(signal_log),
          val(type), path(cnv), path(cnv_log)

    output:
    tuple val(cohort), val(key),
          path("${cohort}.${key}.qcpass"),
          path("${cohort}.${key}.qcsum"),
          path("${cohort}.${key}.goodcnv"),
          path("${cohort}.${key}.qc.log")

    script:
    """
    #!/bin/bash
    filter_cnv.pl \
        <(cat ${cnv}) \
        -qclogfile <(cat ${cnv_log}) \
        -qclrrsd ${params.qclrrsd} \
        -qcnumcnv ${params.qcnumcnv} \
        -qcpassout ${cohort}.${key}.qcpass \
        -qcsumout ${cohort}.${key}.qcsum \
        -out ${cohort}.${key}.goodcnv \
        &> ${cohort}.${key}.qc.log
    """
}