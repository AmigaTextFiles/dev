
-> the basic problem is you have to place 8 queens
-> on a chessboard, all queens must be safe:
-> try:       queens 8
-> and:       queens 8 all
-> size>12 :  has MANY solutions, type Ctrl+C to exit
-> size>22 :  becomes VERY slow, can be used as benchmark


OPT OSVERSION=37

MODULE 'smartlib/permuters'

OBJECT chessboard OF permuter
ENDOBJECT

DEF quiet
DEF once

PROC partial_solution(list:PTR TO LONG) OF chessboard
  DEF l,q,i
  l:=ListLen(list); q:=list[l]
  i:=1; list:=list+Shl(l,2)
  WHILE i<=l
    list--
    IF list[]-q=i THEN RETURN FALSE
    IF q-list[]=i THEN RETURN FALSE
    INC i
  ENDWHILE
ENDPROC TRUE
PROC print_solution(list) OF chessboard
  DEF x,y
  IF once THEN FputC(stdout,"\n")
  once:=TRUE
  FOR y:=0 TO ListMax(list)-1
    FOR x:=0 TO ListMax(list)-1
      FputC(stdout,IF x=ListItem(list,y) THEN "Q" ELSE ".")
      FputC(stdout," ")
    ENDFOR
    FputC(stdout,"\n")
  ENDFOR
ENDPROC

CHAR '$VER: queens 1.0 (15.05.2004) Copyright © Damien Guichard',0

PROC main() HANDLE
  DEF myargs:PTR TO LONG,rdargs,size
  DEF board:PTR TO chessboard
  myargs:=[0,0,0]
  rdargs:=ReadArgs('SIZE/N/A,ALL/S,QUIET/S',myargs,NIL)
  IF rdargs=NIL THEN Raise(1)
  IF (size:=Long(myargs[0]))<=0 THEN Raise(1)
  quiet:=myargs[2]
  NEW board.solve(list_interval(0,size-1),myargs[1],quiet)
EXCEPT DO
  IF rdargs THEN FreeArgs(rdargs)
  IF exception THEN WriteF('Bad Args!\n')
ENDPROC


