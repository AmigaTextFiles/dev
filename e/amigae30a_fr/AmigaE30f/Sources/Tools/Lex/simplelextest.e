-> test lex , analyse (parse) les listes avec des entiers d'un fichier.

MODULE 'tools/simplelex', 'tools/file', 'tools/lisp'

DEF t,at        -> token et attribut courant

PROC main() HANDLE
  DEF m=NIL,l,a
  m,l:=readfile('testinput.lists')
  lex_init(m,l,TRUE,"#")
  t,at:=lex()
  WHILE (a:=parse())<>-1
    showcellint(a)
    WriteF('\n')
  ENDWHILE
EXCEPT DO
  IF m THEN freefile(m)
  SELECT exception
    CASE "OPEN"; WriteF('Pas de fichier!\n')
    CASE "MEM";  WriteF('Pas de mémoire!\n')
    CASE "perr"; printerr(exceptioninfo)
  ENDSELECT
ENDPROC

PROC parse()
  DEF a
  IF t="<"
    t,at:=lex()
    IF t=">"
      t,at:=lex()
      RETURN NIL
    ELSE
      a:=parse()
      RETURN <a|parsecdr()>
    ENDIF
  ELSEIF t=LEX_INTEGER
    a:=at
    t,at:=lex()
    RETURN a
  ELSEIF t=LEX_EOF
    RETURN -1
  ELSE
    Throw("perr",'"<" or integer expected')
  ENDIF
ENDPROC

PROC parsecdr()
  DEF a
  IF t=","
    t,at:=lex()
    a:=parse()
    RETURN <a|parsecdr()>
  ELSEIF t="|"
    t,at:=lex()
    a:=parse()
    IF t<>">" THEN Throw("perr",'">" attendu')
    t,at:=lex()
    RETURN a
  ELSEIF t=">"
    t,at:=lex()
    RETURN NIL
  ELSE
    Throw("perr",'"," or "|" or ">" attendu')
  ENDIF
ENDPROC

PROC printerr(s)
  DEF ers[200]:STRING,pos,a
  pos:=lex_getline(ers)-1
  WriteF('\nERROR: \s\nLINE: \d\n\s\n',s,lex_curline(),ers)
  IF pos>0 THEN FOR a:=1 TO pos DO WriteF(' ')
  WriteF('^\n')
ENDPROC
