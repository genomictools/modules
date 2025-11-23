process GCM {
    tag "${dbsnp}:${chunk}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/ref", mode: 'copy')

    input:
    tuple val(dbsnp), val(chunk), path(pfb),
          path(gc)

    output:
    tuple val(dbsnp), val(chunk),
          path("${dbsnp}.${chunk}.gcmodel"),
          path("${dbsnp}.${chunk}.gcmodel.log")

    script:
    """
    #!/bin/bash
    # Generate GC model
    cal_gc_snp.pl \
        <(sort -k 2,2 -k 3,3n ${gc}) \
        <(tail -n +2 ${pfb} | awk -v OFS='\t' 'BEGIN {print "Name", "Chr", "Pos"} {print \$1, \$2, \$3}') \
        --numwindow ${params.numwindow} \
        --backgroundgc ${params.backgroundgc} \
        --output ${dbsnp}.${chunk}.gcmodel \
        2> ${dbsnp}.${chunk}.gcmodel.log
    """
}