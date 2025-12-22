
MODULE 'reqtools','libraries/reqtools','dos/dos','dos/dosextens',
       'utility/tagitem'

ENUM CPMD_NEW,CPMD_APP,CPMD_ASK

PROC main()
 reqtoolsbase:=OpenLibrary('reqtools.library',38)
 copyfile('S:Startup-Sequence','RAM:Startup-Sequence',CPMD_ASK)
ENDPROC

PROC fehler(text)
 WriteF('\s',text)
ENDPROC

PROC copyfile(in,out,mod)
 DEF han1,han2,buf,rlen,wlen,wahl,doit=TRUE
 IF han1:=Open(in,OLDFILE)
  SELECT mod
   CASE CPMD_NEW
    han2:=Open(out,NEWFILE)
   CASE CPMD_APP
    IF han2:=Open(out,OLDFILE)
     Seek(han2,0,1)
    ELSE
     han2:=Open(out,NEWFILE)
    ENDIF
   CASE CPMD_ASK
   IF (FileLength(out)>0)
    wahl:=RtEZRequestA('File existiert','_Überschreiben|_anhängen|_nix',0,0,
                       [RT_UNDERSCORE,95,
                        TAG_DONE])
    IF wahl=1
     han2:=Open(out,NEWFILE)
    ELSEIF wahl=2
     han2:=Open(out,OLDFILE)
     Seek(han2,0,1)
    ELSE
     doit:=FALSE
    ENDIF
   ELSE
    han2:=Open(out,NEWFILE)
   ENDIF
  ENDSELECT
  IF doit=TRUE
   IF han2
    IF buf:=New(2048)
     REPEAT
      rlen:=Read(han1,buf,2048)
      IF rlen
       wlen:=Write(han2,buf,rlen)
       IF wlen<>rlen THEN fehler('Fehler beim Kopieren !')
      ENDIF
     UNTIL rlen<=0
     Dispose(buf)
     Close(han2)
    ELSE
     fehler('Speichermangel!')
    ENDIF
   ELSE
    fehler('Kann Zielfile nicht öffnen !')
   ENDIF
  ENDIF
  Close(han1)
 ELSE
  fehler('Kann Sourcefile nicht öffnen !')
 ENDIF
ENDPROC


/*
        mfG,
            TOB


The person you rejected yesterday could make you happy, if you say yes.

*/

