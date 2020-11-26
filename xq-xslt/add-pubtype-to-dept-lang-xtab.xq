xquery version '3.0';
(: Adds the pubtype to the deptXlang XML file (not the spreadsheet).  Updated 20161226 to use relative paths. :)


declare function local:deptXpubtype($diss-list, $m) {
(: $dept is the name of the department. $m is the name of the pubtype :)
    for $diss in $diss-list
    let $PQID := translate($diss/proquest/PQID,' ','')
    let $cite-doc := doc(concat('../PQdata2/files/', $PQID, '.xml'))
    let $pubtype-hits := $cite-doc//ExtractedRef/Source[@pubType=$m]
    return count($pubtype-hits)
};

let $doc := doc('../xml/dept-lang-xtab-20161014.xml')
let $pubtypes := doc('../xml/pubType-index.xml')
let $meta := doc('../xml/PQ-and-GD-merged2.xml')

return
<xml>{
    for $n in $doc/xml/record
    let $dept := data($n/dept)
    let $diss-list := $meta//record[matches(gradDiv/major, concat('^', string($dept), '$'))][proquest and gradDiv and citations/@test='yes']
    return
    <record>
    {$n/child::node()}
    <pubtypes>
        {for $m in $pubtypes/xml/pubType/text() return 
        <pubtype id="{$m}" count="{sum(local:deptXpubtype($diss-list, $m))}"/>

        }
    </pubtypes>
    </record>
}</xml>