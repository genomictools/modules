process GCM {
    tag "${dbsnp}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/ref", mode: 'copy')

    input:
    tuple val(dbsnp), val(chunk), path(pfb),
          path(gc)

    output:
    tuple val(dbsnp), val(chunk),
          path("${dbsnp}.gcmodel"),
          path("${dbsnp}.gcmodel.log")

    script:
    """
    #!/bin/bash
    # Generate GC model
    cal_gc_snp.pl \
        <(sort -k 2,2 -k 3,3n ${gc}) \
        <(tail -q -n +2 ${pfb} | awk -v OFS='\t' 'BEGIN {print "Name", "Chr", "Pos"} {print \$1, \$2, \$3}') \
        --numwindow ${params.numsnp} \
        --backgroundgc ${params.backgroundgc} \
        --output ${dbsnp}.gcmodel \
        2> ${dbsnp}.gcmodel.log
    """
}