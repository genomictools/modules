process SCAN {
    tag "${cohort}:${feature}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/scanned", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type), path(cnv), path(cnv_log),
          path(ref_gene), path(ref_link), val(feature)

    output:
    tuple val(cohort), val(feature),
          path("${cohort}.${feature}.${type}"),
          path("${cohort}.${feature}.${type}.log")

    script:
    if (feature == 'gene') {
        """
        #!/bin/bash
        scan_region.pl \
            <(cat ${cnv}) \
            ${ref_gene} \
            -refgene -reflink ${ref_link} \
            > ${cohort}.${feature}.${type} \
            2> ${cohort}.${feature}.${type}.log
        """
    } else if (feature == 'exon') {
        """
        #!/bin/bash
        scan_region.pl \
            <(cat ${cnv}) \
            ${ref_gene} \
            -refexon -reflink ${ref_link} \
            > ${cohort}.${feature}.${type} \
            2> ${cohort}.${feature}.${type}.log
        """
    } else {
        """
        #!/bin/bash
        cat ${cnv} > ${cohort}.${feature}.${type} \
            2> ${cohort}.${feature}.${type}.log
        """
    }
}