select proizvod, p.naziv
from
(
	select distinct proizvod
	from
	(
		Select proizvod
		from katalog k
		where dobavljac= '172'

		union
		Select proizvod
		from KATALOG_TRANZIT k
		where dobavljac= '172'
	)
) k
, proizvod p
where p.sifra = k.proizvod
