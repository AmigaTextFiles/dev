/* HiRes Picture Display
** ---------------------
** Opens a screen of 640 pixels width in HIRES mode.  You can even try
** SuperHiRes (SHIRES) if you change the appropriate flag in the Screen
** structure.
*/

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures'
MODULE 'gms/files/files','gms/screens','gms/system/register','gms/system/modules'
MODULE 'gms/input/joydata','gms/graphics/screens','gms/graphics/blitter'

PROC main()
  DEF screen    :PTR TO screen,
      pic       :PTR TO picture,
      picfile   :filename,
      scrmodule :PTR TO module,
      joydata   :PTR TO joydata

  picfile := [ ID_FILENAME, 'GMS:demos/data/PIC.Pic640x256']:filename

  IF dpkbase := OpenLibrary('GMS:libs/dpkernel.library',0)
     IF (scrmodule := Init([TAGS_MODULE,NIL,
         MODA_NUMBER,    MOD_SCREENS,
         MODA_TABLETYPE, JMP_AMIGAE,
         TAGEND], NIL))

        scrbase := scrmodule.modbase

        IF (pic := Load(picfile, ID_PICTURE))
           screen := Get(ID_SCREEN)
           CopyStructure(pic,screen)
           screen.width   := 640
           screen.height  := 256
           screen.scrmode := SM_HIRES OR SM_LACED

           IF (joydata := Init(Get(ID_JOYDATA),NIL))
              IF (Init(screen,NIL))
                 Copy(pic.bitmap,screen.bitmap)
                 Show(screen)
                 Query(joydata)

                 REPEAT
                   Query(joydata)
                   WaitAVBL()
                 UNTIL (joydata.buttons AND JD_LMB)

              Free(screen)
              ENDIF
           Free(joydata)
           ENDIF
        Free(pic)
        ENDIF
     Free(scrmodule)
     ENDIF
  CloseDPK()
  ENDIF

ENDPROC

