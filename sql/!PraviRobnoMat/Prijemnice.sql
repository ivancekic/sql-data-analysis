--insert into stavka_dok
--(
select '5626','3',2009,STAVKA,PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA,PAKOVANJE,
       BROJ_KOLETA,K_REZ,K_ROBE * -1,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,
       CENA1,Z_TROSKOVI,NETO_KG,PROC_VLAGE,PROC_NECISTOCE,HTL
from Stavka_dok
Where godina    = 2009
  and vrsta_dok = 11
  and broj_dok  = 4104
--)
--order by rownum--z.org_deo, to_number(p.sifra)
