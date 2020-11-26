xquery version '3.0';

let $doc := doc('PQ-and-GD-merged2.xml')

let $recs := $doc/xml/record[not(match='no')]

return
<xml>
{$recs}
</xml>