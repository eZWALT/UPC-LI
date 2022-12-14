:- use_module(library(clpfd)).

%ejemplo(_, Big, [S1...SN]): how to fit all squares of sizes S1...SN in a square of size Big?
ejemplo(0,  3,[2,1,1,1,1,1]).
ejemplo(1,  4,[2,2,2,1,1,1,1]).
ejemplo(2,  5,[3,2,2,2,1,1,1,1]).
ejemplo(3, 19,[10,9,7,6,4,4,3,3,3,3,3,2,2,2,1,1,1,1,1,1]).
ejemplo(4,112,[50,42,37,35,33,29,27,25,24,19,18,17,16,15,11,9,8,7,6,4,2]).
ejemplo(5,175,[81,64,56,55,51,43,39,38,35,33,31,30,29,20,18,16,14,9,8,5,4,3,2,1]).

main:- 
    ejemplo(3,Big,Sides),
    nl, write('Fitting all squares of size '), write(Sides), write(' into big square of size '), write(Big), nl,nl,
    
    %VARIABLES
    length(Sides,N), 
    length(RowVars,N), % get list of N prolog vars: Row coordinates of each small square
    length(ColVars,N), % get list of N prolog vars: Column coordinates of each small square

    %DOMAIN

    %CONSTRAINTS
    insideBigSquare(_,Big,Sides,RowVars),
    insideBigSquare(_,Big,Sides,ColVars),
    nonoverlapping(Sides,RowVars,ColVars),

    %LABELING
    label(RowVars), label(ColVars),

    %WRITE
    displaySol(N,Sides,RowVars,ColVars), halt.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    insideBigSquare(_,_,[],[]):-!.
    insideBigSquare(_,Big,[S|Sides],[V|Vars]):-
        write(Big),write(S),
        Limit is Big-S+1, 
        V in 1..Limit,
        insideBigSquare(_,Big,Sides,Vars).

    %nonoverlapping(Sides,RowVars,ColVars):-
    %    createRectangles(Sides,RowVars,ColVars,L), disjoint2(L).

    %createRectangles([],[],[],[]):-!.
    %createRectangles([S|Sides], [R|RowVars], [C|ColVars], [L1|L]):-
    %    L1 = r(R,S,C,S), createRectangles(Sides,RowVars,ColVars,L).

    nonoverlapping([],[],[]):-!.
    nonoverlapping([S|Sides],[R|RowVars],[C|ColVars]):-
            noSolapingContodos(S,R,C,Sides,RowVars,ColVars), nonoverlapping(Sides,RowVars,ColVars).

    noSolapingContodos(_,_,_,[],[],[]):-!.
    noSolapingContodos(S,R,C,[S1|Sides],[R1|RowVars],[C1|ColVars]):-
        noSolapingDosPaDos(S,R,C,S1,R1,C1), noSolapingContodos(S,R,C,Sides,RowVars,ColVars).

    noSolapingDosPaDos(S,R,C,S1,R1,C1):-
        R + S #=< R1, 
        C + S #=< C1,
        R1 + S1 #=< R,
        C1 + S1 #=< C.


displaySol(N,Sides,RowVars,ColVars):- 
    between(1,N,Row), nl, between(1,N,Col),
    nth1(K,Sides,S),    
    nth1(K,RowVars,RV),    RVS is RV+S-1,     between(RV,RVS,Row),
    nth1(K,ColVars,CV),    CVS is CV+S-1,     between(CV,CVS,Col),
    writeSide(S), fail.
displaySol(_,_,_,_):- nl,nl,!.

writeSide(S):- S<10, write('  '),write(S),!.
writeSide(S):-       write(' ' ),write(S),!.