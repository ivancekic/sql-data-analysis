select 2009,PRT,PRO,ULAZ,IZLAZ,STANJE,MAG, nvl(POC_DATUM, to_date('01.01.0001','dd.mm.yyyy') ) p_datum
from
(
	--     GODINA ,                                  PARTNER,       PROIZVOD,
	select    2009, PPartnerMagacin.partner(z.org_Deo)   PRT, z.proizvod PRO,
   	                                                                    -- ### ULAZ
	                                                                    case when z.stanje < 0 then
	                                                                              z.stanje * -1
	                                                                    else 0 end ULAZ
	                                                                  ,
	                                                                    -- ### IZLAZ
	                                                                    case when z.stanje >= 0 then
	                                                                              z.stanje
	                                                                    else 0 end IZLAZ
	                                                                  , z.Stanje
         , org_Deo MAG
         , (Select Max(Datum_dok) from dokument where vrsta_dok = 21 and org_Deo = z.org_deo) poc_datum
	from zalihe z
	where z.org_deo in (select magacin from partner_magacin_flag)
)
	order by to_number(MAG)
