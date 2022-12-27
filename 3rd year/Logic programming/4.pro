% Loginis programavimas.

/*
    Uzklausu pvz:

    lenta1(N), isspresti(N, X), spausdinti(X).

    9 5 4    3 7 8   1 2 6 
    7 8 2    1 5 6   4 3 9 
    6 3 1    9 2 4   7 5 8

    1 2 3    7 6 9   5 8 4
    8 6 5    4 3 2   9 7 1
    4 9 7    5 8 1   3 6 2

    2 7 9    6 4 3   8 1 5
    3 1 8    2 9 5   6 4 7
    5 4 6    8 1 7   2 9 3

    N = [[9, 5, 4, 3, 7, 8, 1, 2|...], [7, 8, 2, 1, 5, 6, 4|...], [6, 3, 1, 9, 2, 4|...], [1, 2, 3, 7, 6|...], [8, 6, 5, 4|...], [4, 9, 7|...], [2, 7|...], [3|...], [...|...]],
    X = [9, 5, 4, 3, 7, 8, 1, 2, 6|...] ;

    Kitos analogiškos užklausos, keičiant lentos skaičių.
*/

:- use_module(library(clpfd)).


isspresti(IvadineLenta, GalutineLenta) :-
	
	% eilutems apsibreziame kintamuosius
	IvadineLenta = [E1, E2, E3, E4, E5, E6, E7, E8, E9],
	
    % patikrina ar eilutės skirtingos
	skirtingi(E1),
	skirtingi(E2),
	skirtingi(E3),
	skirtingi(E4),
	skirtingi(E5),
	skirtingi(E6),
	skirtingi(E7),
	skirtingi(E8),
	skirtingi(E9),
	
	% "išskaičiuojami" stulpeliai
    maplist(nth1(1), IvadineLenta, S1),
    maplist(nth1(2), IvadineLenta, S2),
    maplist(nth1(3), IvadineLenta, S3),
    maplist(nth1(4), IvadineLenta, S4),
    maplist(nth1(5), IvadineLenta, S5),
    maplist(nth1(6), IvadineLenta, S6),
    maplist(nth1(7), IvadineLenta, S7),
    maplist(nth1(8), IvadineLenta, S8),
    maplist(nth1(9), IvadineLenta, S9),

    % patikrina ar stulpeliai skirtingi
	skirtingi(S1),
	skirtingi(S2),
	skirtingi(S3),
	skirtingi(S4),
	skirtingi(S5),
	skirtingi(S6),
	skirtingi(S7),
	skirtingi(S8),
	skirtingi(S9),
	
	% susidaromo 3x3 blokeliai
         take(3, S1, I11),         take(3, S2, I12),         take(3, S3, I13),    blokas([I11, I12, I13], B1),  
    drop_take(3, 3, S1, I21), drop_take(3, 3, S2, I22), drop_take(3, 3, S3, I23), blokas([I21, I22, I23], B2),  
    drop_take(6, 3, S1, I31), drop_take(6, 3, S2, I32), drop_take(6, 3, S3, I33), blokas([I31, I32, I33], B3),  
    
         take(3, S4, I41),         take(3, S5, I42),         take(3, S6, I43),    blokas([I41, I42, I43], B4),  
    drop_take(3, 3, S4, I51), drop_take(3, 3, S5, I52), drop_take(3, 3, S6, I53), blokas([I51, I52, I53], B5),  
    drop_take(6, 3, S4, I61), drop_take(6, 3, S5, I62), drop_take(6, 3, S6, I63), blokas([I61, I62, I63], B6),  
    
         take(3, S7, I71),         take(3, S8, I72),          take(3, S9, I73),   blokas([I71, I72, I73], B7),  
    drop_take(3, 3, S7, I81), drop_take(3, 3, S8, I82), drop_take(3, 3, S9, I83), blokas([I81, I82, I83], B8),  
    drop_take(6, 3, S7, I91), drop_take(6, 3, S8, I92), drop_take(6, 3, S9, I93), blokas([I91, I92, I93], B9),  


	skirtingi(B1),
	skirtingi(B2),
	skirtingi(B3),
	skirtingi(B4),
	skirtingi(B5),
	skirtingi(B6),
	skirtingi(B7),
	skirtingi(B8),
	skirtingi(B9),
	
	
	Lenta = [E1, E2, E3, E4, E5, E6, E7, E8, E9],
	flatten(Lenta, GalutineLenta),
	label(GalutineLenta). 


blokas(Matrica, Sarasas) :-
    transpose(Matrica, X),
    flatten(X, Sarasas).

skirtingi(Sarasas) :-
	length(Sarasas, 9),
	Sarasas ins 1..9,
	all_different(Sarasas).


spausdinti(Sarasas) :-
	spausdinti(Sarasas, 1).


spausdinti([], _).
spausdinti([Sk1, Sk2, Sk3, Sk4, Sk5, Sk6, Sk7, Sk8, Sk9|Sks], Akum) :-
	format('~d ~d ~d \t ~d ~d ~d \t ~d ~d ~d \n', [Sk1, Sk2, Sk3, Sk4, Sk5, Sk6, Sk7, Sk8, Sk9]),
	(0 is mod(Akum, 3) -> writef('\n', []) ; true),
	Akum1 = Akum + 1,
	spausdinti(Sks, Akum1).


% Implementuota is haskell
take(N, _, Xs) :- N =< 0, !, N =:= 0, Xs = [].
take(_, [], []).
take(N, [X|Xs], [X|Ys]) :- M is N-1, take(M, Xs, Ys).

% Implementuota is haskell
drop(0, X, X) :- !.
drop(_, [], []).
drop(N, [_|Xs], Y) :- M is N-1, drop(M, Xs, Y).

% predikatu "kompozicija"
drop_take(N, M, X, Y) :-
    drop(N, X, X1),
    take(M, X1, Y).

lenta1(Lenta) :- 
	Lenta = [
        [9,_,_, _,7,_, _,2,_], 
		[_,8,_, _,_,_, _,3,_], 
		[6,_,_, _,_,4, 7,_,8],

		[_,_,_, _,_,_, _,8,_],
		[_,6,_, _,3,_, 9,_,1], 
		[4,_,_, 5,_,_, _,_,_],
		
        [_,_,9, _,_,3, _,_,_],
		[_,1,_, _,9,_, 6,_,7], 
		[_,_,_, _,_,_, 2,_,_]].

lenta2(Lenta) :- 
	Lenta = [
        [_,6,_, 1,_,4, _,5,_],
		[_,_,8, 3,_,5, 6,_,_],
		[2,_,_, _,_,_, _,_,1],

		[8,_,_, 4,_,7, _,_,6],
		[_,_,6, _,_,_, 3,_,_],
		[7,_,_, 9,_,1, _,_,4],
		
        [5,_,_, _,_,_, _,_,2],
		[_,_,7, 2,_,6, 9,_,_],
		[_,4,_, 5,_,8, _,7,_]].


lenta3(Lenta) :- 
	Lenta = [
        [1,2,3, 4,5,6, 7,8,9], 
		[_,_,_, _,_,_, _,_,_], 
		[_,_,_, _,_,_, _,_,_],

        [_,_,_, _,_,_, _,_,_], 
		[_,_,_, _,_,_, _,_,_], 
		[_,_,_, _,_,_, _,_,_],
        
        [_,_,_, _,_,_, _,_,_], 
		[_,_,_, _,_,_, _,_,_], 
		[_,_,_, _,_,_, _,_,_]].
