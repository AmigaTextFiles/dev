/* Montre comment attraper les exceptions du processeur de vos propres
   programmes.
   Je ne garantie pas que ce que fait le module trapguru.m est 100% ok
   pour tous les CPU
*/

MODULE 'tools/trapguru'

PROC main()
  DEF a
  trapguru()                       -> installe le gestionnaire
  FOR a:=1 TO 10 DO bla(a)
ENDPROC

PROC bla(x) HANDLE
  DEF a=0
  a:=a/a             -> cause l'exception processeur
EXCEPT
  IF exception="GURU"
    WriteF('Un GURU \d est arrivé: $\z\h[8]\n',x,exceptioninfo)
  ENDIF
ENDPROC
