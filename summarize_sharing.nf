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
        | filter { it[2] == 'gene' }
        | map { it.last() }
        | collectFile
        | splitText(keepHeader: true)
        | splitCsv(header: false, sep: '\t')
        | map { row -> [row[0], row[1], row[3], row[6]]}
        | set { shared }
    shared | take(3) | view
    // Draw pedigrees
    if ( params.draw ) {
        variants
            | combine(family, by: 0)
            | ATTACH
            | combine(shared, by: [0, 1])
            | take(3)
            | DRAW
    }

    emit:
    shared
}

workflow  {
    family_ch = Channel.fromPath(params.cohorts)
        | splitCsv(header: true, sep: ',')
        | map { row -> [ row.famid, file(row.cases), file(row.pedigree)] }
        | unique

    variants_ch = Channel.fromPath(params.cohorts)
        | splitCsv(header: true, sep: ',')
        | map { row -> [
            row.famid, row.category, file(row.rlist), file(row.annotation)
        ] }

    blacklist_ch = Channel.fromPath(params.blacklist)

    summarize_genes( variants_ch, family_ch, blacklist_ch )
}
