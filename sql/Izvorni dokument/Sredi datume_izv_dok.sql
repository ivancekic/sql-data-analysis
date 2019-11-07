declare
    lPomocna Boolean;-- Zbog poziva funkcije iz baze

    nGodinaDok Number;
    cBrojDok VarChar2(20);

    nGodinaVeznog Number;
    cBrojVeznog VarChar2(20);

	cursor nadji_dok_cur is
		SELECT
	  		   D.GODINA,D.VRSTA_DOK,vrd.naziv naziv_vr,D.BROJ_DOK,D.TIP_DOK,D.DATUM_DOK,D.DATUM_UNOSA,D.USER_ID,D.PPARTNER,D.STATUS, D.BROJ_DOK1
	  		 , D.DATUM_IZVORNOG_DOK

		FROM dokument  d, vrsta_dok vrd
		WHERE vrd.vrsta=d.vrsta_Dok
		  and nvl(d.broj_dok,'-9998887') !='-9998888'
		  and D.VRSTA_DOK IN (     '4',  '5', '30'				-- PRIJEM ROBE
				                , '12', '13', '31'				-- OTPREMA ROBE
				                , '26', '45', '46'				-- PREDAJA ROBE IZ PROIZVODNJE U MAGACIN
				                , '27', '28', '32'				-- TREBOVANJE ROBE
				                , '74'							-- TRANZIT
				                , '90'							-- NIVELACIJE STAVKI - AUTOMATSKA
				               )
          and d.godina != 0
          and D.DATUM_IZVORNOG_DOK is null
		;
	nadji_dok nadji_dok_cur % rowtype;

	cursor nadji_vezni_cur(cBrd Varchar2, cVrd Varchar2, nGod Number) is
	  Select za_broj_dok, za_vrsta_dok, za_godina
	  From vezni_dok
	  Where Broj_dok= cBrd and Vrsta_dok=cVrd and Godina = nGod;
    nadji_vezni nadji_vezni_cur % rowtype;

    dDatIzvDok Date;
    nBrRedCommit Number;
begin
nBrRedCommit := 0;

    delete report_tmp_pdf;
    insert into report_tmp_pdf(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17)
                values(  '0RBR', 'GODINA', 'VRSTA_DOK', 'NAZIV_VR', 'BROJ_DOK', 'TIP_DOK', 'DATUM_DOK', 'DATUM_UNOSA', 'USER_ID'
                       , 'PPARTNER', 'STATUS', 'BROJ_DOK1', 'DATUM_IZVORNOG_DOK', 'ZA_BROJ_DOK', 'ZA_VRSTA_DOK', 'ZA_GODINA', 'DAT_IZV_DOK') ;


    open nadji_dok_cur;
    loop
    fetch nadji_dok_cur into nadji_dok;
    exit when nadji_dok_cur %NotFound;
         nBrRedCommit := nBrRedCommit + 1;
         -- PRIJEM ROBE
         if nadji_dok.VRSTA_DOK IN( '4','5','30') then
         lPomocna := PVezniDok.NadjiVezu( nadji_dok.vrsta_dok, nadji_dok.Godina, nadji_dok.Broj_Dok,
                                          '3', nGodinaVeznog, cBrojVeznog );
                     if nGodinaVeznog is not null and cBrojVeznog is not null Then
                        dDatIzvDok := Pdokument.MojeVratiDatum(nGodinaVeznog, cBrojVeznog, '3');
                     end if;
         -- OTPREMA ROBE
         elsif nadji_dok.VRSTA_DOK IN( '12','13','31') then
         lPomocna := PVezniDok.NadjiVezu( nadji_dok.vrsta_dok, nadji_dok.Godina, nadji_dok.Broj_Dok,
                                          '11', nGodinaVeznog, cBrojVeznog );
                     if nGodinaVeznog is not null and cBrojVeznog is not null Then
                        dDatIzvDok := Pdokument.MojeVratiDatum(nGodinaVeznog, cBrojVeznog, '11');
                     end if;
         -- PREDAJA ROBE IZ PROIZVODNJE U MAGACIN
         elsif nadji_dok.VRSTA_DOK IN( '26','45','46') then
         lPomocna := PVezniDok.NadjiVezu( nadji_dok.vrsta_dok, nadji_dok.Godina, nadji_dok.Broj_Dok,
                                          '1', nGodinaVeznog, cBrojVeznog );
                     if nGodinaVeznog is not null and cBrojVeznog is not null Then
                        dDatIzvDok := Pdokument.MojeVratiDatum(nGodinaVeznog, cBrojVeznog, '1');
                     end if;
         -- TREBOVANJE ROBE
         elsif nadji_dok.VRSTA_DOK IN( '27','28','32') then
         lPomocna := PVezniDok.NadjiVezu( nadji_dok.vrsta_dok, nadji_dok.Godina, nadji_dok.Broj_Dok,
                                          '8', nGodinaVeznog, cBrojVeznog );
                     if nGodinaVeznog is not null and cBrojVeznog is not null Then
                        dDatIzvDok := Pdokument.MojeVratiDatum(nGodinaVeznog, cBrojVeznog, '8');
                     end if;
         -- TRANZIT
         elsif nadji_dok.VRSTA_DOK IN( '74') then
         lPomocna := PVezniDok.NadjiVezu( nadji_dok.vrsta_dok, nadji_dok.Godina, nadji_dok.Broj_Dok,
                                          '73', nGodinaVeznog, cBrojVeznog );
                     if nGodinaVeznog is not null and cBrojVeznog is not null Then
                        dDatIzvDok := Pdokument.MojeVratiDatum(nGodinaVeznog, cBrojVeznog, '73');
                     end if;
         -- NIVELACIJE STAVKI - AUTOMATSKA
         elsif nadji_dok.VRSTA_DOK IN( '90') then
               open nadji_vezni_cur(nadji_dok.Broj_Dok, nadji_dok.vrsta_dok, nadji_dok.Godina);
               fetch nadji_vezni_cur into nadji_vezni;
                  lPomocna := PVezniDok.NadjiVezu( nadji_dok.vrsta_dok, nadji_dok.Godina, nadji_dok.Broj_Dok,
                                                   nadji_vezni.za_vrsta_dok, nadji_vezni.za_godina,nadji_vezni.za_Broj_dok );
                              if nGodinaVeznog is not null and cBrojVeznog is not null Then
                                 dDatIzvDok := Pdokument.MojeVratiDatum(nadji_vezni.za_godina,nadji_vezni.za_Broj_dok, nadji_vezni.za_vrsta_dok);
                              end if;
               close nadji_vezni_cur;
         end If;

         insert into report_tmp_pdf(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17)
                values(  1, nadji_dok.GODINA, nadji_dok.VRSTA_DOK, nadji_dok.NAZIV_VR, nadji_dok.BROJ_DOK, nadji_dok.TIP_DOK
                       , to_char(nadji_dok.DATUM_DOK,'dd.mm.yyyy'), to_char(nadji_dok.DATUM_unosa,'dd.mm.yyyy'), nadji_dok.USER_ID
                       , nadji_dok.PPARTNER, nadji_dok.STATUS, nadji_dok.BROJ_DOK1, to_char(nadji_dok.DATUM_IZVORNOG_DOK,'dd.mm.yyyy')
--                       , nadji_dok.ZA_BROJ_DOK, nadji_dok.ZA_VRSTA_DOK, nadji_dok.ZA_GODINA,
--                       to_char(nadji_dok.DATUM_IZV_DOK,'dd.mm.yyyy')
                       , null, null, null, to_char(dDatIzvDok,'dd.mm.yyyy')
                      ) ;
--         if dDatIzvDok is not null then
--            update dokument
--            set DATUM_IZVORNOG_DOK = dDatIzvDok
--            where broj_dok=nadji_dok.BROJ_DOK
--              and vrsta_dok = nadji_dok.VRSTA_DOK
--              and godina = nadji_dok.godina
--            ;
--         end if;
--
--         If nBrRedCommit > 200 then
--            commit;
--            nBrRedCommit := 0;
--         end If;
         dDatIzvDok := NULL;

    end loop;
    close nadji_dok_cur;

--    commit;
end;
