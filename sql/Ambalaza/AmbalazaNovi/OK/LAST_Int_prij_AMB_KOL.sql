select D.STATUS,D.TIP_DOK , D.GODINA , D.VRSTA_DOK , D.BROJ_DOK, D.ORG_DEO , D.BROJ_DOK1,

       SD.PROIZVOD, SD.KOLICINA,K_ROBE,SD.FAKTOR--,SD.REALIZOVANO --SD.CENA, SD.CENA1 --, SD.*
        , VD.GODINA , VD.ZA_VRSTA_DOK , VD.ZA_BROJ_DOK
from   dokument d , stavka_dok sd , VEZNI_DOK VD --, VEZNI_DOK VD1
Where
  -- veza tabela
      sd.godina    (+)= d.godina
  and sd.vrsta_dok (+)= d.vrsta_dok
  and sd.broj_dok  (+)= d.broj_dok

  and vd.godina    = d.godina
  and vd.vrsta_dok = d.vrsta_dok
  and vd.broj_dok  = d.broj_dok


--  and vd.ZA_godina    = Vd1.godina
--  and vd.ZA_vrsta_dok = Vd1.vrsta_dok
--  decode(vd.vrsta_dok,             24,11,
--             11) = d.vrsta_dok
--  and vd.ZA_broj_dok  = Vd1.broj_dok

 -----------------------------
  -- ostali uslovi
  and d.godina = 2007
  and ( d.vrsta_dok ||','||d.tip_dok ) in
                          -- interne prijemnice i sve vezano za njih
                          (
                            select ('3,12') from dual
                            union
                            select ('4,12') from dual
                          )
  AND SD.PROIZVOD = '0333901'
order by
--D.GODINA , TO_NUMBER(D.VRSTA_DOK),
to_number(d.broj_dok)
