/**********************************************\
*                                              *
*  Jaeger und Beute, Fakten                    *
*                                              *
*  Autor  : Gerrit M. Albrecht                 *
*  E-Mail : galbrech@csmd.cs.uni-magdeburg.de  *
*  Datum  : 22. Mai 1996                       *
*                                              *
\**********************************************/

tier(maus).
tier(katze).
tier(hund).
tier(spatz).
tier(bussard).
tier(eule).
tier(fuchs).

jagt(katze,maus).
jagt(hund,katze).
jagt(katze,spatz).
jagt(bussard,maus).
jagt(eule,maus).
jagt(fuchs,maus).
jagt(hund,fuchs).

