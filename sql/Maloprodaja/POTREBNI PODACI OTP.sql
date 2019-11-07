select
Sd.ROWID , --pjedmere.naziv(sd.proizvod) jm,
--pproizvod.naziv(sd.proizvod) ,
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
--d.*,
--Z.*

SD.*
, PPlanskiCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) Plan
, PPlanskiCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , 1  ) Plan_1
--, sd.kolicina*158.84 za_akc

--D.DATUM_dOK, SD.VRSTA_dOK, SD.BROJ_DOK, SD.PROIZVOD, SD.KOLICINA,SD.CENA,SD.CENA1
--, sd.cena * (1-sd.rabat/100)
----,Obracunaj_JUS(sd.proizvod, sd.neto_kg, sd.proc_vlage, sd.proc_necistoce,nvl(sd.htl,0))
----, (sd.kolicina * 2) z_t_osn, round((sd.kolicina * 2 * 1.18),2) z_t_uk
--, OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, 1, sd.valuta,0) odgov
------, PProdajniCenovnikGrKup.Cena ('GKNEU', sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) neu
--,PProdajniCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) PROD
--,PPlanskiCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) Plan
, Pporez.ProcenatPoreza(d.Poslovnica,sd.Proizvod,d.Datum_dok,3) treba_por
--,Kolicina * Faktor * 100 / Kolicina_Kontrolna jacina
--d.tip_dok,pproizvod.naziv(sd.proizvod),--sd.*
--sd.proizvod , pproizvod.naziv(sd.proizvod),sum (sd.kolicina * sd.faktor * sd.k_robe)
--,d.status,sd.kolicina, sd.realizovano

--, ZALIHE Z
--, KOLICINA kol,SD.JED_MERE jm, SD.FAKTOR fak
--
--, P.JED_MERE sjm, P.PRODAJNA_JM, FAKTOR_PRODAJNE fpr
--, p.naziv
--    , (select sp1.stopa from savezni_porez sp1
--       where sp1.Datum = ( Select Max( sp2.Datum )
--                           From Savezni_Porez sp2
--                           Where sp2.Grupa_Poreza = p.Grupa_Poreza
--                             And sp2.Datum <= d.Datum_dok )
--         and sp1.Grupa_Poreza = p.Grupa_Poreza
--       ) sp_stopa

--, ROUND(PKurs.Vrednost( SD.CENA, 'EUR', 'YUD', D.Datum_Dok,'S' ),4) CENA_K


, PProdajniCenovnikMP.Cena_MP( sd.Proizvod , d.Datum_Dok , sd.Valuta , sd.Faktor)          -- Stavka.nPOlje4
, PProdajniCenovnikMP.Cena( sd.Proizvod , d.Datum_Dok , sd.Valuta , sd.Faktor)             -- Stavka_nPOlje5
from stavka_dok sd, dokument d , PROIZVOD P , GRUPA_PR  GPR, tip_proizvoda tp


--from dokument d, stavka_dok sd, PROIZVOD P , GRUPA_PR  GPR
Where
  -- veza tabela
      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
  and tp.sifra = p.tip_proizvoda
  -----------------------------
  -- ostali uslovi
  and d.godina in (2014)
  and d.broj_dok in ('56556')
  and d.status > 0

--  and d.vrsta_Dok='8'
--  and d.broj_dok='51111'
--  AND D.VRSTA_DOK IN ('73','74')
--  AND (
----        (D.BROJ_DOK  in('964') AND d.vrsta_Dok in ('3') )
----      OR
--        (D.BROJ_DOK  in('74') AND d.vrsta_Dok in ('10') )
----      OR
----        (D.BROJ_DOK  in('1994') AND d.vrsta_Dok in ('11') )
--      )



--  and org_Deo = 1105
--  and k_robe <> 0
--  AND D.DATUM_DOK = TO_DATE('01.01.2013','DD.MM.YYYY')
--  AND PPARTNER= 5324

--AND D.STATUS = 0


--  and sd.proizvod 	= '22944'

-- and sd.proizvod IN ('1972')
--  AND TIP_DOK = 165

--  and p.posebna_grupa in (11,107)
--and cena1 <> PPlanskiCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , 1  )

--  and d.datum_dok between to_date('05.02.2011','dd.mm.yyyy') and to_date('09.02.2011','dd.mm.yyyy')
--  and d.datum_dok > to_date('24.01.2013','dd.mm.yyyy')
--  and sd.valuta is null
--  and d.ppartner= 2965

----and sd.faktor <> 1
--  and SD.proizvod in (3764)
--  and SD.proizvod IN (
--							  Select SIFRA from proizvod
--							where tip_proizvoda = 1
--							  and '%'||upper(naziv)||'%' like '%MARG%'
--                     )
----and sd.kolicina <> sd.realizovano
--  and (k_robe <>0 or d.vrsta_Dok = 80)
--and      d.vrsta_dok in ('11')
--  and d.broj_dok = 19
--and (
----          ( d.VRSTA_DOK = 3 And d.BROJ_DOK in(6723)) --1351--
--------      or
--          ( d.VRSTA_DOK = 2 And d.BROJ_DOK in('868')) --1351--
------
--    )
----
----AND D.ORG_DEO = Z.ORG_dEO
----AND SD.PROIZVOD = Z.PROIZVOD  (+)
--
----and proizvod in (select proizvod from stavka_dok
----where godina = 2010
---- and vrsta_dok = 3
---- and broj_dok = 21028)
--
----  AND NVL ( SD.CENA , 0 ) <>  NVL ( SD.CENA1 , 0 )
----
----  and d.status >= 1
----  and ( nvl(sd.cena1,0) <= 0 or nvl(sd.cena,0) <= 0 )
----  and d.vrsta_dok  IN ( 1,26,45,46,
----                        8,27,28,32 )
----  and tip_dok = 23
----  and sd.stavka = 1
----  and d.broj_dok in (10)
---- and d.broj_dok1 in (1595)
----   AND SD.CENA <> 18
---- PProdajniCenovnik.Cena( SD.Proizvod,D.Datum_Dok,SD.Valuta,SD.Faktor)
--  and d.datum_dok > to_date('23.10.2011','dd.mm.yyyy')
----  and sd.proizvod = 4465
----AND D.VRSTA_DOK = 3
----and d.status > 0
----and sd.kolicina <> sd.realizovano
----and k_robe <> 0
----and nvl(sd.cena1,0) = 0
--  and proizvod in ('6845','5304')
----order by --to_number(sd.proizvod),
------d.datum_dok ,
----to_number(sd.broj_dok)
----to_number(sd.proizvod)--,sd.stavka -- ,
----
------, d.broj_dok , stavka
----ORDER BY TO_NUMBER(PROIZVOD),
----         D.DATUM_UNOSA,
----         TO_NUMBER(d.vrsta_dok),
----         TO_NUMBER(d.BROJ_dok)
----         --datum_dok--, stavka--
----
--and sd.stavka in (1,3)
--
--AND CENA1 IS NOT NULL
--AND CENA1 <> OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, 1, sd.valuta,0)
--and nvl(sd.proc_vlage) > 0
order by stavka
----SD.PROIZVOD,
--d.datum_dok,
--d.datum_unosa;
--ORDER BY STAVKA



--393.76
--393.76

--388.73
--388.73

