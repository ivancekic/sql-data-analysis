select
  KOL*(C-C1) VRED
, KOL*(C-C1)* RAB / 100 POV_RAB
,
STATUS,VRD,BRD,GOD,TIP,DATUM_DOK,MAG,PRT,PPI,BRD1
     , STA,PRO,KOL,JM,C,CENA_OK,VAL,K_RO,FAK,PDV,C1, PROD_CENA,rab, NIV_VRD,NIV_BRD,NIV_GOD,OTP_VRD,OTP_BRD,OTP_GOD--,DAT_UNOSA

     , sd1.STAVKA otp_sta, sd1.PROIZVOD otp_pro, sd1.KOLICINA otp_kol, sd1.JED_MERE otp_jm
     , sd1.CENA otp_c     , round(sd1.CENA1 * sd1.faktor,4) otp_cena_ok
     , sd1.VALUTA otp_val
     , sd1.K_ROBE otp_k_ro, sd1.FAKTOR otp_fak
     , sd1.RABAT rab
     , sd1.POREZ otp_pdv
     , sd1.CENA1 otp_c1
     , PProdajniCenovnik.Cena (sd1.proizvod , sd1.otp_Dat, sd1.valuta , sd1.Faktor  ) otp_prod_cena

--, sd1.*
from
(
select
d.status,d.VRSTA_DOK vrd, d.BROJ_DOK brd, d.GODINA god, d.TIP_DOK tip
--, to_char(d.DATUM_DOK,'dd.mm.yy') dat
, d.DATUM_DOK
     , d.ORG_DEO mag
     --, d.ROK_KASE lok_s, d.POSLOVNICA mag_n, d.DPO lok_n
     , d.PPARTNER prt, d.PP_ISPORUKE ppi, d.BROJ_DOK1 brd1

     , sd.STAVKA sta, sd.PROIZVOD pro, sd.KOLICINA kol, sd.JED_MERE jm, sd.CENA c, sd.VALUTA val,sd.LOKACIJA lok
     , sd.K_REZ k_re, sd.K_ROBE k_ro, sd.K_OCEK k_oc, sd.KONTROLA kont, sd.FAKTOR fak, sd.REALIZOVANO rlz
     , sd.RABAT rab
     , sd.POREZ pdv
--     --, sd.KOLICINA_KONTROLNA kol_kon
--     --, sd.AKCIZA, sd.TAKSA
     , sd.CENA1 c1
--     , sd.Z_TROSKOVI, sd.NETO_KG, sd.PROC_VLAGE, sd.PROC_NECISTOCE, sd.HTL
--, sd.akciza, sd.taksa, unos_komentar, IZVOR_PODATKA

, round(sd.CENA1 * sd.faktor,4) cena_ok
,PProdajniCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) prod_cena
--,IzProsecniCenovnik.Cena( d.org_deo,sd.Proizvod, d.datum_dok ,1) izpros
, vd.ZA_VRSTA_DOK niv_vrd, vd.ZA_BROJ_DOK niv_brd, vd.ZA_GODINA niv_god
, vd1.za_VRSTA_DOK otp_vrd, vd1.za_BROJ_DOK otp_brd, vd1.za_GODINA otp_god
, d.DATUM_unosa dat_unosa
From dokument d, stavka_dok sd

   , (select * from vezni_dok VD
      where vd.godina = 2011
        and vd.vrsta_dok = '13'
        and za_vrsta_dok = '90'
     ) vd

   , (select * from vezni_dok VD
      where vd.godina = 2011
        and vd.vrsta_dok = '13'
        and za_vrsta_dok = '11'
     ) vd1



Where
       '2011' = d.godina
  and (sd.k_robe <>0 or d.vrsta_Dok = 80)
  AND D.ORG_DEO = 104
  and d.datum_dok > to_date('15.05.2011','dd.mm.yyyy')
  -- veza tabela
  and d.godina = sd.godina (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.broj_dok = sd.broj_dok (+)
  and d.godina = vd.godina (+) and d.vrsta_dok = vd.vrsta_dok (+) and d.broj_dok = vd.broj_dok (+)
  and d.godina = vd1.godina (+) and d.vrsta_dok = vd1.vrsta_dok (+) and d.broj_dok = vd1.broj_dok (+)

  and nvl(sd.cena,0) <> nvl(sd.cena1,0)
  and d.vrsta_dok = '13'

) dok
   , (select d.datum_dok otp_dat, d.datum_unosa otp_dat_uno, d.status otp_stat, d.org_Deo
          , sd.*
      From dokument d, stavka_dok sd
      where sd.godina = 2011
        and sd.vrsta_dok = '11'
        and d.godina = sd.godina (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.broj_dok = sd.broj_dok (+)
     ) sd1
where
      dok.OTP_GOD = sd1.godina (+) and dok.OTP_VRD = sd1.vrsta_dok (+) and dok.OTP_BRD = sd1.broj_dok (+)
  AND dok.PRO   = SD1.PROIZVOD(+)
  and dok.brd='1138'
order by datum_dok,dat_unosa
--order by stavka, d.vrsta_Dok
--sd.proizvod--d.vrsta_Dok
