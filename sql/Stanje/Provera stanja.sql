select ORG_DEO,DAT_PS,PROIZVOD,STANJE,KONTROLNA,z_STANJE,z_REZ
from
(
select m.ORG_DEO,m.DAT_PS,m.PROIZVOD,m.STANJE,m.KONTROLNA
, z.STANJE z_stanje,z.REZERVISANA z_rez
from
(
	select m.ORG_DEO,m.DAT_PS
	     , sd.Proizvod
	     , Sum( Round( Decode( d.Vrsta_Dok || Tip_Dok,
	                              '314', Kolicina,
	                              '414', Kolicina,
	                              Realizovano ) * Faktor * K_Robe, 5 ) ) Stanje

--	     , case when K_REZ = 1 and d.status in (1,3) Then
--	            Sum( Round( Decode( d.Vrsta_Dok || Tip_Dok,
--	                              '314', Kolicina,
--	                              '414', Kolicina,
--	                              Realizovano ) * Faktor * K_Robe, 5 ) )
--
--	       end                       Rez

	     , Sum( Round( NVL(Kolicina_Kontrolna, 0 ) * K_Robe, 5 ) ) Kontrolna
	from
	(
	Select distinct org_deo
	     , nvl((Select max(datum_dok) dat_ps From dokument d1
	             where d1.godina= 2012 and d1.vrsta_Dok = '21' and d1.status > 0 and d1.status <> 4
	               and d1.org_deo=d.org_Deo
	           )
--	          ,to_date('01.01.2012','dd.mm.yyyy')
,(

      Select NVL( Min( Datum_Dok ), to_date('01.01.2012','dd.mm.yyyy') )

      From Dokument d1
      Where d1.org_deo=d.org_Deo And
            d1.Status > 0 And
            d1.Datum_Dok <= to_date('31.12.2012','dd.mm.yyyy')
            and d.vrsta_dok not in('2','9','10')
)
	          )  dat_ps
	From dokument d
	where godina = 2012
	  and org_Deo not in (select magacin from partner_magacin_flag)
	) m
	, (select * from dokument where godina = 2012 And Status > 0) d
	, (Select * from Stavka_Dok where godina = 2012 and k_robe <>0) sd
	where m.org_deo =  d.org_Deo
	  and m.dat_ps  <= d.datum_dok

	  and d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok = sd.Broj_Dok And d.Godina = sd.Godina
	Group By m.ORG_DEO,m.DAT_PS,Proizvod--,K_REZ
) m
, zalihe z
where m.org_deo= z.org_Deo    (+)
  and m.proizvod = z.proizvod (+)

) m
where org_Deo = 20
--where  STANJE<>Z_STANJE
Order by m.ORG_DEO,m.DAT_PS,m.Proizvod
