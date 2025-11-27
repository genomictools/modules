process QUANTISNP {
    tag "${cohort}:${key}:${level}"

    label 'simple'
    label 'quantisnp'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(tool)

    output:
    tuple val(cohort), val(key), val(tool),
          path("${cohort}.${key}.${tool}.cnv"),
          path("${cohort}.${key}.${tool}.log"),
          env(nmarkers)

    script:
    def args = []
    if ( params.genotype )   { args << "--genotype" }
    if ( params.doXcorrect ) { args << "--doXcorrect" }
    def args_str = args.join(' ')

    """
    #!/bin/bash
	# Run Quantisnp
	export MCR_CACHE_ROOT="./"
    /opt/quantisnp/linux64/run_quantisnp2.sh \
	/opt/MATLAB/MATLAB_Compiler_Runtime/v79/ \
		--input-files ${file} \
		--config ${file(params.quant_params)} \
		--levels ${file(params.quant_ratios)} \
		--lsetting ${params.lsetting} \
		--emiters ${params.emiters} \
		--outdir . \
		--sampleid ${file.name} \
		${args_str} \
		2> ${cohort}.${key}.${tool}.log

	# Convert to birdseye format
	tail -q -n +2 ${file.name}.cnv  ${file.name}.loh | \
	awk -v OFS="\t" '
		BEGIN { print "sample", "sample_index", "copy_number", "chr", "start", "end", "per_probe_score", "size", "num_probes", "lod_score" };
		{ print "${file}", "${file}", \$9, \$2, \$3, \$4, \$10, \$7, \$8, \$10 }
	' > ${cohort}.${key}.${tool}.cnv

	# Append QC info to log
	echo "\n# QC Metrics" >> ${cohort}.${key}.${tool}.log
	cat ${file.name}.qc >> ${cohort}.${key}.${tool}.log

	# Count the number of markers
	nmarkers="\$(wc -l < "${cohort}.${key}.${tool}.cnv")"
	"""
}
