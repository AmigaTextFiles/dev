/*
  wrote by Neng-Fa Zhou
z2sics(In) : translate the matching clauses in the file In into standard
             Edinburgh-style clauses and output the translated clauses into 
             standard output file.
z2sics(In,Out): The same as z2sics but the results are output into the file Out.
*/

:-op(1150,xfy,':'),op(1150,xfy,'?').
:-op(1050,xfy,'->').
:-op(700,xfx,':=').
:-op(900,xfx,'<=').
:-op(500,xfx,'..').
:-op(700,xfx,'?=').
:-op(700,xfx,'\=').

z2sics(In):-
    see(In),
    read(Cl),
    transform(Cl).

z2sics(In,Out):-
    see(In),
    tell(Out),
    read(Cl),
    transform(Cl),
    seen,told.

transform(end_of_file):-
    seen, !.
transform(Cl):-
    read(Cl1),
    trans_clause(Cl,Cl1),
    transform(Cl1).

trans_clause((:-_),_).
trans_clause((H:-G : B),(H1:-_)):-
    functor(H,F,N),
    functor(H1,F,N),!,
    trans_goals(G,G1,_),
    trans_goals(B,B1,_),
%    assertz((H:-G1,!,B1)),
    writeq((H:-G1,!,B1)),
    write('.'),nl.
trans_clause((H:-G : B),_):-
    trans_goals(G,G1,_),
    trans_goals(B,B1,_),
%    assertz((H:-G1,B1)),
    writeq((H:-G1,B1)),
    write('.'),nl.
trans_clause((H:-G ? B),_):-
    trans_goals(G,G1,_),
    trans_goals(B,B1,_),
%    assertz((H:-G1,B1)),
    writeq((H:-G1,B1)),
    write('.'),nl.
trans_clause(Cl,_):-
%    assertz(Cl),
    writeq(Cl),
    write('.'),nl.
    
trans_goals((G,Gs),(NG,NGs),NonvarTests):-!,
    trans_goal(G,NG,NonvarTests),
    trans_goals(Gs,NGs,NonvarTests).
trans_goals(G,NG,NonvarTests):-
    trans_goal(G,NG,NonvarTests).

trans_goal(nonvar(X),NG,NonvarTests):-
    NG=nonvar(X),
    attach_nonvar(X,NonvarTests).
trans_goal(X<=Y,NG,_):-X=dvar(_,_,_),!,NG=(X=Y).
trans_goal(X<=Y,NG,_):-X=domain(_,_,_,_,_,_,_),!,NG=(X=Y).
trans_goal(X<=Y,NG,_):-X=element(_,_,_),!,NG=(X=Y).
trans_goal(X<=Y,NG,_):-X=eq(_,_),!,NG=(X=Y).
trans_goal(X<=Y,NG,_):-X=neq(_,_),!,NG=(X=Y).
trans_goal(X<=Y,NG,_):-X=gt(_,_),!,NG=(X=Y).
trans_goal(X<=Y,NG,_):-X=cs(_,_,_,_,_,_),!,NG=(X=Y).
trans_goal(X<=Y,NG,NonvarTests):-not_member_nonvar(Y,NonvarTests),!,
    X=Y,NG=true.
trans_goal(X<=Y,NG,_):-NG=(X=Y).
trans_goal((X:=Y),NG,_):-!,NG=(X=Y).
trans_goal((X?=Y),NG,_):-!,NG=(X=Y).
trans_goal(unifiable(X,Y),NG,_):-!,NG=(X=Y).

trans_goal('$match'(X,Y),NG,_):-!,NG=(X=Y).

trans_goal(X,X1,_):-X1=X.

not_member_nonvar(_,L):-
    var(L),!.
not_member_nonvar(Y,[X|_]):-
    Y==X,!,
    fail.
not_member_nonvar(Y,[_|L]):-
    not_member_nonvar(Y,L).

attach_nonvar(X,Y) :- 
    var(Y),!,
    Y=[X|_].
attach_nonvar(X,[_|T]):-
    attach_nonvar(X,T).

/*
cputime(X):- 
	statistics(runtime,[X|_]).
*/
