
-> Copyright © 1995, Guichard Damien.

-> Eiffel 3.0 lexical analyser
-> ANY,NONE,INTEGER,BOOLEAN,CHARACTER,STRING,ARRAY,REAL,DOUBLE,BIT,POINTER
-> are also lexical tokens to avoid illegal use of reserved words

-> TO DO :
->   'Result' should be a reserved word
->   ANY, ARRAY and Void should not be reserved words
->   REAL, DOUBLE and BIT n constants

OPT MODULE

MODULE '*errors'
MODULE '*token','*entity_tree'

EXPORT ENUM LEX_ALIAS=300,LEX_ALL,LEX_AND,LEX_ANY,LEX_ARRAY,LEX_AS,LEX_BIT,
  LEX_BOOLEAN,LEX_CHARACTER,LEX_CHECK,LEX_CLASS,LEX_CREATION,LEX_CURRENT,
  LEX_DEBUG,LEX_DEFERRED,LEX_DO,LEX_DOUBLE,LEX_ELSE,LEX_ELSEIF,LEX_END,
  LEX_ENSURE,LEX_EXPANDED,LEX_EXPORT,LEX_EXTERNAL,LEX_FALSE,LEX_FEATURE,
  LEX_FROM,LEX_FROZEN,LEX_IF,LEX_IMPLIES,LEX_INDEXING,LEX_INFIX,LEX_INHERIT,
  LEX_INSPECT,LEX_INTEGER,LEX_INVARIANT,LEX_IS,LEX_LIKE,LEX_LOCAL,
  LEX_LOOP,LEX_NONE,LEX_NOT,LEX_OBSOLETE,LEX_OLD,LEX_ONCE,LEX_OR,
  LEX_POINTER,LEX_PREFIX,LEX_REAL,LEX_REDEFINE,LEX_RENAME,LEX_REQUIRE,
  LEX_RESCUE,LEX_RESULT,LEX_RETRY,LEX_SELECT,LEX_SEPARATE,LEX_STRING,
  LEX_STRIP,LEX_THEN,LEX_TRUE,LEX_UNDEFINE,LEX_UNIQUE,LEX_UNTIL,
  LEX_VARIANT,LEX_VOID,LEX_WHEN,LEX_XOR

EXPORT ENUM LEX_EOF=600, -> Text end reached
  LEX_IDENT,    -> self.ident contains the identifier
  LEX_STR,      -> self.ident contains the string
  LEX_NUMERAL,  -> self.value contains the integer
  LEX_CHAR      -> self.value contains the character

-> A table to perform binary search of reserved words
DEF table:PTR TO entity_tree

EXPORT OBJECT eiffel_lex PUBLIC
  last:INT               -> last lexical token
  value:LONG             -> numeral value
  ident:PTR TO CHAR      -> current identifier
  line:INT               -> current line
PRIVATE
  text:PTR TO CHAR       -> source text
  cur:PTR TO CHAR        -> current position in text
  stored_cur:PTR TO CHAR -> stored position
  stored_line:INT        -> stored line
  stored_last:INT        -> store lexical token
ENDOBJECT

-> Load a text as a lex stream
PROC attach_text(name) OF eiffel_lex HANDLE
  DEF handle=NIL,slen
  DEF tok:PTR TO token
  IF self.text THEN self.detach_text()
  slen:=FileLength(name)
  IF (handle:=Open(name,OLDFILE))=NIL THEN Raise(ER_SOURCEFILE)
  self.text:=NewR(slen+2)
  IF Read(handle,self.text,slen)<slen THEN Raise(ER_SOURCEFILE)
  self.text[slen]:="\0"
  self.cur:=self.text
  self.line:=1
  IF self.ident=NIL THEN self.ident:=String(40)
  IF table=NIL
    NEW table
    table.add(NEW tok.create('alias',LEX_ALIAS))
    table.add(NEW tok.create('all',LEX_ALL))
    table.add(NEW tok.create('and',LEX_AND))
    table.add(NEW tok.create('any',LEX_ANY))
    table.add(NEW tok.create('array',LEX_ARRAY))
    table.add(NEW tok.create('as',LEX_AS))
    table.add(NEW tok.create('bit',LEX_BIT))
    table.add(NEW tok.create('boolean',LEX_BOOLEAN))
    table.add(NEW tok.create('character',LEX_CHARACTER))
    table.add(NEW tok.create('check',LEX_CHECK))
    table.add(NEW tok.create('class',LEX_CLASS))
    table.add(NEW tok.create('creation',LEX_CREATION))
    table.add(NEW tok.create('current',LEX_CURRENT))
    table.add(NEW tok.create('debug',LEX_DEBUG))
    table.add(NEW tok.create('deferred',LEX_DEFERRED))
    table.add(NEW tok.create('do',LEX_DO))
    table.add(NEW tok.create('double',LEX_DOUBLE))
    table.add(NEW tok.create('else',LEX_ELSE))
    table.add(NEW tok.create('elseif',LEX_ELSEIF))
    table.add(NEW tok.create('end',LEX_END))
    table.add(NEW tok.create('ensure',LEX_ENSURE))
    table.add(NEW tok.create('expanded',LEX_EXPANDED))
    table.add(NEW tok.create('export',LEX_EXPORT))
    table.add(NEW tok.create('external',LEX_EXTERNAL))
    table.add(NEW tok.create('false',LEX_FALSE))
    table.add(NEW tok.create('feature',LEX_FEATURE))
    table.add(NEW tok.create('from',LEX_FROM))
    table.add(NEW tok.create('frozen',LEX_FROZEN))
    table.add(NEW tok.create('if',LEX_IF))
    table.add(NEW tok.create('implies',LEX_IMPLIES))
    table.add(NEW tok.create('indexing',LEX_INDEXING))
    table.add(NEW tok.create('infix',LEX_INFIX))
    table.add(NEW tok.create('inherit',LEX_INHERIT))
    table.add(NEW tok.create('inspect',LEX_INSPECT))
    table.add(NEW tok.create('integer',LEX_INTEGER))
    table.add(NEW tok.create('invariant',LEX_INVARIANT))
    table.add(NEW tok.create('is',LEX_IS))
    table.add(NEW tok.create('like',LEX_LIKE))
    table.add(NEW tok.create('local',LEX_LOCAL))
    table.add(NEW tok.create('loop',LEX_LOOP))
    table.add(NEW tok.create('none',LEX_NONE))
    table.add(NEW tok.create('not',LEX_NOT))
    table.add(NEW tok.create('obsolete',LEX_OBSOLETE))
    table.add(NEW tok.create('old',LEX_OLD))
    table.add(NEW tok.create('once',LEX_ONCE))
    table.add(NEW tok.create('or',LEX_OR))
    table.add(NEW tok.create('pointer',LEX_POINTER))
    table.add(NEW tok.create('prefix',LEX_PREFIX))
    table.add(NEW tok.create('real',LEX_REAL))
    table.add(NEW tok.create('redefine',LEX_REDEFINE))
    table.add(NEW tok.create('rename',LEX_RENAME))
    table.add(NEW tok.create('require',LEX_REQUIRE))
    table.add(NEW tok.create('rescue',LEX_RESCUE))
 -> table.add(NEW tok.create('result',LEX_RESULT))
    table.add(NEW tok.create('retry',LEX_RETRY))
    table.add(NEW tok.create('select',LEX_SELECT))
    table.add(NEW tok.create('separate',LEX_SEPARATE))
    table.add(NEW tok.create('string',LEX_STRING))
    table.add(NEW tok.create('strip',LEX_STRIP))
    table.add(NEW tok.create('then',LEX_THEN))
    table.add(NEW tok.create('true',LEX_TRUE))
    table.add(NEW tok.create('undefine',LEX_UNDEFINE))
    table.add(NEW tok.create('unique',LEX_UNIQUE))
    table.add(NEW tok.create('until',LEX_UNTIL))
    table.add(NEW tok.create('variant',LEX_VARIANT))
    table.add(NEW tok.create('void',LEX_VOID))
    table.add(NEW tok.create('when',LEX_WHEN))
    table.add(NEW tok.create('xor',LEX_XOR))
  ENDIF
  self.read()
EXCEPT DO
  IF handle THEN Close(handle)
  ReThrow()
ENDPROC

-> Detach the text
PROC detach_text() OF eiffel_lex
  Dispose(self.text)
  self.text:=NIL
ENDPROC

-> Read next lexical token form the text
-> Update line, last, value, ident
PROC read() OF eiffel_lex
  DEF cur:PTR TO CHAR
  cur:=self.cur
  self.last:=0
  REPEAT
    SELECT 256 OF cur[]++
    CASE ",",";","*","+","=","(",")","{","}","[","]","@","!"
      self.last:=cur[-1]
    CASE "a" TO "z","A" TO "Z","_"
      self.cur:=cur-1
      self.last:=LEX_IDENT
      self.identifier()
      RETURN
    CASE "0" TO "9"
      self.cur:=cur-1
      self.last:=LEX_NUMERAL
      self.number()
      RETURN
    CASE "\a"
      self.cur:=cur
      self.last:=LEX_CHAR
      self.character()
      RETURN
    CASE "\q"
      self.cur:=cur
      self.last:=LEX_STR
      self.string()
      RETURN
    CASE "-"
      IF cur[]="-"
        INC cur
        WHILE cur[]++<>"\n" DO NOP
        self.line:=self.line+1
      ELSEIF cur[]=">"
        INC cur
        self.last:="->"
      ELSE
        self.last:="-"
      ENDIF
    CASE "."
      IF cur[]="."
        INC cur
        self.last:=".."
      ELSE
        self.last:="."
      ENDIF
    CASE "/"
      IF cur[]="/"
        INC cur
        self.last:="//"
      ELSEIF cur[]="="
        INC cur
        self.last:="/="
      ELSE
        self.last:="/"
      ENDIF
    CASE ">"
      IF cur[]=">"
        INC cur
        self.last:=">>"
      ELSEIF cur[]="="
        INC cur
        self.last:=">="
      ELSE
        self.last:=">"
      ENDIF
    CASE "<"
      IF cur[]="<"
        INC cur
        self.last:="<<"
      ELSEIF cur[]="="
        INC cur
        self.last:="<="
      ELSE
        self.last:="<="
      ENDIF
    CASE ":"
      IF cur[]="="
        INC cur
        self.last:=":="
      ELSE
        self.last:=":"
      ENDIF
    CASE "?"
      IF cur[]++<>"=" THEN Raise(ER_SYNTAX)
      self.last:="?="
    CASE "\\"
      IF cur[]++<>"\\" THEN Raise(ER_SYNTAX)
      self.last:="\\\\"
    CASE "\n"
      self.line:=self.line+1
    CASE "\0"
      self.last:=LEX_EOF
    CASE " ","\t","\b"
    DEFAULT
      Raise(ER_SYNTAX)
    ENDSELECT
  UNTIL self.last
  self.cur:=cur
ENDPROC

-> Store text position
PROC store() OF eiffel_lex
  self.stored_cur:=self.cur
  self.stored_line:=self.line
  self.stored_last:=self.last
ENDPROC

-> Restore text position
PROC restore() OF eiffel_lex
  self.cur :=self.stored_cur
  self.line:=self.stored_line
  self.last:=self.stored_last
ENDPROC

-> Destructor
PROC end() OF eiffel_lex
  IF self.text THEN self.detach_text()
  IF self.ident THEN DisposeLink(self.ident)
ENDPROC


-> PRIVATE methods used by read()

-> Find reserved word if possible
PROC identifier() OF eiffel_lex
  DEF c:PTR TO CHAR,cur,a
  DEF tok:PTR TO token
  c:=self.ident
  cur:=self.cur
  WHILE self.isalpha(a:=cur[]++) OR self.isdigit(a) DO c[]++:=a
  c[]:="\0"
  LowerStr(self.ident)
  self.cur:=cur-1
  IF tok:=table.find(self.ident) THEN self.last:=tok.type
ENDPROC

-> Parse eiffel integers and these nasty "_"
PROC number() OF eiffel_lex
  DEF c,cur,value=0
  cur:=self.cur
  c:=cur[]
  WHILE self.isdigit(c)
    IF c="_"
      WHILE cur[]="_"
        self.cur:=cur+1
        value:=Mul(1000,value)+self.digits()
        cur:=cur+4
      ENDWHILE
      self.value:=value
      RETURN
    ELSE
      value:=Mul(10,value)+c-"0"
    ENDIF
    INC cur
    c:=cur[]
  ENDWHILE
  self.cur:=cur
  self.value:=value
ENDPROC

-> Parse 3 Eiffel digits
PROC digits() OF eiffel_lex
  DEF c,i,value=0
  FOR i:=1 TO 3
    c:=self.cur[]
    self.cur:=self.cur+SIZEOF CHAR
    IF Not(self.isdigit(c)) THEN Raise(ER_SYNTAX)
    IF c="_" THEN Raise(ER_SYNTAX)
    value:=10*value+c-"0"
  ENDFOR
ENDPROC value

-> In future "_" won't be considered as a real Eiffel digit
PROC isdigit(c) OF eiffel_lex
ENDPROC (c>="0") AND (c<="9") OR (c="_")

-> More classic alpha characters
PROC isalpha(c) OF eiffel_lex
 IF c="_" THEN RETURN TRUE
 IF (c>="a") AND (c<="z") THEN RETURN TRUE
 IF (c>="A") AND (c<="Z") THEN RETURN TRUE
ENDPROC

-> Eiffel strings with all special characters
PROC string() OF eiffel_lex
  DEF c:PTR TO CHAR,a
  c:=self.ident
  LOOP
    a:=self.cur[]
    self.cur:=self.cur+1
    SELECT a
    CASE "\q"
      c[]:="\0"
      RETURN
    CASE "%"
      a:=self.cur[]
      self.cur:=self.cur+1
      SELECT a
      CASE "A"
        c[]++:="@"
      CASE "B"
        c[]++:=8
      CASE "C"
        c[]++:="^"
      CASE "D"
        c[]++:="$"
      CASE "F"
        c[]++:=12
      CASE "H"
        c[]++:="\\"
      CASE "L"
        c[]++:="~"
      CASE "N"
        c[]++:="\n"
      CASE "Q"
        c[]++:="`"
      CASE "R"
        c[]++:="\b"
      CASE "S"
        c[]++:="#"
      CASE "T"
        c[]++:="\t"
      CASE "U"
        c[]++:="\0"
      CASE "V"
        c[]++:="|"
      CASE "%"
        c[]++:="%"
      CASE "\a"
        c[]++:="\a"
      CASE "\q"
        c[]++:="\q"
      CASE "("
        c[]++:="["
      CASE ")"
        c[]++:="]"
      CASE "<"
        c[]++:="{"
      CASE ">"
        c[]++:="}"
      CASE "/"
        self.value:=Val(self.cur,{a})
        IF a=0 THEN Raise(ER_SYNTAX)
        c[]++:=self.value
        self.cur:=self.cur+a
        IF self.cur[]<>"/" THEN Raise(ER_SYNTAX)
        self.cur:=self.cur+1
      DEFAULT
        Raise(ER_SYNTAX)
      ENDSELECT
    CASE "\0"
      Raise(ER_SYNTAX)
    CASE "\a"
      Raise(ER_SYNTAX)
    CASE "\b"
      Raise(ER_SYNTAX)
    CASE "\n"
      Raise(ER_SYNTAX)
    DEFAULT
      c[]++:=a
    ENDSELECT
  ENDLOOP
ENDPROC

-> Eiffel characters without special characters
PROC character() OF eiffel_lex
  DEF a,len
  a:=self.cur[]
  self.cur:=self.cur+1
  SELECT a
  CASE "%"
    a:=self.cur[]
    self.cur:=self.cur+1
    SELECT a
    CASE "A"
      a:="@"
    CASE "B"
      a:=8
    CASE "C"
      a:="^"
    CASE "D"
      a:="$"
    CASE "F"
      a:=12
    CASE "H"
      a:="\\"
    CASE "L"
      a:="~"
    CASE "N"
      a:="\n"
    CASE "Q"
      a:="`"
    CASE "R"
      a:="\b"
    CASE "S"
      a:="#"
    CASE "T"
      a:="\t"
    CASE "U"
      a:="\0"
    CASE "V"
      a:="|"
    CASE "%"
      a:="%"
    CASE "\a"
      a:="\a"
    CASE "\q"
      a:="\q"
    CASE "("
      a:="["
    CASE ")"
      a:="]"
    CASE "<"
      a:="{"
    CASE ">"
      a:="}"
    CASE "/"
      a:=Val(self.cur,{len})
      IF len=0 THEN Raise(ER_SYNTAX)
      self.cur:=self.cur+len
      IF self.cur[]<>"/" THEN Raise(ER_SYNTAX)
      self.cur:=self.cur+1
    DEFAULT
      Raise(ER_SYNTAX)
    ENDSELECT
  CASE "\0"
    Raise(ER_SYNTAX)
  CASE "\a"
    Raise(ER_SYNTAX)
  CASE "\b"
    Raise(ER_SYNTAX)
  CASE "\n"
    Raise(ER_SYNTAX)
  ENDSELECT
  self.value:=a
  IF self.cur[]<>"\a" THEN Raise(ER_SYNTAX)
  self.cur:=self.cur+1
ENDPROC

