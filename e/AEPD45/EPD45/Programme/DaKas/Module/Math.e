OPT MODULE
OPT EXPORT

PROC mat_GGT(ggt_a,ggt_b)

/* -- Achtung: Bei dieser Funktion spielt die Reihenfolge der Parameter -- *
 * --          keine Rolle, da sie "automatisch" geordnet wird.         -- *
 * --          Außerdem wird nicht getestet, ob einer der beiden        -- *
 * --          Parameter gleich null ist. In diesem Fall gibt es keinen -- *
 * --          `Größten Gemeinsamen Teiler'.                            -- */

  MOVE.L           ggt_a,D1
  MOVE.L           ggt_b,D0

ggt_label:
  DIVU                D0,D1  -> Division durchführen.
  SWAP                   D1  -> Rest steht in den oberen 16 Bits, deshalb Worte vertauschen.
  AND.L           #$FFFF,D1  -> Das Ergebnis der Division steht in den oberen 16 Bits,
                             -> weshalb diese Bits gelöscht werden müssen (ausmaskieren).
  TST.W                  D1  -> Falls Rest = 0,
  BEQ.S            ggt_ende  -> dann steht Ergebnis in D0
  EXG.L               D0,D1  -> sonst Dividend := Divisor und Divisor := Rest
  BRA.S           ggt_label  -> nochmal starten

ggt_ende:
ENDPROC D0


PROC mat_EMod(emo_a,emo_b)
/* -- Achtung: Diese Funktion funktioniert wie sein E-Äquivalent,  -- *
 * --          wobei meine Version sogar langsamer ist. Dafür kann -- *
 * --          man aber einen Divisions-Operanden benutzen,dessen  -- *
 * --          Größe nicht auf ein Wort begrenzt ist. Ferner setzt -- *
 * --          sie voraus, daß für die Parameter folgenden         -- *
 * --          Bedingung gilt:    emo_a >= emo_b.                  -- */

/* -- Die Funktion `mat_Mod()'  habe ich nicht kommentiert, da sie -- *
 * -- genauso aufgebaut ist, wie `mat_EMod()' .                    -- *
 * -- Der einzige Unterschied besteht in der Tatsache, daß         -- *
 * -- unbenötigte Befehle herausgenommen wurden.                   -- */

/* -- Arbeitsprinzip: Vom Dividenden (emo_a) wird der Divisor      -- *
 * --                 (emo_b) solange subtrahiert, bis das         -- *
 * --                 Ergebnis kleiner oder gleich null ist.       -- *
 * --                 Ist das Ergebnis kleiner als null, wurde     -- *
 * --                 Subtraktion zu oft durchgeführt. Die Anzahl  -- *
 * --                 der Subtraktionen entspricht der Division.   -- */


    MOVE.L         emo_a,D0  -> D0 := Dividend
    MOVEQ             #0,D1  -> D1 := Zähler für die Division := 0

emo_back:
    ADDQ              #1,D1  -> Zähler D1 um eins erhöhen.
    SUB.L          emo_b,D0  -> Dazugehörige Subtraktion durchführen.
    BPL.S          emo_back  -> Falls das Ergebnis größer als null ist,
                             -> dann nochmal in die Schleife.
    BEQ.S          emo_ende  -> Falls Ergebnis = 0, dann Ende
    SUBQ.L            #1,D1  -> sonst Zähler erniedrigen und Subtraktion
    ADD.L          emo_b,D0  -> rückgängig machen.

emo_ende:
    MOVE.L            D0,emo_a
    MOVE.L            D1,emo_b

ENDPROC emo_a,emo_b


PROC mat_Mod(mod_a,mod_b)
/* -- Achtung: Diese Funktion kann auch mit 32-Bit-Operanden rechnen, -- *
 * --          wobei das Ergebnis der Division NICHT ermittelt wird.  -- */

    MOVE.L         mod_a,D0

mod_back:
    SUB.L          mod_b,D0
    BPL.S          mod_back
    BEQ.S          mod_ende
    ADD.L          mod_b,D0
mod_ende:

ENDPROC D0

CHAR '$VER: Math.M (E-Modul) v1.0 © Copyrights by Daniel Kasmeroglu'