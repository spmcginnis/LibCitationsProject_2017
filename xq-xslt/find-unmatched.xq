xquery version '3.0';
(: a file to find the unmatched entries.  see also find-unmatched-GD-only.xq :)
(: updated 20161226 to include relative file paths -spm :)
declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare option output:method 'text';

let $doc := doc('../xml/PQ-and-GD-merged2.xml')
let $records := $doc//record[match='no'][contains(proquest/school, 'Berkeley') or not(proquest)]
for $n in $records/key/text()
order by $n
return ($n, '
')