/* $VER: AllAddType 1.1 (28.9.97) © Frédéric Rodrigues - Registered
   Add types to All prefs

   1.0 (26.3.97) - first
   1.1 (28.9.97) - rended compatible with new version of All (1.4) : added
                   TYPESFILE option
*/

OPT OSVERSION=36

MODULE 'dos/dos'

ENUM ER_OK,ER_DOS,ER_MEM,ER_BADFORMAT,ER_TOOLONG
ENUM ARG_KEY,ARG_TYPE,ARG_TYPESFILE

DEF fh,myargs:PTR TO LONG,rdargs

PROC main() HANDLE
  DEF buf,len,size=0
  IF arg[]=0
    PutStr({program});PutStr('\n')
    Raise(ER_OK)
  ENDIF
  myargs:=[NIL,NIL,NIL]
  IF (rdargs:=ReadArgs('KEY/A,TYPE/A,TYPESFILE',myargs,NIL))=NIL THEN Raise(ER_DOS)
  IF StrLen(myargs[ARG_TYPE])>8 THEN Raise(ER_TOOLONG)
  IF (fh:=Open(IF myargs[ARG_TYPESFILE] THEN myargs[ARG_TYPESFILE] ELSE 'ENV:All.prefs',MODE_READWRITE))=NIL THEN Raise(ER_DOS)
  IF (buf:=String(StrLen(myargs[ARG_KEY])+StrLen(myargs[ARG_TYPE])+5))=NIL THEN Raise(ER_MEM)
  StrCopy(buf,myargs[ARG_KEY],ALL)
  StrAdd(buf,';',ALL)
  StrAdd(buf,myargs[ARG_TYPE],ALL)
  StrAdd(buf,'|000',ALL)
  len:=StrLen(buf)
  makestring(buf,{len})
  WHILE buf[size]<>";" DO INC size
/* coding */
  MOVEA.L buf,A0
  MOVE.L len,D0
  SUBQ.L #1,D0
l: NOT.B (A0)+
   DBRA.L D0,l
  Seek(fh,0,OFFSET_END)
  IF Write(fh,buf,len)<len THEN Raise(ER_DOS)
  Seek(fh,4,OFFSET_BEGINING)
  IF Read(fh,buf,4)<4 THEN Raise(ER_DOS)
  IF size>^buf
    Seek(fh,4,OFFSET_BEGINING)
    Write(fh,{size},4)
  ENDIF
  Raise(ER_OK)
EXCEPT
  IF fh THEN Close(fh)
  IF rdargs THEN FreeArgs(rdargs)
  SELECT exception
    CASE ER_DOS;PrintFault(IoErr(),'AllAddType');RETURN RETURN_ERROR
    CASE ER_MEM;PrintFault(ERROR_NO_FREE_STORE,'AllAddType');RETURN RETURN_FAIL
    CASE ER_BADFORMAT;PutStr('AllAddType: bad key format\n');RETURN RETURN_ERROR
    CASE ER_TOOLONG;PutStr('AllAddType: type too long\n');RETURN RETURN_ERROR
  ENDSELECT
ENDPROC

PROC makestring(buf,len)
  DEF val,r,num[3]:STRING,i
  i:=0
  WHILE i<^len
    IF buf[i]="|"
      INC i
      num[0]:=buf[i]
      num[1]:=buf[i+1]
      num[2]:=buf[i+2]
      num[3]:=0
      val:=Val(num,{r})
      IF r=0 THEN Raise(ER_BADFORMAT)
      buf[i-1]:=val
      FOR r:=i TO ^len-3 DO buf[r]:=buf[r+3]
      ^len:=^len-3
    ELSE
      INC i
    ENDIF
  ENDWHILE
ENDPROC

CHAR '$VER: '
program: CHAR 'AllAddType 1.1 (28-9-97) © Frédéric RODRIGUES - Registered\nAdd types to All prefs',0
