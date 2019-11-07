--select GODINA,BROJ_DOK,vrsta_Dok
--,RABAT_kasa_old,RABAT_kasa_new
--from
--(
select vrsta_dok,GODINA,BROJ_DOK,ULAZNI,IZLAZNI,KOLICINA,CENA,FAKTOR,K_ROBE,RABAT,SPEC_RABAT,KASA,POREZ,AKCIZA,CENA1,Z_TROSKOVI,PROC_VLAGE,PROC_NECISTOCE,TAKSA,DATUM_DOK,VALUTA,ORG_DEO,PPARTNER
,VRED,RABAT_kasa_old,RABAT_kasa_new
from
(
	select D.GODINA,d.vrsta_dok
	     ,  D.BROJ_DOK, d.datum_unosa, d.broj_dok1
	     , case when d.vrsta_dok in (80,90) then
	                 1
                -- izlazni
	            when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then -- izlaz
	                 1
                -- ulazna
	            when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'D',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then --ulaz
	                 2
	       end nacin_obrac

	     , PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'D',d.datum_dok)                     ULAZNI
	     , 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) IZLAZNI
	     , SD.KOLICINA, SD.CENA, SD.FAKTOR, SD.K_ROBE, D.Spec_rabat,D.Kasa,SD.Porez, SD.Akciza,SD.Cena1, SD.Z_Troskovi
	     , case when d.vrsta_dok in (80,90) then
	                 1
                -- izlazni
	            when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                 -1
	            -- ulazni
	            when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'D',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                 1
	       end PlusMinus

	     , sd.rabat, sd.neto_kg, sd.htl, SD.PROC_VLAGE,SD.PROC_NECISTOCE,SD.Taksa,D.Datum_Dok,SD.VALUTA,D.Org_Deo,D.PPartner
,
        VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'VREDNOST',
                                  NVL(sd.Kolicina,0),
                                  NVL(sd.Cena,0)      ,
                                  NVL(sd.Faktor,0)    ,
                                  sd.k_robe    ,
                                  NVL(sd.Rabat,0)     ,
                                  NVL(D.Spec_rabat,0) ,
                                  NVL(D.Kasa,0)      ,
                                  sd.Porez     ,
                                  NVL(sd.Akciza,0)    ,
                                  NVL(sd.Cena1,0),
                                  NVL(sd.Z_TROSKOVI,0),
                           	      case when d.vrsta_dok in (80,90) then
	                                        1
                                       -- izlazni
	                                   when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                        -1
                                       -- ulazni
	                                   when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                        1
	                                   end --PlusMinus
                                  ,nvl(sd.proc_vlage,0)
                                  ,nvl(sd.proc_necistoce,0)

                                  ,nvl(sd.taksa,0)
                                  ,nvl(d.datum_dok,sysdate)

                                  ,nvl(sd.valuta,'YUD')
                                  ,d.vrsta_dok
                                  ,d.org_deo
                                  ,d.ppartner
                            )																										VRED
,
        -1* VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'RABAT_KASA',
                                  NVL(sd.Kolicina,0),
                                  NVL(sd.Cena,0)      ,
                                  NVL(sd.Faktor,0)    ,
                                  sd.k_robe    ,
                                  NVL(sd.Rabat,0)     ,
                                  NVL(D.Spec_rabat,0) ,
                                  NVL(D.Kasa,0)      ,
                                  sd.Porez     ,
                                  NVL(sd.Akciza,0)    ,
                                  NVL(sd.Cena1,0),
                                  NVL(sd.Z_TROSKOVI,0),
                           	      case when d.vrsta_dok in (80,90) then
	                                        1
                                       -- izlazni
	                                   when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                        -1
                                       -- ulazni
	                                   when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                        1
	                                   end --PlusMinus
                                  ,nvl(sd.proc_vlage,0)
                                  ,nvl(sd.proc_necistoce,0)

                                  ,nvl(sd.taksa,0)
                                  ,nvl(d.datum_dok,sysdate)

                                  ,nvl(sd.valuta,'YUD')
                                  ,d.vrsta_dok
                                  ,d.org_deo
                                  ,d.ppartner
                            )																										RABAT_kasa_new
, NVL(round(nvl(sign(sd.K_ROBE)*sd.KOLICINA*DECODE(sd.VRSTA_DOK,'90',0,sd.K_ROBE)*
                                 sd.cena
                               * sd.rabat/100
                               * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok)*(-1),0),2) ,0 ) 			rabat_kasa_old


--,
--        -1* VrednostiNaStavkama_new( 1,
--                                  'RABATOSN',
--                                  NVL(sd.Kolicina,0),
--                                  NVL(sd.Cena,0)      ,
--                                  NVL(sd.Faktor,0)    ,
--                                  sd.k_robe    ,
--                                  NVL(sd.Rabat,0)     ,
--                                  NVL(D.Spec_rabat,0) ,
--                                  NVL(D.Kasa,0)      ,
--                                  sd.Porez     ,
--                                  NVL(sd.Akciza,0)    ,
--                                  NVL(sd.Cena1,0),
--                                  NVL(sd.Z_TROSKOVI,0),
--                           	      -1
--                                  ,nvl(sd.proc_vlage,0)
--                                  ,nvl(sd.proc_necistoce,0)
--
--                                  ,nvl(sd.taksa,0)
--                                  ,nvl(d.datum_dok,sysdate)
--
--                                  ,nvl(sd.valuta,'YUD')
--                                  ,d.vrsta_dok
--                                  ,d.org_deo
--                                  ,d.ppartner
--                            )																										RAB_OSN_N
--,
--        -1* VrednostiNaStavkama_new(
--                                    1 , -- NACIN_OBRACUNA
--                                  'RABATAKC',
--                                  NVL(sd.Kolicina,0),
--                                  NVL(sd.Cena,0)      ,
--                                  NVL(sd.Faktor,0)    ,
--                                  sd.k_robe    ,
--                                  NVL(sd.Rabat,0)     ,
--                                  NVL(D.Spec_rabat,0) ,
--                                  NVL(D.Kasa,0)      ,
--                                  sd.Porez     ,
--                                  NVL(sd.Akciza,0)    ,
--                                  NVL(sd.Cena1,0),
--                                  NVL(sd.Z_TROSKOVI,0),
--                           	      -1 --PlusMinus
--                                  ,nvl(sd.proc_vlage,0)
--                                  ,nvl(sd.proc_necistoce,0)
--
--                                  ,nvl(sd.taksa,0)
--                                  ,nvl(d.datum_dok,sysdate)
--
--                                  ,nvl(sd.valuta,'YUD')
--                                  ,d.vrsta_dok
--                                  ,d.org_deo
--                                  ,d.ppartner
--                            )																										RAB_AKC_N
--,
--        -1* VrednostiNaStavkama_new(
--                                    1  , -- NACIN_OBRACUNA
--                                  'RABATNAC',
--                                  NVL(sd.Kolicina,0),
--                                  NVL(sd.Cena,0)      ,
--                                  NVL(sd.Faktor,0)    ,
--                                  sd.k_robe    ,
--                                  NVL(sd.Rabat,0)     ,
--                                  NVL(D.Spec_rabat,0) ,
--                                  NVL(D.Kasa,0)      ,
--                                  sd.Porez     ,
--                                  NVL(sd.Akciza,0)    ,
--                                  NVL(sd.Cena1,0),
--                                  NVL(sd.Z_TROSKOVI,0),
--                           	      -1 --PlusMinus
--                                  ,nvl(sd.proc_vlage,0)
--                                  ,nvl(sd.proc_necistoce,0)
--
--                                  ,nvl(sd.taksa,0)
--                                  ,nvl(d.datum_dok,sysdate)
--
--                                  ,nvl(sd.valuta,'YUD')
--                                  ,d.vrsta_dok
--                                  ,d.org_deo
--                                  ,d.ppartner
--
--                            )																										RAB_NAC_N
--,
--        -1* VrednostiNaStavkama_new(
--                                    1 , -- NACIN_OBRACUNA
--                                  'KASA',
--                                  NVL(sd.Kolicina,0),
--                                  NVL(sd.Cena,0)      ,
--                                  NVL(sd.Faktor,0)    ,
--                                  sd.k_robe    ,
--                                  NVL(sd.Rabat,0)     ,
--                                  NVL(D.Spec_rabat,0) ,
--                                  NVL(D.Kasa,0)      ,
--                                  sd.Porez     ,
--                                  NVL(sd.Akciza,0)    ,
--                                  NVL(sd.Cena1,0),
--                                  NVL(sd.Z_TROSKOVI,0),
--                           	      -1 --PlusMinus
--                                  ,nvl(sd.proc_vlage,0)
--                                  ,nvl(sd.proc_necistoce,0)
--
--                                  ,nvl(sd.taksa,0)
--                                  ,nvl(d.datum_dok,sysdate)
--
--                                  ,nvl(sd.valuta,'YUD')
--                                  ,d.vrsta_dok
--                                  ,d.org_deo
--                                  ,d.ppartner
--                            )																										KASA
	from dokument d, stavka_dok sd --, PROIZVOD P , GRUPA_PR  GPR
	Where d.godina=2011
	  AND D.ORG_DEO = 104
	  -- veza tabela
	  and  d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
	  and (k_robe <>0 or d.vrsta_Dok = 80)


	  and d.datum_dok = to_date('30.06.2011','dd.mm.yyyy')

--	  and d.vrsta_Dok = 80
--      and (
--              (d.vrsta_dok = 11 and d.broj_dok='14037')
--              or
--              (d.vrsta_dok = 3 and d.broj_dok='8568')
--              or
--              (d.vrsta_dok = 5 and d.broj_dok='1847')
--              or
--              (d.vrsta_dok = 12 and d.broj_dok='87')
--          )
--
)
order by datum_dok,datum_unosa
--)
--where
--RABAT_kasa_old<>RABAT_kasa_new
----vrsta_dok not in (80,90)
