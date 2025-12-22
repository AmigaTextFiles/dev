/* file.m */

OPT MODULE

EXPORT PROC readfile(filename,trailbyte="\n",memflags=0)
  DEF len,m,rl,fh,a
  IF (len:=FileLength(filename))<1 THEN Throw("OPEN",filename)
  m:=NewM(len+8,memflags)
  FOR a:=0 TO 3
    m[a]:=trailbyte
    m[len+4+a]:=trailbyte
  ENDFOR
  m:=m+4
  IF (fh:=Open(filename,OLDFILE))=NIL THEN Raise("OPEN")
  rl:=Read(fh,m,len)
  Close(fh)
  IF rl<>len THEN Raise("IN")
ENDPROC m,len

EXPORT PROC freefile(mem)
  Dispose(mem-4)
ENDPROC

EXPORT PROC writefile(filename,mem,len)
  DEF fh,wl
  IF (fh:=Open(filename,NEWFILE))=NIL THEN Throw("OPEN",filename)
  wl:=Write(fh,mem,len)
  Close(fh)
  IF wl<>len THEN Raise("OUT")
ENDPROC

EXPORT PROC countstrings(mem,len)
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

EXPORT PROC stringsinfile(mem,len,max)
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
