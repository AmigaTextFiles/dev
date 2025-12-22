/* Lit un exemple de fichier. Notez que ce programme n'a pas de limite dure
   sur lea longueur du fichier */

CONST MAXLINELEN=1000

PROC main()
  DEF fh,buf[MAXLINELEN]:ARRAY,n=0,last=NIL,s,first=NIL
  IF fh:=Open(arg,OLDFILE)
    WHILE Fgets(fh,buf,MAXLINELEN)
      IF (s:=String(StrLen(buf)))=NIL THEN Raise("MEM")
      StrCopy(s,buf,ALL)
      IF last THEN Link(last,s) ELSE first:=s
      last:=s
      INC n
    ENDWHILE
    Close(fh)
    WriteF('FICHIER: "\s", \d lignes.\n\n',arg,n)
    s:=first
    WHILE s
      PutStr(s)
      s:=Next(s)
    ENDWHILE
    DisposeLink(first)
  ELSE
    WriteF('Pas de fichier : "\s"\n',arg)
  ENDIF
ENDPROC
