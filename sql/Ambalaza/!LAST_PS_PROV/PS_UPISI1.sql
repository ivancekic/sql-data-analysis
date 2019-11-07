Declare
    Cursor MagaciniPS_cur  

    Cursor AmbPS_Cur IS
	Select ORG_DEO,SIFRA partner,NAZIV_PARTNER,PROIZVOD,PRO_NAZIV,ULAZ,IZLAZ,STANJE,JEDMERE,plan_cena,ps_amb_brd, ps_amb_max_st, PS_AMB_KOL from
	(
	select  d.org_deo
	     , pp.sifra, pp.naziv  naziv_partner
	     , sd.Proizvod
	     , P.Naziv pro_naziv
	     , ( Sum ( sd.Kolicina * sd.Faktor * Decode( sd.K_Robe, 1, 1, 0 ) ) ) Ulaz
	     , ( Sum ( sd.Kolicina * sd.Faktor * Decode( sd.K_Robe, -1, 1, 0 ) ) ) Izlaz
	     , ( Sum ( sd.Kolicina * sd.Faktor * sd.K_Robe ) ) Stanje
	     , p.Jed_Mere JedMere

	     ,PPlanskiCenovnik.Cena( sd.Proizvod, To_Date('01.01.2010','dd.mm.yyyy') , 'YUD' ,1 )  plan_cena
	    , (Select d1.broj_Dok
	       From dokument d1
	       Where d1.org_deo in (select magacin from partner_magacin_flag)
	         and d1.vrsta_Dok = '21'
	         and d1.godina = '2010'
	         and d1.datum_dok = To_Date('01.01.2010','dd.mm.yyyy')
	         and d.org_deo   = D1.org_deo
	      ) ps_amb_brd

	    , (Select max(stavka)
	       From dokument d1 , stavka_dok sd1
	       Where d1.godina = sd1.godina and d1.vrsta_dok = sd1.vrsta_dok and d1.broj_dok = sd1.broj_dok
	         and d1.org_deo in (select magacin from partner_magacin_flag)
	         and d1.vrsta_Dok = '21'
	         and d1.godina = '2010'
	         and d1.datum_dok = To_Date('01.01.2010','dd.mm.yyyy')
	         and d.org_deo   = D1.org_deo
	      ) ps_amb_max_st

	    , (Select sd1.kolicina * sd1.k_robe
	       From dokument d1 , stavka_dok sd1
	       Where d1.godina = sd1.godina and d1.vrsta_dok = sd1.vrsta_dok and d1.broj_dok = sd1.broj_dok
	         and d1.org_deo in (select magacin from partner_magacin_flag)
	         and d1.vrsta_Dok = '21'
	         and d1.godina = '2010'
	         and d1.datum_dok = To_Date('01.01.2010','dd.mm.yyyy')
	         and d.org_deo   = D1.org_deo
	         and sd.proizvod = SD1.proizvod
	      ) ps_amb_kol

	from dokument d, stavka_dok sd, PROIZVOD P, GRUPA_PR  GPR, poslovni_partner pp
	Where
	  -- veza tabela
	      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
	  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
	  and d.datum_dok Between To_Date('01.01.2009','dd.mm.yyyy') and to_date('31.12.2009','dd.mm.yyyy')
	  and pp.sifra = d.ppartner
	  and d.org_deo in (select magacin from partner_magacin_flag)
	  -----------------------------
	  And sd.K_Robe != 0

	Group by  d.org_deo, pp.sifra, pp.naziv, sd.Proizvod, P.Naziv,p.Jed_Mere
	--,ps_amb.Pro, ps_amb.kol,ps_amb.d1_dat,ps_amb.d1_datu
	)
	where
	stanje <> nvl(ps_amb_kol,-123456789)
	and stanje <> 0
	and PS_AMB_BRD is not null
	--and sifra = 267
	Order by to_number(ps_amb_brd);

    AmbPS AmbPS_Cur % ROwType;


    Cursor AmbStavka_cur(cBrd Varchar2) Is
    	   Select max(stavka)
	       From stavka_dok d1
	       Where d1.vrsta_Dok = '21'
	         and d1.godina = '2010'
	         and d1.broj_dok = cBrd;
    nStavMax Number;

    nKol Number;
    nKR  Number;


  Cursor Mag_cur is
	select org_deo from dokument
	where (BROJ_DOK,VRSTA_DOK,GODINA) in
	(
	Select BROJ_DOK,VRSTA_DOK,GODINA
	from stavka_dok
	where PROC_VLAGE = 10
	);

  nMag NUmber;

Begin
  Open AmbPS_Cur;
  LOOP
  FETCH AmbPS_Cur INTO AmbPS ;
  EXIT WHEN AmbPS_Cur % NOTFOUND ;

	  Open AmbStavka_cur(AmbPS.ps_amb_brd);
	  FETCH AmbStavka_cur INTO nStavMax ;
		If AmbStavka_cur % NOTFOUND Then  -- ako pravo ne postoji
           nStavMax := 0;
    	End If;
	  Close AmbStavka_cur;
      nStavMax := nStavMax + 1 ;
	  Dbms_output.put_line(' Stavka '|| nStavMax );
	  If AmbPS.STANJE > 0 then
	  	nKr := 1;
	  Else
	  	nKr := -1;
	  End If;

	  nKol := abs(AmbPS.STANJE);

	  Insert into stavka_Dok (        BROJ_DOK, VRSTA_DOK, GODINA,   STAVKA,       PROIZVOD, KOLICINA, JED_MERE
	                           ,            CENA, VALUTA, LOKACIJA, K_REZ,K_ROBE, K_OCEK, KONTROLA, FAKTOR, REALIZOVANO,PROC_VLAGE )
	              Values     (AmbPS.ps_amb_brd,      '21',   2010, nStavMax, AmbPS.PROIZVOD,     nKol,    'kom'
	                           , AmbPS.plan_cena,  'YUD',        1,     0,   nKR,      0,        1,      1,        nKol, 10);
      commit;

  End Loop;
  Close AmbPS_Cur;
  
  Open Mag_cur;
  FETCH Mag_cur INTO nMag;
	If Mag_cur % NOTFOUND Then  -- ako pravo ne postoji
          GenerisiStanjeZaliha(nMag,sysdate,true);
   	End If;
  Close Mag_cur;
  

End;
