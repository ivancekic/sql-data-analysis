Select d.status st, d.godina god,
       d.vrsta_dok vrd, pvrstadok.naziv(d.vrsta_Dok) naziv,
       d.broj_dok brd,
       d.tip_dok tip, pnacinfakt.naziv(d.tip_dok) naziv,
       d.org_deo mag, d.broj_dok1 brd1,
       d.ppartner ppar,d.pp_isporuke ppisp,d.mesto_isporuke misp,
       sd.proizvod pro,nvl(sd.cena,PPlanskiCenovnik.Cena(sd.Proizvod ,d.Datum_Dok,'YUD', sd.faktor )) cena, sd.kolicina kol, sd.faktor fak, sd.k_robe,
       nvl(sd.cena1,PPlanskiCenovnik.Cena(sd.Proizvod ,d.Datum_Dok,'YUD', 1 )) cena1
from dokument d, stavka_dok sd, proizvod p
where d.godina   = 2009 and d.status > 0
  and k_robe <> 0 and d.org_Deo = 104 and p.tip_proizvoda = 8
  and (
           (d.vrsta_dok = 1  and d.broj_dok in ('3','4'))
        or (d.vrsta_dok = 11 and d.broj_dok in ('9743'))
        or (d.vrsta_dok = 61 and d.broj_dok in ('9743'))
        or (d.vrsta_dok = 3  and d.broj_dok in ('6831'))
        or (d.vrsta_dok = 3  and d.broj_dok in ('6832'))
        or (d.vrsta_dok = 4  and d.broj_dok in ('40'))
        or (d.vrsta_dok = 1  and d.broj_dok in ('5','6'))
        or (d.vrsta_dok = 26 and d.broj_dok in ('1','2'))
        or (d.vrsta_dok = 11 and d.broj_dok in ('9744'))
        or (d.vrsta_dok = 61 and d.broj_dok in ('9744'))
        or (d.vrsta_dok = 12 and d.broj_dok in ('57'))
        or (d.vrsta_dok = 62 and d.broj_dok in ('13'))
        or (d.vrsta_dok = 1  and d.broj_dok in ('7','8'))
        or (d.vrsta_dok = 45 and d.broj_dok in ('1','2'))
        or (d.vrsta_dok = 21 and d.broj_dok in ('25'))
     )
  and d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  and p.sifra  = sd.proizvod
order by d.rowid

