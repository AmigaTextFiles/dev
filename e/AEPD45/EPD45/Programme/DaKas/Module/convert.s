
 XDEF con_Int2Bin__ii

con_Int2Bin__ii:

  MOVE.L                4(SP),D0            ; Argument Zahl
  MOVEA.L               8(SP),A0            ; Argument String

  MOVEQ.L                 #31,D1            ; maximaler Index 31

con_label:
  BSR.S               con_check             ; Unterroutine anspringen
  TST.B                      D1             ; wenn D1 <> 0
  DBEQ                    D1,con_label      ; dann dekrementier D1 und Sprung
  MOVE.B                  #0,(A0)           ; Abschluﬂ-Byte schreiben

  RTS                                       ; Ende der Routine

con_check:
;-- D1 : Index des Bits
;-- A0 : Zeiger auf ein freies Byte

  BTST                    D1,D0             ; Bit testen
  BEQ.S                con_next             ; wenn Bit gesetzt,
  MOVE.B                #"1",(A0)+          ; dann schreibe Zeichen "1"
  RTS                                       ; Ende der Routine

con_next:
  MOVE.B                 #48,(A0)+          ; sonst schreibe Zeichen "0"
  RTS                                       ; Ende der Routine

glolab: DC.B     '$VER: Convert.M (E-Modul) v1.0 © Copyrights by Daniel Kasmeroglu'