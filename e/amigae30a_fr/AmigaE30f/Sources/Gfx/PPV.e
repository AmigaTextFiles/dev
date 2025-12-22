/* 256 niveau de gris de fichiers de POVRAY

   Affiche rapidement les fichiers 24-bits ded POV-ray sur une écran AGA de 256 niveau de gris
   Pas d'implémentation spéciale.

*/

MODULE 'tools/file'

PROC main() HANDLE
  DEF scr=NIL,win=NIL,a,p,name,xs,ys,x,y
  name:=IF arg[] THEN arg ELSE 'data.dis'
  p:=readfile(name)
  xs:=p[0]+(p[1]*256); ys:=p[2]+(p[3]*256); p:=p+4
  WriteF('POV-Ray Quick 256 Greyscale PreView, $#%!\n' +
         'file: "\s", (\dx\d) [mouse pour quitter]\n',name,xs,ys)
  IF scr:=OpenS(xs,ys,8,$0,'')
    IF win:=OpenW(0,0,xs,ys,$8,0,'',scr,15,0)
      FOR a:=0 TO 255 DO SetColour(scr,a,a,a,a)
      FOR y:=0 TO ys-1
        p:=p+2
        FOR x:=0 TO xs-1 DO Plot(x,y,p[x]+p[x+xs]+p[x+xs+xs]/3)
        p:=xs*3+p
      ENDFOR
      WaitIMessage(win)
    ENDIF
  ENDIF
EXCEPT DO
  CloseW(win)
  CloseS(scr)
  IF exception THEN WriteF('exception: "\s", info: "\s"\n',
    [exception,0],IF exceptioninfo THEN exceptioninfo ELSE '')
ENDPROC
