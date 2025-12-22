OPT OSVERSION=39

MODULE 'intuition/intuition'

DEF s,w:PTR TO window,rast,x,m,mx,my,r,g,b

PROC main()
  IF s:=OpenS(320,256,8,$800,'AGA Colour Cube')
    rast:=stdrast
    IF w:=OpenW(0,11,320,245,0,WFLG_BORDERLESS,0,s,15,0)
      fullcolour(0,0,0,0)
      fullcolour(1,$40,$80,$c0)
      fullcolour(11,0,0,0)
      fullcolour(12,0,0,0)
      fullcolour(13,0,0,0)
      fullcolour(6,0,0,0)
      r:=0
      g:=0
      b:=0
      Line(0,16,0,79,11)
      Line(70,16,70,79,12)
      Line(140,16,140,79,13)
      FOR x:=0 TO 63
        Plot(1,16+x,192+x)
        Plot(71,16+x,64+x)
        Plot(141,16+x,128+x)
        Line(2+x,16,2+x,79,64+x)
        Line(72+x,16,72+x,79,128+x)
        Line(142+x,16,142+x,79,192+x)
      ENDFOR
      Colour(6,0)
      RectFill(w.rport,0,82,205,120)
      Colour(5,0)
      fullcolour(5,255,255,255)
      TextF(44,10,'R:\z\h[2] G:\z\h[2] B:\z\h[2]',r,g,b)
      TextF(0,130,'Left mouse on square changes')
      TextF(0,138,'Red, Green or Blue colour')
      TextF(0,146,'component. Right mouse exits.')
      WHILE Mouse()<>2
        Delay(1)
        mx:=MouseX(w)
        my:=MouseY(w)
        m:=Mouse()
        IF (m=1) AND (my>=16) AND (my<=79)
          IF (mx>=2) AND (mx<=65)
            b:=mx-2*4
            g:=my-16*4
          ENDIF
          IF (mx>=72) AND (mx<=135)
            r:=mx-72*4
            b:=my-16*4
          ENDIF
          IF (mx>=142) AND (mx<=205)
            g:=mx-142*4
            r:=my-16*4
          ENDIF
          fullcolour(11,r,0,0)
          fullcolour(12,0,g,0)
          fullcolour(13,0,0,b)
          fullcolour(6,r,g,b)
          TextF(44,10,'R:\z\h[2] G:\z\h[2] B:\z\h[2]',r,g,b)
        ENDIF
      ENDWHILE
      CloseWindow(w)
    ENDIF
    CloseScreen(s)
  ENDIF
ENDPROC

PROC fullcolour(nr,r,g,b)       /* a replacement for SetRGB32()   */
  MOVE.L rast,A0                /* as the modules for 3.0 weren't */
  SUB.L  #40,A0                 /* available yet.                 */
  MOVE.L nr,D0
  MOVE.L r,D1
  SWAP   D1
  LSL.L  #8,D1                  /* shift RGB to 32bit */
  MOVE.L g,D2
  SWAP   D2
  LSL.L  #8,D2
  MOVE.L b,D3
  SWAP   D3
  LSL.L  #8,D3
  MOVE.L gfxbase,A6
  JSR    -$354(A6)              /* SetRGB32(rast,nr,r32,g32,b32) */
ENDPROC

/*
        mfG,
            TOB


The person you rejected yesterday could make you happy, if you say yes.
*/

