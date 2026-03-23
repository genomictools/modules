process INTERSECT {
    tag "${gene}"

    label 'simple'
    label 'bedtools'

    publishDir("${params.output_dir}/intersect", mode: 'copy')

    input:
    tuple val(gene), path(gene_coords), path(exon_coords),
          path(capture_coords)

    output:
    tuple val(gene), path(gene_coords), path("${gene}.exon.intersect.bed")

    script:
    """
    #!/bin/bash
    bedtools intersect -wa \
        -a ${exon_coords} \
        -b ${capture_coords}  | \
        uniq \
        > ${gene}.exon.intersect.bed
    """
}
