select godina , vrsta_dok,broj_dok,proizvod , pproizvod.naziv(proizvod), kolicina , jed_mere,faktor, kolicina_kontrolna
, kolicina * 100 * Faktor /  Kolicina_Kontrolna proc_alk
from stavka_dok
where vrsta_dok = 11
and Kolicina_Kontrolna is not null
