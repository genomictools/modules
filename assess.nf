// Quality control of CNV calls
process ASSESS {
    tag "${cohort}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/qc", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type),
          path(cnv), path(cnv_log), val(nmarkers)

    output:
    tuple val(cohort), val(type),
          path("${cohort}.${type}.qcpass"),
          path("${cohort}.${type}.qcsum"),
          path("${cohort}.${type}.goodcnv"),
          path("${cohort}.${type}.qc.log")

    script:
    """
    #!/bin/bash
    filter_cnv.pl \
        <(cat ${cnv}) \
        -qclogfile <(cat ${cnv_log}) \
        -qclrrsd ${params.qclrrsd} \
        -qcnumcnv ${params.qcnumcnv} \
        -qcpassout ${cohort}.${type}.qcpass \
        -qcsumout ${cohort}.${type}.qcsum \
        -out ${cohort}.${type}.goodcnv \
        &> ${cohort}.${type}.qc.log
    """
}