process PENNCNV {
    tag "${cohort}:${key}:${level}"

    label 'simple'
    label 'penncnv'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(tool), file(pfb)

    output:
    tuple val(cohort), val(key), val(tool), val("cnv,gn,log,qc"),
          path("${cohort}.${key}.${tool}.*"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Export genotype calls (GType), if exists in the input file
    # Name, GType
    cat ${file} | awk 'NR==1 {
        for(i=1; i<=NF; i++) if(\$i=="GType") {gtype_col=i; break}
        if(!gtype_col) exit
        next
    }
    {
        split(\$4, a, "");
        print "0\t" "${key}\t" \$1 "\t" a[1] "\t" a[2]
    }' > ${cohort}.${key}.${tool}.gn

    # Run PennCNV
    detect_cnv.pl \
        ${file} \
        -test -loh --confidence \
        -hmm ${file(params.hmm)} \
        -pfb ${pfb} \
        -log ${cohort}.${key}.${tool}.log \
        -out tmp.cnv

    cat tmp.cnv | awk '{\$5 = "${key}"; print \$0}' > ${cohort}.${key}.${tool}.cnv

    # Generate QC metrics
    # File, LRR_mean, LRR_median, LRR_SD, BAF_mean, BAF_median, BAF_SD, BAF_drift, WF, NumCNV
    filter_cnv.pl \
        ${cohort}.${key}.${tool}.cnv \
        --qclog ${cohort}.${key}.${tool}.log \
        --qcsumout tmp.qc
    tail -n +2 tmp.qc > ${cohort}.${key}.${tool}.qc

    # Count the number of markers
    nmarkers=\$(wc -l < "${cohort}.${key}.${tool}.cnv")
    """
}

