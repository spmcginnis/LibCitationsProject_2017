xquery version '3.0';
(:  xquery to create an xml file for arranging language cross tabulations.  created 20160919 (ish) -spm  :)
(:  last updated 20160926 to fix the problem with contains() being too greedy -spm  :)
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

let $depts := doc('../xml/dept-index.xml')
let $meta := doc('../xml/PQ-and-GD-merged2.xml')

let $langs := doc('../xml/language-index.xml')

return 
<xml>
    {comment {concat('created ', current-date(), ' from make-lang-xtab.xq -spm')},
    for $n in $depts/xml/dept/text()
(:    test works with Buddhist Studies #14; test works with all majors.  needs some additional info... NULL language values, etc. :)

    let $diss-list := $meta//record[matches(gradDiv/major, concat('^', string($n), '$'))][proquest and gradDiv and citations/@test='yes']
(:    contains is the wrong function here.  I need an exact match on the string.  :)
(:   //record[matches(gradDiv/major, concat('^', 'History', '$'))][proquest and gradDiv]  :)

    let $diss-count := count($diss-list)
    return 
    <record>
        <dept>{$n}</dept>
        <count>{$diss-count}</count>
        <languages>
            <lang id="NULL" count="{sum(local:Xtab-null($diss-list, $n))}"/>
            {for $m in $langs/xml/lang/text() return
            <lang id="{$m}" count="{sum(local:Xtab-lang($diss-list, $n, $m))}"/>}
        </languages>
    </record>}
</xml>