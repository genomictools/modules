process COMBINE {
    tag "${assembly}:${cohort}:${chunk}"

    label 'heavy'
    label 'gatk'

    publishDir("${params.output_dir}/combined", mode: 'copy')

    input:
    tuple val(assembly), val(cohort), val(id), path(file), path(index),
          val(chunk), path(bed)

    output:
    tuple val(assembly), val(cohort), val(chunk),
          path("${assembly}.${cohort}.${chunk}")

    script:
    def args = []
    file.each { file -> args.add("--variant ${file}") }
    def args_str = args.join(' ')
    """
    #!/bin/bash
    gatk GenomicsDBImport \
      ${args_str} \
      --genomicsdb-workspace-path ${assembly}.${cohort}.${chunk} \
      --intervals ${bed}
    """
}
