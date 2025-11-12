process SORT {
    tag "${filename}"

    label 'simple'
    label 'samtools'

    publishDir("${params.output_dir}/sorted/", mode: 'copy')

    input:
    tuple val(project), val(directory), path(filename)

    output:
    tuple val(project), val(directory), 
          path("${filename.baseName}.sorted.bam"),
          path("${filename.baseName}.sorted.bam.bai")
    
    script:
    """
    #!/bin/bash
    samtools sort -o ${filename.baseName}.sorted.bam ${filename}
    samtools index ${filename.baseName}.sorted.bam
    """
}