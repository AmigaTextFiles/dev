/* This one is responsible for all Hooks used in a program.
** As you can in MODULs only declare simple types (no OBJECTs) and
** therefore the Main-PROC have to initalize all Hooks this
** Modul was written.
** It also does not use the 'h_data'-field of the hook.
**
** Usage:
**   ....
**   DEF thisismyhookptr:PTR TO ehook   -> is initialized to NIL by E
**   ...
**   PROC myconstructhook(pool,constructdata) IS ...
**   ...
**      MUIA_List_ConstructHook, gethook({thisismyhookptr},{myconstructfunc}),
**   ...
*/

OPT MODULE
OPT REG=5

MODULE 'utility/hooks'

EXPORT OBJECT ehook OF hook
  ptrA4:LONG
ENDOBJECT

/* Call this PROC whenever you need a hook. If it is called the first
** time for a hook it creates a new hook-structure and initialize it.
** (Note: the memeory for the ehook-structure is freed by E when the program
**        quits. To free the memory manually do 'END thisismyhookptr' which
**        also does 'thisismyhookptr:=NIL')
** Your Hook-function gets A0, as first parameter, A2 as sceond and A1 as third.
** You can also acces global variables as A4 is set correctly.
**
**   hookref     - pointer to your hook-var (usally {var})
**   hookfuncref - pointer to your hook-function (usally {proc})
**
** Note: As the hook-structure is created dynamical you may get an
**       "MEM"-exception.
*/
EXPORT PROC gethook(hookref,hookfuncref)
DEF hookp:PTR TO ehook

  IF (hookp:=^hookref)=NIL
    NEW hookp
    installhook(hookp,hookfuncref)
    ^hookref:=hookp
  ENDIF

ENDPROC hookp

EXPORT PROC ungetHook(hookref)
DEF hookp:PTR TO ehook

  IF hookp:=^hookref
    END hookp
    ^hookref:=NIL
  ENDIF

ENDPROC

/*
** installhook (written by Wouter van Oortmerssen)
*/

PROC installhook(hook,func)
    MOVE.L hook,A0
    MOVE.L func,12(A0)
    LEA hookentry(PC),A1
    MOVE.L A1,8(A0)     -> entry
    MOVE.L A4,20(A0)    -> ptrA4
ENDPROC

hookentry:
   MOVEM.L D2-D7/A2-A6,-(A7)
   MOVE.L 20(A0),A4
   MOVE.L A0,-(A7)
   MOVE.L A2,-(A7)
   MOVE.L A1,-(A7)
   MOVE.L 12(A0),A0
   JSR (A0)
   LEA 12(A7),A7

   MOVEM.L (A7)+,D2-D7/A2-A6
RTS

/*
** End Of File
*/
 
