/**********************************************\
*                                              *
*  Stammbaum                                   *
*                                              *
*  Autor  : Gerrit M. Albrecht                 *
*  E-Mail : galbrech@csmd.cs.uni-magdeburg.de  *
*  Datum  : 22. Mai 1996                       *
*                                              *
\**********************************************/

/* Personen */

weiblich(iris).
weiblich(gertrud).
weiblich(kaethe).
weiblich(helga).
maennlich(gerrit).
maennlich(uwe).
maennlich(kurt).

/* Beziehungen */

vater(uwe,gerrit).
vater(uwe,iris).
mutter(gertrud,gerrit).
mutter(gertrud,iris).
mutter(kaethe,gertrud).
mutter(helga,uwe).
vater(kurt,uwe).

/* Regeln */

elternteil(E,P) :- vater(E,P).
elternteil(E,P) :- mutter(E,P).

/*

Ich habe hier fuer die Datenbasis
 - maennlich()
 - weiblich()
 - vater()
 - mutter()
benutzt. Eigentlich sollten aber
 - mann()
 - frau()
 - elternteil()
benutzt werden. Hier also die Regeln,
die jetzt eigentlich ueberfluessig sind:

vater(V,K)  :- elternteil(V,K),maennlich(V).
mutter(M,K) :- elternteil(M,K),weiblich(M).

stattdessen gibt es ja jetzt die Regeln fuer
 - elternteil()

*/

onkel(O,P)      :- elternteil(E,P),bruder(O,E).
tante(T,P)      :- elternteil(E,T),schwester(T,E).
/*schwester(S,P)  :- weiblich(S),elternteil(E,S),elternteil(E,P),S\=P.*/
schwester(S,P)  :- weiblich(S),mutter(M,S),mutter(M,P),vater(V,S),vater(V,P),S\=P.
bruder(B,P)     :- maennlich(B),elternteil(E,B),elternteil(E,P),S\=P.
neffe(N,P)      :- maennlich(N),tante(P,N).
neffe(N,P)      :- maennlich(N),onkel(P,N).
nichte(N,P)     :- weiblich(N),tante(P,N).
nichte(N,P)     :- weiblich(N),onkel(P,N).
kind(K,E)       :- elternteil(E,K).
opa(O,E)        :- vater(O,V),elternteil(V,E).
oma(O,E)        :- mutter(O,M),elternteil(M,E).
cousine(C,P)    :- weiblich(C),neffe(P,X),kind(C,X).
cousine(C,P)    :- weiblich(C),nichte(P,X),kind(C,X).

