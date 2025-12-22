/* Name:      Scroll Screen
** Author:    Paul Manias
** Copyright: DreamWorld Productions (c) 1996-1998.  Freely distributable.
**
** This demo allows you to legally scroll up to 50 screens in either
** direction by setting the HBUFFER flag.  Normally we would blit blocks down
** the left and right hand side to give an impression of heaps of screens -
** see the MapEditor for this.
**
*/

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures'
MODULE 'gms/files/files','gms/screens','gms/system/register','gms/system/modules'
MODULE 'gms/input/joydata','gms/graphics/screens','gms/graphics/blitter'

PROC main()
  DEF screen    = NIL:PTR TO screen,
      joy       = NIL:PTR TO joydata,
      pic       = NIL:PTR TO picture,
      scrmodule = NIL:PTR TO module,
      picfile:filename

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
           screen.attrib  := SCR_HSCROLL OR SCR_SBUFFER
           screen.bitmap.width := screen.width+16

           IF (screen := Init(screen,NIL))
              Copy(pic.bitmap,screen.bitmap)
              IF (joy := Init(Get(ID_JOYDATA),NIL))
                 Show(screen)
                 REPEAT
                    Query(joy)
                    SetBmpOffsets(screen, screen.bmpxoffset+joy.xchange, screen.bmpyoffset)
                    WaitVBL()
                 UNTIL !(joy.buttons AND JD_LMB)
              Free(joy)
              ENDIF
           ENDIF
        Free(screen)
        Free(pic)
        ENDIF
     Free(scrmodule)
     ENDIF
  CloseDPK()
  ENDIF
ENDPROC

