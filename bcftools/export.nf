process EXPORT {
    tag "${cohort}:${family}:${chrom}:${source}"

    label 'simple'
    label 'bcftools'

    def type = 'export'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), val(chrom), val(source),
          path(segments), path(top_segments), path(log_segments), val(n_segments),
          val(vcf_type), path(file), path(index),
          val(n_samples), val(n_variants)

    output:
    tuple val(cohort), val(family), val(chrom), val(source), 
          path("${cohort}.${family}.${chrom}.${source}.vcf.gz"),
          path("${cohort}.${family}.${chrom}.${source}.vcf.gz.tbi"),
          path("${cohort}.${family}.${chrom}.${source}.annotation.tsv"),
          path("${cohort}.${family}.${chrom}.${source}.qc.tsv"),
          env(n_samples), env(n_variants)

    script:
    """
    #!/bin/bash
    set -euo pipefail

    # Subset to recommended segment
    bcftools view -R "${top_segments}" -Oz -o "${cohort}.${family}.${chrom}.${source}.vcf.gz" "${file}"
    tabix -p vcf "${cohort}.${family}.${chrom}.${source}.vcf.gz"

    # Export split-VEP annotations
    echo "variant" > headr.txt
    bcftools +split-vep -l "${cohort}.${family}.${chrom}.${source}.vcf.gz" 2>/dev/null | cut -f 2 >> headr.txt || true
    paste -sd '\\t' headr.txt > "${cohort}.${family}.${chrom}.${source}.annotation.tsv"

    bcftools +split-vep -s worst -f '%CHROM:%POS\\_%REF/%ALT\\t%CSQ\\n' -d -A tab \
        "${cohort}.${family}.${chrom}.${source}.vcf.gz" 2>/dev/null \
        >> "${cohort}.${family}.${chrom}.${source}.annotation.tsv" || true

    rm -f headr.txt

    # Export QC metrics
    echo -e "variant\tAC_Het" > "${cohort}.${family}.${chrom}.${source}.qc.tsv"
    bcftools view -Ou "${cohort}.${family}.${chrom}.${source}.vcf.gz" | \
    bcftools query -f '%CHROM:%POS\\_%REF/%ALT\\t%AC_Het\\n' \
    >> "${cohort}.${family}.${chrom}.${source}.qc.tsv"

    # Count exported variants and samples
    n_samples=\$(bcftools query -l "${cohort}.${family}.${chrom}.${source}.vcf.gz" | wc -l | awk '{print \$1}')
    n_variants=\$(bcftools index -n "${cohort}.${family}.${chrom}.${source}.vcf.gz")
    """
}
