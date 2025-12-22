/*   
   This is the source for a little calculator. The provided calculator
   coming with Amiga_E as example was to unflexible for me, so I
   wrote my own one. If you want to use parts of the source in your
   own projects you can do that. Expanding the functionality shouldn't
   be so hard. for that have a look for the
   op()      - checks for infix operators,
   exp()     - calculates the results for all infix, prefix and postfix
               operators
   postfix() - checks for postfix operators
   prefix()  - checks for prefix operators
   func()    - checks for functions and calculates 'em
   procedures.

   Backus Nauer form of how a term looks like:
     term    = "(" term ")" | term op term | num | func
     func    = Abs()
     num     = [prefix] E-numeric [postfix]
     prefix  = "~"
     postfix = "!"
     op      = "*" | "/" | "+" | "-" | "^" | "mod" | "<<" | ">>"

   | means alternatives, [] means an apperance of none or one time

*/

ENUM DIV_BY_ZERO,UNMATCHED_PARENTHESES,SYNTAX_ERR,STACK_OV,
     TERM_EXPECTED,KOMMA_EXPECTED,PUP_EXPECTED,UNEXPECTED_LE,PCLOSE_EXPECTED,
     ARG_EXPECTED

RAISE STACK_OV IF FreeStack()<100

PROC main() HANDLE
DEF string,always_true= TRUE,buffer[256]:STRING,fertig= FALSE
  WriteF('Mycalc v1.0 by Nico Max, written in Amiga_E\nType \ahelp\a for help\n\n')
  REPEAT
    WriteF('>>'); ReadStr(stdout,buffer)
    LowerStr(buffer); string:= TrimStr(buffer)
    SELECT always_true
      CASE StrCmp(string:= TrimStr(string),'help',STRLEN)
        WriteF(' the following commands will be supported:\n\n'+
               '    help   - prints this message\n'+
               '    exit   - quits the program\n'+
               '    <exp>  - calculates the expression\n\n'+
               ' infix operators:   +,-,*,/  - basic operators\n'+
               '                    ^,mod    - power, modulo\n'+
               '                    <<,>>    - bitwise shift left, shift right\n'+
               ' prefix operators:  ~        - logical Not\n'+
               '                    $,%      - indicator for hex and bin nums\n'+
               ' postfix operators: !        - faculthy\n'+
               '         functions: Abs()    - absolute value\n\n')
      CASE StrCmp(string,'exit',STRLEN); fertig:= TRUE
      CASE StrCmp(string,''    ,ALL); NOP
      DEFAULT; calcline(string)
    ENDSELECT
  UNTIL fertig
  WriteF('bye bye...\n')
EXCEPT
ENDPROC

PROC calcline(buf) HANDLE
DEF x=0:PTR TO LONG,l=0
  l:= term(buf:= TrimStr(buf),{x}) /* returns length of examined linepart */
  IF Char(TrimStr(buf+l)) THEN Raise(UNEXPECTED_LE)
  WriteF('->\d\n\n',x)            /* print result */
EXCEPT
  x:= ['Division by Zero','Unmatched parentheses','Syntax error',
       'Stack overflow', 'Term expected',
       'Komma expected','"(" expected','Unexpected end of line',
       '")" expected','Argument expected']
  WriteF('\s!\n',x[exception])
ENDPROC

PROC term (string,value)
DEF x,y,o,t,length
  FreeStack()                   /* check stacksize */
  IF Char(t:= TrimStr(string))="(" /* "("? => term beginning */
    length:= term(t:= TrimStr(t+1),{x})   /* go rekursive... */
    IF Char(t:= TrimStr(t+length))=")"
      IF length:= op(t:=TrimStr(t+1),{o})  /* check for infix operator */
        length:= term(t:= TrimStr(t+length),{y})
        ^value:= exp(x,y,o)         /* calculate result of both subterms x,y*/
        RETURN t+length-string      /* return termlength */
      ELSE; ^value:= x; RETURN t-string; ENDIF
    ELSE; Raise(UNMATCHED_PARENTHESES); ENDIF
  ELSE
    IF (length:= num(t,{x}))=0 THEN length:= func(t,{x})
    IF length
      LOOP
        IF length:= op(t:= TrimStr(t+length),{o})
          IF (length:= num(t:= TrimStr(t+length),{y}))=0 THEN length:= term(t,{y})
          ^value:= x:= exp(x,y,o)
        ELSE; ^value:= x; RETURN t-string; ENDIF
      ENDLOOP
    ELSE; Raise(SYNTAX_ERR); ENDIF
  ENDIF
ENDPROC

PROC func(string,value)
DEF x= TRUE,buffer,length=0,
    params[1]:LIST /* holds parameters for the functions; choose the num
                      as large as the functins with the most parameters
                      need */
  buffer:= string
  SELECT x
    CASE StrCmp(string,'abs',STRLEN)
      length:= checkprocparameters(buffer:= TrimStr(string+STRLEN),params,1)
      ^value:= Abs(params[])
  ENDSELECT
ENDPROC buffer+length-string

PROC checkprocparameters(string,params:PTR TO LONG,numparams)
DEF length=0,buffer,x=0
  DEC numparams
  IF string[]="("
    IF Char(buffer:= TrimStr(string+1))
      length:= term(buffer,params)
    ELSE; Raise(ARG_EXPECTED); ENDIF
    WHILE x++ < numparams
      IF Char(buffer:= TrimStr(buffer+length))=","
        IF Char(buffer:= TrimStr(buffer+1))
          length:= term(buffer:= TrimStr(buffer+1),params+Shl(x+1,2))
        ELSE; Raise(ARG_EXPECTED); ENDIF
      ELSE; Raise(KOMMA_EXPECTED); ENDIF
    ENDWHILE
    IF Char(buffer:= TrimStr(buffer+length))<>")" THEN Raise(PCLOSE_EXPECTED)
  ELSE; Raise(PUP_EXPECTED); ENDIF
ENDPROC buffer+1-string

PROC exp(x,y,o)  /* calculating result depending of the given operator */
DEF i=1,t
  SELECT o
    CASE "+";   RETURN x+y
    CASE "-";   RETURN x-y
    CASE "/";   IF y THEN RETURN Div(x,y) ELSE Raise(DIV_BY_ZERO)
    CASE "*";   RETURN Mul(x,y)
    CASE "^";   FOR t:= 1 TO y DO i:= Mul(i,x); RETURN i
    CASE "mod"; IF y THEN RETURN Mod(x,y) ELSE Raise(DIV_BY_ZERO)
    CASE "<<";  RETURN Shl(x,y)
    CASE ">>";  RETURN Shr(x,y)
    CASE "~";   RETURN Not(x)
    CASE "!";   FOR t:= 1 TO x DO i:= Mul(i,t); RETURN i
  ENDSELECT
ENDPROC

PROC num(string,value)   /* checking for numeric */
DEF x,t,o,i=0
  t:= prefix(string,{o}); ^value:= Val(string:= string+t,{x})
  IF x
    IF t THEN ^value:= exp(^value,0,o)
    IF i:= postfix(string+x,{o}) THEN ^value:= exp(^value,0,o)
  ENDIF
ENDPROC x+i+t

PROC prefix(string,value)
DEF x
  ^value:= x:= string[];
  SELECT x
    CASE "~"; RETURN 1  /* return length of found operator, must be <= 4 */
  ENDSELECT
ENDPROC

PROC postfix(string,value)
DEF x
  ^value:= x:= string[]
  SELECT x
    CASE "!"; RETURN 1  /* return length of found operator, must be <= 4 */
  ENDSELECT
ENDPROC

PROC op(buffer,o)  /* checking infix operators */
DEF t= TRUE,l=0
  SELECT t
    CASE StrCmp(buffer,'*'  ,STRLEN); ^o:= "*";   l:= STRLEN
    CASE StrCmp(buffer,'/'  ,STRLEN); ^o:= "/";   l:= STRLEN
    CASE StrCmp(buffer,'-'  ,STRLEN); ^o:= "-";   l:= STRLEN
    CASE StrCmp(buffer,'+'  ,STRLEN); ^o:= "+";   l:= STRLEN
    CASE StrCmp(buffer,'^'  ,STRLEN); ^o:= "^";   l:= STRLEN
    CASE StrCmp(buffer,'mod',STRLEN); ^o:= "mod"; l:= STRLEN
    CASE StrCmp(buffer,'<<', STRLEN); ^o:= "<<";  l:= STRLEN
    CASE StrCmp(buffer,'>>', STRLEN); ^o:= ">>";  l:= STRLEN
  ENDSELECT
ENDPROC l
