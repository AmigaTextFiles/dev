OPT OSVERSION=37

ENUM NONE, ATSIGN, TILLEND, BRAC, BRACSEND, TILLBRAC,
     GOT_N, GOT_O, GOT_D, GOT_E, SKIPARG, NODE, NODESEND

ENUM ERR_SHORT, ERR_MEM, ERR_IO, ERR_FILE, ERR_ARGS, ERR_NONE

ENUM ARG_FROM, ARG_TO, ARG_NODEFONT, ARG_LINKFONT

ENUM NODEFONT, LINKFONT

CONST QUOTE=34, RET=10, ESC=27,
      FONT_BOLD="1", FONT_ITALIC="3", FONT_REVERSE="7", FONT_NORMAL="0"

RAISE ERR_ARGS IF ReadArgs()=NIL,
      ERR_MEM  IF New()=NIL,
      ERR_FILE IF Open()=NIL

DEF font[2]:ARRAY

PROC main() HANDLE
  DEF state=NONE, quote, in:PTR TO CHAR, out:PTR TO CHAR,
      from=NIL, to=NIL, len, max, bin=NIL, bout=NIL,
      errors:PTR TO LONG, rdargs=NIL, args:PTR TO LONG, templ
  args:=[0, 0, 0, 0]
  templ:='FROM/A,TO,NODEFONT=NODE/K,LINKFONT=LINK/K'
  rdargs:=ReadArgs(templ, args, NIL)
  from:=Open(args[ARG_FROM], OLDFILE)
  IF (len:=FileLength(args[ARG_FROM]))=0 THEN Raise(ERR_SHORT)
  IF args[ARG_TO]
    to:=Open(args[ARG_TO], NEWFILE)
  ELSE
    WriteF('')
    to:=stdout
  ENDIF
  font[NODEFONT]:=FONT_REVERSE
  font[LINKFONT]:=FONT_ITALIC
  IF args[ARG_NODEFONT] THEN setfont(args[ARG_NODEFONT], NODEFONT)
  IF args[ARG_LINKFONT] THEN setfont(args[ARG_LINKFONT], LINKFONT)
  bin:=New(len)
  bout:=New(len)
  IF (Read(from, bin, len)<>len) THEN Raise(ERR_IO)
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
        out[]++:=font[LINKFONT]
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
        out[]++:=font[NODEFONT]
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
  Write(to, bout, out-bout)
  Raise(ERR_NONE)
EXCEPT
  errors:=['Le fichier est vide\n', 'Nepeut pas allouer la mémoire\n',
           'Erreur de lecture du fichier\n']
  IF to THEN Close(to)
  IF from THEN Close(from)
  IF rdargs THEN FreeArgs(rdargs)
  IF exception=ERR_FILE
    WriteF('Fichier "\s" non trouvé!\n', args[ARG_FROM])
  ELSEIF exception=ERR_ARGS
    WriteF('ag2txt: Usage "\s"\n', templ)
  ELSEIF exception<>ERR_NONE
    WriteF(errors[exception])
  ENDIF
ENDPROC

PROC setfont(str:PTR TO CHAR, ind)
  UpperStr(str)
  IF StrCmp(str, 'PLAIN', ALL)
    font[ind]:=FONT_NORMAL
  ELSEIF StrCmp(str, 'ITALIC', ALL)
    font[ind]:=FONT_ITALIC
  ELSEIF StrCmp(str, 'REVERSE', ALL)
    font[ind]:=FONT_REVERSE
  ELSEIF StrCmp(str, 'BOLD', ALL)
    font[ind]:=FONT_BOLD
  ENDIF
ENDPROC