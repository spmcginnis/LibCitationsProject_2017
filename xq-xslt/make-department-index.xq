xquery version '3.0';
(: updated 20161226 to include relative file paths -spm :)

let $doc := doc('../xml/PQ-and-GD-merged2.xml')
let $depts := $doc//major/text()
return
<xml>{for $n in distinct-values($depts) order by $n return
    <dept>{$n}</dept>
    }
</xml>