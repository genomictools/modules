process COVERAGEMASTER {
    tag "${cohort}:${gene}:${key}"

    label 'simple'
    label 'coveragemaster'

    publishDir("${params.output_dir}/calls/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(gene), val(key),
          path(depth), path(stats),
          path(ref_depth), path(ref_stats),
          path(ref_list), path(ref_aggregate),
          path(gene_list),
          val(tool)

    output:
    tuple val(cohort), val(gene), val(key), val(tool),
          path("${cohort}.${gene}.${key}.${tool}.cnv.tsv"),
          env(nmarker), emit: calls, optional: true

    tuple val(cohort), val(gene), val(key), val(tool),
          path("${cohort}.${gene}.${key}.${tool}.CMcalls"), emit: CMcalls, optional: true

    tuple val(cohort), val(gene), val(key), val(tool),
          path("${cohort}.${gene}.${key}.${tool}.CMpositives.pdf"), emit: plots, optional: true

    script:
    """
    #!/bin/bash
    # call cnvs
    python /opt/coverageMaster/coverageMaster.py \
        ${depth} \
        ${stats} \
        ${gene_list} \
        -c ${ref_list} \
        -r ${ref_aggregate} \
        -n ${task.cpus} \
        -o ${cohort}.${gene}.${key}.${tool}

    awk -v cohort=${cohort} -v key=${key} -v tool=${tool} '
        BEGIN {
            OFS="\t"
            print "seqnames","start","end","exon_start","exon_end","cn","cov","norm_cov","ratio","stats","cohort","key","gene","tool"
        }
        {
            if (\$0 ~ /NO COVERAGE/) {
                next
            }

            line_gene = \$1
            for (i=1; i<=NF-4; i++) {
                if (\$i ~ /^chr[0-9XYM]+\$/ && \$(i+1) ~ /^[0-9]+\$/ && \$(i+2) ~ /^[0-9]+\$/ && (\$(i+3)=="DUP" || \$(i+3)=="DEL") && \$(i+4) ~ /^[0-9]+\$/) {
                    print \$i, \$(i+1), \$(i+2), "NA", "NA", (\$(i+3)=="DUP" ? 3 : 1), "NA", "NA", "NA", "NA", cohort, key, line_gene, tool
                }
            }
        }
    ' ${cohort}.${gene}.${key}.${tool}.CMcalls > ${cohort}.${gene}.${key}.${tool}.cnv.tsv

    nmarker=\$(grep -vc '^#' ${cohort}.${gene}.${key}.${tool}.cnv.tsv || true)
    """
}
