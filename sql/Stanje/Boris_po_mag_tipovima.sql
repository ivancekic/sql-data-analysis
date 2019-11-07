select d.org_deo, porganizacionideo.naziv(d.org_deo) naziv, p.tip_proizvoda, ptipproizvoda.naziv(p.tip_proizvoda) naziv,
       sd.proizvod, --pproizvod.naziv(sd.proizvod) naziv,
       p.naziv, p.jed_mere,
       round(sum(sd.kolicina*sd.k_robe*sd.faktor),5) stanje,
       round(sum(sd.kolicina*sd.k_robe*sd.faktor*sd.cena1),2) vrednost
from stavka_dok sd , dokument d , PROIZVOD P
Where sd.godina    = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok  = d.broj_dok
  and SD.PROIZVOD  = P.SIFRA
  and d.status > 0 and sd.k_robe <> 0 and p.tip_Proizvoda in ('01','02','03','04','10')
  and d.datum_dok >= ( select nvl(max(d1.datum_dok), to_date('01.01.1990','dd.mm.yyyy'))
                       from dokument d1
                       where d1.status  > 0 and d1.vrsta_dok = 21
                         and d1.org_deo = d.org_deo
                     )
  and d.datum_dok <= to_date('31.10.2008','dd.mm.yyyy')
  and d.org_deo not in (select magacin from partner_magacin_flag)
Group by d.org_deo, p.tip_proizvoda, sd.proizvod, p.naziv, p.jed_mere, p.tip_Proizvoda
Having round(sum(sd.kolicina*sd.k_robe*sd.faktor),5) > 0
ORDER BY d.org_deo, p.tip_proizvoda, to_number(p.tip_Proizvoda), to_number(sd.proizvod)

