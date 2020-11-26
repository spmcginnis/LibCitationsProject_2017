xquery version '3.0';
(: updated 20161226 to include relative file paths -spm :)

let $coll := collection('../PQdata2/files')

let $refs := $coll//ExtractedRef/Source[contains(data(@pubType), 'Book')]/Publisher/PublisherName

return
<xml>{for $n in distinct-values($refs) order by $n return
    <publisher>{$n}</publisher>}
</xml>