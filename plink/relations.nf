process RELATIONS {
    tag "${cohort}:${tool}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/relations", mode: 'copy')

    input:
    tuple val(cohort), val(tool),
          path(bim), path(bed), path(fam), path(log),
          env(n_samples), env(n_variants)

    output:
    tuple val(cohort), val(tool),
          path("${cohort}.${tool}.relations.{rel,rel.id,log}")

    script:
    """
    #!/bin/bash
    plink \
      --make-rel square0 \
      -bfile ${bim.baseName} \
      --out "${cohort}.${tool}.relations"
    """
}
