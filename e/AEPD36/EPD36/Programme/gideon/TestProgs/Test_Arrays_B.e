/* -- -------------------------------------------------------------- -- *
 * -- Programm....: Test des Objektes `array3'                       -- *
 * -- Autor.......: Daniel Kasmeroglu (Gideon)                       -- *
 * -- Version.....: 2.8                                              -- *
 * -- -------------------------------------------------------------- -- */

/* -- -------------------------------------------------------------- -- *
 * -- WICHTIG: In diesem Testprogramm befinden sich einige Beispiele -- *
 * --          für fehlerhafte Benutzung. Dabei ist zu beachten, daß -- *
 * --          diese Methoden vor Falschangaben geschützt sind.      -- *
 * --          Wer sich beim Programmieren sicher fühlt, kann die    -- *
 * --          Sicherheitsüberprüfung aus dem Quellcode herausnehmen -- *
 * --          um die Methoden etwas zu beschleunigen (minimal).     -- *
 * --          Nach Möglichkeit sollte man solche Mechanismen immer  -- *
 * --          im Quellcode lassen, da es den Programmierer davor    -- *
 * --          bewahrt seine Applikationen nach unnötigen Fehlern    -- *
 * --          zu durchforsten.                                      -- */

OPT PREPROCESS


MODULE 'nukes/arrays'   -> diese Modul beinhaltet mein Objekt


#define LINEFEED  WriteF('\n')
#define WAITMOUSE WHILE Mouse() <> 1 DO Delay(1)
#define NACHRICHT WriteF('Linke Maus-Taste druecken !\n\n')


DEF glo_array3 : PTR TO array3 -> Deklaration

PROC main()
DEF ma_x,ma_y,ma_z


  -> 10 x 10 x 10 Felder a 2 Bytes
  NEW glo_array3.arr_InitArray(10,10,10,ARR_INT)  -> Konstruktor


  FOR ma_x := 0 TO 23         -> maximal erlaubt ist 9, aber die Methode
                              -> ist vor falschen Parametern geschützt
    FOR ma_y := 0 TO 9
      FOR ma_z := 0 TO 9

      -> hier erhält jede Zelle das Produkt seiner Indices
      glo_array3.arr_SetCell(ma_x,ma_y,ma_z,ma_x * ma_y * ma_z)

      ENDFOR
    ENDFOR
  ENDFOR


  FOR ma_z := 0 TO 9

    tabelle(ma_z)
    LINEFEED
    NACHRICHT
    WAITMOUSE
  
  ENDFOR

  LINEFEED
  LINEFEED
  
  END glo_array3    -> Destruktor (alles wird gelöscht)

ENDPROC


PROC tabelle(z_index)
DEF tab_x,tab_y,tab_temp,tab_check

  WriteF('Alle Werte wurden zusätzlich mit \d multipliziert !\n\n',z_index)
  WriteF(' x |   0   1   2   3   4   5   6   7   8   9\n')    
  WriteF('----------------------------------------------')  

  FOR tab_x := 0 TO 9

    WriteF('\n \d |',tab_x)
    FOR tab_y := 0 TO 14
 
      -> die Zelle wird ausgelesen
      tab_temp,tab_check := glo_array3.arr_GetCell(tab_x,tab_y,z_index)

      IF tab_check = FALSE        -> Auslesen war erfolgreich
        WriteF('\d[4]',tab_temp)
      ENDIF

    ENDFOR
  ENDFOR

  LINEFEED

ENDPROC

CHAR '$VER: Test_Arrays_B (array3) v2.8 (c) Copyrights by Daniel Kasmeroglu',0
