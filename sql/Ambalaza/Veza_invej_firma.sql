Select p.jed_mere, k.*, k.proizvod,a.AMBALAZA,a.ZA_KOLICINU
from katalog k, proizvod p, ambalaza@medela a
where k.dobavljac = 1226
  and k.proizvod not in (select proizvod from ambalaza)
  and p.sifra     = k.proizvod
  and p.jed_mere  <> JM_CENA
  and k.nabavna_sifra  = a.proizvod
