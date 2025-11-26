process CAF {
    tag "${dbsnp}"

    label 'simple'
    label 'bcftools'
    
    publishDir("${params.output_dir}/ref", mode: 'copy')

    input:
    tuple val(dbsnp), path(dbsnp_file), path(dbsnp_index)

    output:
    tuple val(dbsnp), path("${dbsnp}.caf")

    script:
    """
    #!/bin/bash
    # Extract the snps info from the dbsnp file
    bcftools query -f '%ID\t%CHROM\t%POS\t%REF\t%ALT\t%CAF\n' ${dbsnp_file} > ${dbsnp}.caf
    """
}
