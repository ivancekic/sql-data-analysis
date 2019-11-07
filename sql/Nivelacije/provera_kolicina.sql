Select STATUS,VRD,BRD,GOD,TIP,DATUM_DOK,datum_unosa, MAG,PRT,PPI,BRD1,STA,PROIZVOD,KOL,JM,CENA,VALUTA,LOK,K_REZ,K_ROBE,K_OCEK,KONT,FAK,RLZ,PDV,CENA1,AKCIZA,TAKSA,PROD_CENA,PROV_STANJA
From
(
select
d.status,d.VRSTA_DOK vrd, d.BROJ_DOK brd, d.GODINA god, d.TIP_DOK tip
--, to_char(d.DATUM_DOK,'dd.mm.yy') dat
, d.DATUM_DOK, d.datum_unosa
     , d.ORG_DEO mag
     --, d.ROK_KASE lok_s, d.POSLOVNICA mag_n, d.DPO lok_n
     , d.PPARTNER prt, d.PP_ISPORUKE ppi, d.BROJ_DOK1 brd1
     , sd.STAVKA sta, sd.PROIZVOD, sd.KOLICINA kol, sd.JED_MERE jm, sd.CENA, sd.VALUTA,sd.LOKACIJA lok
     , sd.K_REZ, sd.K_ROBE, sd.K_OCEK, sd.KONTROLA kont, sd.FAKTOR fak, sd.REALIZOVANO rlz
     --, sd.RABAT rab,
     , sd.POREZ pdv
--     --, sd.KOLICINA_KONTROLNA kol_kon
--     --, sd.AKCIZA, sd.TAKSA
     , sd.CENA1
--     , sd.Z_TROSKOVI, sd.NETO_KG, sd.PROC_VLAGE, sd.PROC_NECISTOCE, sd.HTL
, sd.akciza, sd.taksa
,PProdajniCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) prod_cena
, (select sum(sd1.kolicina*sd1.faktor*sd1.k_robe)
   from dokument d1, stavka_dok sd1
   Where '2010' = d1.godina and d1.org_deo = 104 and d1.status > 0
     and d1.godina = sd1.godina and d1.vrsta_dok = sd1.vrsta_dok and d1.broj_dok = sd1.broj_dok
     and d1.datum_unosa < d.datum_unosa
     and d1.datum_dok <= d.datum_dok and sd1.proizvod = sd.proizvod
     and k_robe <> 0
  ) prov_stanja
from dokument d, stavka_dok sd
Where
      d.vrsta_dok in ('80')
  and '2010' = d.godina
  and org_Deo = 104
  -- veza tabela
  and    d.godina = sd.godina (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.broj_dok = sd.broj_dok (+)
)
where kol <> prov_stanja
order by datum_dok, datum_unosa, proizvod

