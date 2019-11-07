Create or replace Package Body PCena1MagVP4 Is
--   nDUMMY Number;
--   lPostoji Boolean;
   -- funkcija vraca naziv jedinice mere cija SIFRA je prosledjena kao parametar
   -- ili NULL ako ne postoji jedinica sa prosledjenom sifrom
   Function MagVP4Cena1( nOrgDeo Number, cProizvod Varchar2 ) Return Number Is
      -- kursor za pretrazivanje
    Cursor NadjiDokVP4_cur Is
    Select maxdat,god, vrd, maxbrd, pro
    From
    (
      Select datum_dok maxdat, d.godina god, d.vrsta_dok vrd, max(to_number(d.broj_dok)) maxbrd, proizvod pro
      From stavka_dok sd, dokument d
      Where sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
        and d.org_deo = nOrgDeo and d.vrsta_dok = 3 and sd.Proizvod = cProizvod and d.status in (1,5)
      Group by d.godina, d.vrsta_dok, datum_dok, proizvod

      Union

      Select datum_dok maxdat, d.godina god, d.vrsta_dok vrd, max(to_number(d.broj_dok)) maxbrd, proizvod pro
      From stavka_dok sd, dokument d
      Where sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
        and d.org_deo = nOrgDeo and d.vrsta_dok = 21 and sd.Proizvod = cProizvod and d.status in (1,5)
      Group by d.godina, d.vrsta_dok, datum_dok, proizvod
    )
    Order by maxdat desc;

    NadjiDokVP4 NadjiDokVP4_cur % RowType;

  Cursor NadjiVP4Cenu_cur Is
    Select sd.cena1
    From stavka_dok sd
    Where sd.godina = NadjiDokVP4.god and sd.vrsta_dok = NadjiDokVP4.vrd And sd.broj_dok = NadjiDokVP4.maxbrd and sd.Proizvod = NadjiDokVP4.Pro;

    NadjiVP4Cenu NadjiVP4Cenu_cur % RowType;
    VratiCenuVP4 Number;
  Begin
    Open NadjiDokVP4_cur;
    Fetch NadjiDokVP4_cur Into NadjiDokVP4;
      Open NadjiVP4Cenu_cur;
      Fetch NadjiVP4Cenu_cur Into NadjiVP4Cenu;
        If NadjiVP4Cenu_cur% NOTFOUND Then   -- ako izvor nije nadjen
           VratiCenuVP4 := 0;                -- naziv je NULL
        Else
           VratiCenuVP4 := NadjiVP4Cenu.Cena1;
        End If;
      Close NadjiVP4Cenu_cur;
    Close NadjiDokVP4_cur;
    Return( VratiCenuVP4 );
  End;
End;

