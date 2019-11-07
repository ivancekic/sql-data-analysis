SELECT
d.*
,sd.proizvod, sd.cena, sd.faktor,sd.k_robe, sd.rabat, sd.cena1


, ROUND(sd.k_robe*sd.kolicina*(NVL(sd.cena,0)-NVL(round(sd.cena1*sd.faktor,4),0)),2) razlika
FROM
(
SELECT D.VRSTA_DOK NIV_VRD,D.BROJ_DOK NIV_BRD, D.GODINA NIV_GOD, D.TIP_DOK NIV_TIP, D.DATUM_DOK NIV_DAT, D.DATUM_UNOSA NIV_DATU
--     , VD.ZA_BROJ_DOK, VD.ZA_VRSTA_DOK, VD.ZA_GODINA
     , D1.VRSTA_DOK,D1.BROJ_DOK,D1.GODINA,D1.TIP_DOK,D1.DATUM_DOK, D1.DATUM_UNOSA
FROM DOKUMENT D, VEZNI_DOK VD, DOKUMENT D1
WHERE D.BROJ_DOK <> '0'
  AND D.VRSTA_dOK = '90'
  AND D.GODINA = 2011

  AND D.ORG_DEO = 103

  AND D.STATUS > 0

  AND d.godina = VD.godina and d.vrsta_dok = VD.vrsta_dok and d.broj_dok = VD.broj_dok

  AND d1.godina = VD.ZA_godina and d1.vrsta_dok = VD.ZA_vrsta_dok and d1.broj_dok = VD.ZA_broj_dok
) D
, STAVKA_DOK SD
where d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
and sd.cena<> round(sd.cena1*sd.faktor,4)

--ORDER BY D1.DATUM_DOK, D1.DATUM_UNOSA
--WHERE  NIV_DAT <> DATUM_DOK
