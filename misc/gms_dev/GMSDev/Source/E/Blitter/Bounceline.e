/* GMS-example
 * Name:    BounceLine.e
 * Type:    Blitter example (converted from Bounceline.c)
 * Version: 1.0
 * Author:  G. W. Thomassen (0000272e@lts.mil.no)
 * Note:    For code description see the MultiLine.e it's pretty
 *          much the same..
 */

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures'
MODULE 'gms/files/files','gms/screens','gms/system/register','gms/system/modules'
MODULE 'gms/input/joydata','gms/graphics/screens','gms/graphics/blitter'
MODULE 'gms/blitter'

ENUM NONE,ERR_LIB,ERR_SCR,ERR_SMOD,ERR_BMOD,ERR_JOY

PROC main() HANDLE
  DEF scr=NIL:PTR TO screen,
      scrmodule=NIL:PTR TO module,
      bltmodule=NIL:PTR TO module,
      sx,sy,ex,ey,dsx,dsy,dex,dey

  IF (dpkbase:=OpenLibrary('GMS:libs/dpkernel.library',0))=NIL THEN Raise(ERR_LIB)

  IF (scrmodule:=Init([TAGS_MODULE,NIL,       ->screen-module
      MODA_NUMBER,    MOD_SCREENS,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_SMOD)
      scrbase:=scrmodule.modbase

  IF (bltmodule:=Init([TAGS_MODULE,NIL,     ->blitter-module
      MODA_NUMBER,    MOD_BLITTER,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_BMOD)
      bltbase := bltmodule.modbase

  IF (scr:=Init([TAGS_SCREEN, NIL,
       GSA_ScrMode, SM_HIRES,
       GSA_Width,   640,
       GSA_Height,  256,
       GSA_Attrib,  SCR_DBLBUFFER,
         GSA_BitmapTags, NIL,
         BMA_AmtColours, 2,
         BMA_Palette,    [PALETTE_ARRAY,2,$000000,$80f0f0],
         TAGEND,         NIL,
       TAGEND],NIL))=NIL THEN Raise(ERR_SCR)

  sx:=SlowRandom(scr.width);  dsx:=-1
  sy:=SlowRandom(scr.height); dsy:=2
  ex:=SlowRandom(scr.width);  dex:=3
  ey:=SlowRandom(scr.height); dey:=1

  Show(scr)

  REPEAT
    Clear(scr.bitmap)
    sx:=sx+dsx
    sy:=sy+dsy
    ex:=ex+dex
    ey:=ey+dey

    IF sx<0; sx:=0; dsx:=-dsx; ENDIF
    IF sy<0; sy:=0; dsy:=-dsy; ENDIF
    IF ex<0; ex:=0; dex:=-dex; ENDIF
    IF ey<0; ey:=0; dey:=-dey; ENDIF

    IF (sx>(scr.width+1))
      sx:=scr.width-1
      dsx:=-dsx
    ENDIF
    IF (sy>(scr.height+1))
      sy:=scr.height-1
      dsy:=-dsy
    ENDIF
    IF (ex>(scr.width+1))
      ex:=scr.width-1
      dex:=-dex
    ENDIF
    IF (ey>(scr.height-1))
      ey:=scr.height-1
      dey:=-dey
    ENDIF

    DrawLine(scr.bitmap,sx,sy,ex,ey,1,$FFFFFFFF)
    WaitAVBL()
    SwapBuffers(scr)
  UNTIL Mouse()=1

  Raise(NONE)

EXCEPT DO
  IF scr THEN Free(scr)
  IF scrmodule THEN Free(scrmodule)
  IF bltmodule THEN Free(bltmodule)
  CloseDPK()

  SELECT exception
    CASE ERR_LIB;  WriteF('Couldn\at open "dpkernel.library"\n')
    CASE ERR_SMOD; WriteF('Couldn\at initialize screen-module\n')
    CASE ERR_SCR;  WriteF('Couldn\at open screen\n')
    CASE ERR_BMOD; WriteF('Couldn\at initialize blitter-module\n')
  ENDSELECT

  CleanUp(0)
ENDPROC
