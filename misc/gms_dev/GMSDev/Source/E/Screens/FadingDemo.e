/* Name:      Fade Demo
** Author:    Paul Manias
** Copyright: DreamWorld Productions (c) 1996-1998.  Freely distributable.
*/

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures'
MODULE 'gms/files/files','gms/screens','gms/system/register'
MODULE 'gms/system/modules','gms/input/joydata','gms/graphics/screens'
MODULE 'gms/graphics/blitter'

PROC main()
 DEF fstate    = NIL :LONG,
     screen    = NIL :PTR TO screen,
     pic       = NIL :PTR TO picture,
     scrmodule = NIL :PTR TO module,
     picfile   :filename

 picfile := [ ID_FILENAME, 'GMS:demos/data/PIC.Green']:filename

 IF dpkbase := OpenLibrary('GMS:libs/dpkernel.library',0)
  IF (scrmodule := Init([TAGS_MODULE,NIL,
      MODA_NUMBER,    MOD_SCREENS,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))

   scrbase := scrmodule.modbase

   IF (pic := Load(picfile, ID_PICTURE))
      screen := Get(ID_SCREEN)
      CopyStructure(pic,screen)
      screen.bitmap.palette := NIL
      screen.bitmap.flags   := BMF_BLANKPALETTE

      IF (screen := Init(screen,NIL))
         Copy(pic.bitmap,screen.bitmap)
         Show(screen);

         REPEAT
           WaitAVBL()
           fstate := ColourToPalette(screen,fstate,2,0,screen.bitmap.amtcolours,pic.bitmap.palette+8,$000000);
         UNTIL (fstate != NIL)

         REPEAT
           WaitAVBL()
           fstate := PaletteToColour(screen,fstate,2,0,screen.bitmap.amtcolours,pic.bitmap.palette+8,$a5f343)
         UNTIL (fstate != NIL)

         REPEAT
           WaitAVBL()
           fstate := ColourMorph(screen,fstate,2,0,screen.bitmap.amtcolours,$a5f343,$000000);
         UNTIL (fstate != NIL)

      Free(screen)
      ENDIF
   Free(pic)
   ENDIF
   Free(scrmodule)
  ENDIF
 CloseDPK()
 ENDIF
ENDPROC

