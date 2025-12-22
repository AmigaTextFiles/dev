sched_cons(X) :-
    Bool in 0..1,
    X=[SA,SB,SC,SD,SE,SF,SG,SH,SJ,SK,Send],
    X in 1..30,
    '#>='(SB,SA+7),
    '#>='(SD,SA+7),
    '#>='(SC,SB+3),
    '#>='(SE,SC+1),
    '#>='(SE,SD+8),
    '#>='(SG,SC+1),
    '#>='(SG,SD+8),
    '#>='(SF,SD+8),
    '#>='(SF,SC+1),
    '#>='(SH,SF+1),
    '#>='(SJ,SH+2),
    '#>='(SK,SG+1),
    '#>='(SK,SE+2),
    noverlap(SG,1,SE,2,Bool),
    '#>='(SK,SJ+1),
    '#>='(Send,SK+1).


noverlap(E,N,G,M,B) :-  50*B+G #>= E+N, 50+E #> G+M+B*50.

sched(X,Cost) :-
    sched_cons(X),
    writeln(schedule),
    X = [A,B,C,D,E,F,G,H,J,K,_],
    Cost in 1..10000,
    Cost #= 10*A+20*B+15*C+20*D+10*E+20*F+5*G+15*H+10*J+5*K,
    writeln(costs),
    labeling(X).

writeln(X):-write(X),nl.

 
