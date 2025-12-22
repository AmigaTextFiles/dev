
OPT OSVERSION=37

OBJECT queen
  myrow:LONG
  mycolumn:LONG
  neighbor:PTR TO queen
  boardsize:LONG
ENDOBJECT

PROC build(aQueen,col,size) OF queen
  self.neighbor:=aQueen
  self.mycolumn:=col
  self.myrow:=1
  self.boardsize:=size
  IF self.neighbor THEN self.neighbor.first()
ENDPROC

PROC checkCol(colNumber,rowNumber) OF queen
  DEF cd
  IF rowNumber=self.myrow THEN RETURN FALSE
  cd:=colNumber-self.mycolumn
  IF self.myrow+cd=rowNumber THEN RETURN FALSE
  IF self.myrow-cd=rowNumber THEN RETURN FALSE
  IF self.neighbor THEN RETURN self.neighbor.checkCol(colNumber,rowNumber)
ENDPROC TRUE

PROC first() OF queen
  self.myrow:=1
ENDPROC self.checkrow()

PROC next() OF queen
  self.myrow:=self.myrow+1
ENDPROC self.checkrow()

PROC checkrow() OF queen
  IF self.neighbor=NIL
    IF self.myrow>self.boardsize THEN RETURN 0
    RETURN self.myrow
  ENDIF
  WHILE self.myrow<=self.boardsize
    IF self.neighbor.checkCol(self.mycolumn,self.myrow) THEN
      RETURN self.myrow
    self.myrow:=self.myrow+1
  ENDWHILE
  IF self.neighbor.next()=0 THEN RETURN 0
ENDPROC self.first()

PROC printboard() OF queen
  DEF x
  IF self.neighbor THEN self.neighbor.printboard()
  FOR x:=1 TO self.boardsize
    FputC(stdout,IF x=self.myrow THEN "Q" ELSE ".")
  ENDFOR
  FputC(stdout,"\n")
ENDPROC

PROC main() HANDLE
  DEF myargs:PTR TO LONG,rdargs
  DEF lastq=NIL:PTR TO queen,newq:PTR TO queen
  DEF size,x
  myargs:=New(8)
  IF (rdargs:=ReadArgs('BOARDSIZE/N/A,ALL/S',myargs,NIL))=NIL THEN Raise(1)
  IF (size:=Long(myargs[0]))<=0 THEN Raise(1)
  FOR x:=1 TO size DO lastq:=NEW newq.build(lastq,x,size)
  IF lastq.first() THEN lastq.printboard()
  IF myargs[1]=FALSE THEN Raise(0)
  WHILE TRUE
    EXIT CtrlC()
    EXIT lastq.next()=0
    FputC(stdout,"\n")
    lastq.printboard()
  ENDWHILE
EXCEPT DO
  IF rdargs THEN FreeArgs(rdargs)
  IF exception THEN WriteF('Bad Args!\n')
ENDPROC

