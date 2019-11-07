Select sd.Proizvod pro, D.Tip_Dok tip_d, to_char(DATUM_DOK,'dd.mm.yy') Datum_dok,
       SD.Vrsta_Dok vrd, SD.Broj_Dok brd, sd.Kolicina, SD.cena, SD.Cena1
       , sd.K_Robe * sd.Faktor * sd.Realizovano stanje
       ,(case when nvl(lag (sd.proizvod,1) over (ORDER BY sd.proizvod, Datum_Unosa, Datum_dok),'xxxxxxx') <> proizvod then
                      0
         else
              nvl(lag(
                      (case when d.vrsta_Dok = 80 then
                            sd.kolicina*sd.faktor
                       else
                         sd.kolicina*sd.faktor*sd.k_robe
       	            end
                    )
                   ,1) over (ORDER BY To_Number( Proizvod ) , Datum_Unosa, Datum_dok),0)
            end
          ) preth_stanje

       , PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) k_r_UI
       , (case when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 1 then
                    PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) * sd.K_Robe * sd.Faktor * sd.Kolicina
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = -1 Then
                    0
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = 1 Then
                    sd.Faktor * sd.Kolicina
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = -1 Then
                    sd.Faktor * sd.Kolicina
               when PDokument.UlazIzlaz( Sd.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) = 2  And sd.K_Robe = 0 Then
                    sd.Faktor * sd.Kolicina
          end
         ) dug2
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
         ) pot2
       , nvl(lag (sd.proizvod,1) over (ORDER BY sd.proizvod, Datum_Unosa, Datum_dok),sd.proizvod) AS pro_pre
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
Order By  To_Number( Pro ), Datum_Unosa, Datum_dok
