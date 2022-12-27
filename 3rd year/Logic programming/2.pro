% Loginis programavimas.

% 2.1 „studentas A yra vyresnis už to paties kurso studentą B“.
% 6.1 „dviejų skaičių suma lygi trečiajam skaičiui.“ 

/*
    Užklausų pavyzdžiai:
    yraVyresnisKursiokas(X, mindaugas). - Išveda visus kursiokius, vyresnius už mindaugą (lauryna ir zita)
    yraVyresnisKursiokas(jurgis, kazimieras). - Ar jurgis vyresnis už kazimerą, išveda false, nes kazimieras vyresnis už jurgį.
    yraVyresnisKursiokas(petras, kazimieras). - Ar petras vyresnis už kezimierą, išveda false, nes petras 3-kuris, o kazimieras 1-kursis.

    add(s(0), s(0), X). - išveda s(s(0))
    add(s(0), Y, X) - išveda galimas sumos kombinacijas Y = 0, X = s(0), Y = 1, X = s(s(0)), Y = 2 ....
    add(s(0), s(s(0)), s(s(s(0)))). - ar s(0) + s(s(s(0))) = s(s(s(0)))? išveda true. 
*/


studentas(petras, 3).
studentas(jonas, 2).
studentas(kazimieras, 1).
studentas(zita, 4).
studentas(lauryna, 4).
studentas(asta, 3).
studentas(algis, 2).
studentas(jurgis, 1).
studentas(mindaugas, 4).
studentas(aurelija, 3).

yraVyresnis(lauryna, petras).
yraVyresnis(petras, jonas).
yraVyresnis(jonas, kazimieras).
yraVyresnis(kazimieras, zita).
yraVyresnis(zita, asta).
yraVyresnis(asta, algis).
yraVyresnis(algis, jurgis).
yraVyresnis(jurgis, mindaugas).
yraVyresnis(mindaugas, aurelija).

yraVyresnisTransityvus(X, Y) :- yraVyresnis(X, Y).
yraVyresnisTransityvus(X, Y) :-
    yraVyresnis(X, Z),
    yraVyresnisTransityvus(Z, Y).

yraVyresnisKursiokas(X, Y) :-
    yraVyresnisTransityvus(X, Y),
    studentas(X, K),
    studentas(Y, K).


add(X, 0, X).
add(X, s(Y), Z) :- add(s(X), Y, Z).
