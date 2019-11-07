select
----PROIZVOD, TIP_DOK, DATUM, VRSTA_DOK, BROJ_DOK, KOLICINA, CENA, CENA1, FAKTOR, K_ROBE
----     , STANJE, DUG, POT, PRETH_STANJE, PRO_PRE, ODGOV
----     , datum_unosa
--
     TIP_D, Datum_dok, VRD, BRD, KOLICINA, CENA, CENA1, FAK, K_R
     , stanje, preth_stanje
     , ( case when PRO_PRE <> pro then 0 else (case when vrd = 80 then stanje else stanje + preth_stanje  end) end)stanje1

     , ( case when PRO_PRE <> pro then 0 else dug end) dug1
     , ( case when PRO_PRE <> pro then 0 else pot end) pot1
from
(
	Select d.rowid,
	       sd.Proizvod pro, D.Tip_Dok tip_d,DATUM_DOK Datum_dok,
	       SD.Vrsta_Dok vrd, SD.Broj_Dok brd, sd.Kolicina, SD.cena, SD.Cena1, sd.Faktor fak, K_Robe k_r

	       , (case when d.vrsta_Dok = 80 then
                   sd.kolicina*sd.faktor
              else
	               sd.kolicina*sd.faktor*sd.k_robe
	          end
	          ) stanje
           ,(case when nvl(lag (sd.proizvod,1) over (ORDER BY sd.proizvod, Datum_Dok, Datum_Unosa),'xxxxxxx') <> proizvod then
                       0
             else
               nvl(lag(
                       (case when d.vrsta_Dok = 80 then
                             sd.kolicina*sd.faktor
                        else
	                         sd.kolicina*sd.faktor*sd.k_robe
        	            end
	                    )
	                   ,1) over (ORDER BY To_Number( Proizvod ) , Datum_Dok, Datum_Unosa),0)
             end
           ) preth_stanje

	       , (case when sd.k_robe > 0 then sd.kolicina*sd.faktor*sd.k_robe*sd.cena1 else 0 end ) dug
	       , (case when sd.k_robe < 0 then sd.kolicina*sd.faktor*sd.k_robe*sd.cena1 else 0 end ) pot

	       , nvl(lag (sd.proizvod,1) over (ORDER BY sd.proizvod, Datum_Dok, Datum_Unosa),'xxxxxxx') AS pro_pre
	       , OdgovarajucaCena(D.Org_deo , Sd.proizvod , sysdate, sd.faktor, sd.valuta,0) odgov
           , datum_unosa
	From dokument d, stavka_dok sd
	Where sd.godina (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok (+)= d.broj_dok
	 -----------------------------
	  -- ostali uslovi
	  and d.godina = 2009
	  and d.org_deo = 103
	  AND (K_ROBE <> 0 OR D.VRSTA_DOK = 80)
	  And D.Datum_Dok Between (SELECT MAX(d1.DATUM_DOK)
	                           From stavka_dok sd1, dokument d1
	                           Where sd1.godina (+)= d1.godina and sd1.vrsta_dok (+)= d1.vrsta_dok and sd1.broj_dok (+)= d1.broj_dok
	                             and d1.godina = d.GODINA and d1.org_deo = d1.org_deo and d1.vrsta_Dok = 21 and sd1.proizvod = sd.proizvod
	                          )
	                          And SYSDATE
	  And D.Status > 0
--	  and sd.proizvod in ( 1612, 3289)
	  and sd.proizvod in ( 1612 )
)
Order By  To_Number( Pro ) , Datum_dok, Datum_Unosa;
--Order By  To_Number( Pro ) , Datum_Unosa, Datum_dok;
