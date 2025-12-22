
OPT MODULE
OPT EXPORT

OBJECT permuter
PRIVATE
  list:PTR TO LONG
  max:LONG
  sel:LONG
  all:LONG
  quiet:LONG
ENDOBJECT

DEF cnt0,cnt1

PROC solve(list,all,quiet) OF permuter HANDLE
  self.list:=list
  self.max:=ListLen(list)-1
  self.sel:=0
  self.all:=all
  self.quiet:=quiet
  cnt0:=0; cnt1:=0
  SetList(list,0)
  self.total_solution()
  self.erase_line()
EXCEPT
  NOP
ENDPROC
PROC total_solution() OF permuter
  DEF i,tmp,pi:PTR TO LONG,psel:PTR TO LONG
  psel:=self.list+Shl(self.sel,2); pi:=psel
  FOR i:=self.sel TO self.max
    tmp:=pi[]; pi[]:=psel[]; psel[]:=tmp
    IF self.partial_solution(self.list)
      self.sel:=self.sel+1
      IF self.sel<=self.max
        SetList(self.list,self.sel)
        self.total_solution()
      ELSE
        self.erase_line()
        self.print_solution(self.list)
        IF self.all=0 THEN Raise(0)
      ENDIF
      self.sel:=self.sel-1
      SetList(self.list,self.sel)
    ENDIF
    INC cnt1
    IF cnt1-cnt0>=100000
      cnt0:=cnt1
      IF CtrlC()
        self.erase_line()
        Raise(0)
      ELSEIF self.quiet=0
        PrintF('\balready \d permutations tested!',cnt1)
      ENDIF
    ENDIF
    tmp:=pi[]; pi[]:=psel[]; psel[]:=tmp
    pi++
  ENDFOR
ENDPROC
PROC partial_solution(list) OF permuter
ENDPROC
PROC print_solution(list) OF permuter
ENDPROC
PROC erase_line() OF permuter
  DEF x
  IF self.quiet=0
    FputC(stdout,"\b")
    FOR x:=1 TO 40 DO FputC(stdout," ")
    FputC(stdout,"\b")
  ENDIF
ENDPROC

PROC list_interval(a,b)
  DEF i,result,ptr:PTR TO LONG
  IF (result:=List(b-a+1))=NIL THEN Raise("MEM")
  ptr:=result
  FOR i:=a TO b DO ptr[]++:=i
  SetList(result,b-a+1)
ENDPROC result

