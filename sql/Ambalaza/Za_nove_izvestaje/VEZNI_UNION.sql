select VD.*
from vezni_dok VD, DOKUMENT D
where VD.za_vrsta_dok = 11
  and VD.vrsta_dok in (13,31)

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


  and vd.godina = d.godina and vd.vrsta_dok = d.vrsta_dok and vd.broj_dok = d.broj_dok
  AND D.PPARTNER = 406
UNION ALL
select VD1.BROJ_DOK, VD1.VRSTA_DOK, VD1.GODINA, VD1.BROJ_DOK, VD1.VRSTA_DOK, VD1.GODINA
from vezni_dok VD1, DOKUMENT D1
where VD1.vrsta_dok = 11
  and vd1.godina = d1.godina and vd1.vrsta_dok = d1.vrsta_dok and vd1.broj_dok = d1.broj_dok
  AND D1.PPARTNER = 406
--  and (d1.vrsta_dok,d1.tip_dok) in (select  3, 15 from dual     -- prijemnica           --  prijem ambalaze
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
