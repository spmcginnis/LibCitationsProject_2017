xquery version '3.0';

declare variable $PQ := doc('unmatchedPQ-newkeys.xml');
declare variable $GD := doc('unmatchedGD-newkeys.xml');

declare function local:match-test($n, $compared) {
    let $list := string-join($compared/key)
    return if (contains($list, string($n/key)))
    then 'yes' else 'no'
};

declare function local:merge($n, $recGD) {
    let $key2 := string($n/key)
    let $GDmatch := $recGD[contains(key, $key2)]
    return
    <record>
        <key>{$key2}</key>
        <match>yes</match>
        {$n/proquest, $GDmatch/gradDiv, $n/citations}
    </record>
};

let $recPQ := $PQ/xml/record, $recGD := $GD/xml/record

return <xml>
{
let $PQ1 := for $n in $recPQ where local:match-test($n, $recGD)='no' return $n
return $PQ1,
let $PQ2 := for $n in $recPQ where local:match-test($n, $recGD)='yes' return $n
for $n in $PQ2 return local:merge($n, $recGD)

(:for $n in $recPQ return
if (local:match-test($n, $recGD)='yes') then (local:merge($n, $recGD))
else $n
:)
(:,

for $n in $recGD:)
}
</xml>