/*

idée: Piet Molenaar

calcule (a*a-4)*3 pour a = 2 à ..
trouve les "a" (entier, a,a+1,a+2 sont les longueurs d'un triangle avec
pritquements les mêmes cotés), tel que la surface soit un nombre rond!
Remarquable!

*/

MODULE 'tools/longrealtiny'

PROC main()
  DEF a:longreal, b:longreal, c:longreal, d:longreal, e:longreal, s[100]:STRING, x
  dInit()
  dFloat(4,b)
  dFloat(3,c)
  FOR x:=2 TO 40000
    IF (x AND $FFF)=0 THEN WriteF('Calcul, stade: \d\n',x)
    IF CtrlC() THEN RETURN
    dRound(dCopy(e,dSqrt(dMul(dSub(dMul(dFloat(x,a),a,d),b),c))))
    IF dCompare(e,d)=0 THEN WriteF('\d <=> \s\n',x,dFormat(s,d,20))
  ENDFOR
  dCleanup()
ENDPROC
