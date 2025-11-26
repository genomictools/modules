process CCTEST {
    tag "${cohort}:${tool}:${type}:${test}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/tests", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(file), path(log), val(nmarkers),
          val(indid), val(size), val(famid), val(test),
          path(pedigree),
          path(pfb)

    output:
    tuple val(cohort), val(tool), val(test),
          path("${cohort}.${tool}.${type}.${test}"),
          path("${cohort}.${tool}.${type}.${test}.log"),
          env(nmarkers)

    script:
    def args = []
    if ( params.onesided ) { args << "--onesided" }
    def args_str = args.join(' ')

    if ( test == 'cctest' ) {
        """
        #!/bin/bash
        # Create phenotype file
        awk 'NR==FNR {
            split(\$5,a,"."); 
            samples[a[2]]=\$5; 
            next
        } 
        {
            if(\$2 in samples) {
                \$2 = samples[\$2]; 
                print \$2, \$6
            }
        }' ${file} ${pedigree} > phenotype.txt

        # Apply test
        detect_cnv.pl \
            --${test} \
            -cnv ${file} \
            -phenofile phenotype.txt \
            -pfb ${pfb} \
            ${args_str} \
            > ${cohort}.${tool}.${type}.${test} \
            2> ${cohort}.${tool}.${type}.${test}.log

        nmarkers=\$(wc -l < "${cohort}.${tool}.${type}.${test}")
        """
    } else {
        error "Test ${test} not implemented"
    }
}
