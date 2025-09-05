process FORMAT {
    tag "${assembly}:${tool}:${version}:${id}"

    label 'simple'
    label 'deepmvp'

    publishDir("${params.output_dir}/annotations/${params.tool}", mode: 'copy')

    input:
    tuple val(assembly), val(tool), val(version), val(id),
          path(file), env(n_variants)

    output:
    tuple val(assembly), val(tool), val(version), val(id),
          path("${assembly}.${tool}.${version}.${id}.scores.tsv.gz"),
          path("${assembly}.${tool}.${version}.${id}.scores.tsv.gz.tbi"),
          env(n_variants)

    script:
    if ( tool == 'deepmvp' ) {
        """
        #!/bin/bash
        # Create header file
        echo "##INFO=<ID=${tool},Number=.,Type=String,Description=\"Format: \$(head -1 ${file} | tr '\t' '|')\">" | bgzip -c > ${assembly}.${tool}.${version}.${id}.scores.tsv.gz

        # Format output
        cat ${file} | \
        awk 'BEGIN{OFS="\t"} 
        NR==1 {
            info_col = \$1
            for(i=2;i<=NF;i++) info_col = info_col "|" \$i
            print "CHROM","POS","ID","REF","ALT",info_col
            next                  
        }
        {
            split(\$1,a,":")
            merged = \$1
            for(i=2;i<=NF;i++) merged = merged "|" \$i
            print a[1],a[2],\$1,a[3],a[4],merged
        }' | \
        tail -n +2 | \
        sort -k1,1 -k2,2n | \
        bgzip -c >> ${params.assembly}.${params.tool}.${params.version}.${id}.scores.tsv.gz
        
        # Index the output
        tabix -s1 -b2 -e2 ${params.assembly}.${params.tool}.${params.version}.${id}.scores.tsv.gz
        
        # Count the number of variants
        n_variants=\$(zcat ${params.assembly}.${params.tool}.${params.version}.${id}.scores.tsv.gz | wc -l)
        """
    } else {
        println "Tool ${tool} not supported in FORMAT module"
    }
}
