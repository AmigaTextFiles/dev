/* find breuk

try: 0.14159   -> 1/7 (22/7 = 355/113 = pi)
try: 0.618034  -> fibonacci
try: 0.1234568 -> 10/81

*/
PROC main()
  DEF s[20]:STRING,t[20]:STRING,u[20]:STRING
  DEF b=0,max=1,a,best,bst,bsta,d

  best:=2.0
  b,a:=RealVal(arg)
  PrintF('Ctrl-C to stop searching for \s ...\n',RealF(s,b,7))

  WHILE (CtrlC()=FALSE)
    bst:=2.0

    FOR a:=0 TO max
      d:=dist(a!/(max!),b)
      IF !d<bst
        bst:=d
        bsta:=a
      ENDIF
    ENDFOR
    d:=dist(bsta!/(max!),b)
    IF !d<best
      best:=d
      WriteF('best sofar: \d\t/ \d,\tdistance \s .. \s = \s\n',bsta,max,RealF(s,b,7),RealF(t,bsta!/(max!),7),RealF(u,best,7))
      IF (!best=0.0)
        WriteF('best possible reached...\n')
        RETURN
      ENDIF
    ENDIF
    max++
  ENDWHILE

ENDPROC

PROC dist(a,b) IS Abs(!(!a-b)*10000000.0!)!/10000000.0

