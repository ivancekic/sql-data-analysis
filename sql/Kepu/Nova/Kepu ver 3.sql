--            nUlazIzlaz := PDokument.UlazIzlaz( Slog.Vrsta_Dok, Slog.Tip_Dok, Slog.K_Robe,Slog.Datum_Dok );

--If nUlazIzlaz = 1 Then
--                  nUlaz := nUlazIzlaz * Slog.K_Robe * Slog.Faktor * Slog.Kolicina;
--                  nIzlaz := 0;
----               ElsIf Slog.K_Robe = -1 Then
--ElsIf nUlazIzlaz = -1 Then
--                  nIzlaz := nUlazIzlaz * Slog.K_Robe * Slog.Faktor * Slog.Kolicina;
--                  nUlaz := 0;
--ElsIf nUlazIzlaz = 2  And Slog.K_Robe = 1 Then
--                     nUlaz := Slog.Faktor * Slog.Kolicina;
--                     nIzlaz := 0;
--ElsIf nUlazIzlaz = 2  And Slog.K_Robe = -1 Then
--                     nIzlaz := Slog.Faktor * Slog.Kolicina;
--                     nUlaz := 0;
--ElsIf nUlazIzlaz = 2  And Slog.K_Robe = 0 Then
--                     nUlaz := Slog.Faktor * Slog.Kolicina;
--                     nIzlaz := 0;
--               End If;



Select
       org_podaci.dodatni_tip,
       d.datum_dok, d.datum_unosa, d.godina, d.broj_dok, d.tip_dok, d.vrsta_dok, d.org_deo, d.broj_dok1
     , d.ppartner, d.naziv_partnera
     , CASE WHEN D.VRSTA_DOK = 3 AND D.TIP_DOK = 10 THEN
                 '(OTPR: '||TRIM(vd_prij.za_broj_dok)||')'
            WHEN D.VRSTA_DOK = 73 THEN
                 '('||vd_prij_tr.za_broj_dok||'/'||vd_prij_tr.za_godina||')'
            WHEN D.VRSTA_DOK = 90 THEN
                 '(UZROK:'
                               ||
                               case when vd_niv_stav.za_vrsta_dok = 13 then
                                        'POVR.'
                                    WHEN vd_niv_stav.za_VRSTA_dok = 12 then
                                        'STOR.'
                                    ELSE
                                         ' '
                               END

                  ||vd_niv_stav_mag||'-'||vd_niv_stav_brd1||'/'||SUBSTR(vd_niv_stav.za_godina,3,2)||')'
            WHEN D.VRSTA_DOK = 13 THEN
                 '(RN-OT:'||vd_pov_otp_mag||'-'||vd_pov_otp_brd1||'/'||SUBSTR(vd_pov_otp.za_godina,3,2)||')'
            WHEN D.VRSTA_DOK = 5 THEN
                 '(PRIJ:'||vd_pov_prij_mag||'-'||vd_pov_prij_brd1||'/'||SUBSTR(vd_pov_prij.za_godina,3,2)||')'
       ELSE
                 NULL
       END																										PO_DOKUMENTU
From
(

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

--           and orgd.id     = org_podaci.org_deo
--and d.vrsta_Dok = '85'
Group by

         d.datum_dok, d.datum_unosa, d.godina, d.broj_dok, d.tip_dok, d.vrsta_dok, d.org_deo, d.broj_dok1, d.ppartner
       , pp.naziv

) d

, (Select vd.*
   From vezni_dok vd
   Where (vd.broj_dok,vd.vrsta_Dok,vd.godina) in
         (Select d1.broj_dok,d1.vrsta_Dok,d1.godina From dokument d1
          Where d1.broj_dok !='0'
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
            and d1.godina != 0
            and d1.org_deo = &vZa_Magacin
            and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
            and D1.STATUS > 0
            and vrsta_dok = '73'
         )
     and za_vrsta_dok = '24'
  ) vd_prij_tr

, (Select vd.broj_dok, vd.vrsta_Dok, vd.godina, vd.za_broj_dok, vd.za_vrsta_Dok, vd.za_godina
        , d2.org_deo vd_niv_stav_mag, d2.broj_dok1 vd_niv_stav_brd1
   From vezni_dok vd, dokument d2
   Where d2.broj_dok !='0'
     and d2.godina != 0
     and d2.org_deo = &vZa_Magacin
     and d2.datum_dok between  &DatumPocetnogStanja and &dDatumDo
     and d2.STATUS > 0
     and vd.vrsta_dok = '90'
     and d2.godina = vd.za_godina (+) and d2.vrsta_dok = vd.za_vrsta_dok (+) and d2.broj_dok = vd.za_broj_dok (+)
  ) vd_niv_stav

, (Select vd.broj_dok, vd.vrsta_Dok, vd.godina, vd.za_broj_dok, vd.za_vrsta_Dok, vd.za_godina
        , d2.org_deo vd_pov_otp_mag, d2.broj_dok1 vd_pov_otp_brd1
   From dokument d1, vezni_dok vd, dokument d2
   Where d1.broj_dok !='0'
     and d1.godina != 0
     and d1.org_deo = &vZa_Magacin
     and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
     and d1.STATUS > 0
     and d1.vrsta_dok = '13'
     and vd.za_vrsta_dok = '11'
     and d1.godina = vd.godina and d1.vrsta_dok = vd.vrsta_dok and d1.broj_dok = vd.broj_dok
     and d2.godina = vd.za_godina (+) and d2.vrsta_dok = vd.za_vrsta_dok (+) and d2.broj_dok = vd.za_broj_dok (+)
  ) vd_pov_otp

, (Select vd.broj_dok, vd.vrsta_Dok, vd.godina, vd.za_broj_dok, vd.za_vrsta_Dok, vd.za_godina
        , d2.org_deo vd_pov_prij_mag, d2.broj_dok1 vd_pov_prij_brd1
   From dokument d1, vezni_dok vd, dokument d2
   Where d1.broj_dok !='0'
     and d1.godina != 0
     and d1.org_deo = &vZa_Magacin
     and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
     and d1.STATUS > 0
     and d1.vrsta_dok = '5'
     and vd.za_vrsta_dok = '3'
     and d1.godina = vd.godina and d1.vrsta_dok = vd.vrsta_dok and d1.broj_dok = vd.broj_dok
     and d2.godina = vd.za_godina (+) and d2.vrsta_dok = vd.za_vrsta_dok (+) and d2.broj_dok = vd.za_broj_dok (+)
  ) vd_pov_prij

, org_deo_osn_podaci org_podaci
Where d.godina = vd_prij.godina (+) and d.vrsta_dok = vd_prij.vrsta_dok (+) and d.broj_dok = vd_prij.broj_dok (+)
  and d.godina = vd_prij_tr.godina (+) and d.vrsta_dok = vd_prij_tr.vrsta_dok (+) and d.broj_dok = vd_prij_tr.broj_dok (+)
  and d.godina = vd_niv_stav.godina (+) and d.vrsta_dok = vd_niv_stav.vrsta_dok (+) and d.broj_dok = vd_niv_stav.broj_dok (+)
  and d.godina = vd_pov_otp.godina (+) and d.vrsta_dok = vd_pov_otp.vrsta_dok (+) and d.broj_dok = vd_pov_otp.broj_dok (+)
  and d.godina = vd_pov_prij.godina (+) and d.vrsta_dok = vd_pov_prij.vrsta_dok (+) and d.broj_dok = vd_pov_prij.broj_dok (+)
--and d.vrsta_Dok = '90'
  and org_podaci.org_deo=d.org_deo
order by d.org_deo,d.datum_dok,d.datum_unosa

