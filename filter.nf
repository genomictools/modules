process FILTER {
    tag "${cohort}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/filtered", mode: 'copy')

    input:
    tuple val(cohort), val(type),
          path(cnv), path(cnv_log), val(nmarkers)

    output:
    tuple val(cohort), val(type),
          path("${cohort}.filtered.${type}"),
          path("${cohort}.filtered.${type}.{log,qcpass,qcsum}"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    filter_cnv.pl \
        ${cnv} \
        --qclogfile ${cnv_log} \
        --numsnp ${params.numsnp} \
 	    --maxnumsnp ${params.maxnumsnp} \
        --length ${params.length} \
 	    --maxlength ${params.maxlength} \
 	    --confidence ${params.confidence} \
 	    --maxconfidence ${params.maxconfidence} \
        --qcbafdrift ${params.qcbafdrift} \
        --qcwf ${params.qcwf} \
        --qclrrsd ${params.qclrrsd} \
        --qcnumcnv ${params.qcnumcnv} \
        --output ${cohort}.filtered.${type} \
        --qcpassout ${cohort}.filtered.${type}.qcpass \
        --qcsumout ${cohort}.filtered.${type}.qcsum \
        &> ${cohort}.filtered.${type}.log

    nmarkers=\$(wc -l < "${cohort}.filtered.${type}")
    """
}
