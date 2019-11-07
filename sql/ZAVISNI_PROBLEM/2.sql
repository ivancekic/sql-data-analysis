update ZAVISNI_TROSKOVI
set status = 0
WHERE BROJ_DOK   = 6418 AND  VRSTA_DOK = 3 AND  GODINA = 2009
/
update dokument
set status = -8
WHERE BROJ_DOK   = 6418 AND  VRSTA_DOK = 3 AND  GODINA = 2009
/
commit
