/* $VER: alib_protos.h 40.1 (6.6.1998) */
OPT NATIVE, INLINE
MODULE 'target/exec/types', 'target/devices/timer', 'target/devices/keymap', 'target/libraries/commodities', 'target/utility/hooks', 'target/intuition/classes', 'target/intuition/classusr', 'target/graphics/graphint', 'target/rexx/storage'
MODULE 'target/exec/io', 'target/exec/ports', 'target/exec/tasks', 'target/exec/lists', 'target/devices/inputevent'
MODULE 'target/commodities'		->this prevents HotKey() & FreeIEvents() causing AmiDevCpp to complain about "undefined reference to `CxBase'"
{#include <clib/alib_protos.h>}
NATIVE {CLIB_ALIB_PROTOS_H} CONST

/*  Exec support functions */

NATIVE {BeginIO} PROC
->"PROC beginIO(" is on-purposely missing from here (it can be found in 'amigalib/io')
NATIVE {CreateExtIO} PROC
->"PROC createExtIO(" is on-purposely missing from here (it can be found in 'amigalib/io')
NATIVE {CreatePort} PROC
PROC createPort( name:/*CONST_STRPTR*/ ARRAY OF CHAR, pri:VALUE ) IS NATIVE {CreatePort(} name {,} pri {)} ENDNATIVE !!PTR TO mp
NATIVE {CreateStdIO} PROC
->"PROC createStdIO(" is on-purposely missing from here (it can be found in 'amigalib/io')
NATIVE {CreateTask} PROC
PROC createTask( name:/*CONST_STRPTR*/ ARRAY OF CHAR, pri:VALUE, initPC:APTR, stackSize:ULONG ) IS NATIVE {CreateTask(} name {,} pri {,} initPC {,} stackSize {)} ENDNATIVE !!PTR TO tc
NATIVE {DeleteExtIO} PROC
->"PROC deleteExtIO(" is on-purposely missing from here (it can be found in 'amigalib/io')
NATIVE {DeletePort} PROC
PROC deletePort( ioReq:PTR TO mp ) IS NATIVE {DeletePort(} ioReq {)} ENDNATIVE
NATIVE {DeleteStdIO} PROC
->"PROC deleteStdIO(" is on-purposely missing from here (it can be found in 'amigalib/io')
NATIVE {DeleteTask} PROC
PROC deleteTask( task:PTR TO tc ) IS NATIVE {DeleteTask(} task {)} ENDNATIVE
NATIVE {NewList} PROC
PROC newList( list:PTR TO lh ) IS NATIVE {NewList(} list {)} ENDNATIVE
NATIVE {LibAllocPooled} PROC
->Not supported for some reason: PROC libAllocPooled( poolHeader:APTR, memSize:ULONG ) IS NATIVE {LibAllocPooled(} poolHeader {,} memSize {)} ENDNATIVE !!APTR
NATIVE {LibCreatePool} PROC
->Not supported for some reason: PROC libCreatePool( memFlags:ULONG, puddleSize:ULONG, threshSize:ULONG ) IS NATIVE {LibCreatePool(} memFlags {,} puddleSize {,} threshSize {)} ENDNATIVE !!APTR
NATIVE {LibDeletePool} PROC
->Not supported for some reason: PROC libDeletePool( poolHeader:APTR ) IS NATIVE {LibDeletePool(} poolHeader {)} ENDNATIVE
NATIVE {LibFreePooled} PROC
->Not supported for some reason: PROC libFreePooled( poolHeader:APTR, memory:APTR, memSize:ULONG ) IS NATIVE {LibFreePooled(} poolHeader {,} memory {,} memSize {)} ENDNATIVE

/* Assorted functions in amiga.lib */

NATIVE {FastRand} PROC
PROC fastRand( seed:ULONG ) IS NATIVE {FastRand(} seed {)} ENDNATIVE !!ULONG
NATIVE {RangeRand} PROC
PROC rangeRand( maxValue:ULONG ) IS NATIVE {RangeRand(} maxValue {)} ENDNATIVE !!UINT

/* Graphics support functions in amiga.lib */

NATIVE {AddTOF} PROC
->"PROC addTOF(" is on-purposely missing from here (it can be found in 'amigalib/interrupts')
NATIVE {RemTOF} PROC
->"PROC remTOF(" is on-purposely missing from here (it can be found in 'amigalib/interrupts')
NATIVE {waitbeam} PROC
->"PROC waitbeam(" is on-purposely missing from here (it can be found in 'amigalib/interrupts')

/* math support functions in amiga.lib */

NATIVE {afp} PROC
->PROC afp( string:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {afp(} string {)} ENDNATIVE !!FLOAT
NATIVE {arnd} PROC
->PROC arnd( place:VALUE, exp:VALUE, string:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {arnd(} place {,} exp {,} string {)} ENDNATIVE
NATIVE {dbf} PROC
->PROC dbf( exp:ULONG, mant:ULONG ) IS NATIVE {dbf(} exp {,} mant {)} ENDNATIVE !!FLOAT
NATIVE {fpa} PROC
->PROC fpa( fnum:FLOAT, string:PTR TO BYTE ) IS NATIVE {fpa(} fnum {,} string {)} ENDNATIVE !!VALUE
NATIVE {fpbcd} PROC
->PROC fpbcd( fnum:FLOAT, string:PTR TO BYTE ) IS NATIVE {fpbcd(} fnum {,} string {)} ENDNATIVE

/* Timer support functions in amiga.lib (V36 and higher only) */

NATIVE {TimeDelay} PROC
PROC timeDelay( unit:VALUE, secs:ULONG, microsecs:ULONG ) IS NATIVE {TimeDelay(} unit {,} secs {,} microsecs {)} ENDNATIVE !!VALUE
NATIVE {DoTimer} PROC
->PROC doTimer( param1:PTR TO timeval, unit:VALUE, command:VALUE ) IS NATIVE {DoTimer(} param1 {,} unit {,} command {)} ENDNATIVE !!VALUE

/*  Commodities functions in amiga.lib (V36 and higher only) */

NATIVE {ArgArrayDone} PROC
->"PROC argArrayDone(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {ArgArrayInit} PROC
->"PROC argArrayInit(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {ArgInt} PROC
->"PROC argInt(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {ArgString} PROC
->"PROC argString(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {HotKey} PROC
PROC hotKey( description:/*CONST_STRPTR*/ ARRAY OF CHAR, port:PTR TO mp, id:VALUE ) IS NATIVE {HotKey(} description {,} port {,} id {)} ENDNATIVE !!PTR TO CXOBJ
NATIVE {InvertString} PROC
->PROC invertString( str:/*CONST_STRPTR*/ ARRAY OF CHAR, km:PTR TO keymap ) IS NATIVE {InvertString(} str {,} km {)} ENDNATIVE !!PTR TO inputevent
NATIVE {FreeIEvents} PROC
PROC freeIEvents( events:PTR TO inputevent ) IS NATIVE {FreeIEvents(} events {)} ENDNATIVE

/* Commodities Macros */

/* CxObj *CxCustom(LONG(*)(),LONG id)(A0,D0) */
/* CxObj *CxDebug(LONG id)(D0) */
/* CxObj *CxFilter(STRPTR description)(A0) */
/* CxObj *CxSender(struct MsgPort *port,LONG id)(A0,D0) */
/* CxObj *CxSignal(struct Task *task,LONG signal)(A0,D0) */
/* CxObj *CxTranslate(struct InputEvent *ie)(A0) */

/*  ARexx support functions in amiga.lib */

NATIVE {CheckRexxMsg} PROC
PROC checkRexxMsg( rexxmsg:PTR TO rexxmsg ) IS NATIVE {-CheckRexxMsg(} rexxmsg {)} ENDNATIVE !!INT
NATIVE {GetRexxVar} PROC
PROC getRexxVar( rexxmsg:PTR TO rexxmsg, name:/*CONST_STRPTR*/ ARRAY OF CHAR, result:ARRAY OF /*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {GetRexxVar(} rexxmsg {,} name {,} result {)} ENDNATIVE !!VALUE
NATIVE {SetRexxVar} PROC
PROC setRexxVar( rexxmsg:PTR TO rexxmsg, name:/*CONST_STRPTR*/ ARRAY OF CHAR, value:/*CONST_STRPTR*/ ARRAY OF CHAR, length:VALUE ) IS NATIVE {SetRexxVar(} rexxmsg {,} name {,} value {,} length {)} ENDNATIVE !!VALUE

/*  Intuition hook and boopsi support functions in amiga.lib. */
/*  These functions do not require any particular ROM revision */
/*  to operate correctly, though they deal with concepts first introduced */
/*  in V36.  These functions would work with compatibly-implemented */
/*  hooks or objects under V34. */

NATIVE {CallHookA} PROC
->"PROC callHookA(" is on-purposely missing from here (it can be found in 'amigalib/boopsi')
NATIVE {CallHook} PROC
PROC callHook( hookPtr:PTR TO hook, obj:PTR TO INTUIOBJECT, obj2=0:ULONG, ... ) IS NATIVE {CallHook(} hookPtr {,} obj {,} obj2 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {DoMethodA} PROC
->"PROC doMethodA(" is on-purposely missing from here (it can be found in 'amigalib/boopsi')
NATIVE {DoMethod} PROC
PROC doMethod( obj:PTR TO INTUIOBJECT, methodID:ULONG, methodID2=0:ULONG, ... ) IS NATIVE {DoMethod(} obj {,} methodID {,} methodID2 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {DoSuperMethodA} PROC
->"PROC doSuperMethodA(" is on-purposely missing from here (it can be found in 'amigalib/boopsi')
NATIVE {DoSuperMethod} PROC
PROC doSuperMethod( cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, methodID:ULONG, methodID2=0:ULONG, ... ) IS NATIVE {DoSuperMethod(} cl {,} obj {,} methodID {,} methodID2 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {coerceMethodA} PROC
NATIVE {CoerceMethodA} PROC
->"PROC coerceMethodA(" is on-purposely missing from here (it can be found in 'amigalib/boopsi')
NATIVE {CoerceMethod} PROC
PROC coerceMethod( cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, methodID:ULONG, methodID2=0:ULONG, ... ) IS NATIVE {CoerceMethod(} cl {,} obj {,} methodID {,} methodID2 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {HookEntry} PROC
->Could not get to compile: PROC hookEntry( hookPtr:PTR TO hook, obj:PTR TO INTUIOBJECT, message:APTR ) IS NATIVE {HookEntry(} hookPtr {,} obj {,} message {)} ENDNATIVE !!ULONG
/*
PROC hookEntry( hookPtr:PTR TO hook, obj:PTR TO INTUIOBJECT, message:APTR )		->allow CALLBACK without "IS"
ENDPROC NATIVE {HookEntry(} hookPtr {,} obj {,} message {)} ENDNATIVE !!ULONG
*/
NATIVE {SetSuperAttrs} PROC
PROC setSuperAttrs( cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, tag1:ULONG, tag12=0:ULONG, ... ) IS NATIVE {SetSuperAttrs(} cl {,} obj {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG

/*  Network-support functions in amiga.lib. */
/*  ACrypt() first appeared in later V39 versions of amiga.lib, but */
/*  operates correctly under V37 and up. */

NATIVE {ACrypt} PROC
PROC acrypt( buffer:/*STRPTR*/ ARRAY OF CHAR, password:/*CONST_STRPTR*/ ARRAY OF CHAR, username:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ACrypt(} buffer {,} password {,} username {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
