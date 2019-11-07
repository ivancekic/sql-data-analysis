select '4104',	'11',	2009,
       rownum, z.proizvod, null, null, z.stanje, p.jed_mere,
       OdgovarajucaCena(Z.Org_deo , Z.proizvod , SYSDATE, 1, 'YUD',0),
       'YUD',1,null,null,0,-1,0,1,1,Z.STANJE,0,0,null,null,null,
       OdgovarajucaCena(Z.Org_deo , Z.proizvod , SYSDATE, 1, 'YUD',0),
null,null,null,null,null
from zalihe z, PROIZVOD P
Where z.PROIZVOD = P.SIFRA
 -----------------------------
  -- ostali uslovi
  and z.org_deo in (219,220,221) and p.posebna_grupa = 80
order by rownum--z.org_deo, to_number(p.sifra)
