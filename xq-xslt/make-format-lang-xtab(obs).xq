xquery version '3.0';
(: OBSOLETE :)
(: A file to create a cross-tabulation of language and publication type.  20161202 spm :)
(: *** right now the output is not correctly separating by department :)
(: updated 20161226 to include relative file paths -spm :)

declare function local:Xtab-lang($diss-list, $n, $m){
    for $p in $diss-list
    let $PQID := translate($p/proquest/PQID,' ','')
    let $cite-doc := doc(concat('../PQdata2/files/', $PQID, '.xml'))
    let $lang-hits := $cite-doc//ExtractedRef[@language=$m]
    return count($lang-hits)
};

declare function local:Xtab-null($diss-list, $n) {
    for $p in $diss-list
    let $PQID := translate($p/proquest/PQID,' ','')
    let $cite-doc := doc(concat('../PQdata2/files/', $PQID, '.xml'))
    let $lang-hits := $cite-doc//ExtractedRef[not(@language)]
    return count($lang-hits)
};

(:  documents and indexes  :)
let $pubTypes := doc('../xml/pubType-index.xml')
let $meta := doc('../xml/PQ-and-GD-merged2.xml')
let $langs := doc('../xml/language-index.xml')
let $diss-list := $meta//record[proquest and gradDiv and citations/@test='yes']

return
<xml>
    {for $n in $pubTypes/xml/pubType
    return 
    <record>
        <pubType>{$n}</pubType>
        <languages>
            <lang id="NULL" count="{sum(local:Xtab-null($diss-list, $n))}"/>
            {for $m in $langs/xml/lang/text() return
            <lang id="{$m}" count="{sum(local:Xtab-lang($diss-list, $n, $m))}"/>}
        </languages>
    </record>}
</xml>

