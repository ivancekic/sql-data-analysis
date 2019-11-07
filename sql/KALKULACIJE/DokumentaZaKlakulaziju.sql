SELECT d.godina , d.vrsta_dok , d.broj_dok , d.org_Deo , od.DODATNI_TIP , d.broj_dok1 , D.USER_ID ,
       vd.za_godina , vd.za_vrsta_dok , vd.za_broj_dok
FROM dokument d , org_deo_osn_podaci od , vezni_dok vd
WHERE d.godina = 2008  and d.vrsta_dok = 3  And d.tip_dok = 10  And d.broj_Dok1 > 0 And Status = 1
--  and od.DODATNI_TIP <> 'VP'
  and d.org_deo = od.org_Deo
  and vd.godina    (+)= d.godina  and vd.vrsta_dok (+)= d.vrsta_dok  and vd.broj_dok  (+)= d.broj_dok
  and vd.za_vrsta_dok not in (2,3,4,10,24,11,63)
--  and (d.godina , d.vrsta_dok , d.broj_dok) in (Select vd.godina , vd.vrsta_dok , vd.broj_dok
--                                                From Vezni_dok Vd
--                                                Where --vd.vrsta_dok = 3 and
--                                                vd.za_vrsta_dok not in (2,85,86)
--                                               )
order by to_number (d.broj_dok )
