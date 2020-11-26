xquery version '3.0';
(: a file to find unmatched Grad Div dissertations.  See also find-unmatched.xq  :)
(: updated 20161226 to include relative file paths -spm :)

declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare option output:method 'text';

let $doc := doc('../xml/PQ-and-GD-merged2.xml')
let $records := $doc//record[match='no'][not(proquest)]
return 
(
    'SID, LAST_NAME, FIRST_NAME, MIDDLE_NAME, TITLE, MAJOR, DATE, KEY
    ',
    for $n in $records
    let $n2 := $n/gradDiv
    return 
        concat(
            $n2/SID/text(), ',',
            '"', $n2/lastName/text(), '",',
            '"',$n2/firstName/text(), '",',
            '"',$n2/middleName/text(), '",',
            '"',normalize-space(translate($n2/title/text(), '"', "'")), '",',
            '"',$n2/major/text(), '",',
            '"',$n2/date/text(), '",',
            $n/key/text(), '
            '
            )
)