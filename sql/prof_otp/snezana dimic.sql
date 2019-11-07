SELECT
D.*

FROM


VEZNI_DOK vd
,
dokument  d
WHERE vd.godina = 2013
and (
         ( vd.VRSTA_DOK = '9' )
     )
and vd.za_vrsta_dok='11'
order by to_Number(vd.za_broj_dok)

