process QUANTISNP {
    tag "${cohort}:${key}:${level}"

    label 'simple'
    label 'quantisnp'

    publishDir("${params.output_dir}/${tool}", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(level),
          path(file), path(log), val(nmarkers),
          val(tool), path(model), path(levels)

    output:
    tuple val(cohort), val(key), val(tool), val("cnv,loh"),
          path("${cohort}.${key}.${tool}.{cnv,loh}"),
          path("${cohort}.${key}.${tool}.qc"),
          env(nmarkers)

    script:
    def args = []
    if ( params.genotype ) { args << "--genotype" }
    if ( params.doXcorrect ) { args << "--doXcorrect" }
    def args_str = args.join(' ')

    """
    #!/bin/bash
	# Setup MCR
	export MCR_CACHE_ROOT=\$(pwd)/mcr_cache
	mkdir -p \$MCR_CACHE_ROOT
	export HOME=\$(pwd)

	# Run Quantisnp
    /opt/quantisnp/linux64/run_quantisnp2.sh \
    /opt/MATLAB/MATLAB_Compiler_Runtime/v79/ \
		--input-files ${file} \
		--config ${model} \
		--levels ${levels} \
		--lsetting ${params.lsetting} \
		--emiters ${params.emiters} \
		--outdir . \
		--sampleid ${cohort}.${key}.${tool} \
		${args_str}

	# Convert to birdseye format
	tail -n +2 ${cohort}.${key}.${tool}.cnv > tmp.cnv
	echo -e "sample\tsample_index\tcopy_number\tchr\tstart\tend\tper_probe_score\tsize\tnum_probes\tlod_score" > ${cohort}.${key}.${tool}.cnv
	cat tmp.cnv | awk -v F="\t" '{print "${file}\t${file}\t"\$9"\t"\$2"\t"\$3"\t"\$4"\t"\$10"\t"\$7"\t"\$8"\t"\$10}' >> ${cohort}.${key}.${tool}.cnv

	tail -n +2 ${cohort}.${key}.${tool}.loh > tmp.loh
	echo -e "sample\tsample_index\tcopy_number\tchr\tstart\tend\tper_probe_score\tsize\tnum_probes\tlod_score" > ${cohort}.${key}.${tool}.loh
	cat tmp.loh | awk -v F="\t" '{print "${file}\t${file}\t"\$9"\t"\$2"\t"\$3"\t"\$4"\t"\$10"\t"\$7"\t"\$8"\t"\$10}' >> ${cohort}.${key}.${tool}.loh

	# Count the number of markers
	nmarkers="\$(wc -l < "${cohort}.${key}.${tool}.cnv"),\$(wc -l < "${cohort}.${key}.${tool}.loh")"
	"""
}
