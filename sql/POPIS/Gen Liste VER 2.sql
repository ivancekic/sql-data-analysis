Declare

  nGodina Number := 2014;

  Cursor k0 IS

			select POLJE1,POLJE2,POLJE3, polje4, polje5, POLJE6 , polje39,polje40
				 , p.status, P.POPISNA_LISTA
                 , (SELECT STANJE FROM SEKVENCA WHERE GODINA = nGodina AND NAZIV ='POPISNA_LISTA') S
			from deja_pomocna_tab d
			   ,(select * from popis
                 where godina = nGodina  AND STATUS < 4
                )p
			where polje39='100001'
			  and polje1<>'Rb'
			  and nvl(POLJE4,'NE')='NE'
			  and POLJE7=TO_CHAR(nGodina)
	    AND POLJE2 IN(
	    '184'
--	    ,'191','193','194'
	    )
	           and p.org_deo (+) =d.polje2

			order by polje40, to_number(polje1)

		;

  KK0 K0 % Rowtype;


--  nBroj_Popisa Number;

  nPopisna_Lista Number;
  cLokacija Varchar2(10);
  cGrupa Varchar2(10);
  cProizvod Varchar2(10);
  nBroj_Stavki Number;

Begin

  cLokacija := null;
  cGrupa := null;
  cProizvod := null;

  Dbms_output.Put_line (
                                 rpad('Magacin',7)
                             ||' '|| rpad( 'Popis',7)
                                 );
  Dbms_output.Put_line (rpad('-',7,'-')
                        ||' '||   rpad('-',7,'-')


  );
  Open k0;
  loop
  fetch k0 into kk0;
  exit when k0 % NotFound;

  	DBMS_OUTPUT.PUT_LINE(KK0.POLJE2);
--    nPopisna_Lista := PSekvenca.NextVal( 'POPISNA_LISTA', nGodina) ;
    nPopisna_Lista := NVL(KK0.S,0) +1 ;
       Delete Za_Popise z where Org_Deo = kk0.polje2;
       commit;
--       PGenerisanjePopisa.ProveriPostojecePopise( kk0.polje2,nGodina,nPopisna_Lista);
       Dbms_output.Put_line (
                                     rpad( kk0.polje2,7)
                             ||' '|| rpad( nPopisna_Lista,7)

       );

		if kk0.POPISNA_LISTA IS NOT NULL then
			delete STAVKA_POPISA where godina = nGodina and POPISNA_LISTA = to_number(kk0.POPISNA_LISTA);
			delete POPIS where godina = nGodina and POPISNA_LISTA  = to_number(kk0.POPISNA_LISTA);
		delete Za_Popise where TO_CHAR(ORG_DEO)=kk0.polje2;
			commit;
		end if;



                  PGenerisanjePopisa.GenerisiZaglavljePopisa ( kk0.polje2,
                                                               to_date('31.12'||to_char(nGodina),'dd.mm.yyyy'), nGodina,
                                                               nPopisna_Lista );
                  Dbms_output.Put_line( 'GEN. ZAGLAV.'||nPopisna_Lista);

                  PGenerisanjePopisa.InicijalizujZa_Popise ( kk0.polje2,
                                                             to_date('31.12'||to_char(nGodina),'dd.mm.yyyy') );

                          cLokacija := '%';
                          cGrupa := '%';
                          cProizvod := '%';

                  PGenerisanjePopisa.GenerisiStavkePopisa ( nPopisna_Lista, nGodina,
                                                            kk0.polje2,
                                                            cLokacija, cGrupa, cProizvod );

	            UPDATE DEJA_POMOCNA_TAB
	            SET POLJE4='DA' , polje8= to_char(nPopisna_Lista)
	            where polje39='100001'
			      and polje1<>'Rb'
	 		      and polje2= KK0.polje2
	 		      AND POLJE7=TO_CHAR(nGodina)
				  and nvl(polje4,'NE')='NE'
	 		      ;
                UPDATE SEKVENCA SET STANJE = nPopisna_Lista WHERE GODINA = nGodina AND NAZIV ='POPISNA_LISTA';

  end loop;
  close k0;
End;
