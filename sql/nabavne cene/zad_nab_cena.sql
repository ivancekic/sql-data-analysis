select d.broj_dok,
       d.datum_dok, d.datum_unosa,
       to_number(d.ppartner) prt,
       pp.naziv prt_naz,
       sd.proizvod,
       p.naziv pro_naz,
       sd.kolicina*sd.faktor*sd.k_robe kol_sklad,
--       round(sd.cena*decode(nvl(sd.rabat,0),0,1,(1+sd.rabat/100)),2),
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
   and d.tip_dok in ('10','12')
   AND d.STATUS in ('-8','-9','1','5')
   and sd.proizvod = p.sifra
   and p.sifra = 18665
   and d.org_deo not in (select partner_magacin_flag.magacin
                                  from partner_magacin_flag)

order by d.datum_dok desc, d.datum_unosa desc
