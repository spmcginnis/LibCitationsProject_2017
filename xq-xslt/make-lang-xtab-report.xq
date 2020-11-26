xquery version '3.0';
(: USAGE: This query has to follow make-lang-xtab.xq, using the output of that query as the $langData file path. The best way to do this is probably to chain two saxon commands in bash, which would require passing a parameter in to this file.. :)
(: updated 20161226 to include relative file paths -spm :)

declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare option output:method 'text';
declare option output:item-separator "&#xa;";

declare function local:round-off ($input) {
    let $output := number(floor($input *100)) div 100
    return $output
};

let $depts := doc('../xml/dept-index.xml'),
    $langs := doc('../xml/language-index.xml'),
    $langData := doc('../xml/lang-xtab-20161014.xml')

let $header := string-join($langs/xml/lang/text(), ', ')

return (

    concat('DEPT, ', 'TOTAL_DISS, ', 'TOTAL_CITE,', 'NULL,', 'NULL_PERC,', 'NOT_NULL,', 'NOT_NULL_PERCENT,', $header,'
'),

    for $n in $langData/xml/record
    let $dept := $n/dept/text()
    let $dissCount := $n/count/text()
    let $citeCount := sum($n/languages/lang/data(@count))
    let $nullCount := $n/languages/lang[@id="NULL"]/data(@count)
    let $nullPerc :=  $nullCount div $citeCount * 100
    let $notNull := sum($n/languages/lang[not(@id="NULL")]/data(@count))
    let $notNullPerc := $notNull div $citeCount * 100
    
    let $langCounts := 
        for $m in $langs/xml/lang 
        let $count := $n/languages/lang[@id=$m]/data(@count)
        return $count
    return 
    
    concat(
    '"', $dept, '",', 
    $dissCount, ',',
    $citeCount, ',',
    $nullCount, ',',
    local:round-off($nullPerc), ',',
    $notNull, ',',
    local:round-off($notNullPerc), ',',
    string-join($langCounts, ','),'
'
    )
    
    )