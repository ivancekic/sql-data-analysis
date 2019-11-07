select D.org_deo,porganizacionideo.naziv(d.org_deo) naziv,
       ROUND(Sum(NVL(decode(d.tip_dok,14,SD.Kolicina,SD.realizovano)*SD.Faktor*
               (CASE WHEN D.VRSTA_DOK = '80' THEN
                      (SD.CENA1-SD.CENA)
                     WHEN d.vrsta_dok  ='90' then
                      ROUND((NVL(sd.cena,0)-NVL(sd.cena1,0)),2)
                ELSE K_ROBE*(
                              CASE WHEN D.VRSTA_DOK = 11 AND UPPER(NVL(ORGD.DODATNI_TIP,'xx')) = 'VP2' THEN
                                        SD.CENA1
                              ELSE
                                   SD.CENA1
                              END
                            )
                END),0)),2) kraj_2008,


       (select round(sum(kolicina*faktor*k_robe*cena1),2)
        from stavka_dok sd1 , dokument d1
        Where sd1.godina = d1.godina  and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
           and d1.godina = 2009 and d1.status >= 1
           and d1.org_deo = d.org_deo and d1.vrsta_Dok = 21
       )  PS_2009

from stavka_dok sd, dokument d, ORG_DEO_OSN_PODACI ORGD
Where sd.godina = d.godina  and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
  AND ORGD.ORG_DEO (+)= D.ORG_DEO
 -----------------------------
  -- ostali uslovi
  and d.godina = 2008
  and d.status >= 1
  and d.datum_dok <= to_date('31.12.2008','dd.mm.yyyy')
  and d.datum_dok >= (Select max(datum_dok) from dokument where vrsta_dok = 21 and godina < 2009)
  and D.org_deo not in (select magacin from partner_magacin_flag )
--  and kraj_2008 is not null
  and (select round(sum(kolicina*faktor*k_robe*cena1),2)
        from stavka_dok sd1 , dokument d1
        Where sd1.godina = d1.godina  and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
           and d1.godina = 2009 and d1.status >= 1
           and d1.org_deo = d.org_deo and d1.vrsta_Dok = 21
       ) is null
group by D.org_deo
order by d.org_deo
