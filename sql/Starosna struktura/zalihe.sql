select p.grupa_proizvoda gr, grp.naziv gr_naz
     , p.posebna_grupa prg, pg.naziv pgr_naz
     , ORG_DEO,PROIZVOD,p.naziv, MIN_KOL,MAX_KOL,KOL_NAR,STANJE,REZERVISANA,OCEKIVANA

from zalihe z, proizvod p, GRUPA_PR grp, POSEBNA_GRUPA pg
where p.sifra = z.proizvod
  and
  (    p.posebna_grupa in ( 19, -- Rezervni delovi MEHANICKI
                           159  -- Rezervni delovi ELEKTRONSKI
                          )
    or p.grupa_proizvoda = 14	-- Rezervni delovi za POGON
  )

and pg.grupa = p.posebna_grupa
and grp.id = p.grupa_proizvoda
and stanje - rezervisana > 0
