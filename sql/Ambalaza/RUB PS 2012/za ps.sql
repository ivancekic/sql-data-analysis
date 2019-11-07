select distinct sifra, mag_amb
from
(

Select pp.teren, obl.naziv naziv_ter, pp.sifra, pp.naziv  naziv_partner
     , (SELECT MAGACIN FROM PARTNER_MAGACIN_FLAG PF WHERE PF.PPARTNER = pp.sifra ) MAG_AMB

      , sd.Proizvod, P.Naziv pro_naziv,
       ( Sum ( Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 ) ) ) Ulaz,
       ( Sum ( Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 ) ) ) Izlaz,
       ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje,
       p.Jed_Mere JedMere


,      case when ( Sum ( Kolicina * Faktor * K_Robe ) ) < 0 Then
                  0
       else
                 ( Sum ( Kolicina * Faktor * K_Robe ) )
       end UL

,      case when ( Sum ( Kolicina * Faktor * K_Robe ) ) < 0 Then
                 ABS(( Sum ( Kolicina * Faktor * K_Robe ) ))
       else
                 0
       end IZL


From Dokument d, Stavka_Dok sd, Proizvod p, Poslovni_partner pp, Oblast Obl
--         Where (d.Tip_Dok In ( 14, 15, 203, 204, 99, 301, 402, 61, 60 ) or d.vrsta_Dok = 33)
Where (d.Tip_Dok In ( 14, 15, 203, 204, 99, 301, 402, 61, 60 ) or d.vrsta_Dok = 33)
  And d.Status > 0
  And d.Org_Deo In (Select Magacin From Partner_magacin_Flag, Poslovni_Partner pp
                    Where
--                    PPartner Between cPartnerOd And cPartnerDo And Teren Between nTerenOd And nTerenDo
--                      And
                      pp.sifra = Partner_magacin_Flag.ppartner
                    )
  And d.Datum_Dok Between To_Date('01.01.'||To_Char( &dNaDan, 'yyyy' ),'dd.mm.yyyy') And &dNaDan
--  And Teren Between nTerenOd And nTerenDo
  And sd.Proizvod In ( Select Sifra From Proizvod Where Tip_Proizvoda = '8' )
--  And sd.Proizvod Between cProizvodOd And cProizvodDo
  And sd.K_Robe != 0
  and d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok = sd.Broj_Dok And d.Godina = sd.Godina
  And sd.Proizvod = p.Sifra And d.ppartner = pp.sifra and Obl.Id = pp.Teren

AND pp.sifra=NVL(&cPPartner,pp.sifra)

Group By pp.teren, obl.naziv, pp.sifra, pp.naziv, sd.Proizvod, P.Naziv, P.Jed_Mere
Order By pp.teren, pp.naziv, P.Naziv
)
order by to_number(sifra)
