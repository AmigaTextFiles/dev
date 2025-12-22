        IFND    GLOBALS_I
GLOBALS_I   SET     1

**
** global datas for Eiffel startup program
** Must be included in any assembler source
**
** Copyright © 1995, Guichard Damien.
**

        IFND EXEC_TYPES_I
        INCLUDE "exec/types.i"
        ENDC

  STRUCTURE Globals,0

     APTR SysBase     ; Exec library base
     APTR DOSBase     ; Dos library base
     APTR stdin       ; input file handle
     APTR stdout      ; output file handle
     APTR heap        ; Memory for objects
     ULONG lastchar   ; last character read
     LONG lastint     ; last integer read
     APTR laststring  ; last string read
     FPTR creation    ; generic creation routine

     LABEL Globals_SIZEOF

EXEC_CALL MACRO
        move.l  (SysBase,a4),a6
        jsr     _LVO\1(a6)
        ENDM

DOS_CALL MACRO
        move.l  (DOSBase,a4),a6
        jsr     _LVO\1(a6)
        ENDM

    ENDC ;GLOBALS_I
