process MAPSIGNAL {
    tag "${cohort}:${key}:${level}:${region}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/mappedsignal", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(files), path(log), val(nmarkers),
          val(region),
          path(pfb)

    output:
    tuple val(cohort), val(key), val(level),
          path("${cohort}.${key}.${region.replaceAll(/[:\-]/, '_')}.txt"),
          path("${cohort}.${key}.${region.replaceAll(/[:\-]/, '_')}.log"),
          env(nmarkers),
          val(region)

    script:
    def region_safe = region.replaceAll(/[:\-]/, '_')

    """
    #!/bin/bash
    convert_map2signal.pl \
        "${files[0]}" \
        "${file(params.fasta)}" \
        --region "${region}" \
        --outfile "${cohort}.${key}.${region_safe}" \
        2> "${cohort}.${key}.${region_safe}.log"
    
    # Map BAF/LRR to PFB
    tail -n +2 ${pfb} | awk '{OFS="\t"; print \$2, \$3, \$3, \$1, \$4}' > pfb.bed
    tail -n +2 "${cohort}.${key}.${region_safe}.read3" | awk '{OFS="\t"; print \$8, \$9, \$9, \$4, \$7}' > baf_lrr.bed
    bedtools subtract -a baf_lrr.bed -b pfb.bed > subtract.bed
    bedtools intersect -b baf_lrr.bed -a pfb.bed -wb > intersect.bed
    cat subtract.bed intersect.bed | sort -k1,1 -k2,2n | awk 'BEGIN{OFS="\t"; print "SNP Name", "Chromosome", "Position", "Log R Ratio", "B Allele Frequency"} {OFS="\t"; print \$1 ":" \$2 "-" \$3, \$1, \$2, \$5, \$4}' > ${cohort}.${key}.${region_safe}.txt

    # Count number of markers
    nmarkers=\$(cat "${cohort}.${key}.${region_safe}.txt" | wc -l)
    """
}
