OPT MODULE,PREPROCESS, POWERPC
OPT EXPORT

MODULE 'exec/lists','exec/nodes','exec/tasks'

#define New2D(w,h)    NewR((w)*(h))
#define New3D(w,h,d)  NewR((w)*(h)*(d))

#define ASTR(bstr)    (Shl(bstr,2)+1)
#define APTR(bptr)    Shl(bptr,2)
#define BPTR(aptr)    Shr(aptr,2)

#define TagInit(varname)  varname:=[
#define Tag(tag,data)     tag,data,
#define TagDone           TAG_DONE]

#define TagInitNEW(varname) varname:=NEW [


#define ColorRange(start,numcols) INT numcols,start
#define Color(r,g,b)              CHAR r,0,0,0,g,0,0,0,b,0,0,0
#define ColorEnd                  LONG 0

#define ADDR(varname)   {varname}

#define Mask(sig)       Shl(1,sig)

#define DupStr(str)     StrCopy(String(StrLen(str)),str)
#define DupStrE(str)    StrCopy(String(EstrLen(str)),str)

#define ExceptionReport(pname)  exceptionReport(pname)

PROC exceptionReport(pname)
DEF str[5]:ARRAY OF CHAR,str2,x,fmt
  IF exception
    PutLong(str,exception)
    str[4]:=0
    str2:=str
    WHILE str2[]=0 DO str2++

    FOR x:=0 TO 3
      IF (str[x]<>0) AND ((str[x]<32) OR (str[x]>127)) THEN str2:=-1
    ENDFOR

    IF exception<1000
      PrintF('\s: Exception #\d recieved!\n',pname,exception)
    ELSEIF str2=-1
      PrintF('\s: Exception $\z\h[8]\n recieved!\n',pname,exception)
    ELSE
      PrintF('\s: Exception "\s" recieved!\n',pname,str2)
    ENDIF
  ENDIF
ENDPROC

#define StartArrayStruct(var)  var:=[
#define Array(list,struct)     list:struct,
#define EndArray               NIL]

#define NewLine                PutStr('\n')

#define PrintBool(exp)         IF (exp) THEN 'TRUE' ELSE 'FALSE'
#define IsNotNull(exp)         IF (exp) THEN (exp) ELSE 'NULL POINTER'

->PROC initHeader(h)
->  MOVE.L  h,A0
->  MOVE.L  A0,8(A0)
->  ADDQ.L  #4,A0
->  CLR.L   (A0)
->  MOVE.L  A0,-(A0)
->ENDPROC

#define ForwardList(list,num) forward(list,num)

PROC forward(list:PTR TO lh,num)
DEF n:REG PTR TO ln
  n:=list.head
  WHILE num>0
->    PrintF('name="\s"\n',IF n THEN IF n.name THEN n.name; ELSE 'NULL POINTER')
    n:=n.succ
    EXIT n=NIL
    num--
  ENDWHILE
ENDPROC n

#define Long2Str(l)   long2str(l,[0,0])

PROC long2str(l,tmp)
  PutLong(tmp,l)
ENDPROC tmp

PROC getProgramName()
DEF b,c,d,thistask:PTR TO tc
  IF wbmessage
    thistask:=FindTask(NIL)
    d:=DupStr(thistask.ln.name)
  ELSE
    GetProgramName(b:=String(1024),1024)
    c:=FilePart(b)
    d:=DupStr(c)
    Dispose(b)
  ENDIF
ENDPROC d

#define WaitBreak               waitBreak()
#define WaitBreakD              waitBreak("D",$2000)
#define WaitBreakE              waitBreak("E",$4000)
#define WaitBreakF              waitBreak("F",$8000)

PROC waitBreak(c="C",mask=$1000)
  PrintF('<CTRL-\c>\n',c)
  Wait(mask)
ENDPROC

->----------------------------------------------------------------------------<-

CHAR 'macros.m 3.2 (21/4/96)',0
CHAR '© Chris Sumner 1996',0
