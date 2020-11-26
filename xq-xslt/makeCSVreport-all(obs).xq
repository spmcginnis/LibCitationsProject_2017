xquery version '3.0';
(: OBSOLETE 20161216:)
(: updated 20161226 to include relative file paths -spm :)
    (: XQ created based on ...by-dept.xq.  2016 July 20 spm. :)
    (: Some differences in the fields between this and the one by department :)
    (: Updated 2016 July 23 spm. :)
    (: Updated 2016 July 28 spm to remove UCSF dissertations :)
(:    this might need to be rewritten to produce xml output.  then a new xq will need to be written to transform the xml output to csv.  this is the quickest way I can think of to add line numbers. :)

(: !!!  this file needs to be updated to deal properly with titles:)

(: This process was abandoned in favor of reports by department. :)

declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare option output:method 'text';

(: language test function :)
declare function local:langTest ($in) {
let $lang := $in/@language
let $out := if ($lang) then ($lang) else ('no language given')
return $out
};



let $records := doc('../xml/PQ-and-GD-merged2.xml')//record[descendant::year/contains(., '2015')][citations/@test='yes'][proquest/school/contains(., 'Berkeley')]


return ('number,diss_name,diss_title,diss_date,diss_dept,diss_SID,diss_PQID,cit_type,cit_date,cit_lang,cit_fulltext
',

for $n in $records
    let $PQID := translate($n/proquest/PQID,' ',''), $doc2 := doc(concat('../PQdata2/files/', $PQID, '.xml'))
   
for $m in $doc2/ItemWithRef/References/ExtractedRef

return
concat(
    'NUM', ',',
    '"',$n/proquest/author/text(),'"',',',
    '"', normalize-space(translate($n/proquest/title/text(), '"', "'")),'"',',',
    $n/proquest/year/text(),',',
    '"',$n/gradDiv/major/text(),'"', ',',
    $n/gradDiv/SID/text(), ',',
    $PQID, ',',
    $m/Source/@pubType, ',',
    '"', $m/PubDate, '"', ',',
    local:langTest($m), ',',
    '"',normalize-space(translate($m/ReferenceText/text(), '"', "'")),'"
    '
    )
)