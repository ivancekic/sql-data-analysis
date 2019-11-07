
SELECT d.tip_dok,d.org_deo,d.poslovnica, vd.broj_dok , vd.vrsta_dok , vd.godina , vd.za_broj_dok, vd.za_vrsta_dok , vd.za_godina
FROM dokument d , VEZNI_DOK vd -- , VEZNI_DOK vd1
WHERE vd.VRSTA_DOK in ( 3 )
  AND vd.ZA_VRSTA_DOK in ( 3,4,5,30,24)
--  and (d.vrsta_dok ||','||d.tip_dok) in (select '3,12' from dual) -- interne otpremnice

  --  veza tabela
  and vd.godina    = d.godina
  and decode(vd.vrsta_dok,
             24,11,
             11) = d.vrsta_dok
  and vd.broj_dok  = d.broj_dok

--  and vd1.za_godina    = vd1.godina
--  and vd1.za_vrsta_dok = vd1.vrsta_dok
--  and vd1.za_broj_dok  = vd1.broj_dok
