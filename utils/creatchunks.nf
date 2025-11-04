#!/usr/bin/env nextflow

nextflow.enable.dsl=2

def createChunks(chrom_sizes_file, width) {
    return Channel.fromPath(chrom_sizes_file) 
        | splitCsv(header: false, sep: '\t')
        | flatMap { row -> 
            def chrom = row[0]
            def chrom_size = row[1] as Integer
            def chunk_width = width as Integer
            def regions = []
            
            for (int start = 1; start <= chrom_size; start += chunk_width) {
                def end = Math.min(start + chunk_width - 1, chrom_size)
                regions.add([chrom, start, end])
            }
            return regions
        }
}
