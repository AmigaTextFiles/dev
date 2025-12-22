/* 
 *  BitMap-Füll-Prozedur 1.1
 * -========================-
 * 
 * - 1.0 initial Release
 * - 1.1 Bugfix (Filled outside width/height!)
 */

OPT     OSVERSION = 37
OPT     MODULE

MODULE  'newgui/newgui'

EXPORT PROC ng_FillBitMapPattern(rastport,x,y,width,height,bitmap,bitmapwidth,bitmapheight)
 DEF    rows=1,
        cols=1,
        backcols=0,
        xpos=0,
        ypos=0,
        fillwidth=0,
        fillheight=0
 height:=height-y
 width:=width-x
  IF (bitmap<>NIL)
   IF (bitmapheight<height) 
    rows:=height/bitmapheight
   ELSEIF (bitmapheight>height)
    bitmapheight:=height
     rows:=0
   ELSE
    rows:=0
   ENDIF
    IF (bitmapwidth<width) 
     cols:=width/bitmapwidth
    ELSEIF (bitmapwidth>width)
     bitmapwidth:=width
      cols:=0
    ELSE
     cols:=0
    ENDIF
    backcols:=cols
     WHILE (rows>=0)
      IF (rows=0) THEN fillheight:=height-ypos ELSE fillheight:=bitmapheight
       xpos:=0
       cols:=backcols
        WHILE (cols>=0)
         IF (cols=0) THEN fillwidth:=width-xpos ELSE fillwidth:=bitmapwidth
          BltBitMapRastPort(bitmap,0,0,rastport,x+xpos,y+ypos,fillwidth,fillheight,$c0)
          xpos:=xpos+fillwidth
         cols--
        ENDWHILE
       ypos:=ypos+fillheight
      rows--
     ENDWHILE
  ELSE
   RETURN FALSE
  ENDIF
ENDPROC TRUE
