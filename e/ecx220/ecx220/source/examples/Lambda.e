/* lambda calc evaluator in E, makes heavy use of unification */


DEF nchar="a"

ENUM ATOM,LAMBDA,APP

PROC ev(exp)
  DEF par,body,fun,arg
  IF exp <=> [APP,fun,arg]
    funval(fun) <=> [LAMBDA,par,body]
    RETURN ev(replace(body,par,arg))
  ELSE
    RETURN exp
  ENDIF
ENDPROC

PROC funval(exp)
  DEF x,y
  IF exp <=> [APP,x,y]
    RETURN funval(ev(exp))
  ELSEIF exp <=> [ATOM,x]
    RETURN funval(getdef(x))
  ELSE
    RETURN exp
  ENDIF
ENDPROC

PROC replace(exp,old,new)
  DEF fun,arg,par,body,a,n
  IF exp <=> [APP,fun,arg]
    RETURN NEW [APP,replace(fun,old,new),replace(arg,old,new)]
  ELSEIF exp <=> [ATOM,a]
    RETURN IF a=old THEN new ELSE exp
  ELSEIF exp <=> [LAMBDA,par,body]
    new <=> [ATOM,a]
    IF par=a
      RETURN NEW [LAMBDA,n,replace(replace(body,par,NEW [ATOM,nchar++]),old,new)]
    ELSE
      RETURN NEW [LAMBDA,par,replace(body,old,new)]
    ENDIF
  ENDIF
ENDPROC

PROC pretty(exp)
  DEF x,y
  IF exp <=> [APP,x,y]
    pretty(x)
    PutStr(' (')
    pretty(y)
    PutStr(')')
  ELSEIF exp <=> [LAMBDA,x,y]
    PrintF('\\\c.',x)
    pretty(y)
  ELSEIF exp <=> [ATOM,x]
    PrintF('\c',x)
  ENDIF
ENDPROC

PROC getdef(a)
  SELECT a
    CASE "t"; RETURN [LAMBDA,"x",[LAMBDA,"y",[ATOM,"x"]]]
    CASE "f"; RETURN [LAMBDA,"x",[LAMBDA,"y",[ATOM,"y"]]]
    DEFAULT;  Raise(0)
  ENDSELECT
ENDPROC

PROC main()
  DEF exp
  exp:=[APP,[APP,[ATOM,"t"],[ATOM,"t"]],[ATOM,"f"]]
  pretty(exp)
  PutStr(' results in ')
  pretty(ev(exp))            -> prints: 't (t) (f) results in t'
  PutStr('\n')
ENDPROC
