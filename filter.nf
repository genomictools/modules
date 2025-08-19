process FILTER {
    tag "${cohort}:${key}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/filtered", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type),
          path(cnv), path(cnv_log), val(nmarkers)

    output:
    tuple val(cohort), val(key), val(type),
          path("${cohort}.${key}.filtered.${type}"),
          path("${cohort}.${key}.filtered.${type}.{log,qcpass,qcsum}"),
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
        --output ${cohort}.${key}.filtered.${type} \
        --qcpassout ${cohort}.${key}.filtered.${type}.qcpass \
        --qcsumout ${cohort}.${key}.filtered.${type}.qcsum \
        &> ${cohort}.${key}.filtered.${type}.log

    nmarkers=\$(wc -l < "${cohort}.${key}.filtered.${type}")
    """
}
