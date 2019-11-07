select PROIZVOD,KOL,NA_DAN, nvl(KOL,0)+nvl(NA_DAN,0) promena
from
(
	select proizvod

	 	   , sum(sd.kolicina* sd.faktor * k_robe) kol
 	       ,( Select sum(sd1.kolicina* sd1.faktor * sd1.k_robe ) kol
	   from dokument d1, stavka_dok sd1

	   Where
	      d1.godina = sd1.godina and d1.vrsta_dok = sd1.vrsta_dok and d1.broj_dok = sd1.broj_dok
	  and d1.datum_dok = to_date('30.06.2011','dd.mm.yyyy')
	  and sd1.proizvod = sd.proizvod
	  and d1.status > 0
	  AND D1.ORG_DEO = 104
	  and (sd1.k_robe <> 0 or d1.vrsta_Dok = 80)
	  ) na_dan
	from dokument d, stavka_dok sd

	Where
	  -- veza tabela
	      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
	  -----------------------------
	  -- ostali uslovi
	  and '2011' = d.godina
	  AND D.ORG_DEO = 104
	  and (k_robe <> 0 or d.vrsta_Dok = 80)
	  and d.datum_dok between to_date('01.01.2011','dd.mm.yyyy') and to_date('29.06.2011','dd.mm.yyyy')
	  and d.status > 0
	  and proizvod in('3184',
	'3185',
	'3186',
	'3190',
	'3197',
	'3198',
	'3199',
	'3200',
	'3201',
	'3202',
	'3208',
	'3209',
	'3210',
	'3214',
	'3215',
	'3216',
	'3217',
	'3218',
	'3219',
	'3220',
	'3221',
	'3222',
	'3765',
	'4047',
	'4049',
	'4050',
	'4051',
	'4073',
	'4082',
	'4083',
	'4084',
	'4085',
	'4086',
	'4088',
	'4089',
	'4090',
	'4091',
	'4093',
	'4094',
	'4095',
	'4104',
	'4105',
	'4193',
	'4194',
	'4195',
	'4196',
	'4197',
	'4199',
	'4200',
	'4202',
	'4203',
	'4206',
	'4207',
	'4208',
	'4210',
	'4211',
	'4212',
	'4213',
	'4214',
	'4299',
	'4300',
	'4301',
	'4395',
	'4396',
	'4397',
	'4538',
	'4550',
	'4551',
	'4552',
	'4553',
	'4706',
	'4707',
	'4708',
	'4709',
	'4710',
	'4711',
	'4714',
	'4726',
	'4731',
	'4802',
	'5187',
	'5686',
	'7943',
	'7983',
	'7984',
	'7985',
	'7986',
	'7987',
	'7989',
	'8456',
	'8680',
	'8681',
	'9438',
	'10621',
	'10655')
	Group by sd.proizvod
)
order by to_number(proizvod)
