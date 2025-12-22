/* $Id: alib_protos.h,v 1.12 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/devices/timer', 'target/devices/keymap', 'target/libraries/commodities', 'target/utility/hooks', 'target/intuition/classes', 'target/intuition/classusr', 'target/graphics/graphint', 'target/rexx/storage'
MODULE 'target/exec/ports', 'target/devices/inputevent'
{#include <clib/alib_protos.h>}
NATIVE {CLIB_ALIB_PROTOS_H} CONST

/****************************************************************************\
*                                                                            *
* NOTE: many of the functions traditionally found in amiga.lib have been     *
*       moved into the memory resident operating system with AmigaOS4. This  *
*       includes functionality which is available only as 68k assembly code  *
*       in the original amiga.lib implementation. You are advised to check   *
*       the API definitions of the libraries named in the sections commented *
*       out below and to use the functionality available rather than the old *
*       amiga.lib code.                                                      *
*                                                                            *
\****************************************************************************/

/*  Exec support functions (exec.library) */

/* Assorted functions in amiga.lib|libamiga.a */
NATIVE {FastRand} PROC
PROC FastRand( seed:ULONG ) IS NATIVE {FastRand(} seed {)} ENDNATIVE !!ULONG
NATIVE {RangeRand} PROC
PROC RangeRand( maxValue:ULONG ) IS NATIVE {RangeRand(} maxValue {)} ENDNATIVE !!UINT

/* Graphics support functions in amiga.lib|libamiga.a */
NATIVE {AddTOF} PROC
PROC AddTOF( i:PTR TO isrvstr, p:PTR /*LONG (*p)(APTR args)*/, a:APTR ) IS NATIVE {AddTOF(} i {, (LONG (*)(APTR)) } p {,} a {)} ENDNATIVE
NATIVE {RemTOF} PROC
PROC RemTOF( i:PTR TO isrvstr ) IS NATIVE {RemTOF(} i {)} ENDNATIVE
NATIVE {waitbeam} PROC
->Linker needs a library interface for this unused proc, so it is disabled: PROC Waitbeam( b:VALUE ) IS NATIVE {waitbeam(} b {)} ENDNATIVE

/* math (Motorola Fast Floating Point) support functions in amiga.lib */

/* Timer support functions in amiga.lib|libamiga.a (V36 and higher only) */
NATIVE {TimeDelay} PROC
PROC TimeDelay( unit:VALUE, secs:ULONG, microsecs:ULONG ) IS NATIVE {TimeDelay(} unit {,} secs {,} microsecs {)} ENDNATIVE !!VALUE
NATIVE {DoTimer} PROC
PROC DoTimer( param1:PTR TO timeval, unit:VALUE, command:VALUE ) IS NATIVE {DoTimer(} param1 {,} unit {,} command {)} ENDNATIVE !!VALUE

/* Commodities functions in amiga.lib|libamiga.a (V36 and higher only) */
NATIVE {ArgArrayDone} PROC
->"PROC argArrayDone(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {ArgArrayInit} PROC
->"PROC argArrayInit(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {ArgInt} PROC
->"PROC argInt(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {ArgString} PROC
->"PROC argString(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {HotKey} PROC
->Linker needs a library interface for this unused proc, so it is disabled: PROC HotKey( description:/*CONST_STRPTR*/ ARRAY OF CHAR, port:PTR TO mp, id:VALUE ) IS NATIVE {HotKey(} description {,} port {,} id {)} ENDNATIVE !!PTR TO CXOBJ
NATIVE {InvertString} PROC
->Linker needs a library interface for this unused proc, so it is disabled: PROC InvertString( str:/*CONST_STRPTR*/ ARRAY OF CHAR, km:PTR TO keymap ) IS NATIVE {InvertString(} str {,} km {)} ENDNATIVE !!PTR TO inputevent
NATIVE {FreeIEvents} PROC
PROC FreeIEvents( events:PTR TO inputevent ) IS NATIVE {FreeIEvents(} events {)} ENDNATIVE

/* Commodities Macros */
/* CxObj *CxCustom(LONG(*)(),LONG id)(A0,D0) */
/* CxObj *CxDebug(LONG id)(D0) */
/* CxObj *CxFilter(STRPTR description)(A0) */
/* CxObj *CxSender(struct MsgPort *port,LONG id)(A0,D0) */
/* CxObj *CxSignal(struct Task *task,LONG signal)(A0,D0) */
/* CxObj *CxTranslate(struct InputEvent *ie)(A0) */

/* ARexx support functions in amiga.lib (rexxsyslib.library) */

/* Intuition hook and boopsi support functions in amiga.lib. */

/* Network-support functions in amiga.lib|libamiga.a.
   ACrypt() first appeared in later V39 versions of amiga.lib, but
   operates correctly under V37 and up. */
NATIVE {ACrypt} PROC
PROC Acrypt( buffer:/*STRPTR*/ ARRAY OF CHAR, password:/*CONST_STRPTR*/ ARRAY OF CHAR, username:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ACrypt(} buffer {,} password {,} username {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
