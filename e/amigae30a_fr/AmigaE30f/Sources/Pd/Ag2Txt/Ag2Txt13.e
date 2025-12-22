ENUM NONE, ATSIGN, TILLEND, BRAC, BRACSEND, TILLBRAC,
     GOT_N, GOT_O, GOT_D, GOT_E, SKIPARG, NODE, NODESEND

ENUM ERR_SHORT, ERR_MEM, ERR_IO, ERR_FILE

CONST QUOTE=34, RET=10, ESC=27,
      FONT_BOLD="1", FONT_ITALIC="3", FONT_REVERSE="7", FONT_NORMAL="0"

RAISE ERR_MEM IF New()=NIL,
      ERR_FILE IF Open()=NIL

PROC main() HANDLE
  DEF state=NONE, in:PTR TO CHAR, out:PTR TO CHAR, file=NIL, len,
      max, bin=NIL, bout=NIL, errors:PTR TO LONG, quote
  file:=Open(arg, OLDFILE)
  IF (len:=FileLength(arg))=0 THEN Raise(ERR_SHORT)
  bin:=New(len)
  bout:=New(len)
  IF (Read(file, bin, len)<>len) THEN Raise(ERR_IO)
  in:=bin
  out:=bout
  max:=bin+len
  WHILE in<max
    SELECT state
    CASE NONE
      IF in[]="@"
        IF in[1]="{"
          state:=BRAC
          in++
        ELSEIF (in=bin) OR (in[-1]=RET)
          state:=ATSIGN
        ELSE
          out[]++:=in[]
        ENDIF
      ELSE
        out[]++:=in[]
      ENDIF
    CASE ATSIGN
      IF (in[]="N") OR (in[]="n")
        state:=GOT_N
      ELSE
        state:=TILLEND
      ENDIF
    CASE TILLEND
      IF in[]=RET THEN state:=NONE
    CASE BRAC
      IF in[]<>" "
        quote:=(in[]=QUOTE)
        out[]++:=ESC
        out[]++:="["
        out[]++:=FONT_ITALIC
        out[]++:="m"
        state:=BRACSEND
      ENDIF
    CASE BRACSEND
      IF (quote AND (in[]=QUOTE)) OR ((quote=FALSE) AND (in[]=" "))
        out[]++:=ESC
        out[]++:="["
        out[]++:=FONT_NORMAL
        out[]++:="m"
        state:=TILLBRAC
      ELSE
        out[]++:=in[]
      ENDIF
    CASE TILLBRAC
      IF in[]="}" THEN state:=NONE
    CASE GOT_N
      IF (in[]="O") OR (in[]="o") THEN state:=GOT_O ELSE state:=TILLEND
    CASE GOT_O
      IF (in[]="D") OR (in[]="d") THEN state:=GOT_D ELSE state:=TILLEND
    CASE GOT_D
      IF (in[]="E") OR (in[]="e") THEN state:=GOT_E ELSE state:=TILLEND
    CASE GOT_E
      IF in[]<>" "
        quote:=(in[]=QUOTE)
        state:=SKIPARG
      ENDIF
    CASE SKIPARG
      IF (quote AND (in[]=QUOTE)) OR ((quote=FALSE) AND (in[]=" "))
        state:=NODE
      ENDIF
    CASE NODE
      IF in[]<>" "
        quote:=(in[]=QUOTE)
        out[]++:=ESC
        out[]++:="["
        out[]++:=FONT_REVERSE
        out[]++:="m"
        state:=NODESEND
      ENDIF
    CASE NODESEND
      IF (quote AND (in[]=QUOTE)) OR
         ((quote=FALSE) AND (in[]=" ")) OR (in[]=RET)
        out[]++:=ESC
        out[]++:="["
        out[]++:=FONT_NORMAL
        out[]++:="m"
        out[]++:=RET
        out[]++:=RET
        state:=IF in[]=RET THEN NONE ELSE TILLEND
      ELSE
        out[]++:=in[]
      ENDIF
    DEFAULT
      out[]++:=in[]
    ENDSELECT
    in++
  ENDWHILE
  WriteF('')
  Write(stdout, bout, out-bout)
  Close(file)
EXCEPT
  errors:=['Le fichier est vide\n', 'Ne peut allouer la mémoire\n',
           'Erreur de lecture du fichier\n']
  IF file THEN Close(file)
  IF exception=ERR_FILE
    WriteF('Fichier "\s" non trouvé!\n', arg)
  ELSE
    WriteF(errors[exception])
  ENDIF
ENDPROC