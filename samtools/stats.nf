process STATS {
    tag "${cohort}:${key}:${type}"

    label 'simple'
    label 'samtools'

    publishDir("${params.output_dir}/stats", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(type),
          path(bam), path(bai)
    
    output:
    tuple val(cohort), val(key), val(type),
          path("${cohort}.${key}.${type}.*.stats.tsv")

    script:
    """
    #!/bin/bash
    samtools stats ${bam} > samtools.stats.txt 
    TAGS="CHK SN FFQ LFQ GCF GCL GCC GCT FBC FTC LBC LTC BCC CRC OXC RXC MPC QTQ CYQ BZQ QXQ IS RL FRL LRL MAPQ ID IC COV GCD RFS"
    for TAG in \${TAGS}; do
        grep ^\${TAG} samtools.stats.txt | cut -f 2- > ${cohort}.${key}.${type}.\${TAG}.stats.tsv
    done
    """
}
