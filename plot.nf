process PLOT {
    tag "${cohort}:${feature}:${plot_type}"

    label 'simple'
    label 'cnvranger'

    publishDir("${params.output_dir}/plots", mode: 'copy')

    input:
    tuple val(cohort), val(feature), 
          path(cnv), path(cnv_log), val(cnv_nmarkers),
          val(key), val(level), path(signal), path(signal_log), val(signal_nmarkers),
          val(dbsnp), path(txt), path(pfb),
          val(plot_type)

    output:
    tuple val(cohort), val(feature), val(plot_type),
          path("${cohort}.*.${plot_type}.png"),
          path("${cohort}.${feature}.${plot_type}.log")

    script:
    if ( plot_type == 'heatmap') {
        """
        #!/bin/bash
        heatmap.R ${cohort} ${feature} ${cnv} ${plot_type} 1 1 2> ${cohort}.${feature}.${plot_type}.log
        """
    } else if ( plot_type == 'lrr' ) {
        """
        #!/bin/bash
        scatter.R ${cnv} ${signal.join(',')} ${pfb} ${plot_type} ${params.flank} ${params.top_n} 2> ${cohort}.${feature}.${plot_type}.log
        """
    } else if ( plot_type == 'baf' ) {
        """
        #!/bin/bash
        scatter.R ${cnv} ${signal.join(',')} ${pfb} ${plot_type} ${params.flank} ${params.top_n} 2> ${cohort}.${feature}.${plot_type}.log
        """
    } else {
        printl("Unknown plot type: ${plot_type}")
    }
}