Create table stavka_dok_bckp_amb as

Select *
--delete
from
stavka_dok
Where (godina,vrsta_dok,broj_dok) in (Select godina ,vrsta_dok,broj_dok
                                      From Dokument
                                      Where datum_dok <= to_date('31.12.2007','dd.mm.yyyy')
                                        and org_deo not in (135)
                                        and org_deo not in (select magacin from partner_magacin_flag)
                                    )
  and proizvod = '0333901'
