/* file.m */

OPT MODULE, POINTER
MODULE 'dos','exec'

PROC readfile(filename:ARRAY OF CHAR,trailbyte="\n":CHAR,memflags=0)
  DEF len,m:ARRAY,rl,fh:BPTR,a,mem:ARRAY OF CHAR
  IF (len:=FileLength(filename))<1 THEN Throw("OPEN",filename)
  mem:= m:=NewM(len+8,memflags)
  FOR a:=0 TO 3
    mem[a]:=trailbyte
    mem[len+4+a]:=trailbyte
  ENDFOR
  m:=m+4
  IF (fh:=Open(filename,OLDFILE))=NIL THEN Raise("OPEN")
  rl:=Read(fh,m,len)
  Close(fh)
  IF rl<>len THEN Raise("IN")
ENDPROC m,len

PROC freefile(mem:ARRAY)
  Dispose(mem-4)
ENDPROC

PROC writefile(filename:ARRAY OF CHAR,mem:ARRAY,len)
  DEF fh:BPTR,wl
  IF (fh:=Open(filename,NEWFILE))=NIL THEN Throw("OPEN",filename)
  wl:=Write(fh,mem,len)
  Close(fh)
  IF wl<>len THEN Raise("OUT")
ENDPROC

/*
PROC countstrings(mem,len)
  MOVE.L mem,A0
  MOVE.L A0,D1
  ADD.L  len,D1
  MOVEQ  #0,D0
  MOVEQ  #10,D2
strings:
  ADDQ.L #1,D0
findstring:
  CMP.B  (A0)+,D2
  BNE.S  findstring
  CMPA.L D1,A0
  BMI.S  strings
ENDPROC D0

PROC stringsinfile(mem,len,max)
  DEF list,l
  IF (list:=List(max))=NIL THEN Raise("MEM")
  MOVE.L list,A1
  MOVE.L max,D3
  MOVE.L mem,A0
  MOVE.L A0,D1
  ADD.L  len,D1
  MOVEQ  #0,D0
  MOVEQ  #10,D2
stringsl:
  CMP.L  D3,D0
  BPL.S  done
  ADDQ.L #1,D0
  MOVE.L A0,(A1)+
findstringl:
  CMP.B  (A0)+,D2
  BNE.S  findstringl
  CLR.B  -1(A0)
  CMPA.L D1,A0
  BMI.S  stringsl
done:
  MOVE.L D0,l
  SetList(list,l)
ENDPROC list
*/
