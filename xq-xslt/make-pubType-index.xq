xquery version '3.0';


let $coll := collection('../PQdata2/files')

let $pubType := $coll//ExtractedRef/Source/data(@pubType)

return
<xml>{for $n in distinct-values($pubType) order by $n return
    <pubType>{$n}</pubType>}
</xml>