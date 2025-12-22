MODULE 'intuition/intuition',
       'intuition/screens'

PMODULE 'PMODULES:mousePointer'

PROC main () HANDLE
  DEF myWin           = NIL,
      busyPointerData = NIL : PTR TO INT,
      busyPointer     = NIL
  IF myWin := OpenW (20, 20, 100, 100, 0, 0,
                     'BusyPointer', NIL, WBENCHSCREEN, NIL)
    busyPointerData := [$0000, $0000,  /* Reserved, must be NULL */
                        $0400, $07c0,
                        $0000, $07c0,
                        $0100, $0380,
                        $0000, $07e0,
                        $07c0, $1ff8,
                        $1ff0, $3fec,
                        $3ff8, $7fde,
                        $3ff8, $7fbe,
                        $7ffc, $ff7f,
                        $7efc, $ffff,
                        $7ffc, $ffff,
                        $3ff8, $7ffe,
                        $3ff8, $7ffe,
                        $1ff0, $3ffc,
                        $07c0, $1ff8,
                        $0000, $07e0,
                        $0000, $0000] : INT  /* Reserved, must be NULL */
    IF (busyPointer := newPointer (busyPointerData)) = NIL THEN Raise ("MEM")
    setPointer (myWin, busyPointer)
    WHILE Mouse () <> 2 DO WaitTOF ()
    CloseW (myWin)
    freePointer (busyPointer)
  ENDIF
EXCEPT
  WriteF ('Error allocating pointer\n')
  IF myWin THEN CloseW (myWin)
ENDPROC
