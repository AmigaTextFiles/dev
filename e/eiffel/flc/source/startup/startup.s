
**
** the Eiffel startup program in 68020 Assembler
**
** Copyright © 1995, Guichard Damien.
**

HEAP_SIZE EQU 2000

        include exec/memory.i
        include exec/exec_lib.i
        include dos/dos_lib.i
        include globals.i

_startup
        lea     (-Globals_SIZEOF,sp),sp
        move.l  sp,a4

        move.l  _SysBase,(SysBase,a4)

        lea     dosname(pc),a1
        move.l  #36,d0
        EXEC_CALL OpenLibrary
        tst.l   d0
        beq.s   goaway
        move.l  d0,(DOSBase,a4)

        DOS_CALL Input
        move.l   d0,(stdin,a4)

        DOS_CALL Output
        move.l   d0,(stdout,a4)

        move.l   #HEAP_SIZE,d0
        move.l   #MEMF_ANY!MEMF_CLEAR,d1
        EXEC_CALL AllocVec
        tst.l   d0
        beq.s   goawayclosedos
        move.l  d0,(heap,a4)
        move.l  d0,a3

        lea     creator(pc),a1
        move.l  a1,(creation,a4)

        bsr.s   _main

* finished so free heap
goawayfreeheap
        move.l  (heap,a4),a1
        EXEC_CALL FreeVec

* finished so close Dos library
goawayclosedos
        move.l  (DOSBase,a4),a1
        EXEC_CALL CloseLibrary

goaway
        lea     (Globals_SIZEOF,sp),sp
        move.l  #0,d0
        rts

* generic creation routine where a2 is the class
creator
        move.l  a3,d0
        move.l  a2,(a3)+
        add.l  (-4,a2),a3
        rts

dosname DOSNAME
        EVEN

_main

