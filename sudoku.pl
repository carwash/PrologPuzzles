/*  File: sudoku.pl  Author: Mihaela Malita
    Title: SUDOKU Solver/Generator.  From: http://www.sudoku.com/
A sort of Magic Square 9 x 9
all integers: 1-9 fill on lines and columns (no repeats)
also blocks (9) do not repeat
SWI predicates: permutation/2  and is_set/1
**************************************************************/

:- encoding(utf8).
:- use_module(library(lists)).

%% start :- write('Enter known positions?'),read(S),solve(S).

start :-
	S = [[_,_,_,3,4,2,_,_,_],
	     [5,4,_,_,7,_,_,8,_],
	     [_,_,2,_,_,5,4,_,6],
	     [_,6,_,2,_,_,_,_,_],
	     [3,_,8,_,_,_,2,_,4],
	     [_,_,_,_,_,8,_,7,_],
	     [6,_,9,1,_,_,5,_,_],
	     [_,3,_,_,8,_,_,1,9],
	     [_,_,_,5,3,9,_,_,_]],
	solve(S).

write_square(S) :-
	nl,
	forall(
		member(X,S),
		(write(X), nl)
	),
	nl.
/*
two lines are different if they do not have any elements on the same position.
?- different([a,b],[b,a]).
true
?- different([a,b],[a,a]).
false
----------------------------------*/
different([],[]).
different([H1|T1],[H2|T2]) :-
	not(var(H1)),
	not(var(H2)),
	not(H1=H2),
	different(T1,T2),
	!.
different([H1|T1],[H2|T2]) :-
	(var(H1) ; var(H2)),
	different(T1,T2), !.

/*
Integers do not repeat in blocks 3x3
----------------------------------*/
good([],[],[]).
good([A1,A2,A3|AT],
	 [B1,B2,B3|BT],
	 [C1,C2,C3|CT]):-
    notvars([A1,A2,A3,
			 B1,B2,B3,
			 C1,C2,C3],G),
    is_set(G),
	good(AT,BT,CT) .

/*
Collect non variables from lines:
?- notvars([_,2,_,_,5,_,7,_,9,1],L).
L = [2, 5, 7, 9, 1]
----------------------------------*/
notvars(L,G) :-
	findall(
		X,
		(member(X,L), not(var(X))),
		G).

solve(S) :-
	Nine = [1,2,3,4,5,6,7,8,9],
	S = [L1,L2,L3,L4,L5,L6,L7,L8,L9],
	write_square(S),
	permutation(L1,Nine), %% Line 1
	%%write_square(S),
    good(L1,L2,L3),
	maplist(different(L1),[L2,L3,L4,L5,L6,L7,L8,L9]),
	write_square(S),
	permutation(L2,Nine), %% Line 2
    good(L1,L2,L3),
	maplist(different(L2),[L1,L3,L4,L5,L6,L7,L8,L9]),
	write_square(S),
	permutation(L3,Nine), %% Line 3
    good(L1,L2,L3),
	maplist(different(L3),[L1,L2,L4,L5,L6,L7,L8,L9]),
	write_square(S),
	permutation(L4,Nine), %% Line 4
    good(L4,L5,L6),
	maplist(different(L4),[L1,L2,L3,L5,L6,L7,L8,L9]),
	write_square(S),
	permutation(L5,Nine), %% Line 5
    good(L4,L5,L6),
	maplist(different(L5),[L1,L2,L3,L4,L6,L7,L8,L9]),
	write_square(S),
	permutation(L6,Nine), %% Line 6
    good(L4,L5,L6),
	maplist(different(L6),[L1,L2,L3,L4,L5,L7,L8,L9]),
	write_square(S),
	permutation(L7,Nine), %% Line 7
    good(L7,L8,L9),
	maplist(different(L7),[L1,L2,L3,L4,L5,L6,L8,L9]),
	write_square(S),
    permutation(L8,Nine),   %% Line 8
    good(L7,L8,L9),
	maplist(different(L8),[L1,L2,L3,L4,L5,L6,L7,L9]),
	write_square(S),
    permutation(L9,Nine),   %% Line 9
    good(L7,L8,L9),
	maplist(different(L9),[L1,L2,L3,L4,L5,L6,L7,L8]),
	maplist(good,[L1,L4,L7],[L2,L5,L8],[L3,L6,L9]),
    write_square(S).
