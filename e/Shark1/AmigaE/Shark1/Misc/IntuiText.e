MODULE	'intuition/intuition',
	'graphics/rastport'

DEF w:PTR TO window
PROC main()

w:=OpenW(0,0,100,100,0,0,'Flaki z rozna',0,1,0)
mWriteInt(w.rport,20,20,'Kotek')

LOOP
IF Mouse()=1 THEN JUMP e
ENDLOOP
e:
CloseW(w)

ENDPROC

PROC mWriteInt(rp,x,y,name,ap=2,bp=1)
DEF itext:PTR TO intuitext

itext:=[bp,0,RP_JAM1,0,0,0,name,NIL]:intuitext
PrintIText(rp,itext,x,y)
itext.frontpen:=ap
PrintIText(rp,itext,x-2,y-2)

ENDPROC

