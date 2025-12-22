/* Name:      Double Buffering
** Author:    Paul Manias
** Copyright: DreamWorld Productions (c) 1996-1998.  Freely distributable.
**
** This just shows how to double buffer the screen.  You can also try out
** triple buffering just by changing the DBLBUFFER flag to TPLBUFFER in the
** Screen.
*/

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures'
MODULE 'gms/files/files','gms/screens','gms/system/register','gms/system/modules'
MODULE 'gms/input/joydata','gms/graphics/screens','gms/graphics/blitter'

PROC main()

  DEF picture:PTR TO picture, screen:PTR TO screen, joydata:PTR TO joydata
  DEF picfile:filename, scrmodule:PTR TO module

  picfile := [ ID_FILENAME, 'GMS:demos/data/PIC.Green' ]:filename

  IF dpkbase := OpenLibrary('GMS:libs/dpkernel.library',0)

    IF (scrmodule := Init([TAGS_MODULE,NIL,
        MODA_NUMBER,    MOD_SCREENS,
        MODA_TABLETYPE, JMP_AMIGAE,
        TAGEND], NIL))

      scrbase := scrmodule.modbase

      IF (picture := Load(picfile, ID_PICTURE))
         screen := Get(ID_SCREEN)
         CopyStructure(picture,screen)
         screen.attrib  := SCR_DBLBUFFER OR SCR_CENTRE

         IF (screen := Init(screen,NIL))
            Copy(picture.bitmap,screen.bitmap)

            IF (joydata := Init(Get(ID_JOYDATA),NIL))
               Show(screen)
               Query(joydata)

               REPEAT
                 WaitAVBL()
                 SwapBuffers(screen)
                 Query(joydata)
               UNTIL (joydata.buttons AND JD_LMB)

            Free(joydata)
            ENDIF
         Free(picture)
         ENDIF
      Free(screen)
      ENDIF
    Free(scrmodule)
    ENDIF
   CloseDPK()
   ENDIF
ENDPROC

