/* Name:      Reposition
** Author:    Paul Manias
** Copyright: DreamWorld Productions (c) 1996-1998.  Freely distributable.
**
** This example has a mobile 320x256 screen, which is attached to the
** mouse.  To exit the example, press LMB. 
*/

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures'
MODULE 'gms/files/files','gms/screens','gms/system/register','gms/system/modules'
MODULE 'gms/input/joydata','gms/graphics/screens','gms/graphics/blitter'

PROC main()
   DEF screen    :PTR TO screen,
       joy       :PTR TO joydata,
       pic       :PTR TO picture,
       scrmodule :PTR TO module,
       picfile   :filename

   picfile := [ ID_FILENAME, 'GMS:demos/data/PIC.Green']:filename

   IF dpkbase := OpenLibrary('GMS:libs/dpkernel.library',0)
    IF (scrmodule := Init([TAGS_MODULE,NIL,
       MODA_NUMBER,    MOD_SCREENS,
       MODA_TABLETYPE, JMP_AMIGAE,
       TAGEND], NIL))

      scrbase := scrmodule.modbase

      IF (pic := Load(picfile,ID_PICTURE))
         screen := Get(ID_SCREEN)
         CopyStructure(pic,screen)
         screen.attrib  := SCR_CENTRE

         IF (screen := Init(screen,NIL))
            Copy(pic.bitmap,screen.bitmap)
            IF (joy := Init(Get(ID_JOYDATA),NIL))
               Show(screen)
               REPEAT
                 Query(joy)
                 WaitAVBL()
                 SetScrOffsets(screen, screen.xoffset+joy.xchange, screen.yoffset+joy.ychange)
               UNTIL !(joy.buttons AND JD_LMB)
            Free(joy)
            ENDIF
         Free(screen)
         ENDIF
      Free(pic)
      ENDIF
    Free(scrmodule)
    ENDIF
   CloseDPK()
   ENDIF
ENDPROC

