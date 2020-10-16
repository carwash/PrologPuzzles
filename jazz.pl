/*  File: jazz.pl  (solution MM)
    Title: Sounds Logical?  From: Dell- Math Puzzles Logic Problems, Jan 2002 p.15
    "Giant Book of Challenging Thinking Puzzles",
    Michael A. DiSPezio,Sterling Pub. House, ISBN  1-4027-1090-9, 2003
Saturdays and Sundays are the days that Sheila, Ramon and Niko shop together for music. The CD's they purchase are either rock or jazz. When they visit the music store, each person will purchase one and only one CD. Here are the rules that givern their selections:
1. Either Sheila or Ramon will pick rock, but not both of them.
2. If Sheila picks rock, Niko picks jazz.
3. Niko and Ramon do not both pick jazz.
Which one of the three purchased a jazz CD on Saturday and a Rock CD on Sunday.

S1= sheila buys on Saturday  S2= sheila buys on Sunday
R1= ramon buys on Saturday  R2= ramon buys on Sunday
N1= niko buys on Saturday  N2= niko buys on Sunday
Solution = [S1,R1,N1,S2,R2,N2]
?- start.
     SATURDAY           SUNDAY
Sheila Ramon Niko Sheila Ramon Niko
jazz  rock  jazz  jazz  rock  rock
****************************************************/

:- encoding(utf8).
:- use_module(library(lists)).

start :- find(Sol),
		 mywrite(Sol), nl.

find(Sol) :-
	Sol =  [S1,R1,N1,S2,R2,N2],
	mem(Sol,[jazz,rock]),
	is_set([S1,R1]), %% 2. If Sheila picks rock, Niko picks jazz.
	is_set([S2,R2]), %% that is different
	[N1,R1]\=[jazz,jazz],          %% 3. Niko and Ramon do not both pick jazz
	[N2,R2]\=[jazz,jazz],
	(S1=jazz ; (S1=rock,N1=jazz)), %% if sheila picks jazz does not matter
	(S2=jazz ; (S2=rock,N2=jazz)), %% if sheila picks rock, Nick has jazz
	([S1,S2]=[jazz,rock] ; [R1,R2]=[jazz,rock] ; [N1,N2]=[jazz,rock]). %% at least one of them bought jazz on Saturday and rock on Sunday

mywrite(L) :-
	write('   SATURDAY           SUNDAY       '), nl,
	write('Sheila Ramon Niko Sheila Ramon Niko'), nl,
	forall(member(X,L),
		   (write(X), write('  '))
		  ).

/* mem(Lr,L). Elements from Lr are all members in L.
   Or: Fill an empty list with elements from another list.
*/
mem([],_Y).
mem([H|T],Y) :-
	member(H,Y),
	mem(T,Y).
