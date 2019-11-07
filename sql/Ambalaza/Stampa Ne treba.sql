select * from stavka_ambalaze
where (godina,vrsta_dok,broj_dok)
not in (
		select godina,vrsta_dok,broj_dok
		from dokument
		where (godina,vrsta_dok,broj_dok)
		   in (Select godina,vrsta_dok,broj_dok
		       From vezni_dok
		       where za_vrsta_Dok = 61
 		         and vrsta_Dok = 11
		         and godina = 2010
		       )
)
