/**********************************************\
*                                              *
*  Affe - Banane - Problem                     *
*                                              *
*  Autor  : Gerrit M. Albrecht                 *
*  E-Mail : galbrech@csmd.cs.uni-magdeburg.de  *
*  Datum  : 22. Mai 1996                       *
*                                              *
\**********************************************/

zustand(an_tuer, auf_boden, am_fenster, hat_nicht).
zustand(_,_,_,hat).

kann_erhalten(zustand(_,_,_,hat)).
kann_erhalten(Zustand1) :- zug(Zustand1, Zug, Zustand2),
                           kann_erhalten(Zustand2).

zug(zustand(P1, auf_boden, K, H),
    geht(P1, P2),
    zustand(P2, auf_boden, K, H)).
zug(zustand(P, auf_boden, P, H),
    klettert,
    zustand(P, auf_kiste, P, H)).
zug(zustand(P1, auf_boden, P1, H),
    schiebt(P1, P2),
    zustand(P2, auf_boden, P2, H)).
zug(zustand(mitte, auf_kiste, mitte, hat_nicht),
    greift,
    zustand(mitte, auf_kiste, mitte, hat)).

