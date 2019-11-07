select  *
from   stavka_dok
--update stavka_dok
--set lokacija = 1
Where godina = 2008
  and vrsta_dok  not IN ( 2 , 9 , 10 )
  and lokacija is null
  and ( godina , vrsta_dok , broj_dok ) in ( select sd.godina , sd.vrsta_dok , sd.broj_dok
                                               from dokument sd
                                              where  sd.godina = 2008
                                                and sd.vrsta_dok  not IN ( 2 , 9 , 10 )
                                                and sd.status != 0
                                            )

/
exec GenerisiStanjeZaliha(20,sysdate,true)
