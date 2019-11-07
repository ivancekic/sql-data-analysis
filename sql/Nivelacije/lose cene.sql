select
sD.ROWID , --pjedmere.naziv(sd.proizvod) jm,
d.user_id, --pproizvod.naziv(sd.proizvod) ,
--SD.BROJ_DOK,
--D.org_deo, d.poslovnica,  d.vrsta_izjave,
--sd.proizvod, SD.porez
--,sd.cena,sd.cena1
--,Pporez.ProcenatPoreza(d.Poslovnica,sd.Proizvod,d.Datum_dok,d.Vrsta_izjave) treba_por
--,sd.stavka
--d.rowid, d.vrsta_izjave,d.org_deo, d.broj_dok1, sd.*
--D.ROWID,-- D.*,
--sd.jed_mere, p.jed_mere,
--d.status, d.datum_dok, D.ORG_DEO, D.BROJ_DOK1,
d.datum_dok, d.datum_unosa, d.status,d.org_Deo,d.broj_dok1, d.datum_Storna, SD.*
, PProdajniCenovnik.Cena( SD.Proizvod,D.Datum_Dok,SD.Valuta,SD.Faktor)
, case when PProdajniCenovnik.Cena( SD.Proizvod,D.Datum_Dok,SD.Valuta,SD.Faktor) <> sd.cena1 Then
		(select vd.za_broj_dok from vezni_dok vd
		 where vd.godina = d.godina and vd.vrsta_Dok = d.vrsta_dok and vd.broj_dok = d.broj_dok and za_vrsta_Dok = '90'

		 )
  end niv_stavki
--, sd.cena * (1-sd.rabat/100)
----,Obracunaj_JUS(sd.proizvod, sd.neto_kg, sd.proc_vlage, sd.proc_necistoce,nvl(sd.htl,0))
----, (sd.kolicina * 2) z_t_osn, round((sd.kolicina * 2 * 1.18),2) z_t_uk
--, OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, sd.faktor, sd.valuta,0) odgov
----, PProdajniCenovnikGrKup.Cena ('GKNEU', sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) neu
--, PProdajniCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) PROD
--, Pporez.ProcenatPoreza(d.Poslovnica,sd.Proizvod,d.Datum_dok,d.Vrsta_izjave) treba_por
--,Kolicina * Faktor * 100 / Kolicina_Kontrolna jacina
--d.tip_dok,pproizvod.naziv(sd.proizvod),--sd.*
--sd.proizvod , pproizvod.naziv(sd.proizvod),sum (sd.kolicina * sd.faktor * sd.k_robe)
--,d.status,sd.kolicina, sd.realizovano
from   stavka_dok sd, dokument d , PROIZVOD P , GRUPA_PR  GPR
--from dokument d, stavka_dok sd, PROIZVOD P , GRUPA_PR  GPR
Where
  -- veza tabela
      d.godina = sd.godina (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.broj_dok = sd.broj_dok  (+)
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
  -----------------------------
  -- ostali uslovi
  and '2010' = d.godina
--  AND TIP_DOK = 11
AND D.ORG_DEO = 104 --between 103 and 108
--and d.vrsta_dok = 12

--and sd.faktor <> 1
--and proizvod = '3219'
--and (
--          ( d.VRSTA_DOK = 10 And d.BROJ_DOK in('14157')) --1351--
--      or
--          ( d.VRSTA_DOK = 11 And d.BROJ_DOK in('15914')) --1351--
--
--    )
--and proizvod in (select proizvod from stavka_dok
--where godina = 2010
-- and vrsta_dok = 3
-- and broj_dok = 21028)

--  AND NVL ( SD.CENA , 0 ) <>  NVL ( SD.CENA1 , 0 )
--
--  and d.status >= 1
--  and ( nvl(sd.cena1,0) <= 0 or nvl(sd.cena,0) <= 0 )
--  and d.vrsta_dok  IN ( 1,26,45,46,
--                        8,27,28,32 )
--  and tip_dok = 23
--  and sd.stavka = 1
--  and d.broj_dok in (10)
-- and d.broj_dok1 in (1595)
--   AND SD.CENA <> 18
and PProdajniCenovnik.Cena( SD.Proizvod,D.Datum_Dok,SD.Valuta,SD.Faktor) <> sd.cena1
--  and d.datum_dok >= to_date('29.09.2009','dd.mm.yyyy')
--  and sd.proizvod = 18379
and k_robe <> 0
--and nvl(sd.cena,0) = nvl(sd.cena1,0)
--and nvl(sd.cena1,0) = 0
--  and proizvod in ('10174','10175')
--order by --to_number(sd.proizvod),
----d.datum_dok ,
--to_number(sd.broj_dok)
--to_number(sd.proizvod)--,sd.stavka -- ,
--
----, d.broj_dok , stavka
--ORDER BY TO_NUMBER(PROIZVOD),
--         D.DATUM_UNOSA,
--         TO_NUMBER(d.vrsta_dok),
--         TO_NUMBER(d.BROJ_dok)
--         --datum_dok--, stavka--
--
--and sd.stavka = 98
--and d.status = 4
order by d.datum_dok,d.datum_unosa;
