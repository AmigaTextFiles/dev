/* Un autre programme de calcul de pi.
   Un bon exemple de ce quoi l'optimisation avec l'utilisation de
   l'assembleur en ligne peut faire:
   Le sources E est la traduction du source original C, qui met 48 secondes
   pour 250 décimales, la version E met 30 secondes.
   La boucle la plus interne a été mises en assembleur, cette version
   (E+ASm) prend seulement 10 secondes (tous sur 7 MHz).
   Seulement une petite pqrtie a besoin d'être traduite en assembleur, comme
   c'est là que se fait 99% du calcul   */

DEF m,k,n,p,i,max,nr,handle,out,num[50]:STRING,a:PTR TO LONG

PROC main()
  WriteF('Calcul de PI\nNb de décimales (try 50-250): ')
  ReadStr(stdout,num)
  IF (nr:=Val(num,NIL))=0 THEN stop('Illégal #!\n')
  WriteF('Calcule ... pressez CtrlC pour arrêter.\n\n')
  max:=nr*16
  IF (a:=New(max))=NIL THEN stop('Plus de mémoire!\n')
  m:=nr
  k:=m!*3.321-1!
  WriteF('\d\c',k,13)
  FOR n:=k TO 1 STEP -1
    a[0]:=a[0]+2
    p:=n*2+1
    MOVEQ   #0,D7       /* D7=c */
    MOVE.L  a,A0        /* A0=a tableau */
    MOVE.L  m,D4        /* D4=i compteur */
    MOVE.L  p,D2
    MOVE.L  n,D3
l:  MOVE.L  D7,D0       /* cette boucle est hyper optimisée. */
    LSL.L   #3,D0
    ADD.L   D7,D0       /* à la suite, l'équivalent E */
    ADD.L   D7,D0
    MOVE.L  (A0),D1     /* c:=0               */
    MULU    D3,D1       /* x:=a               */
    ADD.L   D1,D0       /* FOR i:=0 TO m      */
    DIVU    D2,D0       /*   c:=10*c+(n*^x)   */
    MOVE.L  D0,D7       /*   ^x:=c/p          */
    EXT.L   D0          /*   c:=c-(^x*p)      */
    MOVE.L  D0,(A0)     /*   x:=x+4           */
    SWAP    D7          /* ENDFOR             */
    EXT.L   D7
    ADDQ.L  #4,A0
    DBRA    D4,l
    IF (n AND $F)=0     /* pas toutes les boucles */
      WriteF('\d     \c',n,13)
      IF CtrlC() THEN stop('\n*** Calcul arrêtée!\n')
    ENDIF
  ENDFOR
  FOR i:=m TO 1 STEP -1
    IF a[i]>9
      a[i]:=a[i]-10
      a[i-1]:=a[i-1]+1
    ENDIF
  ENDFOR
  handle:=Open('ram:pi.txt',1006)
  IF handle<>NIL
    out:=SetStdOut(handle)
    writenum()
    SetStdOut(out)
    Close(handle)
    WriteF('\n\nRegardez ram:pi.txt pour la sortie.\n')
  ELSE
    WriteF('Ne peut ouvrir le fichier de sortie!\n')
  ENDIF
  WriteF('\n')
  writenum()
ENDPROC

PROC stop(messy)
  WriteF(messy)
  CleanUp(5)
ENDPROC

PROC writenum()
  WriteF('pi=3.')
  FOR i:=1 TO m DO WriteF('\d',a[i])
  WriteF('\n')
ENDPROC
