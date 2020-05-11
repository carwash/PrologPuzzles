/* 	File: Puzzles/bibmm.pro Author: MMalita 
Work in Progress!! Library for Logic Puzzles 	
	SWI: append/3 member/2 intersection/3	permutations/2 	flatten/2 last/2 length/2 numlist(1,N,L) sumlist/2
	all/3
	all_prop(P,L): if all in a list have Property P/1  	
	arrange/3 	
	comb/3		
	first/2	first([H|_],H).	same as nth0(0,L,H). count/3 
	count_list_all/3
	count_list_comb/3
	count_list_arange/3
	count_prop/3  	
	intersection_n/3
	generate_sol/2 		
	list_comb/3	
	list_all/3 			
	list_arrange/3 	
	mem/2 (=subset)		SWI: subset/2  
	mem1/2	
    SWI: nth0/3		
	place/3 			SWI: nth1(?Index, ?List, ?Elem)
	remove/3			SWI: select(E,L,R)	
	rest/3
	next/3 		     
	SWI: nextto(X,Y,L).		
	before/3			SWI: nextto(X,Y,L).
	neighbor/5		diagonal/1 	not_diagonal/1
	set/1  (=no_duplicates,=alldifferent)	SWI: is_set/1
	set_equal/2   		SWI: permutation/2				
	sum/2 				SWI: sumlist/2
	write_list/1
*/
% 	first(List,First).
first(List,H):- List=[H|_].
/* generate_sol(S,N). Generate solution list - size N */
generate_sol(S,N):- length(S,N).
/* write_list(L). Format predicates.*/
write_list(L):-forall(member(X,L),(write(X),nl)).
/* count(A,L,N). Counts occurrences 
	?- count(a,[b,a,c,d,a],N).	
	N = 2
*/
count(_,[],0).
count(A,[A|L],N):- count(A,L,N1), N is N1+1,!.
count(A,[_|L],N):- count(A,L,N).
/* count_prop(P,L,N). Count elements with a certain property
	?-count_prop(integer,[1,2,a,b,3,4],N).
	N=4
	?- count_prop(atomic,[b,[a,c],d,a],N).
	N = 3
*/
count_prop(P,[],0).
count_prop(P,[A|L],N):- F=..[P,A],call(F),count_prop(P,L,N1),N is N1+1,!.
count_prop(P,[_|L],N):- count_prop(P,L,N).
/* all_prop(P,L). All elements from a list (first level) have property Prop. EX: check if all are integres in a list 
?- P=integer,L=[1,2,3],forall(member(X,L),(F=..[P,X],call(F))).
P = integer,
L = [1, 2, 3].
*/
all_prop(P,[]).
all_prop(P,[H|T]):- F=..[P,H],call(F),all_prop(P,T),!.
/* same as:
all_prop(P,L):-forall(member(X,L),(F=..[P,X],call(F))).
*/
/* mem(Lr,L). Elements from Lr are all members in L. 
	?- mem([X,Y],[a,b,c]).
	X = Y = a ;	X = a ,Y = b ;	X = a ,Y = c ;	X = b ,Y = a ;	
	X = Y = b ;	X = b ,Y = c ;	X = c ,Y = a ;	X = c ,Y = b ;
	X = Y = c ;
*/
mem([],Y).
mem([H|T],Y):-member(H,Y),mem(T,Y).
/* all(N,L,X). All possible N-length lists with elements from [a,b,c,d]:
	| ?- all(2,[a,b,c],I).
	I = [a,a] ;	I = [a,b] ;	I = [a,c] ;	I = [b,a] ;
	I = [b,b] ;	I = [b,c] ;	I = [c,a] ;	I = [c,b] ;	I = [c,c] ;
*/
all(N,L,X):-length(X,N),mem(X,L).
/* list_all(N,L,R).  
	?- list_all(2,[a,b,c],R).
	R = [[a,a],[a,b],[a,c],[b,a],[b,b],[b,c],[c,a],[c,b],[c,c]]
*/
list_all(N,L,Res):-findall(X,all(N,L,X),Res).
/* count_list_all(N,L,M).   k list has N = number is N^K
	?- count_list_all(2,[a,b,c,d],Many).
	Many = 16
*/
count_list_all(N,L,Many):-findall(X,all(N,L,X),Res),length(Res,Many).
/* arrange(N,L,R). Lists have to be sets! That is: elements do not repeat.
	?- arrange(2,[a,b,c],R).    
	R = [a,b] ;	R = [a,c] ;	R = [b,a] ;	R = [b,c] ;	R = [c,a] ;	R = [c,b] ;
*/
arrange(N,L,X):-length(X,N),mem(X,L),is_set(X).
no_duplicates(M):- is_set(M).
alldifferent(M):-  is_set(L).
/* list_arrange(N,L,Res). 
	?- list_arange(2,[a,b,c,d],R).
	R = [[a,b],[a,c],[a,d],[b,a],[b,c],[b,d],[c,a],[c,b],[c,d],[d,a],[d,b],[d,c]]
*/
list_arrange(N,L,Res):- findall(X,arrange(N,L,X),Res).
/* count_list_arrange/3. A(k,n)= n!/(n-k)!
	?- count_list_arrange(2,[a,b,c,d],R).
	R = 12
*/
count_list_arrange(N,L,Many):- list_arrange(N,L,Res),length(Res,Many).
list_permutations(L,R):-findall(X,permutations(L,X),Res).
/* count_list_permutations(L,N). N=length(L)!*/
count_list_permutations(L,N):-list_permutations(L,R),length(R,N).

/* mem1(Lr,L). For comb/3. Same as mem/2 but does not generate [a,b] and [b,a]. 	
	?- mem1([X,Y],[a,b,c]),write([X,Y]),false.
	[a,b][a,c][b,a][b,c][c,a][c,b]no
*/
mem1([],Y).
mem1([H|T],Y):-member(H,Y),rest(H,Y,New),mem1(T,New).
/* rest(A,L,R). For comb/3. Returns the rest of the list after the first occurrence of A. 
	| ?- rest(a,[a,b,c,d],I).	I = [b,c,d]
	| ?- rest(a,[b,c,a,d],I).	I = [d]
	| ?- rest(a,[b,c,d],I).		I = []
rest(X,[],[]):-!.
rest(X,[X|T],T):-!.
rest(X,[_|T],R):-rest(X,T,R).
*/
%%same as
rest(A,L,R):-Y=[A|R],append(X,Y,L),!.
/* comb(N,L,Res). Combinations. Arrangements without " order".	
	| ?- comb(2,[a,b,c],I).
	I = [a,b] ;	I = [a,c] ;	I = [b,c] ;
*/
comb(N,L,X):-length(X,N),mem1(X,L).
/* list_comb(N,L,Res).	
	?-  list_comb(2,[a,b,c,d],L).
	L = [[a,b],[a,c],[a,d],[b,c],[b,d],[c,d]]
*/
list_comb(N,L,Res):- findall(X,comb(N,L,X),Res).
/* count_list_comb(N,L,Many). Formula is: C(k,n) = n!/ k! (n-k)!
	or Pascal's formula:	C(k,n)=C(k,n-1) + C(k-1,n-1)
	?-  count_list_comb(2,[a,b,c,d],L).
	L = 6
*/
count_list_comb(N,L,Many):- list_comb(N,L,Res),length(Res,Many).
/* SWI: select/3. Removes the first occurrence of an element.
	?- select(a,[a,b,a,d,a],I).
	I = [b,a,d,a] ;	I = [a,b,d,a] ; I = [a,b,a,d] ;
	?- select(X,[a,b,c],I).
	X = a ,	I = [b,c] ;	X = b ,	I = [a,c] ;	X = c ,	I = [a,b] ;
	?- select(m,[a,b,c,d],I).
	false
	?- select(m,I,[b]).
	I = [m,b] ;	I = [b,m] ;
We can write remove/3 as follows, with same effect as follows:
	remove(X,[],[]):-!.
	remove(X,[X|T],T):-!.
	remove(X,[H|T],[H|R]):-myremove(X,T,R).
%%	same as:
	remove(X,L,R):-append(F,[X|R1],L),append(F,R1,R). %skip X
*/
/* Order in a list:List= ..X,Y,.. means:Y is in the right of X
	?- right(a,b,[c,a,b,m,n]). %% SWI: nextto/3
	true
*/
right(X,Y,L):- 	nextto(X,Y,L).
/* next(X,Y,L). If X and Y are next to each other in the list.	
	?- next(X,Y,[a,b,c]).
	X = a ,Y = b ;	X = b ,Y = c ;	X = b ,Y = a ;	X = c ,Y = b ;
	?- next(a,b,[m,a,b,c]),next(a,c,[m,a,b,c,d]).
	true.
*/
next(X,Y,L):- 	nextto(X,Y,L) ; nextto(Y,X,L).
/* 	before(X,Y,List) checks if X is before Y in the List.
    Starts from Left to right (normal order..).
    ?-before(a,c,[m,a,v,c,d]).
	true
*/
before(X,Y,L):- append(_,[X|R],L),member(Y,R).
/* neighbor(+X,+Y,X1,Y1,+S). Two cells are neighbors in an array size S
- starts from 0. Assume X and Y are in the range 0 - S.
between(0,I,5) means 0 <= I <= 5
	?-neighbor(1,1,2,2,3). 
	true
	?-neighbor(1,2,I,J,2).  
	I = J = 2 ;	I = 0 ,J = 2 ;
	I = J = 1 ;	I = 2 ,	J = 1 ; I = 0 ,	J = 1 ;
*/
neighbor(X,Y,X1,Y1,S):- ((X1 is X+1, Y=Y1);
			(X1 is X-1, Y=Y1);(X1=X, Y1 is Y+1); 
			(X1=X, Y1 is Y-1);(X1 is X+1, Y1 is Y-1);
			(X1 is X-1, Y1 is Y-1);(X1 is X+1, Y1 is Y+1);
			(X1 is X-1, Y1 is Y+1)),between(0,X1,S),
			between(0,Y1,S).
/*  	Chessboard (any SIZE!). Are on a the same diagonal. */
diagonal(X/Y,X1/Y1):-   A is abs(X-X1),A is abs(Y-Y1). 
/*	Not on the same diagonal*/
not_diagonal([X/Y,X1/Y1]):- A is abs(X-X1),B is abs(Y-Y1),A \= B.