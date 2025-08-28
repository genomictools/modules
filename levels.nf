process LEVELS {
    tag "${tool}"

    label 'simple'

    publishDir("${params.output_dir}/ref", mode: 'copy')

    input:
    val(tool)

    output:
    tuple val(tool), path("${tool}.params.dat"), path("${tool}.levels.dat")

    script:
    """
    #!/bin/bash
    echo -e "Parameter\tValue" > ${tool}.params.dat
    echo -e "nComp\t${params.nComp}" >> ${tool}.params.dat
    echo -e "v\t${params.v}" >> ${tool}.params.dat
    echo -e "nu_alpha\t${params.nu_alpha}" >> ${tool}.params.dat
    echo -e "nu_beta\t${params.nu_beta}" >> ${tool}.params.dat
    echo -e "w_alpha\t${params.w_alpha}" >> ${tool}.params.dat
    echo -e "q_alpha\t${params.q_alpha}" >> ${tool}.params.dat
    echo -e "tau\t${params.tau}" >> ${tool}.params.dat
    echo -e "S_alpha\t${params.S_alpha}" >> ${tool}.params.dat
    echo -e "S_alpha_homdel\t${params.S_alpha_homdel}" >> ${tool}.params.dat
    echo -e "longChromosome\t${params.longChromosome}" >> ${tool}.params.dat

    echo -e "CopyNumber\tMeanLogRRatio\tComment" > ${tool}.levels.dat
    echo -e "0\t${params.level_0}\tHomozygous deletion" >> ${tool}.levels.dat
    echo -e "1\t${params.level_1}\tHemizygous deletion" >> ${tool}.levels.dat
    echo -e "2\t${params.level_2}\tNormal" >> ${tool}.levels.dat
    echo -e "2\t${params.level_2}\tCopy-Neutral LOH" >> ${tool}.levels.dat
    echo -e "3\t${params.level_3}\tDuplication" >> ${tool}.levels.dat
    echo -e "4\t${params.level_4}\tDouble duplication" >> ${tool}.levels.dat
    echo -e "5\t4\tAll Higher copy numbers (DO NOT MODIFY)" >> ${tool}.levels.dat
    """
}