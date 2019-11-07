Select BROJ_DOK,VRSTA_DOK,GODINA,STAVKA,PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,TIP,OPIS
     , tr.NAZIV
from
(
	Select sd.BROJ_DOK,sd.VRSTA_DOK,sd.GODINA,sd.STAVKA,sd.PROIZVOD,sd.LOT_SERIJA,sd.ROK,sd.KOLICINA,sd.JED_MERE,sd.CENA
	     , r.tip, r.opis
	from stavka_dok sd, reklamacija r
	where sd.godina = 2012
	  and sd.vrsta_Dok = 5
	  and sd.broj_dok in (511,513,514,515,517,518,519)
	  --511  -- 108 istekao rok
	  --513  -- 108 istekao rok
	  --514  -- 108 istekao rok
	  --515  -- 105 ostecena roba
	  --517  -- 102 odbijena isporuka
	  --518  -- 108 istekao rok
	  --519  -- 108 istekao rok

--	  and sd.broj_dok = 519



	  and sd.broj_dok=r.broj_dok (+)
	  and sd.vrsta_dok=r.vrsta_dok (+)
	  and sd.godina=r.godina       (+)


) sdr
, TIP_REKLAMACIJE tr
where sdr.tip=tr.sifra (+)
