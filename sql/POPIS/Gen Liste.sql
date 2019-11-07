Declare

  nGodina Number := 2015;

  Cursor k0 IS

		Select rowid, d.POLJE1,POLJE2,polje3, polje4,polje5, POLJE39,POLJE40
		from deja_pomocna_tab d
		where polje39='100000'
		AND POLJE1 !='godina'
		and nvl(polje5,'NE')='NE'
	    AND POLJE1=TO_CHAR(nGodina)

	    AND POLJE2 IN('148','191','193','194')
		order by polje39, polje40,TO_NUMBER(POLJE2)



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
       Delete Za_Popise z where Org_Deo = kk0.polje3;
       commit;
       PGenerisanjePopisa.ProveriPostojecePopise( kk0.polje3,nGodina,nPopisna_Lista);
       Dbms_output.Put_line (
                                     rpad( kk0.polje3,7)
                             ||' '|| rpad( nPopisna_Lista,7)

       );

                  PGenerisanjePopisa.GenerisiZaglavljePopisa ( kk0.polje3,
                                                               to_date('31.12'||to_char(nGodina),'dd.mm.yyyy'), nGodina,
                                                               nPopisna_Lista );
                  Dbms_output.Put_line( 'GEN. ZAGLAV.'||nPopisna_Lista);

                  PGenerisanjePopisa.InicijalizujZa_Popise ( kk0.polje3,
                                                             to_date('31.12'||to_char(nGodina),'dd.mm.yyyy') );

                          cLokacija := '%';
                          cGrupa := '%';
                          cProizvod := '%';

                  PGenerisanjePopisa.GenerisiStavkePopisa ( nPopisna_Lista, nGodina,
                                                            kk0.polje3,
                                                            cLokacija, cGrupa, cProizvod );

	            UPDATE DEJA_POMOCNA_TAB
	            SET POLJE5='DA'
	            where polje39='100000'
			      AND POLJE1 !='godina'
	 		      and nvl(polje5,'NE')='NE'
			      AND POLJE1=TO_CHAR(nGodina)
			      AND POLJE3= KK0.POLJE3;


  end loop;
  close k0;
End;
