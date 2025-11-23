process PFB {
    tag "${dbsnp}:${chunk}"

    label 'simple'
    label 'bcftools'
    
    publishDir("${params.output_dir}/ref", mode: 'copy')

    input:
    tuple val(chunk), path(snplist),
          val(dbsnp), path(dbsnp_file), path(dbsnp_index)

    output:
    tuple val(dbsnp), val(chunk), path("${dbsnp}.${chunk}.pfb")

    script:
    """
    #!/bin/bash
    # Extract the snps info from the dbsnp file
    bcftools query -f '%ID\t%CHROM\t%POS\t%REF\t%ALT\t%CAF\n' ${dbsnp_file} > ${dbsnp}.${chunk}.txt

    # Convert to pfb
    dbsnp.awk ${snplist} ${dbsnp}.${chunk}.txt > ${dbsnp}.${chunk}.pfb
    """
}
