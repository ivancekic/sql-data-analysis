SELECT
--------rpad(SrediNazivDok(pvrstadok.naziv(d.vrsta_dok),
--------              pnacinfakt.naziv(d.tip_dok),
--------              3,
--------              8,
--------              1,
--------              5,
--------              '(',
--------              ')'),
--------              20,' '),
----       d.rowid , --d.* , pposlovnipartner.naziv(d.ppartner)--max (to_number(broj_dok1))--d.ROWID ,
       d.rowid,d.* --spec_rabat , VRSTA_DOK , BROJ_DOK , org_deo , broj_dok1 ,DATUM_DOK , mesto_Isporuke, poslovnica
--MAX(TO_NUMBER(D.BROJ_DOK1))
FROM dokument  d
--update dokument
--set datum_dok = to_date('03.09.2007','dd.mm.yyyy')
WHERE d.godina = 2008  and d.vrsta_dok  IN (3) and tip_dok = 10 and broj_dok1 > 0 and status = 1
--  and org_deo in (select org_deo from org_deo_osn_podaci)
--And d.broJ_dok in (389)
--AND D.DATUM_VALUTE IS NULL
--AND ORG_DEO = 160
--and to_char(datum_unosa, >

--and tip_dok = 103
--and status = 0
--and datum_dok > to_date('18.11.2007','dd.mm.yyyy')

--order by to_number(broj_dok1)

--union
--
--SELECT --D.BROJ_DOK
--       d.rowid , --d.* , pposlovnipartner.naziv(d.ppartner)--max (to_number(broj_dok1))--d.ROWID ,
--       d.* --spec_rabat , VRSTA_DOK , BROJ_DOK , org_deo , broj_dok1 ,DATUM_DOK , mesto_Isporuke, poslovnica
--FROM DOKUMENT  d
--WHERE d.GODINA       = 2007
--  AND d.VRSTA_DOK    = 11
--  And d.broj_dok     in ( 18360 )
----  AND  d.broj_dok1     in (351,352,354,355,357)
----  and  d.org_deo = 445
--
----order by to_number(broj_dok1)
order by to_number (d.broj_dok )
--                                                26.01.2008 19:16:55
--                                                11.02.2008 16:17:21 PS

-- za proizvod 4928 :  176.85921348314606741573033707865
-- za proizvod 4929 :  156.83375218150087260034904013962
-- za proizvod 4930 :  121.66043195063421323277339732602
-- za proizvod 4931 :  121.66043195063421323277339732602
