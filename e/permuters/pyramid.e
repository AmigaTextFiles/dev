
-> the basic problem is you have to place 1-n integers in a pyramid,
-> each integer must be the difference between its two inferiors
-> try:      pyramid 4
-> and:      pyramid 4 all
-> size=5 :  can be used as a benchmark
-> size>5 :  has no solution, really SLOW, good benchmark for power users


OPT OSVERSION=37

MODULE 'smartlib/permuters'

OBJECT pyramid OF permuter
  length
  level
ENDOBJECT

DEF quiet
DEF once
DEF size

PROC partial_solution(list:PTR TO LONG) OF pyramid
  DEF l,x,y,z,i,level
  l:=ListLen(list)
  IF l<size THEN RETURN TRUE
  x:=list[l]
  IF self.length<>l
    self.length:=l
    level:=1; i:=ListMax(list)-1
    WHILE TRUE
      EXIT i<=l
      INC level
      i:=i-level
    ENDWHILE
    self.level:=level
  ENDIF
  y:=list[l-self.level]; z:=list[l-self.level-1]
  IF y-z=x THEN RETURN TRUE
  IF z-y=x THEN RETURN TRUE
ENDPROC FALSE
PROC print_solution(list:PTR TO LONG) OF pyramid
  DEF level,count
  IF once THEN FputC(stdout,"\n")
  once:=TRUE
  list:=list+Shl(ListMax(list),2)
  FOR level:=1 TO size
    FOR count:=size TO level STEP -1
      PrintF('  ')
    ENDFOR
    FOR count:=1 TO level
      list--
      IF list[]<10 THEN FputC(stdout," ")
      PrintF('\d  ',list[])
    ENDFOR
    FputC(stdout,"\n")
  ENDFOR
ENDPROC

CHAR '$VER: pyramid 1.0 (15.05.2004) Copyright © Damien Guichard',0

PROC main() HANDLE
  DEF myargs:PTR TO LONG,rdargs
  DEF pyramid:PTR TO pyramid
  DEF interval
  myargs:=[0,0,0]
  rdargs:=ReadArgs('SIZE/N/A,ALL/S,QUIET/S',myargs,NIL)
  IF rdargs=NIL THEN Raise(1)
  IF (size:=Long(myargs[0]))<=0 THEN Raise(1)
  interval:=list_interval(1,size*size+size/2)
  quiet:=myargs[2]
  NEW pyramid.solve(interval,myargs[1],quiet)
EXCEPT DO
  IF rdargs THEN FreeArgs(rdargs)
  IF exception THEN WriteF('Bad Args!\n')
ENDPROC


