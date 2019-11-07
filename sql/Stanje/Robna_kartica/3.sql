--select PRO, TIP_D, DATUM_DOK, VRD, BRD, ULAZ, IZLAZ, STANJE, dug, pot
--	     , CENA1, ODGOV
--	     ,preth_stanje
----      KOLICINA, CENA, CENA1, ODGOV, DATUM_UNOSA
----     ,
--From
--(
Select sd.Proizvod pro, D.Tip_Dok tip_d, to_char(DATUM_DOK,'dd.mm.yy') Datum_dok,
       SD.Vrsta_Dok vrd, SD.Broj_Dok brd

       , (case when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 1 then
                    PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) * sd.K_Robe * sd.Faktor * sd.Kolicina
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = -1 Then
                    0
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = 1 Then
                    sd.Faktor * sd.Kolicina
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = -1 Then
                    sd.Faktor * sd.Kolicina
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = 0 Then
                    0
          end
         ) ulaz
       , (case when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 1 then
                    0
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = -1 Then
                    PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) * sd.K_Robe * sd.Faktor * sd.Kolicina
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = 1 Then
                    0
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = -1 Then
                    0
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = 0 Then
                    0
          end
         ) izlaz

       , sd.K_Robe * sd.Faktor * sd.Realizovano stanje

       , (case when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 1 then
                    PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) * sd.K_Robe * sd.Faktor * sd.Kolicina * sd.cena1
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = -1 Then
                    0
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = 1 Then
                    sd.Faktor * sd.Kolicina * sd.cena1
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = -1 Then
                    sd.Faktor * sd.Kolicina * sd.cena1
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = 0 Then
                    sd.Faktor * sd.Kolicina * (sd.cena1 - sd.cena)
          end
         ) dug
       , (case when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 1 then
                    0
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = -1 Then
                    PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) * sd.K_Robe * sd.Faktor * sd.Kolicina * sd.cena1
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = 1 Then
                    0
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = -1 Then
                    0
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = 0 Then
                    0
          end
         ) pot

       ,(case when nvl(lag (proizvod,1) over (ORDER BY proizvod, Datum_Unosa, Datum_dok),'xxxxxxx') <> proizvod then
                      0
         else
              null
         end
         ) preth_stanje

       , sd.Kolicina, SD.cena, SD.Cena1
--       , PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) k_r_UI

       , OdgovarajucaCena(D.Org_deo , Sd.proizvod , sysdate, sd.faktor, sd.valuta,0) odgov
       , datum_unosa
From dokument d, stavka_dok sd
Where sd.godina (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok (+)= d.broj_dok
 -----------------------------
  -- ostali uslovi
  and d.godina = 2009 and d.org_deo = 103 AND (K_ROBE <> 0 OR D.VRSTA_DOK = 80) And D.Status > 0 and sd.proizvod in ( 1612 )
  And D.Datum_Dok Between (SELECT MAX(d1.DATUM_DOK)
                           From stavka_dok sd1, dokument d1
                           Where sd1.godina (+)= d1.godina and sd1.vrsta_dok (+)= d1.vrsta_dok and sd1.broj_dok (+)= d1.broj_dok
                             and d1.godina = d.GODINA and d1.org_deo = d1.org_deo and d1.vrsta_Dok = 21 and sd1.proizvod = sd.proizvod
                          )
                          And SYSDATE
--)
Order By  To_Number( PRO ), Datum_Unosa, Datum_dok
