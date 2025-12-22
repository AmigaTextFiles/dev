/* AmigaGuide to Text converter (v2). Copyright (c) 1994, Jason R. Hulance */
/* E version.  For AmigaDos 2.0+.  Uses Michael Zucchi's excellent 'async' */
/* module that comes with E v3.0 to get a 1/3 speed up over the AmigaDOS   */
/* buffered I/O functions. (Would be good if 'async' handled output, too.) */

OPT OSVERSION=37

MODULE 'utility', 'tools/async', 'dos/stdio'

ENUM N_INIT, N_OUT, N_IN, NODE_STATES
ENUM L_INIT, L_QUOTED, L_SPACED, LINE_STATES
ENUM A_INIT, A_AT, A_BRAC, A_IGNORE, A_END, AT_STATES
ENUM NO_ERR, ERR_FILE, ERR_LIB, ERR_DATA, ERR_BRK, NUM_ERRS

CONST MAX_LINE_LEN=1024, MAX_WIDTH=120, CMP_EQUAL=0

RAISE ERR_LIB  IF OpenLibrary()=NIL

DEF in[MAX_LINE_LEN]:ARRAY, outh=NIL

ENUM        BOLD,     ITALIC,     F_LINK,       TITLE,  HIGHLIGHT,  OTHER

PROC write_ansi(type, on=TRUE)
  DEF ansi:PTR TO LONG
  /*        BOLD      ITALIC      F_LINK        TITLE   HIGHLIGHT   OTHER */
  IF on
    ansi:=['\e[1m',  '\e[3m',  '\e[1m\e[3m',   '\e[7m',  '\e[1m',  '\e[1m']
  ELSE
    ansi:=['\e[22m', '\e[23m', '\e[23m\e[22m', '\e[0m', '\e[22m', '\e[22m']
  ENDIF
  Fputs(outh, ansi[type])
ENDPROC

PROC main() HANDLE
  DEF fh, status=N_INIT, s, title[MAX_WIDTH]:STRING,
      empty=TRUE, top, bot, ownout=TRUE
  utilitybase:=OpenLibrary('utility.library', 37)
  s, arg:=get_word(arg)
  IF (fh:=as_Open(s, OLDFILE, 3, 8*1024))=NIL THEN Raise(ERR_FILE)
  IF arg[]
    s:=get_word(arg)
    IF s[]
      outh:=Open(s, NEWFILE)
    ENDIF
  ENDIF
  IF outh=NIL
    WriteF('')
    outh:=stdout
    ownout:=FALSE
  ENDIF
  top:='\n--------------------------------------' +
       '--------------------------------------\n'
  bot:='======================================' +
       '======================================\n'
  WHILE as_FGetS(fh, in, MAX_LINE_LEN)
    SELECT NODE_STATES OF status
    CASE N_INIT
      IF Strnicmp(in, '@DATABASE', STRLEN)<>CMP_EQUAL
        Raise(ERR_DATA)
      ELSE
        status:=N_OUT
      ENDIF
    CASE N_OUT
      IF Strnicmp(in, '@NODE ', STRLEN)=CMP_EQUAL
        status:=N_IN
	parse_node_line(in+STRLEN, title)
        empty:=TRUE
      ENDIF
    CASE N_IN
      IF empty AND (Strnicmp(in, '@TITLE', STRLEN)=CMP_EQUAL)
	parse_title_line(in+STRLEN, title)
      ELSEIF Strnicmp(in, '@ENDNODE', STRLEN)=CMP_EQUAL
        Fputs(outh, bot)
	status:=N_OUT
      ELSE
        IF CtrlC() THEN Raise(ERR_BRK)
        s:=TrimStr(in)
        IF Not(empty AND (s[]=0))
          IF empty
            write_ansi(TITLE)
            Fputs(outh, title)
            write_ansi(TITLE, FALSE)
            Fputs(outh, top)
            empty:=FALSE
          ENDIF
          output(in)
        ENDIF
      ENDIF
    ENDSELECT
  ENDWHILE
EXCEPT DO
  SELECT NUM_ERRS OF exception
  CASE ERR_LIB
    WriteF('Could not open utility.library\n')
  CASE ERR_FILE
    WriteF('Could not open file "\s"\n', s)
  CASE ERR_DATA
    WriteF('"\s" is not an AmigaGuide file\n')
  CASE ERR_BRK
    WriteF('User aborted\n')
  ENDSELECT
  IF ownout AND outh THEN Close(outh)
  IF fh THEN as_Close(fh)
  IF utilitybase THEN CloseLibrary(utilitybase)
ENDPROC

PROC output(line)
  DEF status=A_INIT, gotbrac, c
  IF line[]="@" THEN IF line[1]<>"{" THEN RETURN
  WHILE c:=line[]
    SELECT c
    CASE "\\"
      IF status=A_INIT
        status:=A_IGNORE
      ELSE
        statecopy(status)
        FputC(outh, c)
        status:=A_INIT
      ENDIF
      line++
    CASE "@"
      IF status=A_INIT
        status:=A_AT
      ELSE
        IF status<>A_IGNORE THEN statecopy(status)
        FputC(outh, c)
        status:=A_INIT
      ENDIF
      line++
    CASE "{"
      IF status=A_AT
        status:=A_BRAC
      ELSE
        statecopy(status)
        FputC(outh, c)
        status:=A_INIT
      ENDIF
      line++
    CASE "}"
      SELECT AT_STATES OF status
      CASE A_BRAC, A_END
      DEFAULT
        statecopy(status)
        FputC(outh, c)
      ENDSELECT
      status:=A_INIT
      line++
    DEFAULT
      SELECT AT_STATES OF status
      CASE A_BRAC
        line,gotbrac:=parse_at_line(line)
        status:=IF gotbrac THEN A_INIT ELSE A_END
      CASE A_END
        line++
      DEFAULT
        statecopy(status)
        FputC(outh, c)
        status:=A_INIT
        line++
      ENDSELECT
    ENDSELECT
  ENDWHILE
ENDPROC

PROC statecopy(state)
  SELECT AT_STATES OF state
  CASE A_IGNORE
    FputC(outh, "\\")
  CASE A_AT
    FputC(outh, "@")
  CASE A_BRAC
    Fputs(outh, '@{')
  ENDSELECT
ENDPROC

PROC parse_at_line(line)
  DEF first, second, third, gotbrac, i=0, on=TRUE, c
  first,line,gotbrac:=get_word(line, TRUE)
  IF first[]
    i:=1
    IF gotbrac=FALSE
      second,line,gotbrac:=get_word(line, TRUE)
      IF second[]
        i:=2
        IF gotbrac=FALSE
          third,line,gotbrac:=get_word(line, TRUE)
          IF third[] THEN i:=3
        ENDIF
      ENDIF
    ENDIF
  ENDIF
  SELECT 4 OF i
  CASE 1
    IF ToUpper(first[])="U"
      on:=FALSE
      first++
    ENDIF
    c:=ToUpper(first[])
    SELECT c
    CASE "B"
      write_ansi(BOLD, on)
    CASE "I"
      write_ansi(ITALIC, on)
    ENDSELECT
  CASE 2
    IF Stricmp(first, 'FG')=CMP_EQUAL
      IF Stricmp(second, 'HIGHLIGHT')=CMP_EQUAL
        write_ansi(HIGHLIGHT)
      ELSEIF Stricmp(second, 'TEXT')=CMP_EQUAL
        write_ansi(HIGHLIGHT, FALSE)
      ENDIF
    ELSEIF (Stricmp(second, 'CLOSE')=CMP_EQUAL) OR
           (Stricmp(second, 'QUIT')=CMP_EQUAL)
      write_ansi(OTHER)
      Fputs(outh, first)
      write_ansi(OTHER, FALSE)
    ENDIF
  CASE 3
    IF (Stricmp(second, 'LINK')=CMP_EQUAL) OR
       (Stricmp(second, 'ALINK')=CMP_EQUAL)
      write_ansi(F_LINK)
      Fputs(outh, first)
      write_ansi(F_LINK, FALSE)
    ELSE
      write_ansi(OTHER)
      Fputs(outh, first)
      write_ansi(OTHER, FALSE)
    ENDIF
  ENDSELECT
ENDPROC line,gotbrac

PROC parse_node_line(line, title)
  DEF first, second
  first,line:=get_word(line)
  second,line:=get_word(line)
  IF first[]
    IF second[]
      StrCopy(title, second)
    ELSE
      StrCopy(title, first)
    ENDIF
  ENDIF
ENDPROC

PROC parse_title_line(line, title)
  DEF first
  first,line:=get_word(line)
  IF first[]
    StrCopy(title, first)
  ENDIF
ENDPROC

CONST L_SIZE=35

PROC get_word(line, chkbrac=FALSE)
  DEF status=L_INIT, noword=TRUE, foundbrac=FALSE,
      t=NIL, to, special=FALSE
  to:=line
  WHILE line[] AND noword
    IF to<>line THEN to[]:=line[]
    SELECT L_SIZE OF line[]
    CASE "\q"
      IF special
        to++
      ELSE
        SELECT LINE_STATES OF status
        CASE L_INIT
          status:=L_QUOTED
          t:=line+1
          to++
        CASE L_QUOTED
          to[]:=0
          noword:=FALSE
        DEFAULT
          to++
        ENDSELECT
      ENDIF
    CASE "\n", "\t", " "
      IF status=L_SPACED
        to[]:=0
        noword:=FALSE
      ELSE
        to++
      ENDIF
    DEFAULT
      IF chkbrac AND (line[]="}")
        to[]:=0
        noword:=FALSE
        foundbrac:=TRUE
      ELSE
        IF status=L_INIT
          t:=line
          status:=L_SPACED
        ENDIF
        to++
      ENDIF
    ENDSELECT
    IF special
      special:=FALSE
    ELSEIF line[]="\\"
      special:=TRUE
      to--
    ENDIF
    line++
  ENDWHILE
ENDPROC t,line,foundbrac
