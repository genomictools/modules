// Quality control of CNV calls
process ASSESS {
    tag "${cohort}:${key}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/qc", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(signal), val(type), path(cnv), path(cnv_log)

    output:
    tuple val(cohort), val(key),
          path("${cohort}.${key}.qcpass"),
          path("${cohort}.${key}.qcsum"),
          path("${cohort}.${key}.goodcnv")

    script:
    """
    #!/bin/bash
    awk '(NR == 1) || (FNR > 1)' ${signal} > ${cohort}.${key}.signal.txt
    cat ${cnv} > ${cohort}.${key}.raw.cnv
    cat ${cnv_log} > ${cohort}.${key}.log.txt

    filter_cnv.pl \
        ${cohort}.${key}.raw.cnv \
        -qclogfile ${cohort}.${key}.log.txt \
        -qclrrsd ${params.qclrrsd} \
        -qcnumcnv ${params.qcnumcnv} \
        -qcpassout ${cohort}.${key}.qcpass \
        -qcsumout ${cohort}.${key}.qcsum \
        -out ${cohort}.${key}.goodcnv
    """
}