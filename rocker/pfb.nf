process PFB {
    tag "${dbsnp}:${chunk}"

    label 'simple'
    label 'rocker'
    
    publishDir("${params.output_dir}/ref", mode: 'copy')

    input:
    tuple val(chunk), path(snplist),
          val(dbsnp), path(dbsnp_file)

    output:
    tuple val(dbsnp), val(chunk), path("${dbsnp}.${chunk}.pfb")

    script:
    """
    #!/bin/bash
    # Convert to pfb
    dbsnp.awk ${snplist} ${dbsnp_file} > ${dbsnp}.${chunk}.pfb
    """
}
