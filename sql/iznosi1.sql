Select pro, sum(kol*kr) kol, cena,
       sum(kol*kr) * cena iznos,
       sum(kol*kr * cena * rab )  / 100 rabat,
       sum(kol*kr * cena * (1 - rab/100)) izn_sa_r,
       (select akciza from stavka_dok where godina = 2009 and vrsta_Dok = 11 and broj_dok = 8 and proizvod = pro) akc,
       (select akciza / kolicina from stavka_dok where godina = 2009 and vrsta_Dok = 11 and broj_dok = 8 and proizvod = pro) akc_jed,
       (select akciza / kolicina from stavka_dok where godina = 2009 and vrsta_Dok = 11 and broj_dok = 8 and proizvod = pro) * sum(kol*kr) akc_nova,
       (select akciza / kolicina from stavka_dok where godina = 2009 and vrsta_Dok = 11 and broj_dok = 8 and proizvod = pro) * sum(kol*kr) +
       sum(kol*kr * cena * (1 - rab/100)) pdv_os,
       ((select akciza / kolicina from stavka_dok where godina = 2009 and vrsta_Dok = 11 and broj_dok = 8 and proizvod = pro) * sum(kol*kr) +
        sum(kol*kr * cena * (1 - rab/100))) * pdv/100 pdv_izn,
       ((select akciza / kolicina from stavka_dok where godina = 2009 and vrsta_Dok = 11 and broj_dok = 8 and proizvod = pro) * sum(kol*kr) +
        sum(kol*kr * cena * (1 - rab/100))) * (1 +  pdv/100 ) za_kupca
from
(
select --d.godina, d.vrsta_Dok, d.broj_dok,
       sd.proizvod pro, sd.jed_mere jm,
       sd.kolicina kol, -1 * sd.k_robe kr, sd.cena cena,
       sd.rabat rab, sd.akciza, sd.taksa, sd.porez pdv
from stavka_dok sd, dokument d
Where sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
 -----------------------------
  -- ostali uslovi
  and d.godina = 2009
  and ( (d.vrsta_dok  = 11 and d.broj_dok = 8 ) or (d.vrsta_dok = 13 and d.broj_dok = 2))
)
group by pro, cena, pdv
having sum(kol*kr) > 0
ORDER BY TO_NUMBER(PRO)
