-- OVAJ SELECT POKAZUJE REZERVACIJU PROIZVODA PO DOKUMENTU I KO JE I KADA PRAVIO DOKUMENT
select d.datum_dok , d.ppartner , pposlovnipartner.naziv(d.ppartner),d.status , d.Vrsta_Dok , pvrstadok.naziv(d.vrsta_dok) naziv_vrste_dok, d.Broj_Dok , User_id ,
       sd.proizvod, pproizvod.naziv(sd.proizvod) naziv_proizvoda,
sum ( sd.kolicina * sd.faktor - sd.realizovano * sd.faktor ) rezervisano



from dokument d, stavka_dok sd
where d.godina    = to_char(sysdate,'YYYY')
  and d.status    in ('1','3')
  and d.vrsta_dok in ('9','10')
--  and d.org_deo   = 91
  and sd.proizvod = 3296
--  and sd.proizvod  IN (SELECT DISTINCT PROIZVOD
--                       FROM STAVKA_DOK
--                       WHERE GODINA    = 2007
--                         AND VRSTA_DOK = 10
--                         AND BROJ_DOK  = 115
--                         )
  and sd.vrsta_dok = d.vrsta_dok
  and sd.broj_dok  = d.broj_dok
  and sd.godina    = d.godina
Having sum ( sd.kolicina * sd.faktor - sd.realizovano * sd.faktor ) > 0
Group by d.datum_dok ,d.ppartner , d.status , d.Vrsta_Dok , d.Broj_Dok , User_id , sd.proizvod
ORDER BY DATUM_DOK
