process LINKAGE {
    tag "${cohort}:${family}:${chrom}:${branch}:${linkage_type}"

    label 'simple'
    label 'merlin'

    def type = 'linkage'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom),
          val(branch), path(branch_files),
          path(counts), path(markers), path(model),
          val(linkage_type)

    output:
    tuple val(cohort), val(family), val(chrom), val("${linkage_type}"), val(branch),
          path("${cohort}.${family}.${chrom}.${branch}.${linkage_type}{-parametric.tbl,.flow}"),
          path("${cohort}.${family}.${chrom}.${branch}.${linkage_type}.log"),
          env(n_markers)

    script:
    def args = switch(linkage_type) {
        case 'multipoint'  -> '--tabulate'
        case 'singlepoint' -> '--tabulate --singlepoint'
        case 'breakpoints' -> '--best --horizontal'
        default            -> ''
    }

    def ext = (linkage_type == 'breakpoints') ? '.flow' : '-parametric.tbl'
    def file = "${cohort}.${family}.${chrom}.${branch}.${linkage_type}${ext}"

    """
    #!/bin/bash
    set -euo pipefail

    exec > "${cohort}.${family}.${chrom}.${branch}.${linkage_type}.log" 2>&1

    merlin \
        -p "${branch}.ped" \
        -d "${branch}.dat" \
        -m "${branch}.map" \
        -f "${branch}.freq" \
        --model ${model} \
        --bits 24 \
        --trim \
        --markerNames \
        ${args} \
        --prefix "${cohort}.${family}.${chrom}.${branch}.${linkage_type}"
    
    # Count number of markers in the linkage output file
    n_markers=\$( [ -s "${file}" ] && wc -l < "${file}" || echo 0 )
    """
}        
