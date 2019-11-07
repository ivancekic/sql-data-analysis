
SELECT d.tip_dok,d.org_deo,d.poslovnica,
       vd.broj_dok , vd.vrsta_dok , vd.godina , vd.za_broj_dok, vd.za_vrsta_dok , vd.za_godina
,       VD1.ZA_VRSTA_DOK ,VD1.ZA_BROJ_dOK
FROM dokument d , VEZNI_DOK vd , VEZNI_DOK vd1 , dokument d1
WHERE
 --vd.VRSTA_DOK in ( 3 , 4 , 5 , 30 )
--  AND vd.ZA_VRSTA_DOK in ( 3 , 4 , 5 , 30 , 24 )
  --and
  vd.za_vrsta_dok not in (41)
  and vd1.za_vrsta_dok not in (41)
--  and ( d.vrsta_dok ||','||d.tip_dok )
--                          in
--                          -- interne prijemnice i sve vezano za njih
--                          (
--                            select ('3,12') from dual
--                            union
--                            select ('4,12') from dual
--                          )
--

  --  veza tabela
  and vd.godina    = d.godina
  and vd.vrsta_dok = d.vrsta_dok
  and vd.broj_dok  = d.broj_dok
  and vd.za_godina    = vd1.godina
  and DECODE(vd.za_vrsta_dok,24,11,11) = vd1.vrsta_dok
  and vd.za_broj_dok  = vd1.broj_dok

  and vd1.godina    = d1.godina
  and vd1.vrsta_dok = d1.vrsta_dok
  and vd1.broj_dok  = d1.broj_dok

  and d.org_deo = 169
order by d.tip_dok , TO_NUMBER(BROJ_DOK)
