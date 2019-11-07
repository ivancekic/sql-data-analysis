Select d.status st, d.godina god,
       d.vrsta_dok vrd, pvrstadok.naziv(d.vrsta_Dok) naziv,
       d.broj_dok brd,
       d.tip_dok tip, pnacinfakt.naziv(d.tip_dok) naziv,
       d.org_deo mag, d.broj_dok1 brd1,
       d.ppartner ppar,d.pp_isporuke ppisp,d.mesto_isporuke misp,
       sd.proizvod pro,nvl(sd.cena,PPlanskiCenovnik.Cena(sd.Proizvod ,d.Datum_Dok,'YUD', sd.faktor )) cena, sd.kolicina kol, sd.faktor fak,
       case when d.tip_dok = 203 Then
                 sd.k_robe * -1
            when d.tip_dok = 402 Then
                 sd.k_robe * -1
            else
                 sd.k_robe
       end k_r,
       nvl(sd.cena1,PPlanskiCenovnik.Cena(sd.Proizvod ,d.Datum_Dok,'YUD', 1 )) cena1,
       sd.kolicina * sd.faktor * (case when d.tip_dok = 203 Then
                                            sd.k_robe * -1
                                       when d.tip_dok = 402 Then
                                            sd.k_robe * -1
                                       else
                                            sd.k_robe
                                   end )
                                    kol_ui,
       sd.kolicina * sd.faktor * (case when d.tip_dok = 203 Then
                                            sd.k_robe * -1
                                       when d.tip_dok = 402 Then
                                            sd.k_robe * -1
                                       else
                                            sd.k_robe
                                   end ) * nvl(sd.cena1,PPlanskiCenovnik.Cena(sd.Proizvod ,d.Datum_Dok,'YUD', 1 )) vred_ui
from dokument d, stavka_dok sd, proizvod p
where d.godina   = 2009 and d.status > 0
  and d.ppartner = 2844
  and p.tip_proizvoda = 8
  AND D.ORG_DEO IN 3016
--  and sd.proizvod = 3190
--  and d.vrsta_dok in( 11, 12, 13, 31)
  and (d.vrsta_dok,d.tip_dok) not in 
                                 (
                                  --IZLAZ AMBALAZE UZ ROBU
                                  select  3, 15 from dual     -- prijemnica           --  prijem ambalaze
                                  Union
                                  select  4, 15 from dual     -- storno prijemnica    --  prijem ambalaze
                                  Union
                                  select  5, 301 from dual    -- povratnica po prijem --  pov amb dobavljacu
                                  Union
                                  select 30, 301 from dual    -- storno pov. po prije --  povrat.amb. dobavlj.
                                  --ULAZ AMBALAZE -- RAZDUZENJE KUPCA
                                  Union
                                  select 63, 203 from dual    -- OTP AMB KUPAC --  KOMP. KROZ PROD.AMB.
                                  Union
                                  select 63, 203 from dual    -- OTP AMB KUPAC --  KOMP. KROZ PROD.AMB.
                                  Union
                                  select 64, 203 from dual    -- STORNO OTP AMB KUPAC --  KOMP. KROZ PROD.AMB.
                                  Union
                                  select 13, 402 from dual    -- POV PO OTP --  POV. AMB. KOMP I RAZD
                                  Union
                                  select 31, 402 from dual    -- STORNO POV PO OTP --  POV. AMB. KOMP I RAZD
                                  )
  and d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  and p.sifra  = sd.proizvod
order by d.rowid

