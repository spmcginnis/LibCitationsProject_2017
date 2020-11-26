xquery version '3.0';
(: updated 20161226 to include relative file paths -spm :)

let $coll := collection('../PQdata2/files')

let $languages := $coll//ExtractedRef/data(@language)

return
<xml>{for $n in distinct-values($languages) order by $n return
    <lang>{$n}</lang>}
</xml>