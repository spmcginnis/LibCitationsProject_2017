xquery version "3.0";
(: created 20160817 to give Harrison something to work with when running his python script.  -spm  :)
(: updated 20160907 to deal with dissertations that don't have article titles  :)
(: updated 20161112 to provide more fields :)
(: updated 20161226 to use relative file paths :)

declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare option output:method 'text';

declare function local:get-title($m, $type) { (: input is the pubType:)
let $itemTest := boolean($m//ItemTitle)
return switch($type)
    case 'Book' return $m//SourceTitle/Title
    case 'Book_Article/Chapter' case 'Journal_Article' case 'Newspaper_Article' return if ($itemTest) then $m//ItemTitle/Title else '' 
    default return if ($itemTest) then $m//ItemTitle/Title else $m//SourceTitle/Title
};


let $header := concat('PQID', ',', 'CIT-NUM', ',', 'PUB_TYPE', ',', 'TITLE', ',', 'PQ_LANG
')
return $header,
for $n in doc('../xml/PQID-list-2008-2015.xml')//record
let $path := $n/loc/text(), $PQID := $n/PQID
let $doc := doc($path)


for $m in $doc//ExtractedRef
let $order := $m/data(@order)
let $type := $m/Source/data(@pubType)
let $lang := if ($m[@language]) then $m/data(@language) else 'NULL'

(:let $itemTest := boolean($m//ItemTitle)
let $title := if ($itemTest) then $m//ItemTitle/Title else $m//SourceTitle/Title
let $title := translate($title, '"', "'")
:)

(: a typeswitch might be better here, to deal with the problem of journals with no article title :)

return concat(
    $PQID, ',',
    $order, ',',
    $type, ',',
    '"', translate(local:get-title($m, $type), '"', "'"), '"', ',',
    $lang, '
    '
    )



