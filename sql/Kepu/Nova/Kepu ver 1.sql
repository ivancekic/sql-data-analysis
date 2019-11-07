--select distinct vrsta_Dok, tip_dok
--from
--(

Select

         d.datum_dok, d.datum_unosa, d.godina, d.broj_dok, d.tip_dok, d.vrsta_dok, d.org_deo, d.broj_dok1, d.ppartner


from dokument d
--   , poslovni_partner pp
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

--   , (Select vd.*
--      From vezni_dok vd
--      Where (vd.broj_dok,vd.vrsta_Dok,vd.godina) in
--            (Select d1.broj_dok,d1.vrsta_Dok,d1.godina From dokument d1
--             Where d1.broj_dok !='0'
--               and d1.vrsta_dok not in (2,9,10,61,62,63,64)
--               and d1.godina != 0
--               and d1.org_deo = &vZa_Magacin
--               and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
--               and D1.STATUS > 0
--            )
--
--     ) sd
where          d.broj_dok <> '0'
           and d.vrsta_dok not in (2,9,10,61,62,63,64)
           and d.godina != 0
--           and orgd.id     = org_podaci.org_deo
--           and p.tip_proizvoda not in (8)
           and d.org_deo   = &vZa_Magacin
           and d.datum_dok between  &DatumPocetnogStanja and &dDatumDo
           and d.status > 0
--           and pp.sifra = d.ppartner (+)
           and d.godina = sd.godina (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.broj_dok = sd.broj_dok (+)

           and (sd.k_robe <>0 or d.vrsta_Dok  in( 80, 90 ) )
--           and orgd.id     = org_podaci.org_deo
--and d.vrsta_Dok = '85'
Group by

         d.datum_dok, d.datum_unosa, d.godina, d.broj_dok, d.tip_dok, d.vrsta_dok, d.org_deo, d.broj_dok1, d.ppartner
--       , nvl(pp.naziv,'xyz')
order by d.org_deo,d.datum_dok,d.datum_unosa
--)
