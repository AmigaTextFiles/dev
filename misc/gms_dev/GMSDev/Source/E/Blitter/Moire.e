/* GMS-example
 * Name: Moire.e
 * Type: Blitter example (converted from Moire.c)
 * Version: 1.0
 * Author: G. W. Thomassen (0000272e@lts.mil.no)
 */

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures','gms/files/files',
       'gms/screens','gms/system/register','gms/system/modules','gms/input/joydata',
       'gms/graphics/screens','gms/blitter','gms/graphics/blitter'

ENUM NONE,ERR_LIB,ERR_SMOD,ERR_BMOD,ERR_JOY,ERR_SCR

DEF scr:PTR TO screen,
    joy:PTR TO joydata,
    scrmod:PTR TO module,
    bltmod:PTR TO module

PROC main() HANDLE
  init_all()

  Show(scr)
  moire()

  Raise(NONE)
EXCEPT DO
  IF joy THEN Free(joy)
  IF scr THEN Free(scr)
  IF bltmod THEN Free(bltmod)
  IF scrmod THEN Free(scrmod)
  CloseDPK()
  SELECT exception
    CASE ERR_SCR; WriteF('Error opening screen\n')
  ENDSELECT
  CleanUp(0)
ENDPROC

PROC init_all()
  IF (dpkbase:=OpenLibrary('GMS:libs/dpkernel.library',0))=NIL THEN Raise(ERR_LIB)

  IF (scrmod:=Init([TAGS_MODULE,NIL,
      MODA_NUMBER,    MOD_SCREENS,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_SMOD)
      scrbase:=scrmod.modbase

  IF (bltmod:=Init([TAGS_MODULE,NIL,
      MODA_NUMBER,    MOD_BLITTER,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_BMOD)
      bltbase := bltmod.modbase

  IF (scr:=Init([TAGS_SCREEN, NIL,
         GSA_BitmapTags, NIL,
         BMA_Palette, [PALETTE_ARRAY,4,$000000,$808080,$A0A0A0,$F0F0F0],
         TAGEND, NIL,
       TAGEND],NIL))=NIL THEN Raise(ERR_SCR)

   IF (joy:=Init(Get(ID_JOYDATA),NIL))=NIL THEN Raise(ERR_JOY)
ENDPROC

PROC moire()
  DEF xm,ym,i,exit=FALSE

  REPEAT
    Clear(scr.bitmap)
    xm:=FastRandom(scr.width)
    ym:=FastRandom(scr.height)

    FOR i:=0 TO scr.height
      Query(joy)
      IF (joy.buttons AND JD_LMB); exit:=TRUE; JUMP efor0; ENDIF

      DrawLine(scr.bitmap,xm,ym,0,i,Mod(i,3),$FFFFFFFF)
      DrawLine(scr.bitmap,xm,ym,scr.width,i,Mod(i,3),$FFFFFFFF)
    ENDFOR

    FOR i:=0 TO scr.width
      Query(joy)
      IF (joy.buttons AND JD_LMB); exit:=TRUE; JUMP efor0; ENDIF

      DrawLine(scr.bitmap,xm,ym,i,0,Mod(i,3),$FFFFFFFF)
      DrawLine(scr.bitmap,xm,ym,i,scr.height,Mod(i,3),$FFFFFFFF)
    ENDFOR
    WaitTime(100)

    efor0:
  UNTIL (joy.buttons AND JD_LMB)
ENDPROC

