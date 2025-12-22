/**********************************************\
*                                              *
*  Wasserkrugproblem                           *
*                                              *
*  Autor  : Gerrit M. Albrecht                 *
*  E-Mail : galbrech@csmd.cs.uni-magdeburg.de  *
*  Datum  : 29. Mai 1996                       *
*                                              *
\**********************************************/


/* Starttext */

infotext :-
  write('Mit diesem Programm kann man mit einem'),nl,
  write('7l und einem 5l Eimer genau 4l abmessen.'),nl,
  write('Programmiert mit SBProlog 3.1'),nl.


/* Append */

append([], L, L).
append([E|R1], L2, [E|R3]) :-
  append(R1, L2, R3).


/* Reverse */

reverse([], []).
reverse([X|Rest], M) :-
  reverse(Rest, Z),
  append(Z, [X], M).


/* Member */

member(E, [E|Rest]).
member(E, [K|Rest]) :-
  member(E, Rest).


/* Moegliche Aktionen - zug(AnfZustand,AktionsName,EndZustand). */
/* Reihenfolge ist wichtig fuer die Loesungsfindung, aber sonst egal ! */

zug([G,K], fuelle_gr_krug,  [7,K]) :- G<7.
zug([G,K], fuelle_kl_krug,  [G,5]) :- K<5.
zug([G,K], leere_gr_krug,   [0,K]) :- G>0.
zug([G,K], leere_kl_krug,   [G,0]) :- K>0.
zug([G,K], fuelle_kl_in_gr, [V,0]) :- K>0, G+K =< 7, V is G+K.
zug([G,K], fuelle_kl_in_gr, [7,V]) :- K>0, G+K  > 7, V is G+K-7.
zug([G,K], fuelle_gr_in_kl, [V,0]) :- G>0, G+K =< 5, V is G+K.
zug([G,K], fuelle_gr_in_kl, [7,V]) :- G>0, G+K  > 5, V is G+K-5.


/* weg(ZustandsMerkListe, Endzustand, AusgabeparameterListe). */

weg([ZE|R], ZE, [ZE|R]).               /* Abbruchbedingung */
weg([Z|R], ZE, L) :-                   /* Suche */
  zug(Z, A, ZZ),                       /* eine Aktion ausfuehren */
  not member(ZZ, [Z|R]),               /* Aktion noch nicht in Liste */
  weg([ZZ,Z|R], ZE, L).                /* Aktion zu Liste hinzufuegen */


/* Hauptprogramm */

start :-
  infotext,
  ZA=[0,0],                            /* Anfangszustand */
  ZE=[4,0],                            /* Endzustand */
  weg([ZA], ZE, L),                    /* Es geht los */
  reverse(L, L1),                      /* Fertig: Liste umdrehen */
  write(L1).                           /* und ausgeben */

