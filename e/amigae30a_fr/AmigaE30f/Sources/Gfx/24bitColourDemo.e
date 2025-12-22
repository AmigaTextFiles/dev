/* démo affichant une image 24 bits.
   Uniquement pour machine AGA et WB3.0
   Traduction : Olivier ANH (BUGSS)      */

OPT OSVERSION=39

CONST X=319, Y=255

DEF rast,s,win,x,y,z

PROC main()
  IF s:=OpenS(X+1,Y+1,8,0,'bla')
    rast:=stdrast         /* nécessaire pour fullcolour() */
    IF win:=OpenW(0,0,X+1,Y+1,0,0,'bla',s,15,0)
      FOR x:=0 TO 255 DO fullcolour(x,x,x,x)
      FOR y:=0 TO Y DO Line(0,y,63,y,y AND $FF)
      FOR y:=0 TO Y DO Line(64,y,127,y,y AND $FE)
      FOR y:=0 TO Y DO Line(128,y,191,y,y AND $FC)
      FOR y:=0 TO Y DO Line(192,y,255,y,y AND $F8)
      FOR y:=0 TO Y DO Line(256,y,319,y,y AND $F0)
      SetDrMd(stdrast,0)
      TextF(0,20,' Pressez le bouton gauche pour afficher les points (x,y)')
      TextF(0,30,' le bouton droit pour quitter.')
      TextF(0,50,' nombre de couleurs :')
      TextF(0,60,'   256     128     64      32      16   ')
      TextF(0,80,' nombre de bits :')
      TextF(0,90,'   24      21      18      15      12   ')
      TextF(0,100,'   AGA     AGA     AGA     AGA     ECS  ')
      WHILE Mouse()<>2
        IF Mouse()=1
          y:=MouseX(win)*4/5
          z:=MouseY(win)
          FOR x:=0 TO 255
            fullcolour(x,y,x,z)
          ENDFOR
        ENDIF
      ENDWHILE
      CloseW(win)
    ENDIF
    CloseS(s)
  ENDIF
ENDPROC

PROC fullcolour(nr,r,g,b)       /* replace SetRGB32()   */
  MOVE.L rast,A0                /* tant que les modules pour 3.0 */
  SUB.L  #40,A0                 /* ne sont pas encore disponible. */
  MOVE.L nr,D0
  MOVE.L r,D1
  SWAP   D1
  LSL.L  #8,D1                  /* échange RGB et 32bit */
  MOVE.L g,D2
  SWAP   D2
  LSL.L  #8,D2
  MOVE.L b,D3
  SWAP   D3
  LSL.L  #8,D3
  MOVE.L gfxbase,A6
  JSR    -$354(A6)              /* SetRGB32(rast,nr,r32,g32,b32) */
ENDPROC
