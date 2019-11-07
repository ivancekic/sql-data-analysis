
SELECT D.GODINA,D.BROJ_DOK,D.DATUM_DOK,D.STATUS,D.ORG_DEO,D.MAG_NAZIV,D.BROJ_DOK1,D.DATUM_UNOSA,D.USER_ID
     , D.PPARTNER , PP.NAZIV KUPAC
     , D.PP_ISPORUKE, PP1.NAZIV ISPORUCENO
     , D.MESTO_ISPORUKE, MI.NAZIV_KORISNIKA
     , MI.NAZIV_KORISNIKA, MI.ADRESA, MI.ADRESA1, MI.ADRESA2, MI.ADRESA3
     , D.STAVKA,D.PROIZVOD, P.NAZIV NAZIV_PRO, D.KOLICINA, D.JED_MERE, D.CENA
     , D.RABAT RABAT_PROC, D.POREZ PDV_STOPA
     , D.KOLICINA*D.CENA 										 			VREDNOST
     , ROUND(D.KOLICINA*D.CENA*D.RABAT/100,2) 								VREDNOST_RAB
     , ROUND(D.KOLICINA*D.CENA*(100-D.RABAT)/100,2) 						VREDNOST_SA_RAB
     , ROUND(D.KOLICINA*D.CENA*(100-D.RABAT)/100,2)*D.POREZ/100				VREDNOST_PDV
     , ROUND(D.KOLICINA*D.CENA*(100-D.RABAT)/100,2)*(100+D.POREZ)/100		VREDNOST_ZA_KUPCA
     , D.VALUTA,D.OPIS,D.NAZIV NAZIV_REKLAMACIJE
     , D.ZA_GODINA, D.ZA_BROJ_DOK
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
--, (SELECT * FROM VEZNI_DOK WHERE BROj_DOK>'0' AND VRSTA_DOK = '11' AND GODINA >0 ) VD
--
WHERE
--d.godina = VD.ZA_godina (+) and d.broj_dok = VD.ZA_broj_dok (+)
D.PP_ISPORUKE=MI.PPARTNER (+)
AND D.MESTO_ISPORUKE=MI.SIFRA_MESTA(+)
AND P.SIFRA = D.PROIZVOD
AND PP.SIFRA = D.PPARTNER
AND PP1.SIFRA = D.PP_ISPORUKE
Order by datum_dok, datum_unosa
