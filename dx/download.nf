process DOWNLOAD {
    tag "${filename}"

    label 'simple'
    label 'dxtoolkit'

    publishDir("${params.output_dir}/downloaded/", mode: 'copy')

    input:
    tuple val(project), val(directory), val(filename)

    output:
    tuple val(project), val(directory), path("${filename}")
    
    secret 'TOKEN'
    //  nextflow secrets set TOKEN "<GDC_TOKEN>"
    
    script:
    """
    #!/bin/bash
    export HOME=\${PWD}
    mkdir -p ~/.dnanexus_config
    echo '{}' > ~/.dnanexus_config/environment.json
    dx login --token "\$TOKEN" --noprojects 2>&1 || echo "Login failed"
    dx download '${project}:/${directory}/${filename}'
    """
}