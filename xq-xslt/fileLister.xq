xquery version '3.0';
(: genarate an xml list of proquest files by PQID :)
(: updated 20161226 to include relative file paths -spm :)
let $files := collection('../PQdata2/files')
return <xml>
{for $x in $files return <PQID>{substring-before(substring-after(base-uri($x), 'files/'), '.xml')}</PQID>}
</xml>