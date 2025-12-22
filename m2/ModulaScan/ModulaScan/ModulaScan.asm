; GoldED Scanner fuer MODULA DEFINITION MODULES
; es werden PROCEDURE, CONST, TYPE und VAR erkannt.
; Dafuer muss aber auch vor jedem Objekt das entsprechende Schlüsselwort stehen.

        movem.l a1-a2,-(SP)
        moveq.l #0,d0
        movea.l (a0),a1
        cmpi.b  #"P",(a1)         ; Proceduren suchen
        beq     pro
        cmpi.b  #"T",(a1)         ; nein, dann Typen suchen
        beq     typ
        cmpi.b  #"C",(a1)         ; nein, dann Konstanten suchen
        beq     con
        cmpi.b  #"V",(a1)         ; nein, dann Variablen suchen
        bne     ende
        
        lea     varstr,a2         ; Variablen suchen
varl    cmpi.b  #0,(a2)
        beq     gefun             ; gefunden
        cmpm.b  (a2)+,(a1)+
        bne     ende              ; nicht gefunden
        bra     varl

pro     lea     prostr,a2         ; Proceduren suchen
prol    cmpi.b  #0,(a2)
        beq     gefun             ; gefunden
        cmpm.b  (a2)+,(a1)+
        bne     ende              ; nicht gefunden
        bra     prol

typ     lea     typstr,a2         ; Typen suchen
typl    cmpi.b  #0,(a2)
        beq     gefun             ; gefunden
        cmpm.b  (a2)+,(a1)+
        bne     ende              ; nicht gefunden
        bra     typl

con     lea     constr,a2         ; Konstanten suchen
conl    cmpi.b  #0,(a2)
        beq     gefun             ; gefunden
        cmpm.b  (a2)+,(a1)+
        bne     ende              ; nicht gefunden
        bra     conl

gefun   cmpi.b  #" ",(a1)+
        beq     gefun
        suba.l  #1,a1
        move.l  a1,(a0)           ; schon mal den Namen merken
loop    cmpi.b  #" ",(a1)         ; Länge berechnen
        beq     ende
        cmpi.b  #"(",(a1)
        beq     ende
        cmpi.b  #";",(a1)
        beq     ende
        cmpi.b  #":",(a1)
        beq     ende
        cmpi.b  #",",(a1)
        beq     ende
        cmpi.b  #"=",(a1)+
        beq     ende
        addq.l  #1,d0
        bra loop

ende    movem.l (SP)+,a1-a2
        rts

prostr  dc.b    'PROCEDURE',0
constr  dc.b    'CONST',0
varstr  dc.b    'VAR',0
typstr  dc.b    'TYPE',0

