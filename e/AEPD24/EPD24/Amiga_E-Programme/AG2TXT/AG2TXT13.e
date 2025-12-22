/* AmigaGuide to Text converter (v2). Copyright (c) 1994, Jason R. Hulance */
/* E version.  For AmigaDos 1.3 or before (?).  Very slow because it lacks */
/* buffering on the I/O, and it's not likely to be added by me, either :-) */

ENUM N_INIT, N_OUT, N_IN, NODE_STATES
ENUM L_INIT, L_QUOTED, L_SPACED, LINE_STATES
ENUM A_INIT, A_AT, A_BRAC, A_IGNORE, A_END, AT_STATES
ENUM NO_ERR, ERR_FILE, ERR_DATA, ERR_BRK, NUM_ERRS

CONST MAX_LINE_LEN=1024, MAX_WIDTH=120, CMP_EQUAL=0, CMP_UNEQUAL=1

DEF in[MAX_LINE_LEN]:STRING, outh=NIL

ENUM        BOLD,     ITALIC,     F_LINK,       TITLE,  HIGHLIGHT,  OTHER

PROC write_ansi(type, on=TRUE)
  DEF ansi:PTR TO LONG
  /*        BOLD      ITALIC      F_LINK        TITLE   HIGHLIGHT   OTHER */
  IF on
    ansi:=['\e[1m',  '\e[3m',  '\e[1m\e[3m',   '\e[7m',  '\e[1m',  '\e[1m']
  ELSE
    ansi:=['\e[22m', '\e[23m', '\e[23m\e[22m', '\e[0m', '\e[22m', '\e[22m']
  ENDIF
  fputs(outh, ansi[type])
ENDPROC

PROC fputc(fh, c) IS Out(fh, c)
PROC fputs(fh, s) IS Write(fh, s, StrLen(s))

PROC toupper(c) IS IF (c<"a") OR (c>"z") THEN c ELSE c-32

PROC stricmp(s1, s2, all=TRUE)
  WHILE (s2[]<>0) AND (s1[]<>0)
    IF toupper(s1[]++)<>s2[]++ THEN RETURN CMP_UNEQUAL
  ENDWHILE
  IF all
    RETURN IF (s1[] OR s2[]) THEN CMP_UNEQUAL ELSE CMP_EQUAL
  ELSE
    RETURN IF s2[] THEN CMP_UNEQUAL ELSE CMP_EQUAL
  ENDIF
ENDPROC

PROC main() HANDLE
  DEF fh, status=N_INIT, s, title[MAX_WIDTH]:STRING,
      empty=TRUE, top, bot, ownout=TRUE, err
  s, arg:=get_word(arg)
  IF (fh:=Open(s, OLDFILE))=NIL THEN Raise(ERR_FILE)
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
  REPEAT
    err:=ReadStr(fh, in)
    SELECT NODE_STATES OF status
    CASE N_INIT
      IF stricmp(in, '@DATABASE', FALSE)<>CMP_EQUAL
        Raise(ERR_DATA)
      ELSE
        status:=N_OUT
      ENDIF
    CASE N_OUT
      IF stricmp(in, '@NODE ', FALSE)=CMP_EQUAL
        status:=N_IN
	parse_node_line(in+STRLEN, title)
        empty:=TRUE
      ENDIF
    CASE N_IN
      IF empty AND (stricmp(in, '@TITLE', FALSE)=CMP_EQUAL)
	parse_title_line(in+STRLEN, title)
      ELSEIF stricmp(in, '@ENDNODE', FALSE)=CMP_EQUAL
        fputs(outh, bot)
	status:=N_OUT
      ELSE
        IF CtrlC() THEN Raise(ERR_BRK)
        s:=TrimStr(in)
        IF Not(empty AND (s[]=0))
          IF empty
            write_ansi(TITLE)
            fputs(outh, title)
            write_ansi(TITLE, FALSE)
            fputs(outh, top)
            empty:=FALSE
          ENDIF
          output(in)
        ENDIF
      ENDIF
    ENDSELECT
  UNTIL err=-1
EXCEPT DO
  SELECT NUM_ERRS OF exception
  CASE ERR_FILE
    WriteF('Could not open file "\s"\n', s)
  CASE ERR_DATA
    WriteF('"\s" is not an AmigaGuide file\n')
  CASE ERR_BRK
    WriteF('User aborted\n')
  ENDSELECT
  IF ownout AND outh THEN Close(outh)
  IF fh THEN Close(fh)
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
        fputc(outh, c)
        status:=A_INIT
      ENDIF
      line++
    CASE "@"
      IF status=A_INIT
        status:=A_AT
      ELSE
        IF status<>A_IGNORE THEN statecopy(status)
        fputc(outh, c)
        status:=A_INIT
      ENDIF
      line++
    CASE "{"
      IF status=A_AT
        status:=A_BRAC
      ELSE
        statecopy(status)
        fputc(outh, c)
        status:=A_INIT
      ENDIF
      line++
    CASE "}"
      SELECT AT_STATES OF status
      CASE A_BRAC, A_END
      DEFAULT
        statecopy(status)
        fputc(outh, c)
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
        fputc(outh, c)
        status:=A_INIT
        line++
      ENDSELECT
    ENDSELECT
  ENDWHILE
  fputc(outh, "\n")
ENDPROC

PROC statecopy(state)
  SELECT AT_STATES OF state
  CASE A_IGNORE
    fputc(outh, "\\")
  CASE A_AT
    fputc(outh, "@")
  CASE A_BRAC
    fputs(outh, '@{')
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
    IF toupper(first[])="U"
      on:=FALSE
      first++
    ENDIF
    c:=toupper(first[])
    SELECT c
    CASE "B"
      write_ansi(BOLD, on)
    CASE "I"
      write_ansi(ITALIC, on)
    ENDSELECT
  CASE 2
    IF stricmp(first, 'FG')=CMP_EQUAL
      IF stricmp(second, 'HIGHLIGHT')=CMP_EQUAL
        write_ansi(HIGHLIGHT)
      ELSEIF stricmp(second, 'TEXT')=CMP_EQUAL
        write_ansi(HIGHLIGHT, FALSE)
      ENDIF
    ELSEIF (stricmp(second, 'CLOSE')=CMP_EQUAL) OR
           (stricmp(second, 'QUIT')=CMP_EQUAL)
      write_ansi(OTHER)
      fputs(outh, first)
      write_ansi(OTHER, FALSE)
    ENDIF
  CASE 3
    IF (stricmp(second, 'LINK')=CMP_EQUAL) OR
       (stricmp(second, 'ALINK')=CMP_EQUAL)
      write_ansi(F_LINK)
      fputs(outh, first)
      write_ansi(F_LINK, FALSE)
    ELSE
      write_ansi(OTHER)
      fputs(outh, first)
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
