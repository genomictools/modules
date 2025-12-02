process RGADA {
    tag "${cohort}:${key}:${level}"

    label 'simple'
    label 'rgada'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(tool)
          

    output:
    tuple val(cohort), val(key), val(tool), val("cnv,log"),
          path("${cohort}.${key}.${tool}.{cnv,log}"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
    # Call RGADA
    # sample, sample_index, copy_number, chr, start, end, per_probe_score, size, num_probes, lod_score
    RGadaIndividual.R ${key} ${file} ${params.a_alpha} ${params.t_statistic} ${params.numsnp} ${cohort}.${key}.${tool}.cnv >& ${cohort}.${key}.${tool}.log

    # Count the number of markers
    nmarkers="\$(wc -l < "${cohort}.${key}.${tool}.cnv")"
    """
}

