--Select * from stavka_dok
--where proizvod in (3202,3201,3205,3207)
--/
--Select * from zalihe
--where proizvod in (3202,3201,3205,3207)
--/
--Select * from katalog
--where proizvod in (3202,3201,3205,3207)
--/
--Select * from planski_cenovnik
--where proizvod in (3202,3201,3205,3207)
--/
--Select * from prosecni_cenovnik
--where proizvod in (3202,3201,3205,3207)
--/
--Select * from prodajni_cenovnik
--where proizvod in (3202,3201,3205,3207)
--/
--Select rowid, p.* from pakovanje p
--where proizvod in (3202,3201,3205,3207)
--/
--Select rowid, p.* from ambalaza p
--where proizvod in (3202,3201,3205,3207)
--/
Select rowid, p.* from proizvod p
where SIFRA in (3202,3201,3205,3207)
