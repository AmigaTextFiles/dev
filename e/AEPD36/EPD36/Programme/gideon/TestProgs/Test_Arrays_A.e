/* -- -------------------------------------------------------------- -- *
 * -- Programm....: Test des Objektes `array2'                       -- *
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


#define LINEFEED WriteF('\n')


PROC main()
DEF ma_array2 : PTR TO array2                  -> Deklaration
DEF ma_lauf1,ma_lauf2,ma_temp,ma_check

  NEW ma_array2.arr_InitArray(10,10,ARR_BYTE)  -> Konstruktor
                                               -> 10 x 10 Felder a 1 Byte


  FOR ma_lauf1 := 0 TO 23     -> maximal erlaubt ist 9, aber die Methode
                              -> ist vor falschen Parametern geschützt
    FOR ma_lauf2 := 0 TO 9
    
      -> hier erhält jede Zelle das Produkt seiner Indices
      ma_array2.arr_SetCell(ma_lauf1,ma_lauf2,ma_lauf1 * ma_lauf2)

    ENDFOR
  ENDFOR

  LINEFEED

  WriteF(' x |  0  1  2  3  4  5  6  7  8  9\n')    
  WriteF('------------------------------------')  

  FOR ma_lauf1 := 0 TO 9
    WriteF('\n \d |',ma_lauf1)
    FOR ma_lauf2 := 0 TO 12     -> hier läuft die Schleife zu weit,
                                -> um die Funktion des 2. Funktionswertes
                                -> zu verdeutlichen
    
      -> die Zelle wird ausgelesen
      ma_temp,ma_check := ma_array2.arr_GetCell(ma_lauf1,ma_lauf2)

      IF ma_check = FALSE        -> Auslesen war erfolgreich
        WriteF('\d[3]',ma_temp)
      ENDIF

    ENDFOR
  ENDFOR

  LINEFEED
  LINEFEED
  
  END ma_array2    -> Destruktor (alles wird gelöscht)

ENDPROC

CHAR '$VER: Test_Arrays_A (array2) v2.8 (c) Copyrights by Daniel Kasmeroglu',0
