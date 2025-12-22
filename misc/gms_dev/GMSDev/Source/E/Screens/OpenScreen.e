/* GMS-example
 * Name:    OpenScreen.e
 * Type:    Example on screen and blitter module
 * Version: 1.1
 * Author:  G. W. Thomassen (0000272e@lts.mil.no)
 */

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures',
       'gms/screens','gms/system/register','gms/system/modules','gms/graphics/pictures',
       'gms/graphics/screens','gms/graphics/blitter','gms/blitter'

ENUM NONE,ERR_LIB,ERR_SCR,ERR_SMOD,ERR_BMOD

PROC main() HANDLE -> Better use exceptions!
  DEF scr=NIL:PTR TO screen,
      scrmodule=NIL:PTR TO module,
      bltmodule=NIL:PTR TO module,
      fstate=NIL:LONG,
      ms=FALSE

  -> Open the library
  IF (dpkbase:=OpenLibrary('GMS:libs/dpkernel.library',0))=NIL THEN Raise(ERR_LIB)

  -> Initialize the use of the blitter-module
  IF (bltmodule:=Init([TAGS_MODULE,NIL,     ->blitter-module
      MODA_NUMBER,    MOD_BLITTER,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_BMOD)
      bltbase := bltmodule.modbase

  -> Initialize the use of the screen-module
  IF (scrmodule:=Init([TAGS_MODULE,NIL,
      MODA_NUMBER,    MOD_SCREENS,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_SMOD)

    scrbase:=scrmodule.modbase


  -> Set up a screen..
  IF (scr := Init([TAGS_SCREEN,NIL,
      GSA_Attrib,  SCR_CENTRE,
      GSA_ScrMode, SM_HIRES OR SM_LACED,
      GSA_Width,   640,
      GSA_Height,  512,
        GSA_BitmapTags, NIL,
        BMA_Planes, 3,
        BMA_Palette, [PALETTE_ARRAY,6,$000000,$ffffff,$ffff00,$ff0000,$ff00ff,$0000ff],
        TAGEND, NIL,
      TAGEND], NIL))=NIL THEN Raise(ERR_SCR)

  Show(scr)     -> Open the screen!

  -> Main loop!
  LOOP
    WaitAVBL() -> Wait one vertical blank

    -> Do something stupid (only to use blitter-module)
    DrawLine(scr.bitmap,Rnd(scr.width),Rnd(scr.height),Rnd(scr.width),Rnd(scr.width),Rnd(4)+1,-1)

    -> Fade to white
    IF ms=TRUE
      fstate:=PaletteToColour(scr,fstate,1,0,scr.bitmap.amtcolours,scr.bitmap.palette+8,$ffffff)
      WaitAVBL()   -> Slow down the fade even more
      IF fstate != NIL THEN JUMP exit0  -> Check if $ffffff is reached, and exit the loop
    ELSEIF Mouse()=1
      ms:=TRUE
    ENDIF
  ENDLOOP
  exit0:

  ->Quit with no error..
  Raise(NONE)
EXCEPT DO
  IF scr THEN Free(scr)
  IF scrmodule THEN Free(scrmodule)
  IF bltmodule THEN Free(bltmodule)
  CloseDPK()
  SELECT exception
  CASE ERR_LIB; WriteF('Couldn\at open "dpkernel.library"\n')
  CASE ERR_SMOD; WriteF('Couldn\at initialize screen-module\n')
  CASE ERR_SCR; WriteF('Couldn\at open screen\n')
  CASE ERR_BMOD; WriteF('Couldn\at initialize blitter-module\n')
  ENDSELECT
  CleanUp(0)
ENDPROC
