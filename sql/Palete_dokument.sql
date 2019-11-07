Select k.NABAVNA_SIFRA, amb.proizvod , amb.za_kolicinu
From pakovanje amb, katalog k , stavka_dok sd
Where amb.proizvod = k.proizvod
  And DOBAVLJAC        = 342
  and amb.proizvod = sd.proizvod (+)
  and vrsta_dok        = 10
  and broj_dok  = 230







