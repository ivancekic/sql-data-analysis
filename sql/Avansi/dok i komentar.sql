SELECT

        d.godina, d.vrsta_dok, d.broj_dok, d.datum_dok, d.datum_unosa, d.org_deo, d.broj_dok1
      , PUtility.DokumentIznosi( d.broj_dok, d.vrsta_dok, d.godina, 'ZA_KUPCA' ) za_kup
      , trim(Substr( k.komentar,   1, 20))								RN_BRD
      , trim(Substr( k.komentar,  22,  6))								RN_GOD
      , trim(Substr( k.komentar,  31, 18))								RN_0_IZN
      , trim(Substr( k.komentar,  51, 18))								RN_5_IZN
      , trim(Substr( k.komentar,  73, 18))								RN_8_IZN
      , trim(Substr( k.komentar,  94, 18))								RN_18_IZN


      , nvl(trim(Substr( k.komentar,  31, 18)),0)								+
        nvl(trim(Substr( k.komentar,  51, 18)),0)								+
        nvl(trim(Substr( k.komentar,  73, 18)),0)								+
        nvl(trim(Substr( k.komentar,  94, 18)),0)								UK_IZN

FROM
dokument d,  (select * from komentar where vrsta_dok = 11 and stavka= -11100) k
WHERE d.godina = 2012
and d.vrsta_Dok = 11
and d.godina = k.godina  and d.vrsta_dok = k.vrsta_dok  and d.broj_dok = k.broj_dok

Order by d.datum_dok, d.datum_unosa
