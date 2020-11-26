xquery version '3.0';
(: created early July 2016. :)
(: last updated 2017 May 5 -spm:)
(: OBS. Note the different ways to declare the department (using variables... probably could be made into parameters, but this works fine.  see line 44.:)
(: Changed the dept declaration to an external variable. :)

(:need to eliminate carriage returns in data :)


declare namespace functx = "http://www.functx.com";
declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';

(:  serialization   :)
declare option output:method 'text';

declare variable $dept external := 'null';

(: functx function:)
declare function functx:is-a-number
  ( $value as xs:anyAtomicType? )  as xs:boolean {

   string(number($value)) != 'NaN'
 } ;

(:a function to deal with authors and editors.  will output a single string.  doesn't deal well with reprints when there is a second author:)
declare function local:findAuthor($in) {
let $author := $in//AuthorPortion/text()
let $a := count($author)
let $eds := $in//Editor/Full
let $b := count($eds)
let $out := if ($a=1) then ($author)
    else if ($a=0 and $b>0) then (string-join($eds,','))
    else (string-join($author, ','))
return $out
};

(: language test function :)
declare function local:langTest ($in) {
let $lang := $in/@language
let $out := if ($lang) then ($lang) else ('NULL')
return $out
};

(: function to escape quotation marks, commas, and carriage returns in the citation entries :)
declare function local:normalize ($in) {
let $out := concat(
    '"',
    translate(normalize-space($in), '"', "'"),
    '"',
    ',') (: translates double quotes to single quotes then wraps in double quotes for csv processing. This is necessary to escape commas in titles.:)
return $out
};

let $record := doc('../xml/PQ-and-GD-merged2.xml')/xml/record[gradDiv/major/text()=$dept][citations/@test='yes']
let $deptList := doc('../xml/dept-index.xml')


(: OBS. Here a the way of declaring a dept by name, for one-off reports.   :)
(: ------------------------------------ :)
(:let $dept := 'African American Studies':)
(: ------------------------------------ :)

(: OBS.  Here a the way of using a number to represent the position of the department in the dept-index :)
(: ------------------------------------ :)
(:let $i := 38

let $dept := $deptList/xml/dept[$i]/text():)
(: ------------------------------------ :)

let $dept := 
    if (functx:is-a-number($dept)) then $deptList/xml/dept[$dept]/text()
    else $dept

return ('record_number,dissertation_number,diss_name,diss_title,diss_date,diss_dept,diss_SID,diss_PQID,cit_type,cit_name,cit_title,cit_subtitle,cit_title2,cit_subtitle2,cit_volume,cit_issue,cit_pub_name,cit_date,cit_lang,cit_fulltext
',

for $n at $i in $record 
    let $PQID := translate($n/proquest/PQID,' ','')
    let $doc2 := doc(concat('../PQdata2/files/', $PQID, '.xml'))
for $m in $doc2/ItemWithRef/References/ExtractedRef

(: We need to distinguish between titles in different types of citations, to properly grab article titles (rather than the title of the journal they are found in) :)
let $itemTest := boolean($m//ItemTitle)
let $title := if ($itemTest) then $m//ItemTitle/Title else $m//SourceTitle/Title
let $subTitle := if ($itemTest) then $m//ItemTitle/SubTitle else $m//SourceTitle/SubTitle
let $subTitle := if ($subTitle) then $subTitle else 'NULL'

(: In the case of a journal or edited volume, we need the title of the work which contains our article as well:)
let $title2 := if ($itemTest) then $m//SourceTitle/Title else 'NULL'
let $subTitle2 := if ($itemTest) then $m//SourceTitle/SubTitle else 'NULL'
let $subTitle2 := if ($subTitle2) then $subTitle2 else 'NULL'

(: We also need volume and issue numbers :)
let $volume := if ($m//Volume) then $m//Volume else 'NULL'
let $issue := if ($m//Issue) then $m//Issue else 'NULL'

let $pubName := if ($m//PublisherName) then $m//PublisherName else 'NULL'

return 
concat(
    '""', ',',
    $i, ',',
    local:normalize($n/proquest/author/text()),
    local:normalize($n/proquest/title/text()),
    local:normalize($n/proquest/year/text()),
    local:normalize($n/gradDiv/major/text()),
    local:normalize($n/gradDiv/SID/text()),
    local:normalize($PQID),
    local:normalize(data($m/Source/@pubType)),
    local:normalize(local:findAuthor($m)),
    local:normalize($title),
    local:normalize($subTitle),
    local:normalize($title2),
    local:normalize($subTitle2),
    local:normalize($volume),
    local:normalize($issue),
    local:normalize($pubName),
    local:normalize($m/PubDate),
    local:normalize(local:langTest($m)),
    local:normalize($m/ReferenceText/text()),'
    '
    )
)
