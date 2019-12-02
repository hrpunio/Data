# JUDOBASE

Ze strony pobrano Dane dotyczące turniejów o Mistrzostwo Świata w judo
oraz turnieju judo na Igrzyskach Olimpijskich w latach 2000--2019
pobrano ze strony https://judobase.ijf.org/.  Dało się je względnie
sprawnie zamienić na plik csv:

Plik zawiera około 7 tys walk. Poszczególne kolumny zawierają:
`event` -- symbol trumieju (oo albo wc);
`year` -- rok;
`cat` -- kategoria wagowa (178/200 to umowny zapisa dla kategorii +78
oraz +100);
`sex` -- płeć;
`fid` -- id walki (nieużywane);
`cntry1` -- kraj zawodnika z kolumny następnej;
`name1` -- imię nazwisko;
`winner` -- zwycięzca (L/R jeżeli L to pierwszy zawodnik
w wierszy/R drugi);
`name2` -- imię nazwisko;
`cntry2` -- kraj zawodnika z poprzedniej kolumny --;
`score1` -- wynik zawodnika 1 (zapis i w y = ostrzeżenia;
iwy są opcjonalne, jeżeli ich nie było, tj może być
zapis 1 (równoważny 0 0 1) lub 1 1 (równoważny 0 1 1));
`score2` -- wynik zawodnika 2 (zapis i w y = ostrzeżenia);
`time` -- czas walki (mm:ss);
`round` -- runda turnieju;
`idr` -- id rundy turnieju;
`ippon` -- czy koniec przez ippon (1/tak, 0/nie);
`stime` -- czas walki w sekundach;
`in` -- liczba ippon (1 lub zero/kopia zmiennej ippon);
`wn` -- liczba wazari;
`yn` -- liczba yuka.

Uwaga:
walki dłuże niż 480 s (8 minut) albo krótsze niż 2 s oznaczono
jako NA (zmienna `stime`),
bo czas wydaje się podejrzenie niepoprawny.
