/*
written by Neng-Fa Zhou
whatpreds(F) where F is a file or a list of files. It reports those 
predicates that are defined, those used but not defined, those defined but 
not used, and those that are built-in in the file (or files).
*/

:-determinate([expand_term/2]).

whatpreds([F|Fs]):-
    collect_res([F|Fs],Defined,Used),
    report_res(Defined,Used).
whatpreds(F):-
    collect_res(F,Defined,Used),
    report_res(Defined,Used).

report_res(Defined,Used):-
    closetail(Defined),
    closetail(Used),
    builtin_preds(Used,Builtin,Used1),
    dif(Used1,Defined,Import),
    dif(Defined,Used,DefinedNotUsed),
    sort(Defined,DefinedSrt),
    sort(Import,ImportSrt),
    sort(Builtin,BuiltinSrt),
    sort(DefinedNotUsed,DefinedNotUsedSrt),
    prt_res(DefinedSrt,ImportSrt,DefinedNotUsedSrt,BuiltinSrt).

collect_res([],Defined,Used):-!.
collect_res(F,Defined,Used):-
    atom(F),!,
    name(F,F_l),
    name('.pl',T1),
    append(F_l,T1,Fin_l),
    name(Fin,Fin_l),
    (exists(Fin)->
     see(Fin),
     getclauses(Clauses),
     seen,
     inf(Clauses,Used,Defined);
     warning([Fin, ' does not exist'])).
collect_res([F|Fs],Defined,Used):-
    collect_res(F,Defined,Used),
    collect_res(Fs,Defined,Used).

getclauses(Clauses):-read(X),
	(X==end_of_file->Clauses=[];
	 X=(:-op(Op,Assoc,Prec)) -> op(Op,Assoc,Prec),getclauses(Clauses);
	 Clauses=[X|Clauses1],getclauses(Clauses1)).
	
closetail(L):-var(L) : L=[].
closetail([]):-true : true.
closetail([_|Xs]):-true : closetail(Xs).

inf([],Used,Defined):-true : true.
inf([(:-B)|Cs],Used,Defined):-
	true :
	inf_body(B,Used),
	inf(Cs,Used,Defined).
inf([(H:-B)|Cs],Used,Defined):-
	true :
	functor(H,F,N),
	member1(F/N,Defined),
	inf_body(B,Used),
	inf(Cs,Used,Defined).
inf([(LHS-->RHS)|Cs],Used,Defined):-
	true :
	expand_term((LHS-->RHS),C),
	inf([C|Cs],Used,Defined).
inf([C|Cs],Used,Defined):-
	true :
	functor(C,F,N),
	member1(F/N,Defined),
	inf(Cs,Used,Defined).

inf_body(G,_):-var(G) : true.
inf_body((G : Gs),Used):- true :
	inf_body(G,Used),
	inf_body(Gs,Used).
inf_body((G ? Gs),Used):- true :
	inf_body(G,Used),
	inf_body(Gs,Used).
inf_body((G,Gs),Used):- true :
	inf_body(G,Used),
	inf_body(Gs,Used).
inf_body('->'(G,Gs),Used):-true :
	inf_body(G,Used),
	inf_body(Gs,Used).
inf_body(';'('->'(A,B),C),Used):-true :
	inf_body(A,Used),
	inf_body(B,Used),
	inf_body(C,Used).
inf_body((G;Gs),Used):-true :
	inf_body(G,Used),
	inf_body(Gs,Used).
inf_body(not(G),Used):-true :
	inf_body(G,Used).
inf_body(G,Used):- true :
	functor(G,F,N),
        member1(F/N,Used).

dif([],_,L3):-true : L3=[].
dif([X|L1],L2,L3):-
    membchk(X,L2) :
    dif(L1,L2,L3).
dif([X|L1],L2,L3):-
	true : L3=[X|L4],
	dif(L1,L2,L4).

builtin_preds([],Builtin,Rest):-
    true :
    Rest=[],
    closetail(Builtin).
builtin_preds([Pred|Preds],Builtin,Rest):-
    F/N<=Pred,
    predefined(F,N) :
    member1(Pred,Builtin),
    builtin_preds(Preds,Builtin,Rest).
builtin_preds([Pred|Preds],Builtin,Rest):-
    true :
    Rest:=[Pred|Rest1],
    builtin_preds(Preds,Builtin,Rest1).

prt_res(Defined,Used,DefinedNotUsed,Builtin):-
	write('/*********************************************************************/'),nl,
	write('/* '),nl,
	write('defined:'), nl,
	p_names(Defined),
	nl,nl,
	write('used_but_not_defined:'),nl,
	p_names(Used),
        nl,nl,
	write('defined_but_not_used:'),nl,
	p_names(DefinedNotUsed),
	nl,nl,
	write('builtin:'),nl,
	p_names(Builtin),
	nl,
	write('**********************************************************************/'),nl.

p_names([]).
p_names([N]):-!,tab(5),write(N).
p_names([N|Names]):-tab(5),write(N),nl,p_names(Names).

membchk(X,[X|Xs]):-
	true : true.
membchk(X,[_|Xs]):-
	true : membchk(X,Xs).

member1(X,L):-
	var(L) : L=[X|_].
member1(X,[H|T]):-
	true : member1(X,T).

warning(Mes):-
    true :
    write(user,'** warning ** '),
    write(user,Mes),nl(user),
    fail.




















	
