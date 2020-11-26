xquery version '3.0';

let $doc := doc('key-index.xml')

return
<xml>
{$doc/xml/record[match='no']}
</xml>
