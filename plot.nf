process PLOT {
    tag "${cohort}:${feature}:${type}:${plot_type}"

    label 'simple'
    label 'cnvr'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(cohort), val(feature), val(type),
          path(cnv), path(cnv_log), val(cnv_nmarkers),
          val(key), val(level), path(signal), path(signal_log), val(signal_nmarkers),
          val(dbsnp), path(txt), path(pfb),
          val(plot_type)

    output:
    tuple val(cohort), val(feature), val(type), val(plot_type),
          path("${cohort}.*.${plot_type}.png"),
          path("${cohort}.${feature}.${type}.${plot_type}.log")

    script:
    if ( plot_type == 'heatmap') {
        """
        #!/bin/bash
        heatmap.R ${cohort} ${feature} ${cnv} ${plot_type} ${params.n_samples} ${params.n_genes} 2> ${cohort}.${feature}.${type}.${plot_type}.log
        """
    } else if ( plot_type == 'lrr' ) {
        """
        #!/bin/bash
        scatter.R ${cnv} ${signal.join(',')} ${pfb} ${plot_type} ${params.flank} ${params.n_genes} 2> ${cohort}.${feature}.${type}.${plot_type}.log
        """
    } else if ( plot_type == 'baf' ) {
        """
        #!/bin/bash
        scatter.R ${cnv} ${signal.join(',')} ${pfb} ${plot_type} ${params.flank} ${params.n_genes} 2> ${cohort}.${feature}.${type}.${plot_type}.log
        """
    } else {
        printl("Unknown plot type: ${plot_type}")
    }
}
