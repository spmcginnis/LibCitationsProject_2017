xquery version "3.0";

(: a script to list the files in the proquest set which are relevant to the project--that is, which come from 2008-2015.  -spm 20160817 :)
(: updated 20161226 to use relative file paths :)
let $doc := doc('../xml/PQ-and-GD-merged2.xml')
return <xml>
<!-- A list of all relevant PQIDs for the current project, to cover 2008-2015.  -spm 20161226 -->
<!-- the location paths are relative -->
    {for $n at $i in $doc//record[proquest]//PQID/translate(text(), ' ', '') return 
    <record n="{$i}">
        <PQID>{$n}</PQID>
        <fileName>{$n}.xml</fileName>
        <loc>../PQdata2/files/{$n}.xml</loc>
    </record>}
</xml>