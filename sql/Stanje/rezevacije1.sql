select d.org_deo, porganizacionideo.naziv(d.org_deo) naziv,
       sd.proizvod, pproizvod.naziv(sd.proizvod) naziv,
       sum(sd.kolicina * K_Robe * faktor) stanje_stavka,
       sum (sd.kolicina *sd.faktor -sd.realizovano *sd.faktor ),
       z.rezervisana
from dokument d,stavka_dok sd, zalihe z
where d.godina=to_char(sysdate,'YYYY')
  and d.status in ('1','3')
  and d.vrsta_dok in ('9','10')
  and z.org_Deo = d.org_deo and z.proizvod = sd.proizvod
  and sd.vrsta_dok=d.vrsta_dok and sd.broj_dok=d.broj_dok and sd.godina=d.godina
  and rezervisana > stanje
Group by d.org_deo, sd.proizvod, z.rezervisana
--Having sum (sd.kolicina *sd.faktor -sd.realizovano *sd.faktor ) <> z.rezervisana

order by d.org_deo, to_number(sd.proizvod)
--)
