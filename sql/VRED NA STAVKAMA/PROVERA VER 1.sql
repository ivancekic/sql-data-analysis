select D.GODINA,d.vrsta_dok, D.BROJ_DOK, d.datum_unosa, D.ORG_DEO, d.broj_dok1
     ,
     -1 * VrednostiNaStavkama_new(
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
     -1 * VrednostiNaStavkama_new(
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
,
     -1 * VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'RABATOSN',
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
                            )																										RABAT_OSN
,
     -1 * VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'RABATAKC',
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
                            )																										RABAT_AKC
,
     -1 * VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'RABATNAC',
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
                            )																										RABAT_NAC
,
     -1 * VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'KASA',
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
                            )																										KASA
,
     -1 * VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'OSNOVICA',
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
                            )																										PDV_OSN
,
     -1 * VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'PDV_IZNOS',
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
                            )																										PDV_IZN

,
     -1 * VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'ZAVISNI_TROSKOVI',
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
                            )																										ZAV_TRO
,
     -1 * VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'RAZLIKA_U_CENI',
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
                            )																										RUC
,
     -1 * VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) * SIGN(sd.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'MAGACINSKA_VREDNOST',
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
                            )																										MAG_VRED

, SD.PROIZVOD, SD.CENA, SD.FAKTOR, SD.CENA1
	from dokument d, stavka_dok sd --, PROIZVOD P , GRUPA_PR  GPR
	Where d.godina=2012
	  and  d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
	  and (k_robe <>0 or d.vrsta_Dok = 80)
      AND D.VRSTA_DOK=13 AND D.BROJ_DOK IN (6,7)

order by datum_dok,datum_unosa
