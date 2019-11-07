select d.broj_dok,
       d.datum_dok, d.datum_unosa,
       to_number(d.ppartner) prt,
       pp.naziv prt_naz,
       sd.proizvod,
       p.naziv pro_naz,
       sd.kolicina*sd.faktor*sd.k_robe kol_sklad,
       nvl(sd.rabat,0) rab_proc,
       round(sd.cena,2) cena,
       sd.valuta val,
       round(sd.cena * (1 - nvl(sd.rabat,0)/100),4) CenaSaRab,
       round(nvl(sd.Z_Troskovi,0) / sd.kolicina,4) ZTro,
       round((sd.cena * (1 - nvl(sd.rabat,0)/100) +
                                   (nvl(sd.Z_Troskovi,0) / sd.kolicina)),4) CenaZtro
  from dokument d, stavka_dok sd, poslovni_partner pp, proizvod p
 where d.godina = sd.godina
   and d.vrsta_dok = sd.vrsta_dok
   and d.broj_dok  = sd.broj_dok
   and d.ppartner  = pp.sifra
--                                      and d.datum_dok between DatOd and DatDo
   and d.vrsta_dok   = '3'
   and d.tip_dok in ('10','16')
   AND d.STATUS in ('-8','-9','1','5')
   and sd.proizvod = p.sifra
--   and p.tip_proizvoda not in ('1','2')
   and p.sifra in (select ss.proizvod st_pro
                   from SASTAVNICA_ZAG sz
                      , SASTAVNICA_STAVKA ss, proizvod p1
					WHERE
					      upper(nvl(DEFAULT_PLAN,'N')) ='D'
					  and sz.broj_dok = ss.broj_dok
					  and p1.sifra = ss.proizvod
					  and p1.tip_proizvoda not in ('1','2')
				   group by ss.proizvod	
                  )
   and d.org_deo not in (select partner_magacin_flag.magacin
                                  from partner_magacin_flag)
   and (d.datum_dok, d.datum_unosa) in
       ( Select max(d1.datum_dok),max(d1.datum_unosa)
         From dokument d1, stavka_dok sd1
         where d1.godina = sd1.godina
           and d1.vrsta_dok = sd1.vrsta_dok
           and d1.broj_dok  = sd1.broj_dok
           and sd1.proizvod = sd.proizvod
           and d1.vrsta_dok   = '3'
           and d1.tip_dok in ('10','16')
           AND d1.STATUS in ('-8','-9','1','5')
       )

order by sd.proizvod, d.datum_dok desc, d.datum_unosa desc
