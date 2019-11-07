select
Sd.ROWID , --pjedmere.naziv(sd.proizvod) jm,
  d.VRSTA_DOK vrd, d.BROJ_DOK brd, d.GODINA god, d.TIP_DOK tdok, d.DATUM_DOK, d.datum_unosa, d.status
, SD.STAVKA st,SD.PROIZVOD pro, SD.KOLICINA kol, SD.JED_MERE jm, SD.CENA, SD.VALUTA, sd.rabat, sd.porez, sd.cena1
, OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, 1, sd.valuta,0) odg
, PProdajniCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) PROD
--, KOLICINA kol,SD.JED_MERE jm, SD.FAKTOR fak

--, P.JED_MERE sjm, P.PRODAJNA_JM, FAKTOR_PRODAJNE fpr
, p.naziv
, PorganizacioniDeo.OrgDeoOsnPod( d.Org_deo, 'MAG_TR') mag_tr
, PMaPiranje.MOJE_MODUL_PODATAK('FORME','OTPREMNICE KATEGORIJA KUPACA A UZMI PROD CENU','1','U2') uzmi_c
, upper(PPoslovniPartner.kategorija(d.PPartner)) kat
, FCena1MagVP4(d.Org_Deo, sd.Proizvod)   MagVP4_cena
, SIFRA_FIRMA, MAGACIN
from stavka_dok sd, dokument d , PROIZVOD P , GRUPA_PR  GPR
   , (
      select t.* from OTPREMA_PROIZVODI_FIRME t
      WHERE FIRMA = 5
        AND STATUS = 1

      ) KA
--from dokument d, stavka_dok sd, PROIZVOD P , GRUPA_PR  GPR
Where
      d.godina=2012
  and org_deo=113
  and proizvod in (6752,7033,7035,8209,8326)
  -- veza tabela
  and
      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID

  AND P.SIFRA = KA.INVEJ_SIFRA (+)
--  AND D.VRSTA_DOK <> 11
  -----------------------------
  -- ostali uslovi
order by sd.proizvod, d.datum_dok, d.datum_unosa
