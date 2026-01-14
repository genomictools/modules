process RELATIONS {
    tag "${cohort}:${tool}"

    label 'simple'
    label 'plink'

    publishDir("${params.output_dir}/relations", mode: 'copy')

    input:
    tuple val(cohort), val(tool),
          path(lgen), path(map), path(fam), path(log),
          val(nmarkers)

    output:
    tuple val(cohort), val(tool),
          path("${cohort}.${tool}.relations.{rel,rel.id,log}")

    script:
    """
    #!/bin/bash
    plink \
      --make-rel square0 \
      -lfile ${lgen.baseName} \
      --out "${cohort}.${tool}.relations"
    """
}
