/*

    Picture_oo Example 1

    (C)Copyright 1996/97 By Fabio Rotondo

    This Software is placed in Public Domain.

*/

MODULE 'fabio/picture_oo',  -> The Picture_oo MODULE
       'intuition/screens', -> FOR Screen Tags AND screen structure
       'graphics/gfx',      -> FOR the bitnap structure
       'tools/exceptions'   -> TO show the errors

PROC main() HANDLE
  DEF pic=NIL:PTR TO picture  -> Here there is an instance TO picture OBJECT
  DEF scr:PTR TO screen
  DEF bmp:PTR TO bitmap

  NEW pic.picture()  -> Here we create the picture OBJECT

  pic.loadpic('IntelOutside.iff')  -> Here we load a picture

  bmp:=pic.bitmap()   -> We need a PTR TO picture's bitmap

  IF (scr:=OpenScreenTagList(NIL,     -> Let's open a screen!
    [SA_WIDTH,     bmp.bytesperrow*8,
     SA_HEIGHT,    bmp.rows,
     SA_DEPTH,     bmp.depth,
     SA_DISPLAYID, pic.viewmode(),
     0,0]))

    pic.paltoscr(scr)   -> Let's set the screen palette!!!


    -> This line blit the picture on the screen
    BltBitMapRastPort(bmp, 0,0, scr.rastport, 0,0, bmp.bytesperrow*8, bmp.rows, $C0)


    -> Waiting FOR user events
    REPEAT
      Delay(5)
    UNTIL Mouse()
    CloseScreen(scr)
  ENDIF

  pic.savepic('Ram:picture_try.iff') -> Here we SAVE picture in RAM!!!


EXCEPT DO
  report_exception()
  END pic            -> Remember TO ALWAYS end a MODULE!
  CleanUp(0)         -> Just TO keep things clean!
ENDPROC

