xquery version '3.0';
(: A query to create a cross-tabulation for pubTypesXlanguages, with one output sheet for each department. -spm 20161228 :)

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

(: Use the command line or Oxygen to set this external variable.  History is default for testing.  :)
declare variable $dept external := 'History';

(: $PT is the current pubType for the array :)
declare function local:count-langs($refs, $PT, $lang-array) {
    let $refs := $refs[*/@pubType=$PT]

    let $lang-count :=
        for $lang in $lang-array
        let $refs := $refs[@language=$lang] 
        return count($refs)
        
    let $lang-array := 
        let $lang-count := for $n in $lang-count return string($n)
        return string-join($lang-count, ',')
        
    let $totals :=
        let $PT-total := count($refs), $lang-total := sum($lang-count)
        return ($PT-total, ',', $lang-total, ',')
        
    return ($totals, $lang-array)
};

(: set dept param here... replace with the global declaration :)
(:-----------------------------------------:)
(:let $dept := 'History':)
(:-----------------------------------------:)

let $refs := 
    let $meta := doc('../xml/PQ-and-GD-merged2.xml')//record[proquest][gradDiv/major=$dept][citations/@test='yes'][not(contains(proquest/school, 'San'))]
    for $m in $meta
    let $refs := doc(concat('../PQdata2/files/', translate($m//PQID, ' ', ''), '.xml'))//ExtractedRef
    return $refs

let $PT-array :=
    let $pubType-index := doc('../xml/pubType-index.xml')/xml/pubType
    for $PT in $pubType-index
    return data($PT)

let $lang-array :=
    let $lang-index := doc('../xml/language-index.xml')/xml/lang
    for $lang in $lang-index
    return data($lang)

let $header := ('pubType_name, total, not_english,', string-join($lang-array, ','))
return (
    $header, '&#10;',
    for $PT in $PT-array return ($PT, ',', local:count-langs($refs, $PT, $lang-array), '&#10;')
    )
