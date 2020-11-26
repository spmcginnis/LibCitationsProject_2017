xquery version '3.0';
(: creates a file to help find unmatched entries :)
(: updated 20161226 to include relative file paths -spm :)

declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare option output:method 'text';


declare variable $doc := doc('../xml/PQ-and-GD-merged2.xml');
declare variable $records := $doc//record[contains(proquest/school, 'Berkeley') or not(proquest)];

let $header := 'KEY,MATCH_Y/N
'
return $header,

for $n in $records
order by $n/key/text()
return concat($n/key/text(), ',', $n/match, '
')