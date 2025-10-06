process CCTEST {
    tag "${cohort}:${tool}:${type}:${test}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/tests", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type),
          path(file), path(log), val(nmarkers),
          val(test),
          path(pedigree),
          val(dbsnp), path(txt), path(pfb)

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
        # Create IID to sample name mapping from the CSV (assuming header in CSV)
        cat ${file} | awk '{ split(\$5,a,"."); print a[1], \$5}' | sort -u > iid2name.txt

        # Create phenotype.txt by replacing IID with sample name and setting case/control
        awk 'BEGIN{
            while((getline<"iid2name.txt")>0) map[\$1]=\$2
        }
        !/^#/ {
            label = (\$NF==2 ? "case" : "control")
            print map[\$2], label
        }' ${pedigree} > phenotype.txt

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
