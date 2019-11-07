SELECT   d.rowid,
D.*
From
 dokument  d
WHERE org_deo between 113 and 118
and d.vrsta_dok='21'
order by org_deo, datum_dok, datum_unosa
