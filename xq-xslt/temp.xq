xquery version '3.0';
(: created early July 2016. :)
(: last updated 2016 Nov. 15 -spm :)
(: Note the different ways to declare the department (using variables... probably could be made into parameters, but this works fine.  see line 44.:)


(:need to eliminate carriage returns in data :)



(:  serialization   :)
declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare option output:method 'text';

(:a function to deal with authors and editors.  will output a single string.  doesn't deal well with reprints when there is a second author:)
declare function local:findAuthor($in) {
let $author := $in//AuthorPortion/text()
let $a := count($author)
let $eds := $in//Editor/Full
let $b := count($eds)
let $out := if ($a=1) then ($author)
    else if ($a=0 and $b>0) then (string-join($eds,','))
    else (string-join($author, ','))
return $out
};

(: language test function :)
declare function local:langTest ($in) {
let $lang := $in/@language
let $out := if ($lang) then ($lang) else ('NULL')
return $out
};

(: function to escape quotation marks, commas, and carriage returns in the citation entries :)
declare function local:normalize ($in) {
let $out := concat(
    '"',
    translate(normalize-space($in), '"', "'"),
    '"',
    ',') (: translates double quotes to single quotes then wraps in double quotes for csv processing. This is necessary to escape commas in titles.:)
return $out
};

(: Here a the way of declaring a dept by name, for one-off reports.   :)
(: ------------------------------------ :)
(:let $dept := 'African American Studies':)
(: ------------------------------------ :)

(: Here a the way of using a number to represent the position of the department in the dept-index :)
(: ------------------------------------ :)
let $i := 38
let $deptList := doc('../xml/dept-index.xml')
let $dept := $deptList/xml/dept[$i]/text()
(: ------------------------------------ :)


let $record := doc('../xml/PQ-and-GD-merged2.xml')/xml/record[gradDiv/major/text()=$dept][citations/@test='yes']

return count($record)