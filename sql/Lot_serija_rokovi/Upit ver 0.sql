select
       d.godina, d.vrsta_Dok, VRD.NAZIV VRSTA_NAZIV
     , d.broj_dok, d.tip_dok, NF.NAZIV TIP_NAZIV

     , SrediNazivDok(VRD.NAZIV,
                     NF.NAZIV,
                     4,
                     10,
                     3,
                     9,
                     '(',
                     ')') NAZIV_DOK
     , d.org_Deo MAG, OD.NAZIV MAG_NAZIV, d.broj_dok1
     , upper(OD1.TIP) ORG_2_TIP
     , D.POSLOVNICA ORG_2, OD1.NAZIV ORG_2_NAZ
     , d.status, (SELECT DISTINCT NAZIV FROM STATUS WHERE TIP_STAT_SIFRA = 3 AND ID=D.STATUS) STATUS_NAZIV
     , d.datum_dok, d.datum_unosa, d.user_id
     , d.ppartner, PP.NAZIV PP_NAZIV
     , d.pp_isporuke, PP1.NAZIV PP_ISP_NAZIV
     , d.mesto_isporuke, MISP.NAZIV_KORISNIKA MISP_NAZIV, MISP.ADRESA MISP_ADRESA
     , MISP.ADRESA1 MISP_ADRESA1, MISP.ADRESA2 MISP_ADRESA2, MISP.ADRESA3 MISP_ADRESA3
     , sd.proizvod, p.naziv pro_naziv
     , P.JED_MERE SKL_JM, sd.kolicina, SD.JED_MERE SD_JM, sd.faktor, sd.k_robe, sd.lot_Serija--, SD.ROK

from VRSTA_DOK VRD, NACIN_FAKT NF, dokument d, stavka_dok sd, PROIZVOD P, ORGANIZACIONI_DEO OD, POSLOVNI_PARTNER PP, POSLOVNI_PARTNER PP1
   , MESTO_ISPORUKE MISP, ORGANIZACIONI_DEO OD1
Where
  -- veza tabela
      VRD.VRSTA=D.VRSTA_DOK
  AND NF.TIP=D.TIP_DOK
--  AND D.STATUS > 0
  AND d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  AND P.SIFRA = SD.PROIZVOD
  and sd.lot_Serija = '395/12'
--  and sd.lot_Serija = 'b.n.1561'
  AND SD.K_REZ=0
  AND SD.K_ROBE <>0
  AND SD.K_OCEK=0
  AND OD.ID= D.ORG_DEO
  AND OD1.ID= D.POSLOVNICA
  AND PP.SIFRA(+)=D.PPARTNER
  AND PP1.SIFRA(+)=D.PP_ISPORUKE

  AND MISP.PPARTNER(+)=D.PP_ISPORUKE
  AND MISP.SIFRA_MESTA(+)=D.MESTO_ISPORUKE
order by  SD.PROIZVOD, nvl(sd.lot_serija,'ASDFJKL')
        , d.datum_dok,d.datum_unosa;
--ORDER BY STAVKA
