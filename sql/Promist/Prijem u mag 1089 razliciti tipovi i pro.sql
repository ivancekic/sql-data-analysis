SELECT
       distinct tip_dok, nf.naziv tip_naz
     , sd.proizvod  pro
     , p.tip_proizvoda  tip_pro
     , tp.cena tip_pro_cena
     , case
       when tp.cena = 1 then
           'prosecna-zad nab'
       when tp.cena = 2 then
           'planska'
       when tp.cena = 3 then
           'zad prod'
       end tip_pro_cena_naz

FROM stavka_Dok sd, dokument d
   , proizvod p
   , tip_proizvoda tp
   , nacin_fakt nf
WHERE d.GODINA = 2013
  and sd.k_robe <> 0

  and d.org_Deo=1089

  and d.status > 0
  and sd.godina = d.godina
  and sd.vrsta_Dok = d.vrsta_Dok
  and sd.broj_dok = d.broj_dok

  AND D.VRSTA_DOK IN ('3')

--  AND round(sd.cena * Pkurs.KursNaDan(sd.Valuta, d.datum_dok, 'S'),4) <> round(sd.cena1*sd.faktor,4)
--  AND SD.CENA1 <> PProdajniCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  )
   and p.sifra = sd.proizvod
   and tp.sifra = p.tip_proizvoda

   and nf.tip=d.tip_dok
order by to_number(proizvod)
