Select BROJ_DOK, VRSTA_DOK, pvrstadok.naziv(VRSTA_DOK) naziv , GODINA,
       ZA_BROJ_DOK,ZA_VRSTA_DOK,  pvrstadok.naziv(ZA_VRSTA_DOK) naziv , ZA_GODINA
from vezni_dok
Where Godina = 2008
  and vrsta_Dok = 13
  and broj_Dok in ('6','7')
