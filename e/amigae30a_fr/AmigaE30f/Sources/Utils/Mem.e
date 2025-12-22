/* Un très petit utilitaire pour récupérer la mémoire dans un shell.
   usage: MEM <adr>

  dumpe la mémore dans un shell siplement, util pour les debbugages
  kamikases et du style.

  Essayez:
   1> mem $f80000        ; seulement si vous avez un kick 2.0 à sa place
                           ou mieux

*/

PROC main()
  DEF adr,a,b,radr:PTR TO LONG,c,r
  adr,r:=Val(arg)
  IF r=0
    WriteF('Usage: MEM <adr>\n')
  ELSE
    adr:=adr AND -2     /* no odd adr */
    FOR a:=0 TO 7
      radr:=a*16+adr
      WriteF('$\r\z\h[8]:   ',radr)
      FOR b:=0 TO 3 DO WriteF('\r\z\h[8] ',radr[b])
      WriteF('  "')
      c:=radr
      FOR b:=0 TO 15 DO Out(stdout,IF (c[b]<32) OR (c[b]>126) THEN "." ELSE c[b])
      WriteF('"\n')
    ENDFOR
  ENDIF
ENDPROC
