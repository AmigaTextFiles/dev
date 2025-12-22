

OBJECT lst
 next:PTR TO lst
 current:LONG
ENDOBJECT


PROC main()
DEF ls:PTR TO lst,nxt:PTR TO lst,nx,x,s[20]:STRING
 nxt:=ls:=add('INIT')
 IF ls=0 THEN RETURN
 FOR x:=1 TO 10
    StringF(s,'\d',x)
    nx:=add(s)
    EXIT nx=0
    nxt.next:=nx
    nxt:=nx
 ENDFOR
 show(ls)
 sub(ls,5)
 WriteF('\n')
 show(ls)
 free(ls)
ENDPROC


PROC add(nm)
DEF l:PTR TO lst,buf
IF l:=New(8)
   IF buf:=New(10000)
      l.current:=buf
      AstrCopy(buf,nm,ALL)
   ELSE
      Dispose(l)
   ENDIF
ENDIF   
ENDPROC l

PROC free(ls:PTR TO lst)
DEF nx
WHILE ls
 IF ls.current THEN Dispose(ls.current)
 nx:=ls.next
 Dispose(ls)
 ls:=nx
ENDWHILE
ENDPROC

PROC sub(ls:PTR TO lst,num)
DEF pr:PTR TO lst
IF ls
  WHILE num
     DEC num
     pr:=ls
     ls:=ls.next
     EXIT ls=0
  ENDWHILE
  IF num=0
     IF ls.current THEN Dispose(ls.current)
     pr.next:=ls.next
     Dispose(ls)
     RETURN TRUE
  ENDIF
ENDIF
ENDPROC FALSE


PROC show(ls:PTR TO lst)
WHILE ls
  WriteF('[\s]\n',ls.current)
  ls:=ls.next
ENDWHILE
ENDPROC

