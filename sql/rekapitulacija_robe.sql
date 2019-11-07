select
       D.VRSTA_DOK,D.BROJ_DOK,D.GODINA,D.TIP_DOK,D.DATUM_DOK,D.DATUM_UNOSA,D.USER_ID,D.PPARTNER
     , sd.proizvod
     , sd.cena, sd.kolicina, sd.rabat, sd.faktor, sd.cena1
     , VrednostiNaStavkamaDeja (  &NacinObracuna,'VREDNOST'
                                , SD.kolicina
                                , SD.cena,SD.faktor,SD.k_robe,SD.rabat,d.spec_rabat,d.kasa,SD.porez,SD.akciza,SD.cena1
                                , SD.z_troskovi,&PlusMinus,d.godina,d.vrsta_dok,d.broj_dok) VRED
     , VrednostiNaStavkamaDeja (  &NacinObracuna,'RABAT'
                                , SD.kolicina
                                , SD.cena,SD.faktor,SD.k_robe,SD.rabat,d.spec_rabat,d.kasa,SD.porez,SD.akciza,SD.cena1
                                , SD.z_troskovi,&PlusMinus,d.godina,d.vrsta_dok,d.broj_dok) RABAT
     , VrednostiNaStavkamaDeja (  &NacinObracuna,'KASA'
                                , SD.kolicina
                                , SD.cena,SD.faktor,SD.k_robe,SD.rabat,d.spec_rabat,d.kasa,SD.porez,SD.akciza,SD.cena1
                                , SD.z_troskovi,&PlusMinus,d.godina,d.vrsta_dok,d.broj_dok) KASA

     ,VrednostiNaStavkamaDeja (&NacinObracuna,'RABAT_KASA',sd.kolicina,
     sd.cena,
     sd.faktor,sd.k_robe,sd.rabat,d.spec_rabat,d.kasa,sd.porez,sd.akciza,sd.cena1,sd.z_troskovi,&PlusMinus,d.godina,d.vrsta_dok,d.broj_dok)
     RABAT_KASA
     ------------------------------------------------------------------------------------------------------------------------------------------------------------------
     ,VrednostiNaStavkamaDeja (&NacinObracuna,'OSNOVICA',sd.kolicina,
     sd.cena,
     sd.faktor,sd.k_robe,sd.rabat,d.spec_rabat,d.kasa,sd.porez,sd.akciza,sd.cena1,sd.z_troskovi,&PlusMinus,d.godina,d.vrsta_dok,d.broj_dok)
     OSNOVICA
     ------------------------------------------------------------------------------------------------------------------------------------------------------------------
     ,sd.porez PDV_STOPA
     ------------------------------------------------------------------------------------------------------------------------------------------------------------------
     ,VrednostiNaStavkamaDeja (&NacinObracuna,'PDV_IZNOS',sd.kolicina,
     sd.cena,
     sd.faktor,sd.k_robe,sd.rabat,d.spec_rabat,d.kasa,sd.porez,sd.akciza,sd.cena1,sd.z_troskovi,&PlusMinus,d.godina,d.vrsta_dok,d.broj_dok)
     PDV
     ------------------------------------------------------------------------------------------------------------------------------------------------------------------
     ,VrednostiNaStavkamaDeja (&NacinObracuna,'RAZLIKA_U_CENI',sd.kolicina,
     sd.cena,
     sd.faktor,sd.k_robe,sd.rabat,d.spec_rabat,d.kasa,sd.porez,sd.akciza,sd.cena1,sd.z_troskovi,&PlusMinus,d.godina,d.vrsta_dok,d.broj_dok)
     RAZ_U_CENI
     ------------------------------------------------------------------------------------------------------------------------------------------------------------------
     ,VrednostiNaStavkamaDeja (&NacinObracuna,'ZAVISNI_TROSKOVI',sd.kolicina,
     sd.cena,
     sd.faktor,sd.k_robe,sd.rabat,d.spec_rabat,d.kasa,sd.porez,sd.akciza,sd.cena1,sd.z_troskovi,&PlusMinus,d.godina,d.vrsta_dok,d.broj_dok)
     ZAV_TROSKOVI
     ------------------------------------------------------------------------------------------------------------------------------------------------------------------
     ,VrednostiNaStavkamaDeja (&NacinObracuna,'MAGACINSKA_VREDNOST',sd.kolicina,
     sd.cena,
     sd.faktor,sd.k_robe,sd.rabat,d.spec_rabat,d.kasa,sd.porez,sd.akciza,sd.cena1,sd.z_troskovi,&PlusMinus,d.godina,d.vrsta_dok,d.broj_dok)
     MAG_VREDNOST



--D.DATUM_dOK, SD.VRSTA_dOK, SD.BROJ_DOK, SD.PROIZVOD, SD.KOLICINA,SD.CENA,SD.CENA1
--, sd.cena * (1-sd.rabat/100)
----,Obracunaj_JUS(sd.proizvod, sd.neto_kg, sd.proc_vlage, sd.proc_necistoce,nvl(sd.htl,0))
----, (sd.kolicina * 2) z_t_osn, round((sd.kolicina * 2 * 1.18),2) z_t_uk
, OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, sd.faktor, sd.valuta,0) odgov
----, PProdajniCenovnikGrKup.Cena ('GKNEU', sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) neu
--, PProdajniCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) PROD
--, Pporez.ProcenatPoreza(d.Poslovnica,sd.Proizvod,d.Datum_dok,d.Vrsta_izjave) treba_por
--,Kolicina * Faktor * 100 / Kolicina_Kontrolna jacina
--d.tip_dok,pproizvod.naziv(sd.proizvod),--sd.*
--sd.proizvod , pproizvod.naziv(sd.proizvod),sum (sd.kolicina * sd.faktor * sd.k_robe)
--,d.status,sd.kolicina, sd.realizovano
from stavka_dok sd, dokument d , PROIZVOD P , GRUPA_PR  GPR, ZALIHE Z
--from dokument d, stavka_dok sd, PROIZVOD P , GRUPA_PR  GPR
Where
  -- veza tabela
      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
  -----------------------------
  -- ostali uslovi
  and '2011' = d.godina
--  AND TIP_DOK = 11
--AND D.ORG_DEO = 162
--and sd.faktor <> 1
--  and proizvod = '8240'
--  and (k_robe <>0 or d.vrsta_Dok = 80)
--and      d.vrsta_dok in ('11')
--  and d.broj_dok = 19
and (
          ( d.VRSTA_DOK = 11 And d.BROJ_DOK in('11015')) --1351--
----      or
----          ( d.VRSTA_DOK = 2 And d.BROJ_DOK in('156')) --1351--
--
    )

AND D.ORG_DEO = Z.ORG_dEO
AND SD.PROIZVOD = Z.PROIZVOD  (+)

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
-- PProdajniCenovnik.Cena( SD.Proizvod,D.Datum_Dok,SD.Valuta,SD.Faktor)
--  and d.datum_dok > to_date('14.05.2011','dd.mm.yyyy')
--  and sd.proizvod = 4465
--AND D.VRSTA_DOK = 3
--and d.status > 0
--and sd.kolicina <> sd.realizovano
--and k_robe <> 0
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
order by d.datum_dok,d.datum_unosa;
