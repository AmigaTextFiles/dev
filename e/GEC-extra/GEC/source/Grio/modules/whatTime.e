
OPT MODULE
OPT EXPORT


OBJECT whatTime
    hour
    minute
    second
ENDOBJECT



PROC whatTime(whatTime:PTR TO whatTime)
  DEF hour:REG,min:REG,sec:REG
  CurrentTime(whatTime,whatTime+4)
  sec:=whatTime.hour
  sec:=sec-Mul(Div(sec,86400),86400)
  whatTime.hour:=hour:=Div(sec,3600)
  sec:=sec-Mul(hour,3600)
  whatTime.minute:=min:=Div(sec,60)
  whatTime.second:=sec-Mul(min,60)
ENDPROC

/*

MODULE 'intuition/intuition','intuition/screens'


PROC main()
    DEF win:PTR TO window,wt:whatTime
    IF win:=OpenW(100,100,200,100,IDCMP_CLOSEWINDOW,
		  WFLG_CLOSEGADGET OR WFLG_DRAGBAR,
           'WhatTime',OpenWorkBench(),CUSTOMSCREEN,NIL)

       Colour(1)
       LOOP
         EXIT GetMsg(win.userport)
         whatTime(wt)
         TextF(30,40,'Time is \z\d[2]:\z\d[2]:\z\d[2]',wt.hour,wt.minute,wt.second)
         Delay(45)
       ENDLOOP
       CloseW(win)
       RETURN 0
    ENDIF
ENDPROC 5

*/

