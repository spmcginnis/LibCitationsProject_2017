xquery version '3.0';

declare variable $doc := doc('unmatchedPQ.xml');
declare variable $index := doc('key-index-unmatched.xml');

declare function local:key($n) {
    let $old := string($n/key)
    let $key := $index/xml/record[old=$old]/new
    return <key>{string($key)}</key>
};

let $records := $doc/xml/record
return
<xml>{
for $n in $records
return 
    <record>
        {local:key($n),
        $n/match,
        $n/proquest,
        $n/gradDiv,
        $n/citations}
    </record>
}</xml>