/*  File: ifthen.pl  Author: If Then (sol MM)
    Title: The false Statements
1. Only one of these statements is false
2. Only two of these statements is false
3. Only three of these statements is false
4. Only four of these statements is false
5. All five of these statements is false
Which if any is true?
?- start.
I = [false,false,false,true,false] ;
*/

:- encoding(utf8).
:- use_module(library(lists)).

start :- find(I), write(I).
/* mem(Lr,L). Elements from Lr are all members in L.
   Or: Fill an empty list with elements from another list.
*/
mem([],_Y).
mem([H|T],Y) :-
	member(H,Y),
	mem(T,Y).

find([A1,A2,A3,A4,A5]) :-
	mem([A1,A2,A3,A4,A5],[true,false]),
	Sol = [A1,A2,A3,A4,A5],
	count(false,Sol,N),
	((A1 -> N=1 ) ; (not A1 -> not N=1)),
	((A2 -> N=2 ) ; (not A2 -> not N=2)),
	((A3 -> N=3 ) ; (not A3 -> not N=3)),
	((A4 -> N=4 ) ; (not A4 -> not N=4)),
	((A5 -> N=5 ) ; (not A5 -> not N=5)).

/* count(A,L,N). Counts occurrences
	?- count(a,[b,a,c,d,a],N).
	N = 2
*/
count(_A,[],0).
count(A,[A|L],N) :-
	count(A,L,N1),
	N is N1 + 1, !.
count(A,[_|L],N) :- count(A,L,N).
