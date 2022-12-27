% Loginis programavimas.

% 1.7 maxlyg(S,M) - skaičius M - didžiausias lyginis skaičių sąrašo S elementas.
% 2.1 nr(S,K,E) - E yra K-asis sąrašo S elementas. 
% 3.1 ieina(S,R) - teisingas, kai visi duoto sąrašo S elementai įeina į sąrašą R.
% 4.7 i_dvejet(Des,Dvej) - Des yra skaičius vaizduojami dešimtainių skaitmenų sąrašu. Dvej - tas pats skaičiaus, vaizduojamas dvejetainių skaitmenų sąrašu.

/*
    Užklausų pavyzdžiai: 
    maxLyg([3,4,6,4,8,1,19,17], M). gražina M = 8
    maxLyg([3,4,6,4,8,1,19,17], 17). ar 17 didžiausas lyginis? gražina false

    nr([1,4,6,7], 3, E). Koks yra 3 elementas? E = 6

    ieina([2,4,7], [1,3,4,7]). - false
    ieina([2,4,7], [1,3,4,7,2]). - true

    i_dvejet([1,6,4], Dvej). - Dvej = [1, 0, 1, 0, 0, 1, 0, 0].   
*/

% Limituotas variantas. Yra parašytas ir antras variantas.
maxLyg([], -10000).
maxLyg([X | XS], M) :-
    X mod 2 =:= 0,
    maxLyg(XS, N),
    M is max(X, N),
    !
    ;
    maxLyg(XS, M).

% % Vienas iš variantų naudojantis list funkcijomis
% % Panašus sprendimas Haskell
% % mxLyg :: [Int] -> Int
% % mxLyg = last . sort $ filter even x

% maxLyg(L, M) :-
%     include(lyginis, L, LL),
%     sort(LL, SLL),
%     last(SLL, M).

% lyginis(X) :-
%     X mod 2 =:= 0.


nr([E|_], 1, E) :- !.
nr([_|XS], K, E) :- 
    K1 is K - 1,
    nr(XS, K1, E).

ieina([], _) :- !. 
ieina([X|XS], S) :- 
    egzistuoja(S, X),
    ieina(XS, S).

egzistuoja([], _) :- !, fail.
egzistuoja([X | _], S) :- X =:= S, !.
egzistuoja([_ | XS], S) :- egzistuoja(XS, S).

i_dvejet(Des, Dvej) :-
    i_skaiciu(Des, 0, Visas),
    i_dvejet_pag(Visas, [], Dvej).

i_skaiciu([], X, X) :- !.
i_skaiciu([H | T], S, R) :-
    SN is S * 10 + H,
    i_skaiciu(T, SN, R).

i_dvejet_pag(0, Arr, Arr) :- !.
i_dvejet_pag(X, Arr, Res) :-
    D is X rem 2,
    NX is X // 2,
    i_dvejet_pag(NX, [D | Arr], Res).



%4.8 i_desimt(Dvej, Des) - Dvej yra skaičius vaizduojami dvejetainių skaitmenų sąrašu. Des - tas pats skaičiaus, vaizduojamas dešimtainių skaitmenų sąrašu.
ilgis([], 0) :- !.
ilgis([_], 1) :- !.
ilgis([_|L], I) :- 
    ilgis(L, LI),  
    I is LI + 1.

append( [], X, X).
append( [X | Y], Z, [X | W]) :- 
    append( Y, Z, W).

dvej_skaic([0], 0) :- !.
dvej_skaic([1], 1) :- !.
dvej_skaic([A|L], K) :-
    A =< 1 , 
    A >= 0, 
    dvej_skaic(L, Sk), 
    ilgis([A|L], I), 
    Index is I-1, 
    Lp is 2**Index, 
    K is Sk + Lp * A.

skaitmenys(A, [A]) :- A < 10.
skaitmenys(A, R) :- 
    Sk is A mod 10, 
    A1 is (A - Sk)/10, 
    skaitmenys(A1, Rez), 
    append(Rez, [Sk], R), 
    !.

i_desimt(Dvej, Des) :- 
    dvej_skaic(Dvej, Sk), 
    skaitmenys(Sk, Des). 


