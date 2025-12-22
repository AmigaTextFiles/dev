
;
; Do the compilation using vbcc and the dmake utility from dice.
; All the assigns and path-setups are done.
; You can use it to build ressourcetracking.library:
;   1> Execute make.b ressourcetraccking.library
; When you are prompted to insert volume vbcc: cancel the request.
;
; Note: This only works for my system.  You will need to adapt
; the assigns.
;


.bra {
.ket }
.key WHAT/A


Stack 51200

CD Projects:c/RsrcTrackLib/src/

IF NOT EXISTS vbcc:
  Assign vbccm68k: hd1:Programmation/vbcc/machines/amiga68k/
  Assign vbcc: vbccm68k:
  Assign vlibm68k: vbccm68k:lib/
  Assign vincludem68k: vbccm68k:include/ dcc:include/amiga30/
ENDIF

Path ADD vbccm68k://bin/ vbccm68k:bin/

dcc:abin/dmake {WHAT} -f makefile

