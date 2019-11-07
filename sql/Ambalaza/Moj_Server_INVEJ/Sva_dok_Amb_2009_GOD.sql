select D.ROWID, D.GODINA GOD, D.VRSTA_DOK VR, D.BROJ_DOK BRD, D.DATUM_DOK, D.DATUM_UNOSA,D.STATUS ST,tip_dok tip,pnacinfakt.naziv(d.tip_dok)naziv,
       D.ORG_DEO MAG, PORGANIZACIONIDEO.NAZIV(D.ORG_DEO) NAZIV, D.BROJ_DOK1 BR1,
       SD.PROIZVOD PRO, SD.KOLICINA KOL, SD.FAKTOR FAK, SD.CENA, SD.K_ROBE K_r, SD.REALIZOVANO REALZ, SD.RABAT RAB,SD.POREZ PDV,SD.CENA1
       , OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, sd.faktor, sd.valuta,0) odgov
from stavka_dok sd , dokument d , PROIZVOD P , GRUPA_PR  GPR
--from   dokument d , stavka_dok sd , PROIZVOD P , GRUPA_PR  GPR
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
 -----------------------------
  and d.godina = 2009
  And D.Org_Deo = 2013
--  and d.vrsta_dok  IN (3,5)
AND PROIZVOD IN (399)
ORDER BY D.DATUM_UNOSA,TO_NUMBER(PROIZVOD),TO_NUMBER(d.vrsta_dok),TO_NUMBER(d.BROJ_dok)

