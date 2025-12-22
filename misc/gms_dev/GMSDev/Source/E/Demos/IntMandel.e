/* This is a Mandel generator from the Amiga E archive (which was converted
** from Oberon) and is now converted to work with GMS.
*/

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures'
MODULE 'gms/files/files','gms/screens','gms/system/register','gms/system/modules'
MODULE 'gms/input/joydata','gms/graphics/screens','gms/graphics/blitter'
MODULE 'gms/blitter'

CONST ITERDEPTH = 50   /* This constant defines the detail of the mandel */

PROC main()
 DEF screen=NIL:PTR TO screen, zr, zi, ar, ai, dr, di, sr, si, st, x, y, i,
     joy       = NIL:PTR TO joydata,
     scrmodule = NIL:PTR TO module,
     bltmodule = NIL:PTR TO module

 IF dpkbase := OpenLibrary('GMS:libs/dpkernel.library',0)
  IF (scrmodule := Init([TAGS_MODULE,NIL,
      MODA_NUMBER,    MOD_SCREENS,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))
      scrbase := scrmodule.modbase

  IF (bltmodule := Init([TAGS_MODULE,NIL,
      MODA_NUMBER,    MOD_BLITTER,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))
      bltbase := bltmodule.modbase

  IF (screen := Init([TAGS_SCREEN,NIL,
       GSA_Width,      640,
       GSA_Height,     512,
         GSA_BitmapTags, NIL,
         BMA_AmtColours, 16,
         TAGEND,         NIL,
       GSA_ScrMode,    SM_HIRES OR SM_LACED,
       TAGEND],NIL))

   x := 256/screen.bitmap.amtcolours*2
   FOR i:=0 TO screen.bitmap.amtcolours-1 DO UpdateColour(screen,i,(Shl(i*x,8) OR (i*x)))

   sr := $400000/screen.width   -> shrink horiz
   si := $300000/screen.height  -> shrink vert
   st := $140000*-2             -> move side
   zi := $160000                -> move up

   IF (joy := Init(Get(ID_JOYDATA),NIL))

    Show(screen)

    FOR y:=screen.height-1 TO 0 STEP -1
      zi := zi-si
      zr := st

      FOR x:=0 TO screen.width-1

        Query(joy)
        IF (joy.buttons AND JD_LMB) THEN JUMP end

        i := 0
        ar := zr
        ai := zi
        REPEAT
          dr := Shr(ar,10)
          di := Shr(ai,10)
          ai := dr*2*di+zi
          dr := dr*dr
          di := di*di
          ar := dr-di+zr
          i++
        UNTIL (i>ITERDEPTH) OR (dr+di>$400000)
        DrawPixel(screen.bitmap, x, y, Mod(i, screen.bitmap.amtcolours))
        zr:=zr+sr
      ENDFOR

    ENDFOR

    REPEAT
      WaitAVBL()
      Query(joy)
    UNTIL (joy.buttons AND JD_LMB)

end:
   ENDIF
  ENDIF
  ENDIF
  ENDIF
 Free(joy)
 Free(screen)        
 Free(scrmodule)
 Free(bltmodule)
 CloseDPK()
 ENDIF
ENDPROC

