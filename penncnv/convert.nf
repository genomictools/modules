process CONVERT {
    tag "${cohort}:${tool}:${type}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(tool), val(type), path(cnv), val(nmarkers),
          path(pfb)

    output:
    tuple val(cohort), val(tool), val(type),
          path("${cohort}.${tool}.converted.${type}"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Prepare snplocfile
    tail -n+2 ${pfb} | \
        awk 'BEGIN{OFS = "\t"; print "Name", "Chr", "Pos"}; {OFS = "\t"; print \$1, \$2, \$3}' \
        > snplocfile.txt

    # Prepare input files
    # when copy number is not 2
    cat ${cnv} | \
        awk 'BEGIN {OFS = "\t"; print "sample", "sample_index", "copy_number", "chr", "start", "end", "per_probe_score", "size", "num_probes", "lod_score"};
                   {OFS = "\t"; if (\$3 != 2) print \$0}' \
        > birdseye_not2.cnv

    # Convert to penncnv
    convert_cnv.pl \
        -snplocfile snplocfile.txt \
        -intype birdseye \
        -outtype penncnv \
        birdseye_not2.cnv \
        > birdseye_not2.converted

    # when copy number is 2
    cat ${cnv} | \
        awk 'BEGIN {OFS = "\t"; print "sample", "sample_index", "copy_number", "chr", "start", "end", "per_probe_score", "size", "num_probes", "lod_score"};
                   {OFS = "\t"; if (\$3 == 2) { \$3 = 0; print \$0 } else { print \$0 }}' \
        > birdseye_cn2.cnv

    # Convert to penncnv
    convert_cnv.pl \
        -snplocfile snplocfile.txt \
        -intype birdseye \
        -outtype penncnv \
        birdseye_cn2.cnv \
        > birdseye_cn2.converted

    # replace "state1,cn=0" with "state4,cn=2" in the converted file
    cat birdseye_cn2.converted | \
        sed 's/state1,cn=0/state4,cn=2/g' \
        > birdseye_cn2.fixed.converted
    
    # Combine both converted files
    cat birdseye_not2.converted birdseye_cn2.fixed.converted \
        > ${cohort}.${tool}.converted.${type}

    # Count the number of markers
    nmarkers=\$(wc -l < "${cohort}.${tool}.converted.${type}")
    """
}
