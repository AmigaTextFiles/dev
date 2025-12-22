/* $VER: readline 1.2 (25.9.97) © Frédéric RODRIGUES
   plus rapide que ReadStr et Fgets
   v1.1 (28.2.97) - cette version ajuste son tampon dynamiquement
                    il reste un bug : je ne peux pas utiliser l'écran pour
                    les redirections : problèmes d'affichage
                    plus qu'un seul appel à InStr : cette version devrait
                    être plus rapide
   v1.2 (25.9.97) - j'en ai fait un module

   Timings:              milliseconds  (file in RAM)
   readline            - 0.786
   readStr (E list)    - 3.257
   FGets (dos.library) - 3.562
   ReadStr             - 30.082
*/

OPT MODULE

CONST SIZEBUF=1024 /* ATTENTION ! doit être multiple de 4 pour que çà marche */
                   /* la vitesse dépend de cette valeur */

OBJECT objreadline
  line
  s
  buf
  sizebuf
  fh
ENDOBJECT

EXPORT PROC readlinefrom(fh)
  DEF objreadline:PTR TO objreadline
  NEW objreadline
  objreadline.buf:='\0'
  objreadline.sizebuf:=0
  objreadline.s:=objreadline.buf
  objreadline.fh:=fh
ENDPROC objreadline

EXPORT PROC readline(o)
  DEF pos,objreadline:PTR TO objreadline
  objreadline:=o
  objreadline.line:=objreadline.s
l:
  IF (pos:=InStr(objreadline.line,'\n',0))=-1
    IF objreadline.line<>objreadline.buf
      AstrCopy(objreadline.buf,objreadline.line,ALL)
    ELSE
      objreadline.sizebuf:=objreadline.sizebuf+SIZEBUF
      pos:=NewR(objreadline.sizebuf)
      AstrCopy(pos,objreadline.buf,ALL)
      Dispose(objreadline.buf)
      objreadline.buf:=pos
    ENDIF
    pos:=StrLen(objreadline.buf)
    IF (pos:=Read(objreadline.fh,objreadline.buf+pos,objreadline.sizebuf-pos))=0
      objreadline.line:='\0'
      RETURN FALSE
    ENDIF
    IF pos<0 THEN Raise("dos")
    objreadline.line:=objreadline.buf
    objreadline.s:=objreadline.buf
    JUMP l
  ELSE
    objreadline.s:=objreadline.line+pos
    pos:=objreadline.s
    pos[]++:=0
    objreadline.s:=pos
  ENDIF
ENDPROC TRUE

EXPORT PROC endreadline(o:PTR TO objreadline)
  Dispose(o.buf)
  END o
ENDPROC
