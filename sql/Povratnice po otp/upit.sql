SELECT
SD.ROWID,

d.godina, d.broj_dok, d.datum_dok,d.status,d.ppartner,d.org_deo, od.naziv mag_naziv, d.broj_dok1
     , d.datum_valute,d.poslovnica
     , d.datum_storna,d.datum_unosa,d.user_id,d.tip_dok,d.pp_isporuke
     , d.nacin_otpreme,d.mesto_isporuke,d.reg_broj,d.prevoz,d.cena_prevoza
     , d.franko
     , sd.Stavka, sd.Proizvod, sd.Kolicina, sd.Jed_Mere, sd.Broj_Koleta
     , sd.Lot_Serija, sd.Rok, sd.Lokacija, sd.Cena, sd.Faktor,sd.Kolicina_Kontrolna , nvl(sd.rabat,0) rabat ,nvl(sd.porez,0) porez , sd.valuta

     , r.OPIS, R.NAZIV
     , VD.ZA_GODINA, VD.ZA_BROJ_DOK
FROM stavka_dok sd, Dokument d, organizacioni_deo od
   ,(
         SELECT R.godina, R.broj_dok, R.vrsta_dok, R.Opis, TR.NAZIV FROM Reklamacija R, TIP_REKLAMACIJE TR
         WHERE vrsta_dok = '13' AND godina >0 AND broj_dok > '0' AND TIP= TR.SIFRA
         ORDER BY Stavka
     ) r
  , (SELECT * FROM VEZNI_DOK WHERE VRSTA_DOK='13' AND ZA_VRSTA_DOK = '11')   VD
WHERE d.vrsta_dok = '13'
  and od.id =d.org_deo

  AND D.DATUM_DOK BETWEEN TO_DATE('01.01.2011','DD.MM.YYYY') AND  TO_DATE('22.11.2011','DD.MM.YYYY')
  AND D.ORG_DEO BETWEEN 103 AND 108

  and d.godina = sd.godina (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.broj_dok = sd.broj_dok (+)
  and d.godina = r.godina (+) and d.vrsta_dok = r.vrsta_dok (+) and d.broj_dok = r.broj_dok  (+)

  and d.godina = VD.godina (+) and d.vrsta_dok = VD.vrsta_dok (+) and d.broj_dok = VD.broj_dok (+)

  and SD.PROIZVOD IS NOT NULL
Order by d.datum_dok, d.datum_unosa
