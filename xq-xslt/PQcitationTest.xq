xquery version '3.0';
(: OBSOLETE 20161226 :)
(: updated 20161226 to include relative file paths -spm :)
(: This file adds a line to each record of the PQ-andGD-merged metadata file to state whether citations exist in the PQ database. :)



(:let $files := collection('../PQData2/files'):)

let $doc := doc('../xml/PQ-and-GD-merged.xml')
let $list := doc('../xml/fileList.xml'), $PQID := $list/xml/PQID

return
<xml>{
    let $records := $doc/xml/record
    for $x in $records return
    <record>
        {$x/node()}
        {if (not($x/proquest)) then (<citations test="no">No match with Proquest list.</citations>) else 
        if (contains(string-join($PQID, ' '), $x/proquest/PQID/text())) then (<citations test="yes">Citations exist in database.</citations>) else (<citations test="no">Proquest ID not found in citations files.</citations>)}
        
    </record>
}</xml>

