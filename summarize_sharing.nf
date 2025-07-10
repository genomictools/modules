#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { SHARING }     from '../modules/sharing.nf'
include { CLASSIFY }    from '../modules/classify.nf'
include { ATTACH }      from '../modules/attach.nf'
include { DRAW }        from '../modules/draw.nf'

type_ch = Channel.of( 'variant', 'gene' )

workflow summarize_sharing {
    take:
    variants
    family
    blacklist
    
    main:
    // Extract variants stats
    variants
        | combine(family, by: 0)
        | combine(blacklist)
        | SHARING
        | groupTuple(by: [0, 1])
        | combine(type_ch)
        | CLASSIFY
        | filter { it[2] == 'variant' }
        | splitCsv(header: true, sep: '\t')
        | map { famid, category, type, row -> [ row.famid, row.category, row.gene, row.variant ] }
        | distinct
        | groupTuple(by: [0, 1, 2, 3])
        | set { shared }

    // Draw pedigrees
    if ( params.draw ) {
        variants
            | combine(family, by: 0)
            | ATTACH
            | combine(shared, by: [0, 1])
            | DRAW
    }

    emit:
    shared
}

workflow  {
    family_ch = Channel.fromPath(params.cohorts)
        | splitCsv(header: true, sep: ',')
        | map { row -> [ row.famid, file(row.cases), file(row.ped)] }
        | unique

    variants_ch = Channel.fromPath(params.cohorts)
        | splitCsv(header: true, sep: ',')
        | map { row -> [
            row.famid, row.category, file(row.snplist), file(row.rlist), file(row.freq), file(row.annotation)
        ] }

    blacklist_ch = Channel.fromPath(params.blacklist)

    summarize_genes( variants_ch, family_ch, blacklist_ch )
}
