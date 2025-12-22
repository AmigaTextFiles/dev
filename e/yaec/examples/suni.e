-> prints out title of html-page (e+)
RAISE "OPEN" IF Open()=NIL
PROC main()
   DEF fh=NIL, mem, flen, x[100]:STRING
   fh := Open(arg, OLDFILE)
   flen := FileLength(arg) 
   NEW mem[flen+4]
   Read(fh, mem, flen)
   IF mem <=> *,'<TITLE>',x,'</TITLE>',* THEN WriteF('\s\n', x)
EXCEPT DO
   IF fh THEN Close(fh)
ENDPROC

