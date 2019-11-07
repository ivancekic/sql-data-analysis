SELECT DISTINCT D.VRSTA_DOK, ZA_VRSTA_DOK, d1.tip_dok
FROM DOKUMENT D
   , (SELECT * FROM VEZNI_DOK WHERE ZA_VRSTA_DOK IN ('4','5','30')) VD
   , (SELECT * FROM DOKUMENT WHERE VRSTA_DOK IN ('4','5','30')
)D1
WHERE D.VRSTA_DOK = '3'
  and d.tip_dok = 10
  and d.status > 0

  and VD.godina = d.godina and VD.vrsta_dok = d.vrsta_dok and VD.broj_dok = d.broj_dok
  and d1.godina = Vd.ZA_godina and d1.vrsta_dok = Vd.ZA_vrsta_dok and d1.broj_dok = Vd.ZA_broj_dok
  and d1.tip_dok <> 301
order by za_vrsta_Dok
