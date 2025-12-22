/**********************************************\
*                                              *
*  Mensa-Essenauswahl                          *
*                                              *
*  Autor  : Gerrit M. Albrecht                 *
*  E-Mail : galbrech@csmd.cs.uni-magdeburg.de  *
*  Datum  : 29. Mai 1996                       *
*                                              *
\**********************************************/

vorspeise(kein,0).
vorspeise(suppe,3).
vorspeise(salat,2).

haupt(schnitzel,8).
haupt(braten,10).
haupt(steak,9).

dessert(kein,0).
dessert(obst,3).
dessert(eis,5).

getraenk(kein,0).
getraenk(wein,4).
getraenk(bier,3).

menu(V,H,D,G,Preis) :-
  vorspeise(V,VP),
  haupt(H,HP),
  dessert(D,DP),
  getraenk(G,GP),
  P is VP+HP+DP+GP,
  P=<Preis,
  HP<P.

