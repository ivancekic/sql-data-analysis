SELECT D.GODINA,D.BROJ_DOK,D.DATUM_DOK,D.STATUS,D.ORG_DEO,D.MAG_NAZIV,D.BROJ_DOK1,D.DATUM_UNOSA,D.USER_ID
     , D.PPARTNER , PP.NAZIV KUPAC
     , D.PP_ISPORUKE, PP1.NAZIV ISPORUCENO
     , D.MESTO_ISPORUKE, MI.NAZIV_KORISNIKA
     , MI.NAZIV_KORISNIKA, MI.ADRESA, MI.ADRESA1, MI.ADRESA2, MI.ADRESA3
     , SUM(ROUND(D.KOLICINA*D.CENA,2)) 										 			VREDNOST
     , SUM(ROUND(D.KOLICINA*D.CENA*D.RABAT/100,2)) 								VREDNOST_RAB
     , SUM(ROUND(D.KOLICINA*D.CENA*(100-D.RABAT)/100,2)) 						VREDNOST_SA_RAB
     , SUM(ROUND(D.KOLICINA*D.CENA*(100-D.RABAT)/100*D.POREZ/100,2))				VREDNOST_PDV
     , SUM(ROUND(D.KOLICINA*D.CENA*(100-D.RABAT)/100*(100+D.POREZ)/100,2))		VREDNOST_ZA_KUPCA
     , D.VALUTA,D.NAZIV NAZIV_REKLAMACIJE
--     , D.ZA_GODINA, D.ZA_BROJ_DOK

     , OTP.GODINA OTP_GOD
     , OTP.BROJ_DOK OTP_ID
     , OTP.ORG_DEO OTP_MAG
     , OTP.BROJ_DOK1 OTP_BRD1
FROM
(
SELECT
       d.godina, d.broj_dok, d.datum_dok,d.status,d.ppartner,d.org_deo, od.naziv mag_naziv, d.broj_dok1
     , d.datum_unosa,d.user_id,d.tip_dok, d.pp_isporuke
     , d.mesto_isporuke,d.prevoz
     , sd.Stavka, sd.Proizvod, sd.Kolicina, sd.Jed_Mere
     , sd.Cena, sd.Faktor
     , nvl(sd.rabat,0) rabat ,nvl(sd.porez,0) porez , sd.valuta

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
  AND D.STATUS IN (1,5)
) D
, (SELECT * FROM MESTO_ISPORUKE) MI
, PROIZVOD P
, POSLOVNI_PARTNER PP
, POSLOVNI_PARTNER PP1
, (SELECT * FROM DOKUMENT WHERE BROJ_DOK>'0' AND VRSTA_DOK = '11' AND GODINA >0 ) OTP

WHERE

D.PP_ISPORUKE=MI.PPARTNER (+)
AND D.MESTO_ISPORUKE=MI.SIFRA_MESTA(+)
AND P.SIFRA = D.PROIZVOD
AND PP.SIFRA = D.PPARTNER
AND PP1.SIFRA = D.PP_ISPORUKE
AND d.godina = OTP.godina (+) and d.broj_dok = OTP.broj_dok (+)
GROUP BY
D.GODINA,D.BROJ_DOK,D.DATUM_DOK,D.STATUS,D.ORG_DEO,D.MAG_NAZIV,D.BROJ_DOK1,D.DATUM_UNOSA,D.USER_ID
     , D.PPARTNER , PP.NAZIV
     , D.PP_ISPORUKE, PP1.NAZIV
     , D.MESTO_ISPORUKE, MI.NAZIV_KORISNIKA
     , MI.NAZIV_KORISNIKA, MI.ADRESA, MI.ADRESA1, MI.ADRESA2, MI.ADRESA3
     , D.VALUTA,D.NAZIV
     , D.ZA_GODINA, D.ZA_BROJ_DOK

     , OTP.GODINA
     , OTP.BROJ_DOK
     , OTP.ORG_DEO
     , OTP.BROJ_DOK1

Order by datum_dok, datum_unosa
