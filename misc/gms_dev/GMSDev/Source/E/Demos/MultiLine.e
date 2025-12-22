/* GMS-example
**
** Name:    MultiLine.e
** Type:    Blitter example (based on Bounceline.e/c)
** Version: 1.1
** Author:  G. W. Thomassen (0000272e@lts.mil.no)
*/

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures',
       'gms/screens','gms/system/register','gms/system/modules','gms/graphics/pictures',
       'gms/graphics/screens','gms/graphics/blitter','gms/blitter'

ENUM NONE,ERR_LIB,ERR_SCR,ERR_SMOD,ERR_BMOD,ERR_JOY

PROC main() HANDLE
  DEF scr=NIL:PTR TO screen,
      scrmodule=NIL:PTR TO module,
      bltmodule=NIL:PTR TO module,
      sx,sy,ex,ey,state,up=0,
      dsx,dsy,dex,dey,col,count=0

  DEF colours[10]:ARRAY OF LONG

  colours := [ $00ff0000, $0000ff00, $000000ff, $00ff00ff, $0000ff77,
               $00ffff00, $004488aa, $0000ffff, $00999999, $00ffffff ]:LONG


  IF (dpkbase:=OpenLibrary('GMS:libs/dpkernel.library',0))=NIL THEN Raise(ERR_LIB)

  IF (bltmodule:=Init([TAGS_MODULE,NIL,     ->blitter-module
      MODA_NUMBER,    MOD_BLITTER,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_BMOD)
      bltbase := bltmodule.modbase

  IF (scrmodule:=Init([TAGS_MODULE,NIL,       ->screen-module
      MODA_NUMBER,    MOD_SCREENS,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_SMOD)
      scrbase:=scrmodule.modbase

  col := colours[SlowRandom(10)] -> Set the first colour.

  IF (scr:=Init([TAGS_SCREEN, NIL,
       GSA_ScrMode, SM_HIRES + SM_LACED,
       GSA_Width,   640,
       GSA_Height,  512,
       GSA_Attrib,  SCR_DBLBUFFER,   -> Two frames (Doublebuffering)
         GSA_BitmapTags, NIL,
         BMA_Palette,    [PALETTE_ARRAY,2,$000000,$000000],
         TAGEND,NIL,
       TAGEND],NIL))=NIL THEN Raise(ERR_SCR)

  -> Calculate start values..
  sx:=SlowRandom(scr.width);  dsx:=-1
  sy:=SlowRandom(scr.height); dsy:=2
  ex:=SlowRandom(scr.width);  dex:=3
  ey:=SlowRandom(scr.height); dey:=1

  -> Display the screen
  Show(scr)

  REPEAT
    /* Calculate new values */
    sx:=sx+dsx
    sy:=sy+dsy
    ex:=ex+dex
    ey:=ey+dey

    /* Check if screen limits are exceeded */
    IF sx<0; sx:=0; dsx:=-dsx; ENDIF
    IF sy<0; sy:=0; dsy:=-dsy; ENDIF
    IF ex<0; ex:=0; dex:=-dex; ENDIF
    IF ey<0; ey:=0; dey:=-dey; ENDIF

    IF (sx>(scr.width))
      sx  := scr.width-2
      dsx := -dsx
    ENDIF
    IF (sy>(scr.height))
      sy  := scr.height-2
      dsy := -dsy
    ENDIF
    IF (ex>(scr.width))
      ex  := scr.width-2
      dex := -dex
    ENDIF
    IF (ey>(scr.height))
      ey  :=scr.height-2
      dey :=-dey
    ENDIF

    /* Fading */

    IF (up=0)
       /* Fade from black into a colour */
       state := ColourMorph(scr,state,3,1,1,$000000,col)
       IF (state = NIL)
          up := 1
          count := NIL
       ENDIF
    ELSEIF (up=1)
       count := count + 1
       IF (count > 700)
          count := NIL
          up    := 2
       ENDIF
    ELSEIF (up=2)
       /* Fade from colour down to black */

       state := ColourMorph(scr,state,1,1,1,col,$000000)

       IF (state = NIL)
          Clear(scr.bitmap); WaitAVBL()
          SwapBuffers(scr);  WaitAVBL()
          Clear(scr.bitmap)
          col := colours[SlowRandom(10)]
          up  := 0 /* Fade back into a colour next time */
       ENDIF
    ENDIF

    /* Drawing */

    -> Draw the line and put the frame in front.
    DrawLine(scr.bitmap,sx,sy,ex,ey,1,$FFFFFFFF)
    WaitAVBL()
    SwapBuffers(scr)
  UNTIL Mouse()=1       -> You should use the Joy-module instead.

  -> No error..
  Raise(NONE)

EXCEPT DO

  -> Close down everything
  IF scr THEN Free(scr)
  IF scrmodule THEN Free(scrmodule)
  IF bltmodule THEN Free(bltmodule)
  CloseDPK()

  -> Report errors..
  SELECT exception
  CASE ERR_LIB; WriteF('Couldn\at open "dpkernel.library"\n')
  CASE ERR_SMOD; WriteF('Couldn\at initialize screen-module\n')
  CASE ERR_SCR; WriteF('Couldn\at open screen\n')
  CASE ERR_BMOD; WriteF('Couldn\at initialize blitter-module\n')
  ENDSELECT

  -> End with the return code 0, a good way to end programs..
  CleanUp(0)
ENDPROC
