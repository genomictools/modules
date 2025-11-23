process QUANTMODEL {
    tag "${parameter}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/ref", mode: 'copy')

    input:
    val(parameter)

    output:
    tuple val(parameter), path("${parameter}.dat")

    script:
    if ( parameter == 'levels' ) {
        """
        echo -e "Parameter\tValue" > ${parameter}.dat
        echo -e "nComp\t${params.nComp}" >> ${parameter}.dat
        echo -e "v\t${params.v}" >> ${parameter}.dat
        echo -e "nu_alpha\t${params.nu_alpha}" >> ${parameter}.dat
        echo -e "nu_beta\t${params.nu_beta}" >> ${parameter}.dat
        echo -e "w_alpha\t${params.w_alpha}" >> ${parameter}.dat
        echo -e "q_alpha\t${params.q_alpha}" >> ${parameter}.dat
        echo -e "tau\t${params.tau}" >> ${parameter}.dat
        echo -e "S_alpha\t${params.S_alpha}" >> ${parameter}.dat
        echo -e "S_alpha_homdel\t${params.S_alpha_homdel}" >> ${parameter}.dat
        echo -e "longChromosome\t${params.longChromosome}" >> ${parameter}.dat
        """
    } else if ( parameter == 'params' ) {
        """
        #!/bin/bash
        echo -e "CopyNumber\tMeanLogRRatio\tComment" > ${parameter}.dat
        echo -e "0\t${params.level_0}\tHomozygous deletion" >> ${parameter}.dat
        echo -e "1\t${params.level_1}\tHemizygous deletion" >> ${parameter}.dat
        echo -e "2\t${params.level_2}\tNormal" >> ${parameter}.dat
        echo -e "2\t${params.level_2}\tCopy-Neutral LOH" >> ${parameter}.dat
        echo -e "3\t${params.level_3}\tDuplication" >> ${parameter}.dat
        echo -e "4\t${params.level_4}\tDouble duplication" >> ${parameter}.dat
        echo -e "5\t4\tAll Higher copy numbers (DO NOT MODIFY)" >> ${parameter}.dat
        """
    }
}