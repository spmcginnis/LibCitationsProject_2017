xquery version '3.0';
(: OBSOLETE :)
(: updated 20161226 to include relative file paths -spm :)
(:  To report the state of the data.  last updated 20160907 spm :)
declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare option output:method 'text';

let $doc := doc('../xml/PQ-and-GD-merged2.xml')

let $meta := $doc/xml/meta
let $rec := $doc/xml/record

let $PQn := count($rec[proquest])
let $GDn := count($rec[gradDiv])

let $PQonly := count($rec[proquest and not(gradDiv)])
let $GDonly := count($rec[gradDiv and not(proquest)])
let $matched := count($rec[gradDiv and proquest])
let $total := count($rec[gradDiv or proquest])
let $hasCitations := count($rec[citations/@test='yes'])
let $SF := count($rec/proquest[contains(school, 'San Francisco') and not(contains(school, 'Berkeley'))])

return concat(current-date(), ' report on the PQxGD metadata:', '&#xD;',
    'Total Dissertations, ', $total, '&#xD;',
    'Matched, ', $matched, '&#xD;',
    'Grad. Division Only, ', $GDonly, '&#xD;',
    'Proquest Only, ', $PQonly, '&#xD;',
    'PQ SF not Berkeley subset, ', $SF, '&#xD;',
    'Has citations, ', $hasCitations, '&#xD;',
    'Has PQID but no citations, ', $total - $GDonly - $hasCitations
    )