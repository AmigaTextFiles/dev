/* -- -------------------------------------------------------------- -- * 
 * -- Programm..: Testprogramm für Colora.M v2.0                     -- *
 * -- Autor.....: Daniel Kasmeroglu (Gideon)                         -- *
 * -- Version...: 2.0                                                -- *
 * -- -------------------------------------------------------------- -- */

MODULE 'nukes/colora',      -> zu testendes Modul
       'intuition/screens'

PROC main()
DEF ma_screen : PTR TO screen
DEF ma_colora : PTR TO colora      -> Das Objekt der Begierde ;-)))
DEF ma_handle,ma_old
 
  ma_screen := LockPubScreen(NIL)  -> irgendein Bildschirm

  -> Falls kein Screen da ist
  IF ma_screen = NIL
    WriteF('Sorry, aber es konnte kein Screen "festgehalten" werden !\n\n')
    RETURN 5
  ENDIF

  -> kleines Ausgabe-Fenster, dmait der User bescheid weiß  
  ma_handle := Open('CON:50/20/500/150/Ausgabe',NEWFILE)
 
  -> hoppla, keine Ausgabe-Fenster zu öffnen
  IF ma_handle = NIL 
    WriteF('Sorry, es konnte kein AmigaDOS-Fenster geöffnet werden !\n\n')
    UnlockPubScreen(NIL,ma_screen)
    RETURN 10
  ENDIF

  -> Erzeugung des Objekts
  NEW ma_colora.col_InitColora(ma_screen)  -> Konstruktor

  ma_old    := SetStdOut(ma_handle)

  WriteF('Wenn Sie die Maus-Taste drücken,\nwerden neue Farben gesetzt !\n\n') 

  wmouse()

  ma_colora.col_SetCols({rot},{gruen},{blau})

  WriteF('In 5 Sekunden,\nwerden die Farben rotieren !\n\n')

  Delay(250)

  ma_colora.col_Shift(10,COL_ZYKLUS,2)

  WriteF('In 5 Sekunden,\nkommen die alten Farben wieder !\n\n')

  Delay(250)

  ma_colora.col_Restore()

  END ma_colora                            -> Destruktor

  WriteF('Wenn Sie die Maus-Taste drücken,\nwird das Programm beendet !\n')

  wmouse()

  SetStdOut(ma_old)

  Close(ma_handle)

  UnlockPubScreen(NIL,ma_screen)

ENDPROC


PROC rot(i)   IS i
PROC gruen(i) IS IF i > 1 THEN 4-i ELSE i
PROC blau(i)  IS $A

PROC wmouse() 
  WHILE Mouse() <> 1 DO Delay(0)
ENDPROC

CHAR '$VER: Test_Colora v2.0 (c) Copyrights by Daniel Kasmeroglu',0
