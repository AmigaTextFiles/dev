OPT MODULE
OPT EXPORT

MODULE 'intuition/intuition',
       'graphics/rastport'

PROC mRequest(title,text,gads)
DEF answer
answer:=EasyRequestArgs(NIL,[SIZEOF easystruct, 0,
			title,text,gads]:easystruct,
			NIL,NIL)
ENDPROC answer

PROC mReset(text=NIL)
  IF text<>NIL
	WriteF('\s',text)
	Delay(100)
  ENDIF 
  BSET    #$7, $DE0002
  MOVEA.L $4,  A6
  JMP     -$2D6(A6)
ENDPROC

PROC mBox(rp,x,y,x1,y1,p1=1,p2=2)
SetAPen(rp,p1)
RectFill(rp,x,y,x1,y)
RectFill(rp,x,y,x,y1)
SetAPen(rp,p2)
RectFill(rp,x,y1,x1,y1)
RectFill(rp,x1,y,x1,y1)
ENDPROC

PROC mTextOne(rp,x,y,texts,ap=2,bp=1,m=2)
DEF itext:PTR TO intuitext
	itext:=[bp,0,RP_JAM1,0,0,0,texts,NIL]:intuitext
		PrintIText(rp,itext,x,y)
	itext.frontpen:=ap
		PrintIText(rp,itext,x-m,y-m)
ENDPROC

PROC mTextTwo(rp,x,y,texts,ap=2,bp=1,cp=0)
DEF itext:PTR TO intuitext
	itext:=[bp,0,RP_JAM1,0,0,0,texts,NIL]:intuitext
		PrintIText(rp,itext,x-1,y-1)
	itext.frontpen:=ap
		PrintIText(rp,itext,x+1,y+1)
	itext.frontpen:=cp
		PrintIText(rp,itext,x,y)
ENDPROC

PROC mClick(dummy=0)
DEF x
REPEAT;UNTIL x:=Mouse()
ENDPROC x

PROC mError(errname,x=0)
WriteF('\s\n',errname)
CleanUp(x)
ENDPROC

PROC mStrFill(char,size)
DEF p,a,z[512]:STRING
p:=String(4096)
StringF(z,'\c',char)
FOR a:=0 TO size
StrAdd(p,z,1)
ENDFOR
ENDPROC p
