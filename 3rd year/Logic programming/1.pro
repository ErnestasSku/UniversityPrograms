% Loginis programavimas.

/**
    Užklausų pavyzdžiai:
    sv_suk(X). | Išveda visus žmonės, kurie švenčia apvalią sukaktį.
    sv_suk(darius). | Patikrina ar Darius švenčią apvalią sukaktį.
    usvis(X, darius). | Randa dariaus uošvį.
    dar_pagyvens(feliksas). | išves ar feliskas dar pagyvens ar ne.
    turi_vaiku(X). | išveda visus žmones, kurie turi vaikų.

**/

% asmuo(Vardas, Lytis, Amžius, Pomėgis)
% mama(Mama, Vaikas);
% pora(Vyras, Žmona).

% 19 uosvis(Uosvis, Zentas) - Pirmasis asmuo (Uosvis) yra antrojo (Zentas) uošvis (žmonos tėvas);
% 28 turi_vaiku(TevasMama) - Asmuo TevasMama turi vaikų;
% 32 sv_suk(Jubiliatas) - Asmuo Jubiliatas ką tik atšventė apvalią sukaktį: amžius yra 10 (ar kokio kito skaičiaus - nuspręskite patys) kartotinis;
% 43 dar_pagyvens(Asmuo) - Asmuo Asmuo mėgsta kurią nors iš sporto šakų arba yra dar nepensinio amžiaus (64 metai vyrams ir 63 metai moterims);

asmuo(feliksas, vyras, 73, kolekcionavimas).
asmuo(paulyna, moteris, 70, joga).
asmuo(jule, moteris, 75, vaiksciojimas).
asmuo(alfonsas, vyras, 74, golfas).
asmuo(darius, vyras, 50, mechanika).
asmuo(snieguole, moteris, 48, darzas).
asmuo(ernestas, vyras, 20, programavimas).
asmuo(deimante, moteris, 22, studijos).

mama(paulyna, darius).
mama(jule, snieguole).
mama(snieguole, ernestas).
mama(snieguole, deimante).

pora(feliksas, paulyna).
pora(alfonsas, jule).
pora(darius, snieguole).

uosvis(Uosvis, Zentas) :- 
    pora(Zentas, X),
    mama(Y, X),
    pora(Uosvis, Y).

turi_vaiku(Mama) :- 
    mama(Mama, _).

turi_vaiku(Tevas) :-
    mama(X, _),
    pora(Tevas, X).

sv_suk(Jubiliatas) :-
    asmuo(Jubiliatas, _, X, _),
    Y is X mod 10,
    Y = 0.

dar_pagyvens(Asmuo) :-
    asmuo(Asmuo, _, _, Pomegis),
    sporto_saka(Pomegis).

dar_pagyvens(Asmuo) :-
    asmuo(Asmuo, moteris, Amzius, _),
    Amzius < 63.

dar_pagyvens(Asmuo) :-
    asmuo(Asmuo, vyras, Amzius, _),
    Amzius < 64.


sporto_saka(joga).
sporto_saka(golfas).
sporto_saka(krepsinias).
sporto_saka(futbolas).
