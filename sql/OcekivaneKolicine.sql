
select d.status, d.datum_dok, d.broj_dok, d.vrsta_dok, d.user_id, sd.kolicina, sd.jed_mere, sd.realizovano , sd.jed_mere sklad_jm
from stavka_dok sd , dokument d , proizvod p
where d.GODINA=2008
and d.vrsta_dok in (2)
and d.status in (1,3)
and sd.proizvod = p.sifra
and sd.proizvod in ('4465','4466','4467','4468','4469','4470')
and sd.kolicina != sd.realizovano
and sd.godina    = d.godina
and sd.vrsta_dok = d.vrsta_dok
and sd.broj_dok  = d.broj_dok

