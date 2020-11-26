xquery version '3.0';
(: USAGE: This query has to follow add-pubtype-to-dept-lang-xtab.xq, using the output of that query as the $data file path. The best way to do this is probably to chain two saxon commands in bash, which would require passing a parameter in to this file.. :)
(: updated 20161226 to include relative file paths -spm :)

(: generates a xtab report.  created 20161127 -spm :)
(: for some reason, saving the output mucks it up, but it shows up fine in the preview pane, and can be saved from there. :)
(: also note, the pubtype numbers and the lang numbers don't add up.  I think there were some langs that I missed, perhaps because they had an @language attribute but no value.  This is a small number though.  :)

declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare option output:method 'text';

declare function local:round-off ($input) {
    let $output := number(floor($input *100)) div 100
    return $output
};

let $depts := doc('../xml/dept-index.xml')
let $pubtypes := doc('../xml/pubType-index.xml')
let $data := doc('../xml/dept-lang-formats-xtab-20161127.xml')

let $header := for $n in $pubtypes/xml/pubType return concat($n, ',', $n, '_PERCENT', ',') 

return (
concat('DEPT,','TOTAL_DISS,', 'TOTAL_CITE,', string-join($header),'
'),
    for $n in $data/xml/record
    let $dept := $n/dept/text()
    let $total_diss := $n/count/text()
    let $pubcount := sum($n/pubtypes/pubtype/data(@count))
    let $values :=
        for $m in $pubtypes/xml/pubType
        let $value := $n/pubtypes/pubtype[@id=$m]/@count
        return (string($value), string(local:round-off($value div $pubcount * 100)))
    return
concat(
    '"', $dept, '",',
    $total_diss, ',',
    $pubcount, ',',
    string-join($values, ', '),'
'
    )
)