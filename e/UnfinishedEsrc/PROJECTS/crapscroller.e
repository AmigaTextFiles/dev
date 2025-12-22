->By Ian Chapman
->A very old and simple scroller that doesn't work too well :0

MODULE  'intuition/screens'

CONST SWIDTH=640,
      SHEIGHT=256,
      CENY=124,
      BLINE=50,
      FLINE=206


DEF scr:PTR TO screen,rast

PROC main()

IF (scr:=OpenS(640,256,8,$8000,'Wibbly Wobbly',NIL))<>NIL
    SetColour(scr,0,0,0,0)
    SetColour(scr,1,0,0,0)
    SetColour(scr,2,255,255,255)
    rast:=scr.rastport
    Colour(2)
    ctext('THIS ROUTINE WAS ORIGINALLY USED...',35,BLINE)
    vanish('...IN ONE OF MY OLDEST...',25)
    vanish('BBS ADVERTS. WHEN I HAD ONE! :(',31)
    vanish(' ',1)
    CloseS(scr)

ELSE
    PrintF('Warning! Unable to open screen!\n')
ENDIF

ENDPROC

PROC ctext(thetext,len,y)
DEF x
len:=len*8
x:=(SWIDTH-len)/2
TextF(x,y,thetext)
ENDPROC

PROC scls()
Move(rast,0,0)
ClearScreen(rast)
ENDPROC

PROC fliptext()
Delay(100)
scls()
ENDPROC

PROC vanish(stext,len)
DEF a,b
Delay(100)
FOR b:=1 TO 2
FOR a:=1 TO 25

ScrollRaster(rast,0,-20,0,BLINE-8,SWIDTH,BLINE+180)
ENDFOR
ctext(stext,len,BLINE)
ENDFOR
ENDPROC



