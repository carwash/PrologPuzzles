/*  File: aa1.pl  Author: (sol MM)
    Title: Contest: swimming and biking  From: Adrian Atanasiu: www.be-logic.ro
Four students competed in two different tests: swimming and biking.
Can you establish the final order for each test?
1. Andrew did not win any competition.
2. The person who won the swimming contest was the third
   at the bike competition.
3. Andrew did better than Corey at the swimming contest,
   but Corey was better than Andrew at the bike contest.
4. Corey was never the last.
5. Dan won the bike contest,
   but Sandy was better than him at the swimming contest.
What was the winning order in the swimming and bike contest?
?- start,false.
Swimming contest=[sandy,andrew,corey,dan]
Bike contest= [dan,corey,sandy,andrew]
*****************************************************/

:- encoding(utf8).
:- use_module(library(lists)).

start :-
	sol(S,B),
	write('Swimming contest = '), write(S), nl,
	write('Bike contest = '),     write(B), nl.

sol(Swim,Bike) :-
	St = [sandy,andrew,corey,dan],
	permutation(Swim,St),
	permutation(Bike,St),
	Swim = [Hs|_],
	andrew \== Hs, Bike = [Hb|_], andrew \== Hb,          %% 1
	Bike = [_,_,Hs,_],                                    %% 2
	before(andrew,corey,Swim), before(corey,andrew,Bike), %% 3
	\+last(Swim,corey), \+last(Bike,corey),               %% 4
	Bike = [dan|_], before(sandy,dan,Swim).               %% 5

/* before(X,Y,List) checks if X is before Y in the List.
	Starts from Left to right (normal order...).
	?- before(a,c,[m,a,v,c,d]).
	true
*/
before(X,Y,L) :-
	append(_,[X|R],L),
	member(Y,R).
