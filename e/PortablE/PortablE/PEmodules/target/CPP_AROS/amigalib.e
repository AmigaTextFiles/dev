OPT NATIVE
MODULE 'target/aros/rt', 'target/exec/types', 'target/intuition/intuition', 'target/intuition/screens', /*'intuition/classusr', 'intuition/classes',*/ 'target/libraries/commodities', 'target/aros/asmcall', 'target/libraries/gadtools', 'target/devices/keymap', 'target/devices/inputevent', 'target/rexx/storage'
MODULE 'target/utility/hooks', 'target/exec/tasks', 'target/exec/lists', 'target/exec/ports', 'target/graphics/view', 'target/graphics/rastport', 'target/utility/tagitem'
{#include <clib/alib_protos.h>}
NATIVE {CLIB_ALIB_PROTOS_H} CONST

NATIVE {CallHookA} PROC
->"PROC callHookA(" is on-purposely missing from here (it can be found in 'amigalib/boopsi')
NATIVE {CallHook} PROC
PROC callHook(hook:PTR TO hook, obj:APTR, obj2=0:ULONG, ...) IS NATIVE {CallHook(} hook {,} obj {,} obj2 {,} ... {)} ENDNATIVE !!IPTR

/* Exec support */
NATIVE {BeginIO} PROC
->"PROC beginIO(" is on-purposely missing from here (it can be found in 'amigalib/io')
NATIVE {CreateExtIO} PROC
->"PROC createExtIO(" is on-purposely missing from here (it can be found in 'amigalib/io')
NATIVE {CreateStdIO} PROC
->"PROC createStdIO(" is on-purposely missing from here (it can be found in 'amigalib/io')
NATIVE {DeleteExtIO} PROC
->"PROC deleteExtIO(" is on-purposely missing from here (it can be found in 'amigalib/io')
NATIVE {DeleteStdIO} PROC
->"PROC deleteStdIO(" is on-purposely missing from here (it can be found in 'amigalib/io')
NATIVE {CreateTask} PROC
PROC createTask(name:/*STRPTR*/ ARRAY OF CHAR, pri:VALUE, initpc:APTR, stacksize:ULONG) IS NATIVE {CreateTask(} name {,} pri {,} initpc {,} stacksize {)} ENDNATIVE !!PTR TO tc
NATIVE {DeleteTask} PROC
PROC deleteTask(task:PTR TO tc) IS NATIVE {DeleteTask(} task {)} ENDNATIVE
NATIVE {NewList} PROC
PROC newList(param1:PTR TO lh) IS NATIVE {NewList(} param1 {)} ENDNATIVE
->#if !defined(ENABLE_RT) || !ENABLE_RT
NATIVE {CreatePort} PROC
PROC createPort(name:/*STRPTR*/ ARRAY OF CHAR, pri:VALUE) IS NATIVE {CreatePort(} name {,} pri {)} ENDNATIVE !!PTR TO mp
NATIVE {DeletePort} PROC
PROC deletePort(mp:PTR TO mp) IS NATIVE {DeletePort(} mp {)} ENDNATIVE
->#endif

/* Extra */
NATIVE {RangeRand} PROC
PROC rangeRand(maxValue:ULONG) IS NATIVE {RangeRand(} maxValue {)} ENDNATIVE !!ULONG
NATIVE {FastRand} PROC
PROC fastRand(seed:ULONG) IS NATIVE {FastRand(} seed {)} ENDNATIVE !!ULONG
NATIVE {TimeDelay} PROC
PROC timeDelay(unit:VALUE, secs:ULONG, microsecs:ULONG) IS NATIVE {TimeDelay(} unit {,} secs {,} microsecs {)} ENDNATIVE !!VALUE
NATIVE {waitbeam} PROC
->PROC waitbeam(pos:VALUE) IS NATIVE {waitbeam(} pos {)} ENDNATIVE
NATIVE {__sprintf} PROC
PROC __sprintf(buffer:PTR TO UBYTE, format:PTR TO UBYTE, format2=0:ULONG, ...) IS NATIVE {__sprintf(} buffer {,} format {,} format2 {,} ... {)} ENDNATIVE
NATIVE {StrDup} PROC
PROC strDup(str:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {StrDup(} str {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {ReAllocVec} PROC
->PROC reAllocVec(oldmem:APTR, size:ULONG, requirements:ULONG) IS NATIVE {ReAllocVec(} oldmem {,} size {,} requirements {)} ENDNATIVE !!APTR

NATIVE {MergeSortList} PROC
PROC mergeSortList(l:PTR TO mlh, compare:PTR /*int (*compare)(struct MinNode *n1, struct MinNode *n2, void *data)*/, data:PTR) IS NATIVE {MergeSortList(} l {, (int (*)(MinNode*, MinNode*, void*)) } compare {,} data {)} ENDNATIVE

/* Commodities */
NATIVE {HotKey} PROC
PROC hotKey(description:/*STRPTR*/ ARRAY OF CHAR, port:PTR TO mp, id:VALUE) IS NATIVE {HotKey(} description {,} port {,} id {)} ENDNATIVE !!PTR TO CXOBJ
NATIVE {FreeIEvents} PROC
PROC freeIEvents(/*volatile*/ events:PTR TO inputevent) IS NATIVE {FreeIEvents(} events {)} ENDNATIVE
NATIVE {ArgArrayInit} PROC
->"PROC argArrayInit(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {ArgArrayDone} PROC
->"PROC argArrayDone(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {ArgInt} PROC
->"PROC argInt(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {ArgString} PROC
->"PROC argString(" is on-purposely missing from here (it can be found in 'amigalib/argarray')
NATIVE {InvertString} PROC
PROC invertString(str:/*STRPTR*/ ARRAY OF CHAR, km:PTR TO keymap) IS NATIVE {InvertString(} str {,} km {)} ENDNATIVE !!PTR TO inputevent

/* Graphics */
->#ifndef ObtainBestPen
NATIVE {ObtainBestPen} PROC
PROC obtainBestPen( cm:PTR TO colormap, r:VALUE, g:VALUE, b:VALUE, tag1:ULONG, tag12=0:ULONG, ...) IS NATIVE {ObtainBestPen(} cm {,} r {,} g {,} b {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->#endif

->#ifndef GetRPAttrs
NATIVE {GetRPAttrs} PROC
PROC getRPAttrs( rp:PTR TO rastport, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {GetRPAttrs(} rp {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
->#endif

/* Intuition */
->#ifndef SetWindowPointer 
NATIVE {SetWindowPointer} PROC
PROC setWindowPointer( window:PTR TO window, tag1:ULONG, tag12=0:ULONG, ...) IS NATIVE {SetWindowPointer(} window {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
->#endif

/* Locale */
/*#ifndef OpenCatalog
NATIVE {OpenCatalog} PROC
PROC openCatalog(	locale:PTR TO locale, name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {OpenCatalog(} locale {,} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO catalog
#endif*/

/* Pools */
NATIVE {LibCreatePool} PROC
PROC libCreatePool(requirements:ULONG, puddleSize:ULONG, threshSize:ULONG) IS NATIVE {LibCreatePool(} requirements {,} puddleSize {,} threshSize {)} ENDNATIVE !!APTR
NATIVE {LibDeletePool} PROC
PROC libDeletePool(poolHeader:APTR) IS NATIVE {LibDeletePool(} poolHeader {)} ENDNATIVE
NATIVE {LibAllocPooled} PROC
PROC libAllocPooled(poolHeader:APTR, memSize:ULONG) IS NATIVE {LibAllocPooled(} poolHeader {,} memSize {)} ENDNATIVE !!APTR
NATIVE {LibFreePooled} PROC
PROC libFreePooled(poolHeader:APTR, memory:APTR, memSize:ULONG) IS NATIVE {LibFreePooled(} poolHeader {,} memory {,} memSize {)} ENDNATIVE

/* Hook Support */
NATIVE {HookEntry} OBJECT	
PROC hookEntry( hook:PTR TO hook, obj:APTR, param:APTR )		->allow CALLBACK without "IS"
ENDPROC NATIVE {HookEntry(} hook {,} obj {,} param {)} ENDNATIVE !!IPTR

   NATIVE {AROS_METHODRETURNTYPE} CONST ->AROS_METHODRETURNTYPE = IPTR

   NATIVE {AROS_NR_SLOWSTACKMETHODS_PRE} CONST	->AROS_NR_SLOWSTACKMETHODS_PRE(arg)
   NATIVE {AROS_SLOWSTACKMETHODS_PRE} CONST	->AROS_SLOWSTACKMETHODS_PRE(arg)   AROS_METHODRETURNTYPE retval;
   NATIVE {AROS_SLOWSTACKMETHODS_ARG} CONST	->AROS_SLOWSTACKMETHODS_ARG(arg)   ((Msg)&(arg))
   NATIVE {AROS_SLOWSTACKMETHODS_POST}	    CONST ->AROS_SLOWSTACKMETHODS_POST	    = return retval;
   NATIVE {AROS_NR_SLOWSTACKMETHODS_POST} CONST

    NATIVE {GetTagsFromStack} PROC
->PROC GetTagsFromStack(firstTag:IPTR, args:va_list) IS NATIVE {GetTagsFromStack(} firstTag {,} args {)} ENDNATIVE !!ARRAY OF tagitem
    NATIVE {FreeTagsFromStack} PROC
->PROC FreeTagsFromStack(tags:ARRAY OF tagitem) IS NATIVE {FreeTagsFromStack(} tags {)} ENDNATIVE

/* Rexx support */
NATIVE {CheckRexxMsg} PROC
PROC checkRexxMsg(param1:PTR TO rexxmsg) IS NATIVE {-CheckRexxMsg(} param1 {)} ENDNATIVE !!INT
NATIVE {SetRexxVar} PROC
PROC setRexxVar(param1:PTR TO rexxmsg, param2:PTR TO CHAR, param3:PTR TO CHAR, length:ULONG) IS NATIVE {SetRexxVar(} param1 {,} param2 {,} param3 {,} length {)} ENDNATIVE !!VALUE
NATIVE {GetRexxVar} PROC
PROC getRexxVar(param1:PTR TO rexxmsg, param2:PTR TO CHAR, value:PTR TO PTR /*TO CHAR*/) IS NATIVE {GetRexxVar(} param1 {,} param2 {, (char **) } value {)} ENDNATIVE !!VALUE
