process CHUNKS {
    tag "${cohort}:${family}"

    label 'simple'
    label 'bcftools'

    def type = 'chunks'

    publishDir("${params.output_dir}/${type}", mode: 'copy')

    input:
    tuple val(cohort), val(family), path(file), path(index)

    output:
    path("${cohort}.${family}.${type}.bed")

    script:
    """
    #!/bin/bash
    bcftools index -s ${file} | \
    awk -v chroms="${params.chroms ?: ''}" -v size="${params.chunk_size}" '
        BEGIN {
            if (chroms != "" && chroms != "null" && chroms != "all") {
                n = split(chroms, arr, ",")
                for (i = 1; i <= n; i++) keep[arr[i]] = 1
            }
        }
        (length(keep) == 0 && \$1 ~ /^(chr)?([1-9]|1[0-9]|2[0-2]|X|Y)\$/) || (\$1 in keep) {
            for (s = 1; s <= \$2; s += size) {
                e = (s + size - 1 < \$2) ? s + size - 1 : \$2
                printf "%s\\t%d\\t%d\\n", \$1, s, e
            }
        }
    ' | while IFS=\$'\\t' read -r chr beg end; do
        if [ -n "\$(tabix ${file} "\${chr}:\${beg}-\${end}" 2>/dev/null | head -n 1)" ]; then
            printf "%s\\t%s\\t%s\\n" "\$chr" "\$beg" "\$end"
        fi
    done > ${cohort}.${family}.${type}.bed
    """
}
