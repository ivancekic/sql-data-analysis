DECLARE
  cDodatniTip Varchar2(20);
  cBrojKalk   Varchar2(7);
  cBrojKalk1  Varchar2(7);
  cVrstaKalk  Varchar2(3);
  nRbr        Number := 1 ;
BEGIN
  Dbms_OutPut.Put_Line('r.br.'    ||' '||
                       '  god'    ||' '||
                       ' vr'      ||' '||
                       'brojdok'  ||' '||
                       ' org'     ||' '||
                       'dodtip'   ||' '||
                       'brojdok1' ||' '||
                       'vrK'      ||' '||
                       ' brKALK'  ||' '||
                       'brKALK1'  ||' '||
                       'user_id'
                      )  ;
  Dbms_OutPut.Put_Line('----- ----- --- ------- ---- ------ -------- --- ------- ------- ------------------------------');

  For kalk in (SELECT d.godina , d.vrsta_dok , d.broj_dok , d.org_Deo , od.DODATNI_TIP , d.broj_dok1 , D.USER_ID --,
               FROM dokument d , --VEZNI_DOK vd ,
                    org_deo_osn_podaci od
               WHERE d.godina = 2008  and d.vrsta_dok  IN (3)  And d.tip_dok = 10  And d.broj_Dok1 > 0
                 and od.DODATNI_TIP <> 'VP'
                 --  and vd.godina    (+) = d.godina  and vd.vrsta_dok (+) = d.vrsta_dok  and vd.broj_dok  (+) = d.broj_dok
                 and d.org_deo = od.org_Deo
                 and (d.godina , d.vrsta_dok , d.broj_dok) in (Select vd.godina , vd.vrsta_dok , vd.broj_dok
                                                               From Vezni_dok Vd
                                                               Where --vd.vrsta_dok = 3 and
                                                               vd.za_vrsta_dok not in (2,85,86)
                                                              )

               order by to_number (d.broj_dok )
              )
  Loop
--    If upper(kalk.DODATNI_TIP) IN ( 'VP2',) Then
  If upper(kalk.DODATNI_TIP) IN ( 'VP','VP2') Then
     cVrstaKalk := '85' ;
  ElsIf upper(kalk.DODATNI_TIP) IN ( 'NAB') Then
     cVrstaKalk := '86' ;
  End If;
  -- PAZI OVDE !!!
/*
       cBrojKalk  := To_Char( PSekvenca.NextVal( 'Broj_KALKULACIJE_VP_CENE', kalk.godina ) );
       cBrojKalk1 := To_Char( PSekvencaOrg.NextVal( 'Broj_KALKULACIJE_VP_CENE', kalk.godina ,kalk.org_Deo) );
       cVrstaKalk := '85';
       Insert Into Dokument ( VRSTA_DOK  , BROJ_DOK  , GODINA            , TIP_DOK , DATUM_DOK , DATUM_UNOSA , USER_ID            , STATUS ,
                              ORG_DEO , BROJ_DOK1 )
                   VALUES   ( cVrstaKalk , cBrojKalk , kalk.godina, 99      , SYSDATE   , SYSDATE     , kalk.USER_id , 1      ,
                              kalk.org_Deo , cBrojKalk1);
       -- sada regulise stanje u tabeli veza
       -- prvo veza PRIJEMNICA (sifra=3) - kalkulacija VP cene ( sifra = 85 ili 86 )
       PvezniDok.DodajPar( '3'        , kalk.godina , kalk.broj_dok,
                           cVrstaKalk , kalk.godina , cBrojKalk );
       Commit;
*/
       Dbms_OutPut.Put_Line(lpad(to_char(nRbr),5)         ||' '||
                            lpad(to_char(kalk.godina),5)  ||' '||
                            lpad(kalk.vrsta_dok,3)        ||' '||
                            lpad(kalk.broj_dok,7)         ||' '||
                            lpad(to_char(kalk.org_Deo),4) ||' '||
                            lpad(kalk.DODATNI_TIP,6)      ||' '||
                            lpad(kalk.broj_dok1,8)        ||' '||
                            lpad(cVrstaKalk,3)            ||' '||
                            lpad(nvl(cBrojKalk,'       '),7)             ||' '||
                            lpad(nvl(cBrojKalk1,'       '),7)            ||' '||
                            rpad(kalk.USER_id,30)
                       ) ;
       nRbr := nRbr + 1 ;
 --   End If;

  End Loop;
END;
