/* -- -------------------------------------------------------------- -- *
 * -- Programm....: Test des Objektes `booleans'                     -- *
 * -- Autor.......: Daniel Kasmeroglu (Gideon)                       -- *
 * -- Version.....: 2.8                                              -- *
 * -- -------------------------------------------------------------- -- */

MODULE 'nukes/arrays'   -> diese Modul beinhaltet mein Objekt

PROC main()
DEF ma_booleans : PTR TO booleans
DEF ma_lauf,ma_index,ma_check

  NEW ma_booleans.arr_InitArray(256)  -> Konstruktor

  FOR ma_lauf := 0 TO 300             -> hier steckt mal wieder ein Würmchen drin
    
    ma_booleans.arr_SetCell(ma_lauf,FALSE)

  ENDFOR


  -> einige Zellen verändern
  FOR ma_lauf := 1 TO 14
 
    ma_index := Rnd(256)
    WriteF('Element Nr.\d ist TRUE\n',ma_index)

    ma_booleans.arr_SetCell(ma_index,TRUE)

  ENDFOR


  FOR ma_lauf := 0 TO 265

    -> Den Zellinhalt lesen
    ma_index,ma_check := ma_booleans.arr_GetCell(ma_lauf)

    IF ma_check = FALSE              -> Auslesen war erfolgreich
      WriteF('Element Nr.\d[4] = ',ma_lauf)
      IF ma_index = TRUE 
        WriteF('TRUE\n') 
      ELSE 
        WriteF('FALSE\n')
      ENDIF
    ENDIF

  ENDFOR

  END ma_booleans                     -> Destruktor

ENDPROC

CHAR '$VER: Test_Arrays_C (booleans) v2.8 (c) Copyrights by Daniel Kasmeroglu',0
