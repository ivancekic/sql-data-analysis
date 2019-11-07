         Select t.PPartner, t.Proizvod, t.Datum_Dok, t.DATUM_UNOSA
              , t.Vrsta_Dok vrd , t.Godina, t.Broj_Dok

, ZA_BROJ_DOK n_brd
--, ZA_VRSTA_DOK
, ZA_GODINA n_god
, (select datum_unosa from dokument
   where godina = ZA_GODINA and vrsta_dok = za_vrsta_dok and broj_dok=za_broj_dok
  ) n_dat_un

              , t.K_Robe, t.Kol Kolicina, t.Faktor
              , t.Kontrola, t.Realizovano, t.Kolicina_Kontrolna
              , t.Cena1,
                t.Tip_Dok, t.cena, t.Broj_Dok1

         From TUDJAROBALAGER t
            , (select * from vezni_dok where vrsta_dok='11' and za_vrsta_dOk='10') vd

         Where --Org_Deo = nSifraMag
               Org_Deo in (select org_deo from org_deo_osn_podaci where mag_tudje_robe = 1376 and org_Deo = mag_tudje_robe)
           and ppartner = '1991'
--           And Datum_Dok Between dOdDat and dDoDat
           And Proizvod = '71632'
--and Kol <> realizovano
           and t.godina = vd.godina (+) and t.vrsta_dok = vd.vrsta_dok (+) and t.broj_dok = vd.broj_dok (+)
         Order By to_number(t.ppartner), To_Number( t.Proizvod ), t.Datum_Dok, t.Datum_Unosa;
