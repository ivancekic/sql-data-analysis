select
--DISTINCT ORG_DEO, PORGANIZACIONIDEO.NAZIV(D.ORG_DEO) ORG_NAZ
Sd.ROWID , --pjedmere.naziv(sd.proizvod) jm,
--d.*,
D.GODINA, D.VRSTA_DOK, D.BROJ_DOK, D.STATUS, D.ORG_DEO, PORGANIZACIONIDEO.NAZIV(D.ORG_DEO) ORG_NAZ,D.BROJ_DOK1,D.DATUM_DOK, D.DATUM_STORNA, D.USER_ID,
SD.PROIZVOD, SD.KOLICINA, SD.CENA, SD.CENA1
--,(SELECT STANJE-REZERVISANA FROM ZALIHE Z WHERE Z.ORG_DEO=D.ORG_DEO AND Z.PROIZVOD=SD.PROIZVOD ) ST
, OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, 1, sd.valuta,0) odgov
from stavka_dok sd, dokument d , PROIZVOD P , GRUPA_PR  GPR
Where
  -- veza tabela
      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID

  -----------------------------
  -- ostali uslovi
  and d.godina in (2013)
  AND d.VRSTA_DOK IN ( SELECT VRSTA FROM VRSTA_DOK
                       WHERE INSTR(UPPER(NAZIV),'STOR')>0
                         AND VRSTA NOT IN ('7','12','15','40','53','64','75')
                     )

  AND ORG_DEO NOT IN (SELECT MAGACIN FROM PARTNER_MAGACIN_FLAG)
  AND D.VRSTA_DOK NOT IN (62)
--  AND D.ORG_DEO NOT IN (1511)

  AND D.ORG_DEO < 1200

--order by
----SD.PROIZVOD,
--d.datum_dok,
--d.datum_unosa;
----ORDER BY STAVKA
--
--
--
----393.76
----393.76
--
----388.73
----388.73
--
