    BRA     L1
a: dc.l 0
b: dc.l 0
c: dc.l 0
INTEGER: dc.l 0
_dos:       DC.L   0
_dosname:   DC.B   'dos.library',0
_format:    DC.B   '%ld',10,0
            DS.L   0
_print:     DC.L   0
L1:
    LEA      _dosname,A1
    MOVE.L   #37,D0
    MOVE.L   $4,A6
    JSR      -552(A6)
    TST.L    D0
    BNE.S    ok_
    RTS
ok_:
    MOVE.L   D0,_dos
    MOVE.L  #1,D0
    MOVE.L  D0,a
    MOVE.L  #0,D0
    MOVE.L  D0,b
    MOVE.L  #46,D0
    MOVE.L  D0,c
L2:
    MOVE.L  c,D0
    TST.L   D0
    BLE     L3
    MOVE.L  a,D0
    LEA     _format,A0
    MOVE.L  A0,D1
    LEA     _print,A0
    MOVE.L  A0,D2
    MOVE.L  D0,(A0)
    MOVE.L  _dos,A6
    JSR     -954(A6)
    MOVE.L  a,D0
    MOVE.L  D0,D1
    MOVE.L  b,D0
    ADD.L   D1,D0
    MOVE.L  D0,a
    MOVE.L  a,D0
    MOVE.L  D0,D1
    MOVE.L  b,D0
    NEG.L   D0
    ADD.L   D1,D0
    MOVE.L  D0,b
    MOVE.L  c,D0
    MOVE.L  D0,D1
    MOVE.L  #1,D0
    NEG.L   D0
    ADD.L   D1,D0
    MOVE.L  D0,c
    BRA     L2
L3:
    MOVE.L   _dos,A1
    MOVE.L   $4,A6
    JSR      -414(A6)
    MOVE.L   #0,D0
    RTS
    END
