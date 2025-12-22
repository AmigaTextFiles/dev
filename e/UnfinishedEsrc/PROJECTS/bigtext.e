->By Ian Chapman
->Some experimental vector graphics.

MODULE  'intuition/screens'

OBJECT btext
tw
th
spx
spy
ENDOBJECT

DEF scr:PTR TO screen,
    rast,
    bf:btext

PROC main()




IF (scr:=OpenS(640,480,4,$8000,'Scroller',NIL))<>NIL
    rast:=scr.rastport

    SetColour(scr,2,255,0,0)
    SetColour(scr,0,0,0,0)

    resetparam()

    zoomt(3)
    respar2()
    zoomt(-3)
    resetparam()

    zoomh(3)
    respar2()
    zoomh(-3)
    resetparam()

    zoome(3)
    respar2()
    zoome(-3)
    resetparam()

    zoomj(3)
    respar2()
    zoomj(-3)
    resetparam()

    zoome(3)
    respar2()
    zoome(-3)
    resetparam()

    zooml(3)
    respar2()
    zooml(-3)
    resetparam()

    zooml(3)
    respar2()
    zooml(-3)
    resetparam()

    zoomy(3)
    respar2()
    zoomy(-3)
    resetparam()

    zoomz(3)
    respar2()
    zoomz(-3)
    resetparam()

    zoomo(3)
    respar2()
    zoomo(-3)
    resetparam()

    zoomn(3)
    respar2()
    zoomn(-3)
    resetparam()

    zoome(3)
    respar2()
    zoome(-3)
    resetparam()


    across()

    Colour(5)
    scroller()

    Delay(200)
    CloseS(scr)

ELSE
        PrintF('Unable top open screen\n')
ENDIF

ENDPROC

PROC a()
drawleft()
drawright()
drawtop()
drawmiddle()
ENDPROC

PROC b()
drawleft()
drawright()
drawtop()
drawbottom()
drawmiddle()
ENDPROC

PROC c()
drawtop()
drawbottom()
drawleft()
ENDPROC

PROC d()
drawleft()
movetopleft()
Draw(rast,bf.spx+(bf.tw/2),bf.spy)
movebottomleft()
Draw(rast,bf.spx+(bf.tw/2),bf.spy+bf.th)
Move(rast,bf.spx+bf.tw,bf.spy+(bf.th/2))
Draw(rast,bf.spx+(bf.tw/2),bf.spy)
Move(rast,bf.spx+bf.tw,bf.spy+(bf.th/2))
Draw(rast,bf.spx+(bf.tw/2),bf.spy+bf.th)
ENDPROC

PROC e()
drawleft()
drawtop()
drawbottom()
drawmiddle()
ENDPROC

PROC f()
drawtop()
drawleft()
drawmiddle()
ENDPROC

PROC g()
drawtop()
drawleft()
drawbottom()
Draw(rast,bf.spx+bf.tw,bf.spy+(bf.th/2))
Draw(rast,bf.spx+(bf.tw/2),bf.spy+(bf.th/2))
ENDPROC

PROC h()
drawleft()
drawmiddle()
drawright()
ENDPROC

PROC i()
drawtop()
drawbottom()
drawvmiddle()
ENDPROC

PROC j()
drawtop()
drawvmiddle()
Draw(rast,bf.spx,bf.spy+bf.th)
ENDPROC

PROC k()
drawleft()
Move(rast,bf.spx,bf.spy+(bf.th/2))
Draw(rast,bf.spx+bf.tw,bf.spy)
Move(rast,bf.spx,bf.spy+(bf.th/2))
Draw(rast,bf.spx+bf.tw,bf.spy+bf.th)
ENDPROC

PROC l()
drawleft()
drawbottom()
ENDPROC

PROC m()
drawleft()
drawright()
diaglrhalf()
diagrlhalf()
ENDPROC

PROC n()
drawleft()
drawright()
diaglr()
ENDPROC

PROC o()
drawleft()
drawright()
drawtop()
drawbottom()
ENDPROC

PROC p()
drawleft()
drawtop()
drawmiddle()
Draw(rast,bf.spx+bf.tw,bf.spy)
ENDPROC

PROC q()
drawtop()
drawleft()
drawright()
drawbottom()
Draw(rast,bf.spx+(bf.tw/2),bf.spy+(bf.th/2))
ENDPROC

PROC r()
drawleft()
drawtop()
drawmiddle()
Draw(rast,bf.spx+bf.tw,bf.spy)
Move(rast,bf.spx,bf.spy+(bf.th/2))
Draw(rast,bf.spx+bf.tw,bf.spy+bf.th)
ENDPROC

PROC s()
drawtop()
drawmiddle()
drawbottom()
Draw(rast,bf.spx+bf.tw,bf.spy+(bf.th/2))
movetopleft()
Draw(rast,bf.spx,bf.spy+(bf.th/2))
ENDPROC

PROC t()
drawtop()
drawvmiddle()
ENDPROC

PROC u()
drawleft()
drawright()
drawbottom()
ENDPROC

PROC v()
movetopleft()
Draw(rast,bf.spx+(bf.tw/2),bf.spy+bf.th)
movetopright()
Draw(rast,bf.spx+(bf.tw/2),bf.spy+bf.th)
ENDPROC

PROC w()
drawleft()
drawright()
movebottomleft()
midpoint()
movebottomright()
midpoint()
ENDPROC

PROC x()
diaglr()
diagrl()
ENDPROC

PROC y()
diaglrhalf()
diagrlhalf()
Draw(rast,bf.spx+(bf.tw/2),bf.spy+bf.th)
ENDPROC

PROC z()
drawtop()
drawbottom()
diagrl()
ENDPROC








/*******************/

PROC movetopleft()
Move(rast,bf.spx,bf.spy)
ENDPROC

PROC movetopright()
Move(rast,bf.spx+bf.tw,bf.spy)
ENDPROC

PROC movebottomleft()
Move(rast,bf.spx,bf.spy+bf.th)
ENDPROC

PROC movebottomright()
Move(rast,bf.spx+bf.tw,bf.spy+bf.th)
ENDPROC

PROC drawleft()
movetopleft()
Draw(rast,bf.spx,bf.spy+bf.th)
ENDPROC

PROC drawright()
movetopright()
Draw(rast,bf.spx+bf.tw,bf.spy+bf.th)
ENDPROC

PROC drawtop()
movetopleft()
Draw(rast,bf.spx+bf.tw,bf.spy)
ENDPROC

PROC drawbottom()
movebottomleft()
Draw(rast,bf.spx+bf.tw,bf.spy+bf.th)
ENDPROC

PROC drawmiddle()
Move(rast,bf.spx,bf.spy+(bf.th/2))
Draw(rast,bf.spx+bf.tw,bf.spy+(bf.th/2))
ENDPROC

PROC drawvmiddle()
Move(rast,bf.spx+(bf.tw/2),bf.spy)
Draw(rast,bf.spx+(bf.tw/2),bf.spy+bf.th)
ENDPROC


PROC diaglr()
movetopleft()
Draw(rast,bf.spx+bf.tw,bf.spy+bf.th)
ENDPROC

PROC diagrl()
movetopright()
Draw(rast,bf.spx,bf.spy+bf.th)
ENDPROC

PROC diaglrhalf()
movetopleft()
Draw(rast,bf.spx+(bf.tw/2),bf.spy+(bf.th/2))
ENDPROC

PROC diagrlhalf()
movetopright()
Draw(rast,bf.spx+(bf.tw/2),bf.spy+(bf.th/2))
ENDPROC

PROC midpoint()
Draw(rast,bf.spx+(bf.tw/2),bf.spy+(bf.th/2))
ENDPROC


PROC zoomt(add)
DEF inc

FOR inc:=1 TO 50
    Colour(2)
    bf.tw:=bf.tw+add
    bf.th:=bf.th+add
    t()
    WaitTOF()
    Colour(0)
    t()
    ENDFOR
ENDPROC

PROC zoomh(add)
DEF inc

FOR inc:=1 TO 50
    Colour(2)
    bf.tw:=bf.tw+add
    bf.th:=bf.th+add
    h()

    WaitTOF()
    Colour(0)
    h()
    ENDFOR
ENDPROC

PROC zoome(add)
DEF inc

FOR inc:=1 TO 50
    Colour(2)
    bf.tw:=bf.tw+add
    bf.th:=bf.th+add
    e()

    WaitTOF()
    Colour(0)
    e()
    ENDFOR
ENDPROC

PROC zoomj(add)
DEF inc

FOR inc:=1 TO 50
    Colour(2)
    bf.tw:=bf.tw+add
    bf.th:=bf.th+add
    j()

    WaitTOF()
    Colour(0)
    j()
    ENDFOR
ENDPROC

PROC zooml(add)
DEF inc

FOR inc:=1 TO 50
    Colour(2)
    bf.tw:=bf.tw+add
    bf.th:=bf.th+add
    l()

    WaitTOF()
    Colour(0)
    l()
    ENDFOR
ENDPROC

PROC zoomy(add)
DEF inc

FOR inc:=1 TO 50
    Colour(2)
    bf.tw:=bf.tw+add
    bf.th:=bf.th+add
    y()

    WaitTOF()
    Colour(0)
    y()
    ENDFOR
ENDPROC

PROC zoomz(add)
DEF inc

FOR inc:=1 TO 50
    Colour(2)
    bf.tw:=bf.tw+add
    bf.th:=bf.th+add
    z()

    WaitTOF()
    Colour(0)
    z()
    ENDFOR
ENDPROC

PROC zoomo(add)
DEF inc

FOR inc:=1 TO 50
    Colour(2)
    bf.tw:=bf.tw+add
    bf.th:=bf.th+add
    o()

    WaitTOF()
    Colour(0)
    o()
    ENDFOR
ENDPROC

PROC zoomn(add)
DEF inc

FOR inc:=1 TO 50
    Colour(2)
    bf.tw:=bf.tw+add
    bf.th:=bf.th+add
    n()

    WaitTOF()
    Colour(0)
    n()
    ENDFOR
ENDPROC

PROC resetparam()
bf.spy:=63
bf.spx:=250
bf.tw:=1
bf.th:=1
ENDPROC

PROC respar2()
bf.tw:=150
bf.th:=150
ENDPROC

PROC across()
DEF inc


Colour(4)

bf.spx:=70
bf.spy:=50
bf.tw:=50
bf.th:=50

i()

bf.spx:=bf.spx+bf.tw+10
bf.tw:=bf.tw-5
bf.th:=bf.th-5

a()

bf.spx:=bf.spx+bf.tw+10
bf.tw:=bf.tw-5
bf.th:=bf.th-5

n()

bf.spx:=bf.spx+bf.tw+10
bf.tw:=bf.tw-5
bf.th:=bf.th-5

c()

bf.spx:=bf.spx+bf.tw+10
bf.tw:=bf.tw-5
bf.th:=bf.th-5

h()

bf.spx:=bf.spx+bf.tw+10
bf.tw:=bf.tw
bf.th:=bf.th

a()

bf.spx:=bf.spx+bf.tw+10
bf.tw:=bf.tw+5
bf.th:=bf.th+5

p()

bf.spx:=bf.spx+bf.tw+10
bf.tw:=bf.tw+5
bf.th:=bf.th+5

m()

bf.spx:=bf.spx+bf.tw+10
bf.tw:=bf.tw+5
bf.th:=bf.th+5

a()

bf.spx:=bf.spx+bf.tw+10
bf.tw:=bf.tw+5
bf.th:=bf.th+5

n()

Delay(100)

FOR inc:=1 TO 160
ScrollRaster(rast,0,-1,70,50,640,bf.spy+100)
ENDFOR


ENDPROC

PROC scroller()
DEF x
Colour(4)
SetColour(scr,4,255,255,0)
bf.spx:=600
bf.spy:=150
bf.tw:=30
bf.th:=30

t()
on()
h()
on()
i()
on()
s()
on()
on()
l()
on()
i()
on()
t()
on()
t()
on()
l()
on()
e()
on()
on()

d()
on()
e()
on()
m()
on()
o()
on()
on()
w()
on()
a()
on()
s()
on()
on()
c()
on()
r()
on()
e()
on()
a()
on()
t()
on()
e()
on()
d()
on()
on()

e()
on()
n()
on()
t()
on()
i()
on()
r()
on()
e()
on()
l()
on()
y()
on()
on()

i()
on()
n()
on()
on()

a()
on()
m()
on()
i()
on()
g()
on()
a()
on()
on()

e()
on()
on()

b()
on()
y()
on()
on()

i()
on()
a()
on()
n()
on()
 on()


c()
on()
h()
on()
a()
on()
p()
on()
m()
on()
a()
on()
n()
on()
on()
on()






on()
on()
on()
on()
on()
on()

p()
on()
o()
on()
w()
on()
e()
on()
r()
on()
e()
on()
d()
on()
on()

b()
on()
y()
on()
on()

a()
on()
m()
on()
i()
on()
g()
on()
a()

Delay(5)

FOR x:=1 TO 35
WaitTOF()
ScrollRaster(rast,0,1,0,150,640,185)
ENDFOR

Delay(10)
ENDPROC

PROC on()
DEF x
FOR x:=1 TO 40
ScrollRaster(rast,1,0,0,150,640,185)
ENDFOR
ENDPROC





