/* an early version of stringf20.e, written mostly in E  */
OPT MODULE

SET PAD,LEFT,BIN,FIELD

EXPORT PROC writef(format,streamptr=NIL:PTR TO LONG)
DEF s[240]:STRING
PutStr(stringf(s,format,streamptr))
ENDPROC

EXPORT PROC stringf(str:PTR TO CHAR,format:PTR TO CHAR,dataptr=NIL:PTR TO LONG)
DEF tempstr[80]:STRING, savestr, savetempstr, templen,
    streamstring:PTR TO CHAR,
    ch,padch, number,i,flag=0,left=0,right=0

  savestr:=str
  REPEAT
    str[]++ := format[]

nextformat:
    i:=0; flag:=0; right:=0; left:=0
    ch:=format[]
    IF ch="%"
nextch:
      i++
      ch:=format[i]
      SELECT  ch
	CASE "l"; JUMP gotlong
	CASE "s"; JUMP gotstring
	CASE "-"; flag:=flag OR LEFT; JUMP nextch
	CASE "0"; flag:=flag OR PAD; JUMP nextch
	DEFAULT; IF (ch>"0") AND (ch<="9")
		    flag:=flag OR FIELD; JUMP field
		 ELSE
		   str[]++ := format[]++; JUMP nextformat
		 ENDIF
      ENDSELECT
    ENDIF
endloop:
    format++
  UNTIL str[-1]=0
  str:=str-savestr
  MOVE.L str,D1
JUMP endstringf

gotstring:
  format:=format+i
  str--
  streamstring:=dataptr[]++
  IF flag AND  FIELD
    savetempstr:=tempstr
    templen:=0
    REPEAT
      savetempstr[]++ := streamstring[]++
      templen++
    UNTIL streamstring[-1]=0
    savetempstr:=tempstr
    templen--
    IF templen>right THEN templen:=right
    BSR dopad
    NOP
  ELSE
    REPEAT
      str[]++ := streamstring[]++
    UNTIL streamstring[-1]=0
    str--
  ENDIF
  J