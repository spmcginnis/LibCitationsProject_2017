xquery version "3.0";
(:  OBSOLETE  :)
(: updated 20161226 to include relative file paths -spm :)
(:  xquery to create an xml file for arranging citation format cross tabulations.  created 20161005) -spm  :)
(:  outdated.  new approach is to add format to existing deptXlang xml  -spm 20161127  :)



declare function local:xtab-pubType($diss-list, $n, $m) {
    for $p in $diss-list
    let $PQID := translate($p/proquest/PQID,' ','')
    let $cite-doc := doc(concat('../PQdata2/files/', $PQID, '.xml'))
    let $hits := $cite-doc//Source[@pubType=$m]
return $hits
};



(:  documents and indexes  :)
let $depts := doc('../xml/dept-index.xml')
let $pubTypes := doc('../xml/pubType-index.xml')
let $meta := doc('../xml/PQ-and-GD-merged2.xml')

return 
<xml>
    {comment {concat('created ', current-date(), ' from make-format-xtab.xq -spm')},
    for $n in $depts/xml/dept/text()
    let $diss-list := $meta//record[matches(gradDiv/major, concat('^', string($n), '$'))][proquest and gradDiv]
    let $diss-count := count($diss-list)
    return
    <record>
        <dept>{$n}</dept>
        <count></count><!-- dissertation count? Is this what we need? -->
        <pubTypes>
            {for $m in $pubTypes/xml/pubType/text() return
            
            <pubType id="{$m}" count="{sum(local:xtab-pubType($diss-list, $n, $m))}"/>}
        </pubTypes>
    </record>
    }
</xml>