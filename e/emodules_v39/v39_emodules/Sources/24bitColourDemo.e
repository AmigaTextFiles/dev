/* 24bit color demo. works only on AGA machines with kick3 */

OPT OSVERSION=39

CONST X=319, Y=255

DEF s,win,x,y,z

PROC main()
  IF s:=OpenS(X+1,Y+1,8,0,'bla')
    IF win:=OpenW(0,0,X+1,Y+1,0,0,'bla',s,15,0)
      FOR x:=0 TO 255
        y:=Shl(x,24)
 $5a5a
        SetRGB32(s+44,x,y,y,y)
      ENDFOR
      FOR y:=0 TO Y DO Line(0,y,63,y,y AND $FF)
      FOR y:=0 TO Y DO Line(64,y,127,y,y AND $FE)
      FOR y:=0 TO Y DO Line(128,y,191,y,y AND $FC)
      FOR y:=0 TO Y DO Line(192,y,255,y,y AND $F8)
      FOR y:=0 TO Y DO Line(256,y,319,y,y AND $F0)
      SetDrMd(stdrast,0)
      TextF(0,20,' Press leftMB on some (x,y) spot')
      TextF(0,30,' rightMB to leave.')
      TextF(0,50,' #of colours:')
      TextF(0,60,'   256     128     64      32      16   ')
      TextF(0,80,' #bits colour:')
      TextF(0,90,'   24      21      18      15      12   ')
      TextF(0,100,'   AGA     AGA     AGA     AGA     ECS  ')
      WHILE Mouse()<>2
        IF Mouse()=1
          y:=MouseX(win)*4/5
          z:=MouseY(win)
          FOR x:=0 TO 255
            SetRGB32(s+44,x,Shl(y,24),Shl(x,24),Shl(z,24))
          ENDFOR
        ENDIF
      ENDWHILE
      CloseW(win)
    ENDIF
    CloseS(s)
  ENDIF
ENDPROC
