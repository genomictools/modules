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
    tuple val(cohort), val(key), val(tool), val("cnv,gn,log,qc"),
          path("${cohort}.${key}.${tool}.*"),
          env(nmarkers)

    script:
    """
    #!/bin/bash
	# Get unique chromosome list
	chroms=\$(tail -n +2 ${file} | awk '{print \$2}' | sort -un | tr '\n' ',')

	# Run Quantisnp
	export MCR_CACHE_ROOT="./"
    /opt/quantisnp/linux64/run_quantisnp2.sh \
	/opt/MATLAB/MATLAB_Compiler_Runtime/v79/ \
		--input-files ${file} \
		--config ${file(params.quant_params)} \
		--levels ${file(params.quant_ratios)} \
		--lsetting ${params.lsetting} \
		--emiters ${params.emiters} \
		--chr "\${chroms}" \
		--doXcorrect \
		--genotype \
		--outdir . \
		--sampleid ${file.name} \
		2> ${cohort}.${key}.${tool}.log

	# Convert to birdseye format
	# sample, sample_index, copy_number, chr, start, end, per_probe_score, size, num_probes, lod_score
	tail -q -n +2 ${file.name}.cnv  ${file.name}.loh | \
	awk -v OFS="\t" '
		{ print "${key}", "${key}", \$9, \$2, \$3, \$4, \$10, \$7, \$8, \$10 }
	' > ${cohort}.${key}.${tool}.cnv

	# Rename files
	# Sample ID, Chromosome, Outlier Rate, Std. Dev. LRR, Std. Dev. BAF
	tail -n +2 ${file.name}.qc > ${cohort}.${key}.${tool}.qc

	# Export genotype calls (GType)
	zcat ${file.name}.gn.gz | \
	tail -n +2 | \
	awk '{split(\$10, a, ""); print "0\t" "${key}\t" \$1 "\t" a[1] "\t" a[2]}' \
	> ${cohort}.${key}.${tool}.gn

	# Count the number of markers
	nmarkers="\$(wc -l < "${cohort}.${key}.${tool}.cnv")"
	"""
}
