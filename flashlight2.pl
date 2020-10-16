/*  File: flashlight2.pl  Solution: M.Malita
    Title: Four Men Crossing a Bridge (from Microsoft interview process)
There are four men who would all like to cross a rickety old bridge.
The old bridge will only support 2 men at a time, and it is night time,
so every crossing must use the one flashlight that they all share.
The four men each have different walking speeds;
the fastest each of them can cross is 1 minute, 2 minutes, 5 minutes, and 10 minutes.
If they pair up, since they must share the flashlight,
they can only cross in the time that it would take the slower of the two.
Given that the shortest time to get them all across is 17 minutes total, how should they all cross?
*/
/*
We describe the problem as Nodes in a graph and the solution means to find a path from
the initial node to the final node.
Assume the names of the four people are: a,b,c,d
state = node is graph
state = [Time,Flash_place,[a,b,c,d],[]]
Bank can be left (l) or right (r).  Thus Flash_place is l or r.
[5,l,[a,b,c],[d]] - means 5 minutes passed and a,b,c are on the left bank and d is on the right
| ?- start,false.
Found sol =
[17,r,[],[a,b,c,d]]
[15,l,[a,b],[c,d]]
[13,r,[a],[c,d,b]]
[3,l,[a,c,d],[b]]
[2,r,[c,d],[a,b]]
[0,l,[a,b,c,d],[]]
Found sol =
[17,r,[],[a,b,c,d]]
[15,l,[a,b],[c,d]]
[14,r,[b],[c,d,a]]
[4,l,[b,c,d],[a]]
[2,r,[c,d],[a,b]]
[0,l,[a,b,c,d],[]]
no
*/

:- encoding(utf8).
:- use_module(library(lists)).

start :-
	initial(S),
	path(S,[],Sol),
	write('Found sol ='), nl,
	write_list(Sol).

% Finding a path in a graph from initial node to final node
path(Node,Path,[Node|Path]) :- final(Node).
path(Node,Path,Sol) :-
	arc(Node,N1),
	\+member(N1,Path),
	path(N1,[Node|Path],Sol).
% At the beginning All are on the same bank and Time=0
initial([0,l,[a,b,c,d],[]]).
% At the end they have all to be on the other bank and Time=17
final([17,r,[],[a,b,c,d]]).
% Opposite bank.
opp(l,r).  opp(r,l).
% Time for crossing the bridge - time is a system predicate
tim(a,1).  tim(b,2).  tim(c,5).  tim(d,10).
% Define the arcs (or move conditions from a state node) to another state(node)
arc([T1,F1,L1,R1], [T2,F2,L2,R2]) :-
	opp(F1,F2),
	((F1=l, cross(X,L1),
	  take(X,L1,L2u), append(X,R1,R2), findtime(X,T), T2 is T1+T);
	 (F1=r, cross(X,R1),
	  take(X,R1,R2), append(X,L1,L2u), findtime(X,T), T2 is T1+T)),
	msort(L2u,L2),
	T2 < 18.

% Remove all elements in S from L result is in R
take(S,L,R) :-
	findall(Z, (member(Z,L), \+member(Z,S)), R).

% We know just one or two persons cross the bridge
findtime([X],Tim) :- tim(X,Tim), !.
findtime([A,B],Tim) :-
	tim(A,Ta), tim(B,Tb), Tim is max(Ta,Tb), !.

% Take all the combinations of 1 person, and 2 persons from our group: [a,b,c,d]
cross(X,L) :-
	comb(1,L,X);
	comb(2,L,X).

/* mem1(Lr,L). For comb/3. Same as mem/2 but does not generate [a,b] and [b,a].
	?- mem1([X,Y],[a,b,c]),write([X,Y]),false.
	[a,b][a,c][b,c]
	no
*/
mem1([],_Y).
mem1([H|T],Y) :-
	member(H,Y),
	rest(H,Y,New),
	mem1(T,New).

/* rest(A,L,R). Returns the rest of the list after the first occurrence of A.
	| ?- rest(a,[a,b,c,d],I).  I = [b,c,d]
	| ?- rest(a,[b,c,d],I).    I = []
*/
rest(A,L,R) :- append(_,[A|R],L), !.

/* comb(N,L,Res). Combinations. Arrangements without "order".
	| ?- comb(2,[a,b,c],I).
	I = [a,b] ; I = [a,c] ; I = [b,c] ;
*/
comb(N,L,X) :-
	length(X,N),
	mem1(X,L).

write_list(L) :-
	forall(member(X,L),
		   (write(X), nl)
		  ).
