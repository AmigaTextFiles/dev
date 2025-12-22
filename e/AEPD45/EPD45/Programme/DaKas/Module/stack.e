OPT MODULE

/* -- ----------------------------------------------------------------- -- *
 * -- Es handelt sich hier lediglich um eine lineare dynamische Kette,  -- *
 * -- die immer am Endglied erweitert oder verkürzt wird. Der Stack     -- * 
 * -- gehört bekanntlich zum Typ LIFO (Last In, First Out). Würde man   -- *
 * -- die Veränderungen am Anfangsglied durchführen, wäre diese ein     -- *
 * -- Speicher vom Typ FIFO (First In, First Out). In einer solchen     -- *
 * -- (modifizierten) Kette werden übrigens Exec-Messages abgelegt.     -- *
 * --                                                                   -- *
 * -- Author: Daniel Kasmeroglu                                         -- *  
 * -- ----------------------------------------------------------------- -- */

EXPORT OBJECT stack PRIVATE  /* -- Definition eines Knotens. Der Knoten -- */
  next   : PTR TO stack      /* -- enthält einen Eintrag für den Zeiger -- */
  inhalt : LONG              /* -- auf den nächsten Knoten und einen    -- */
ENDOBJECT                    /* -- Eintrag um eine Information          -- */
                             /* -- aufzunehmen.                         -- */

EXPORT OBJECT fifo OF stack  /* -- Dieses Objekt bildet eine oben       -- */
ENDOBJECT                    /* -- angesprochene Abwandlung (FIFO). Im  -- */
                             /* -- Prinzip wird das ganze Objekt        -- */
                             /* -- übernommen. Die einzige Änderung     -- */
                             /* -- besteht in der neuen Methode         -- */
                             /* -- `sta_Pop()'.                         -- */

PROC sta_Push(wert) OF stack

/* -- Diese Methode fügt einen weiteren Knoten an die dynamische Liste  -- *
 * -- an. Dieser Knoten erhält den Wert des Parameters.                 -- */

DEF sta_stack : PTR TO stack

  sta_stack := self.next           -> Zeiger auf den nächsten Knoten,
                                   -> da "self" die Basis für den Stack
                                   -> bildet und keine Information enthält.

  IF sta_stack = NIL               -> Es gibt keinen weiteren Knoten

    NEW sta_stack                  -> Neuen Knoten erzeugen.

    self.next        := sta_stack  -> Der Vorgänger muß die Adresse des
                                   -> neuen Knotens kennen.

    sta_stack.next   := NIL        -> Der neue Knoten hat noch keinen Nachfolger
    sta_stack.inhalt := wert       -> Der neue Knoten erhält die Information `wert'

  ELSE

    sta_stack.sta_Push(wert)       -> Ansonsten wird versucht am Nachfolger
                                   -> einen neuen Knoten zu erzeugen, indem
                                   -> dieser rekursive Aufruf erfolgt.
  ENDIF

ENDPROC


PROC sta_Pop() OF stack

/* -- Diese Methode durchläuft die ganze Liste bis sie ans Ende   -- *
 * -- angekommen ist. Sie setzt den Zeiger (Komponente "next")    -- *
 * -- des vorletzten Knotens auf NIL, wodurch der letzte Knoten   -- *
 * -- aus der Liste entfernt wird. Die Information dieses Knotens -- *
 * -- wird gespeichert, da der Knoten anschließend gelöscht wird. -- *
 * -- Die gespeicherte Information wird als Funktionswert zurück- -- *
 * -- geliefert.                                                  -- */

DEF sta_n1 : PTR TO stack   -> Zeiger auf den vorletzten Knoten
DEF sta_n2 : PTR TO stack   -> Zeiger auf den letzten Knoten
DEF sta_wert                -> Behälter für die Information

  sta_n1   := self          
  sta_n2   := self.next

  IF self <> NIL              -> Der vorletzte Zeiger existiert.

    WHILE sta_n2.next <> NIL  -> Durchlaufen der Schleife, bis
      sta_n1 := sta_n2        -> der letzte Knoten erreicht wurde.
      sta_n2 := sta_n1.next
    ENDWHILE

    sta_n1.next := NIL        -> Der Zeiger des vorletzten Knotens wird gelöscht.
    sta_wert := sta_n2.inhalt -> Die Information wird gespeichert.
    END sta_n2                -> Der Knoten wird gelöscht.

  ELSE                        -> Wenn der vorletzte Zeiger nicht existiert,
    RETURN 0                  -> gibt es einen "Underflow".
  ENDIF

ENDPROC sta_wert


PROC sta_Pop() OF fifo        -> Anwendung von Polymorphismus B+)

/* -- Diese Methode bildet den Unterschied zwischen LIFO und FIFO. -- *
 * -- Sie setzt das Basisglied auf den zweiten Knoten (2.Knoten -> -- *
 * -- 1. Knoten). Das Resultat ist der Inhalt des alten 1.Knotens. -- */

DEF fif_ptr : PTR TO fifo
DEF fif_wert

  IF self.next = NIL THEN RETURN 0
  fif_ptr   := self.next
  self.next := fif_ptr.next
  fif_wert  := fif_ptr.inhalt
  END fif_ptr

ENDPROC fif_wert


PROC sta_Exist() OF stack IS self.next <> NIL
/* -- Diese Funktion liefert TRUE, wenn die Liste aufgelöst ist. -- */


PROC sta_Clear() OF stack

/* -- Diese Prozedur löscht den Stack, falls noch etwas auf ihm  -- *
 * -- enthalten sein sollte.                                     -- */

  WHILE self.sta_Exist()
    self.sta_Pop()
  ENDWHILE

ENDPROC


PROC sta_Read(num) OF stack

/* -- Diese Methode liest den Wert eines vorhanden Knotens, der die -- * 
 * -- num.te Position in der dynamischen Liste einnimmt. Dieser     -- *
 * -- Wert ist der Funktionswert. Der Zugriff funktioniert also wie -- * 
 * -- bei einer Reihung (ARRAY), wobei das erste Element den Index  -- *
 * -- 0 trägt. Ist der betreffende Knoten nicht vorhanden, wird     -- *
 * -- einfach der letzte Wert zurückgeliefert.                      -- */

DEF sta_ptr:PTR TO stack

  num := num + 1

  /* -- Index muß korrekt sein -- */
  IF num < 0 THEN RETURN 0

  /* -- Schleife um den Knoten zu finden -- */
  sta_ptr := self
  REPEAT
    num := num - 1
    sta_ptr := sta_ptr.next
  UNTIL Not(sta_ptr.sta_Exist()) OR (num = 0)

ENDPROC sta_ptr.inhalt  -> Funktionswert bzw. Inhalt des Knotens


PROC sta_Write(num,wert) OF stack

/* -- Diese Methode funktioniert wie `sta_Read()', wobei die Komponente -- *
 * -- `inhalt' des Knotens mit dem Parameter `wert' überschrieben wird. -- *
 * -- Mit dieser Methode sollte man vorsichtig umgehen, da man schnell  -- *
 * -- etwas wichtiges löschen kann.                                     -- */

DEF sta_ptr:PTR TO stack

  num := num + 1

  /* -- Index muß korrekt sein -- */
  IF num < 0 THEN RETURN

  /* -- Vorgehensweise wie oben -- */
  sta_ptr := self
  REPEAT
    num := num - 1
    sta_ptr := sta_ptr.next
  UNTIL Not(sta_ptr.sta_Exist()) OR (num = 0)

  /* -- neuer Wert wird hineingeschrieben -- */
  sta_ptr.inhalt := wert

ENDPROC


PROC sta_Array(num) OF stack

/* -- Diese Methode legt ein dynamisches initialisiertes Array an. -- */
DEF sta_lauf

  FOR sta_lauf := 1 TO num DO self.sta_Push(0)

ENDPROC

PROC sta_Delete(num) OF stack

/* -- Diese Methode kann das num.te Element aus der Kette löschen -- */

DEF sta_old:PTR TO stack 
DEF sta_ptr:PTR TO stack

  num := num

  /* -- Index muß korrekt sein -- */
  IF num < 0 THEN RETURN 0

  /* -- Schleife um den Knoten zu finden -- */
  sta_ptr := self
  REPEAT
    num := num - 1
    sta_ptr := sta_ptr.next
  UNTIL Not(sta_ptr.sta_Exist()) OR (num = 0)
  sta_old := sta_ptr.next
  sta_ptr.next := sta_old.next
  END sta_old

ENDPROC

CHAR '$VER: Stack.M (E-Modul) v1.1 © Copyrights by Daniel Kasmeroglu',0
