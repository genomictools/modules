process SCAN {
    tag "${cohort}::${feature}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/scanned", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(cnv), path(ref_gene), path(ref_link), val(feature)

    output:
    tuple val(cohort), val(feature),
          path("${cohort}.${feature}.cnv")

    script:
    if (feature == 'gene') {
        """
        #!/bin/bash
         > ${cohort}.cnv
        scan_region.pl \
            <(cat ${cnv}) \
            ${ref_gene} \
            -refgene -reflink ${ref_link} \
            > ${cohort}.${feature}.cnv
        """
    } else if (feature == 'exon') {
        """
        #!/bin/bash
        cat ${cnv} > ${cohort}.cnv
        scan_region.pl \
            <(cat ${cnv}) \
            ${ref_gene} \
            -refexon -reflink ${ref_link} \
            > ${cohort}.${feature}.cnv
        """
    } else {
        """
        #!/bin/bash
        cat ${cnv} > ${cohort}.${feature}.cnv
        """
    }
}