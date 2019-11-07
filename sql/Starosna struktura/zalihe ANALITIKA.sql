select p.grupa_proizvoda gr, grp.naziv gr_naz
     , p.posebna_grupa prg, pg.naziv pgr_naz
     , z.ORG_DEO,z.PROIZVOD,p.naziv,z.LOKACIJA,z.LOT_SERIJA,z.ROK,z.KOLICINA
--,z.KOLICINA_KONTROLNA

from zalihe_analitika z, proizvod p, GRUPA_PR grp, POSEBNA_GRUPA pg
where p.sifra = z.proizvod
  and
  (    p.posebna_grupa in ( 19, -- Rezervni delovi MEHANICKI
                           159  -- Rezervni delovi ELEKTRONSKI
                          )
    or p.grupa_proizvoda = 14	-- Rezervni delovi za POGON
  )
and pg.grupa = p.posebna_grupa
and grp.id = p.grupa_proizvoda
and kolicina > 0
