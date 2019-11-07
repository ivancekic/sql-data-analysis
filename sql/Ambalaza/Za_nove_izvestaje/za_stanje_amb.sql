Select d.status st, d.godina god,
       d.vrsta_dok vrd, pvrstadok.naziv(d.vrsta_Dok) naziv,
       d.broj_dok brd,
       d.tip_dok tip, pnacinfakt.naziv(d.tip_dok) naziv,
       d.org_deo mag, d.broj_dok1 brd1,
       d.ppartner ppar,d.pp_isporuke ppisp,d.mesto_isporuke misp,
       sd.proizvod pro, sd.cena, sd.kolicina kol, sd.faktor fak, sd.k_robe kr, sd.cena1,
       sd.kolicina * sd.faktor * sd.k_robe kol_ui, sd.kolicina * sd.faktor * sd.k_robe * sd.cena1 vred_ui
from dokument d, stavka_dok sd, proizvod p
where d.godina   = 2009 and d.status > 0
--  and d.vrsta_dok in (13)
--  and d.vrsta_dok not in (3,4,5,11,13,31,30)
  and d.ppartner = 2844
  and p.tip_proizvoda = 8
  AND D.ORG_DEO IN 3016
--  and (d.vrsta_dok,d.tip_dok) in (select  3, 15 from dual     -- prijemnica           --  prijem ambalaze
--                                  Union
--                                  select  4, 15 from dual     -- storno prijemnica    --  prijem ambalaze
--                                  Union
--                                  select 13, 401 from dual    -- povratnica po otp    --  povrat.amb. od kupca
--                                  Union
--                                  select  5, 301 from dual    -- povratnica po prijem --  pov amb dobavljacu
--                                  Union
--                                  select 31, 401 from dual    -- povratnica po otpre  --  povrat.amb. od kupca
--                                  Union
--                                  select 30, 301 from dual    -- storno pov. po prije --  povrat.amb. dobavlj.
--                                  )
  and d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  and p.sifra  = sd.proizvod
  and to_char(d.datum_unosa,'DD.mm.YYYY HH24:MI:SS') > '19.06.2009 13:48:19'
order by d.rowid

