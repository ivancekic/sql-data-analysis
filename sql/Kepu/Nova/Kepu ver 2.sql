--select distinct vrsta_Dok, tip_dok
--from
--(

Select

          d.datum_dok, d.datum_unosa, d.godina, d.broj_dok, d.tip_dok, d.vrsta_dok, d.org_deo, d.broj_dok1, d.ppartner
,
               case when d.vrsta_dok = (11) and d.tip_dok in (23,238) then
                         'Int.Otprema'
                    when d.vrsta_dok = (3) and d.tip_dok in (115) then
                         'Int.Prijem'
                    when d.vrsta_dok in (70) then
                         'Medjuskl.Izl'
                    when d.vrsta_dok in (71) then
                         'Medjuskl.Ul'
                    when d.vrsta_dok = (12) and d.tip_dok = 23 then
                         'STORNO INT.OTPR.'
                    when d.vrsta_dok in (21) then
                         'POCETNO STANJE'
                    when d.vrsta_dok in (90) then
                         'NIVEL.'
                    when d.vrsta_dok not in (80) then
                         SUBSTR(pp.naziv,1,19)
                    else
                         'NIVELACIJA'
               end naziv_partnera
         , CASE WHEN D.VRSTA_DOK = 3 AND D.TIP_DOK = 10 THEN
                     ' (OTPR: '||TRIM(vd_prij.za_broj_dok)||')'
                WHEN D.VRSTA_DOK = 73 THEN
                     ' ('||vd_prij_tr.za_broj_dok||'/'||vd_prij_tr.za_godina||')'

--                    WHEN D.VRSTA_DOK = 90 THEN
--                         (select '(UZROK:'
--                                   ||
--                                   case when dp.vrsta_dok = 13 then
--                                            'POVR.'
--                                        WHEN DP.VRSTA_dok = 12 then
--                                            'STOR.'
--                                        ELSE
--                                             ' '
--                                   END
--                                   ||dp.org_deo||'-'||dp.broj_dok1||'/'||SUBSTR(za_godina,3,2)||')'
--                            from vezni_dok VDP, DOKUMENT DP
--
--                           where VDP.vrsta_dok    = d.vrsta_dok
--                             and VDP.broj_dok     = d.broj_dok
--                             and VDP.godina       = d.godina
--                             AND VDP.ZA_vrsta_dok = dp.vrsta_dok
--                             and vdp.za_godina    = dp.godina
--                             and vdp.za_broj_dok  = dp.broj_dok)
--                    WHEN D.VRSTA_DOK = 13 THEN
--                         (
--                            select
--                                   '(RN-OT:'||DX.ORG_DEO||'-'||DX.BROJ_DOK1||'/'||SUBSTR(DX.GODINA,3,2)||')'
--                              from vezni_dok VDX, DOKUMENT DX
--                             where VDX.ZA_VRSTA_DOK = DX.VRSTA_DOK
--                               AND VDX.ZA_BROJ_DOK  = DX.BROJ_DOK
--                               AND VDX.ZA_GODINA    = DX.GODINA
--                               AND VDX.vrsta_dok    = d.vrsta_dok
--                               and VDX.broj_dok     = d.broj_dok
--                               and VDX.godina       = d.godina
--                              and za_vrsta_dok = '11'
--                         )
                    ELSE

                    NULL
               END
               po_dokumentu

--       ,  pp.naziv
from dokument d
   , poslovni_partner pp
   , (Select sd.*, p.tip_proizvoda
      From stavka_dok sd, proizvod p
      Where (sd.broj_dok,sd.vrsta_Dok,sd.godina) in
            (Select d1.broj_dok,d1.vrsta_Dok,d1.godina From dokument d1
             Where d1.broj_dok !='0'
               and d1.vrsta_dok not in (2,9,10,61,62,63,64)
               and d1.godina != 0
               and d1.org_deo = &vZa_Magacin
               and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
               and D1.STATUS > 0
            )
        and p.sifra=sd.proizvod(+)
        and p.tip_proizvoda not in (8)

     ) sd

   , (Select vd.*
      From vezni_dok vd
      Where (vd.broj_dok,vd.vrsta_Dok,vd.godina) in
            (Select d1.broj_dok,d1.vrsta_Dok,d1.godina From dokument d1
             Where d1.broj_dok !='0'
--               and d1.vrsta_dok not in (2,9,10,61,62,63,64)
               and d1.godina != 0
               and d1.org_deo = &vZa_Magacin
               and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
               and D1.STATUS > 0
               and vrsta_dok = '3'
            )
        and za_vrsta_dok = '24'
     ) vd_prij
   , (Select vd.*
      From vezni_dok vd
      Where (vd.broj_dok,vd.vrsta_Dok,vd.godina) in
            (Select d1.broj_dok,d1.vrsta_Dok,d1.godina From dokument d1
             Where d1.broj_dok !='0'
--               and d1.vrsta_dok not in (2,9,10,61,62,63,64)
               and d1.godina != 0
               and d1.org_deo = &vZa_Magacin
               and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
               and D1.STATUS > 0
               and vrsta_dok = '73'
            )
        and za_vrsta_dok = '24'
     ) vd_prij_tr

where          d.broj_dok <> '0'
           and d.vrsta_dok not in (2,9,10,61,62,63,64)
           and d.godina != 0
--           and orgd.id     = org_podaci.org_deo
--           and p.tip_proizvoda not in (8)
           and d.org_deo   = &vZa_Magacin
           and d.datum_dok between  &DatumPocetnogStanja and &dDatumDo
           and d.status > 0
           and d.ppartner = pp.sifra (+)
           and d.godina = sd.godina (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.broj_dok = sd.broj_dok (+)

           and (sd.k_robe <>0 or d.vrsta_Dok  in( 80, 90 ) )

           and d.godina = vd_prij.godina (+) and d.vrsta_dok = vd_prij.vrsta_dok (+) and d.broj_dok = vd_prij.broj_dok (+)
           and d.godina = vd_prij_tr.godina (+) and d.vrsta_dok = vd_prij_tr.vrsta_dok (+) and d.broj_dok = vd_prij_tr.broj_dok (+)
--           and orgd.id     = org_podaci.org_deo
--and d.vrsta_Dok = '85'
Group by

         d.datum_dok, d.datum_unosa, d.godina, d.broj_dok, d.tip_dok, d.vrsta_dok, d.org_deo, d.broj_dok1, d.ppartner
       , pp.naziv, vd_prij.za_broj_dok
       , vd_prij_tr.za_broj_dok, vd_prij_tr.za_godina
--       , vd_prij_tr.za_broj_dok||'/'||vd_prij_tr.za_godina
order by d.org_deo,d.datum_dok,d.datum_unosa
--)
