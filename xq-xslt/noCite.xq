xquery version '3.0';

(: an xquery to generate a list of files for which we have the PQID but no corresponding citations.  n.b. it seems to work differently when the transformation scenario is set to prompt for output.  I'm not sure why.:)
(: updated 20161226 to include relative file paths -spm :)

declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare option output:method 'text';

let $doc := doc('../xml/PQ-and-GD-merged2.xml')
let $rec := $doc/xml/record[proquest and citations/@test="no"]
return (
    concat('Proquest ID,', 'Author,', 'Title,', 'Year
'),
    for $each in $rec order by $each/proquest/PQID return concat($each/proquest/PQID, ',', concat('"',$each/proquest/author, '"'), ',', concat('"', translate(normalize-space($each/proquest/title), '"', "'"), '"'), ',', $each/proquest/year,'
')
    )