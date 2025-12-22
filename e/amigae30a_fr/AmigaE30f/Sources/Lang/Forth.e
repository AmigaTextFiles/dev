/* TinyForth, un petit intepréteur Forth
   pas de fonction *encore*, peut être utilisé comme une calculatrice
   avec pile pour le plaisir.
   Se termine avec QUIT<cr> ou <ctrl-c><cr>
   Traduction : Olivier ANH (BUGSS)                                    */

CONST MAXSTACK=1000,MAXRSTACK=200
ENUM NO_MES,OK,ER_UNDERFLOW,ER_OVERFLOW,ER_SYM

DEF con,stop=FALSE,error=OK,crflag=TRUE,
    inp[100]:STRING,
    item[50]:STRING, item2[50]:STRING,
    stack[MAXSTACK]:ARRAY OF LONG, rstack[MAXRSTACK]:ARRAY OF LONG,
    sp:PTR TO LONG, rsp:PTR TO LONG

PROC main()
  con:=Open('CON:0/11/640/100/TinyForth',1005)
  IF con
    stdout:=con
    WriteF('Interpréteur TinyForth v0.1 (c) 1992 by $#%!\n')
    sp:=stack; rsp:=rstack
    REPEAT
      puterror()
      WriteF('>')
      ReadStr(con,inp)
      IF CtrlC() THEN stopnow()
      error:=OK; crflag:=TRUE
      eval(inp)
    UNTIL stop
    Close(con)
  ENDIF
ENDPROC

PROC eval(c)
  DEF pos,end,symlong,p,i,j,k
  pos:=c; end:=c+EstrLen(c)
  WHILE (pos<end) AND (error<=OK)
    IF CtrlC() THEN stopnow()
    pos:=getsym(pos)
    StrCopy(item2,item,ALL)
    UpperStr(item2)
    StrAdd(item2,'   ',3)
    symlong:=Long(item2)
    SELECT symlong
      CASE "DUP "; i:=pop(); push(i); push(i)
      CASE "DROP"; pop()
      CASE "SWAP"; i:=pop(); j:=pop(); push(i); push(j)
      CASE "OVER"; i:=pop(); j:=pop(); push(j); push(i); push(j)
      CASE "ROT "; i:=pop(); j:=pop(); k:=pop(); push(j); push(i); push(k)
      CASE "PICK"; i:=pop(); IF sp-(i*4)<stack THEN error:=ER_UNDERFLOW ELSE push(sp[-i])
      CASE "ROLL"; i:=pop(); j:=sp[-i]; IF sp-(i*4)<stack THEN error:=ER_UNDERFLOW ELSE FOR k:=-i TO -2 DO sp[k]:=sp[k+1]; pop(); push(j)
      CASE "?DUP"; i:=pop(); push(i); IF i THEN push(i)
      CASE "DEPT"; push(sp-stack/4)
      CASE ">R  "; rpush(pop())
      CASE "R>  "; push(rpop())
      CASE "R@  "; i:=rpop(); push(i); rpush(i)

      CASE "<   "; push(Not(pop()<=pop()))
      CASE "=   "; push(pop()=pop())
      CASE ">   "; push(Not(pop()>=pop()))
      CASE "0<  "; push(pop()<0)
      CASE "0=  "; push(0=pop())
      CASE "0>  "; push(pop()>0)
      CASE "D<  "; push(Not(pop()<=pop()))
      CASE "U<  "; push(Not(pop()<=pop()))
      CASE "NOT "; push(Not(pop()))

      CASE ".   "; WriteF('\d ',pop()); crflag:=FALSE
      CASE "CR  "; WriteF('\n'); crflag:=TRUE
      CASE "EMIT"; WriteF('\c',pop()); crflag:=FALSE
      CASE "TYPE"; i:=pop(); j:=pop(); FOR k:=1 TO i DO WriteF('\c',j[]++)
      CASE "SPAC"; IF Long(item2+4)="E   " THEN i:=1 ELSE i:=pop(); FOR j:=1 TO i DO WriteF(' '); crflag:=FALSE

      CASE "+   "; push(pop()+pop())
      CASE "-   "; i:=pop(); push(pop()-i)
      CASE "*   "; push(Mul(pop(),pop()))
      CASE "/   "; i:=pop(); push(Div(pop(),i))

      CASE "ABOR"; sp:=stack
      CASE "QUIT"; stop:=TRUE
      DEFAULT
        IF Int(item)=$2E22      /* ." construction */
          crflag:=FALSE
          Write(stdout,item+2,EstrLen(item)-3)
        ELSE
          IF item[0]="-" THEN p:=item+1 ELSE p:=item
          i:=Val(p,{j})
          IF (j=0) THEN error:=ER_SYM
          IF p<>item THEN i:=Mul(i,-1)
          push(i)
       ENDIF
    ENDSELECT
  ENDWHILE
ENDPROC

PROC pop() RETURN IF sp<=stack THEN error:=ER_UNDERFLOW ELSE sp[]--
PROC rpop() RETURN IF rsp<=rstack THEN error:=ER_UNDERFLOW ELSE rsp[]--
PROC push(val); IF MAXSTACK*4+stack<=sp THEN error:=ER_OVERFLOW ELSE sp[]++:=val; ENDPROC
PROC rpush(val); IF MAXRSTACK*4+rstack<=rsp THEN error:=ER_OVERFLOW ELSE rsp[]++:=val; ENDPROC

PROC getsym(p)
  DEF p2
  p:=TrimStr(p)
  IF p[0]="("
    p2:=InStr(p,')',0)
    IF p2=-1 THEN p2:=1000
    p:=TrimStr(p+p2+1)
  ENDIF
  IF p[0]="." AND p[1]=34
    p2:=InStr(p,'"',2)
    IF p2=-1 THEN p2:=1000 ELSE INC p2
    StrCopy(item,p,p2)
  ELSE
    p2:=InStr(p,' ',0)
    IF p2=-1 THEN p2:=1000
    StrCopy(item,p,p2)
  ENDIF
ENDPROC p+p2+1

PROC puterror()
  IF crflag=FALSE THEN WriteF('\n')
  SELECT error
    CASE OK;           WriteF('Ok.\n')
    CASE ER_UNDERFLOW; WriteF('PILE UNDERFLOW.\n')
    CASE ER_OVERFLOW;  WriteF('DEPACEMENT DE LA PILE.\n')
    CASE ER_SYM;       WriteF('\s?\n',item)
  ENDSELECT
ENDPROC

PROC stopnow()
  Close(con)
  CleanUp(0)
ENDPROC
