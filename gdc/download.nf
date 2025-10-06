process DOWNLOAD {
    tag "${id}"

    label 'simple'
    label 'gdc'

    publishDir("${params.output_dir}/downloaded/", mode: 'copy')

    input:
    tuple val(id), val(url)

    output:
    tuple val(id), path("${id}/*.vcf.gz{,.tbi}")
    
    secret 'TOKEN'
    //  nextflow secrets set TOKEN "<GDC_TOKEN>"
    
    script:
    if ( params.source == 'GDC') {
        """
        #!/bin/bash
        gdc-client download ${id} -t <(echo \${TOKEN})
        """
    } else if ( params.source == 'STJUDE') {
        """
        #!/bin/bash
        mkdir -p ${id}
        wget -P ${id} ${url}
        """
    } else {
        println "Unknown source: ${params.source}"
    }
}
