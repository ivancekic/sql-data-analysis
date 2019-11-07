select sd.rowid, d.godina god, d.vrsta_dok vr, d.broj_dok br, d.tip_dok tip,
      sd.proizvod, sd.kolicina kol, sd.cena, sd.cena1*sd.faktor,
      sd.faktor, sd.cena1,
      OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, sd.faktor, sd.valuta,0) odgov,
      (select tip_dok from dokument where godina = sd1.godina and vrsta_dok = sd1.vrsta_Dok and broj_dok = sd1.broj_dok) tip_1,
      sd1.vrsta_dok vr1, sd1.broj_dok br_1, sd1.cena, sd1.faktor, sd1.cena1
from stavka_dok sd , dokument d , PROIZVOD P , GRUPA_PR  GPR,
     vezni_dok vd, stavka_dok sd1
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
  and d.godina = 2008
  and org_Deo = 128 and sd.k_robe<> 0
  and vd.godina    (+) = d.godina  and vd.vrsta_dok (+) = d.vrsta_dok  and vd.broj_dok  (+) = d.broj_dok
  and vd.za_godina = sd1.godina  and decode(vd.za_vrsta_dok,24,11,vd.za_vrsta_dok) = sd1.vrsta_dok  and vd.za_broj_dok = sd1.broj_dok
  and sd.proizvod = sd1.proizvod
--  and sd.cena1 <> sd1.cena1
--  and sd.faktor<> sd1.faktor
ORDER BY TO_NUMBER(PROIZVOD), d.datum_unosa, to_number(d.vrsta_dok), to_number(d.broj_dok)

