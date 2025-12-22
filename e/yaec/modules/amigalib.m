OPT EXPORT
OPT NODEFMODS
OPT LINK 'e:linklib/small.lib' -> change to Your setup..
OPT XREF _BeginIO, _CreateExtIO, _CreatePort, _CreateStdIO, _CreateTask,
         _DeleteExtIO, _DeletePort, _DeleteStdIO, _DeleteTask,
         _NewList,
         ->_LibAllocPooled, _LibCreatePool, _LibDeletePool, _LibFreePooled,
         _FastRand, _RangeRand,
         _AddTOF, _RemTOF, _waitbeam,
         ->_afp, _arnd, _dbf, _fpa, _fpbcd,
         _TimeDelay, _DoTimer,
         ->_ArgArrayDone, _ArgArrayInit, _ArgInt, _ArgString,
         _HotKey, _InvertString, _FreeIEvent,
         _CheckRexxMsg, _GetRexxVar, _SetRexxVar,
         _CallHookA, _CallHook,
         _DoMethodA, _DoMethod,
         _DoSuperMethodA, _DoSuperMethod,
         _CoerceMethodA, _CoerceMethod,
         _SetSuperAttrs,
         _ACrypt


/*  Exec support functions */

MACRO BeginIO(io) IS Stores(io) BUT ASM ' bsr _BeginIO' BUT ASM ' addq.l #4, a7'
MACRO CreateExtIO(port, iosize) IS Stores(port, iosize) BUT ASM ' bsr _CreateExtIO' BUT ASM ' addq.l #8, a7'
MACRO CreatePort(name, pri) IS Stores(name,pri) BUT ASM ' bsr _CreatePort' BUT ASM ' addq.l #8, a7'
MACRO CreateStdIO(port) IS Stores(port) BUT ASM ' bsr _CreateStdIO' BUT ASM ' addq.l #4, a7'
MACRO CreateTask(name, pri, initpc, stacksize) IS Stores(name,pri,initpc,stacksize) BUT ASM ' bsr _CreateTask' BUT ASM ' lea 16(a7), a7'
MACRO DeleteExtIO(ioreq) IS Stores(ioreq) BUT ASM ' bsr _DeleteExtIO' BUT ASM ' addq.l #4, a7'
MACRO DeletePort(ioreq) IS Stores(ioreq) BUT ASM ' bsr _DeletePort' BUT ASM ' addq.l #4, a7'
MACRO DeleteStdIO(ioreq) IS Stores(ioreq) BUT ASM ' bsr _DeleteStdIO' BUT ASM ' addq.l #4, a7'
MACRO DeleteTask(task) IS Stores(task) BUT ASM ' bsr _DeleteTask' BUT ASM ' addq.l #4, a7'
MACRO NewList(list) IS Stores(list) BUT ASM ' bsr _NewList' BUT ASM ' addq.l #4, a7'
MACRO LibAllocPooled(poolheader, memsize) IS Stores(poolheader,memsize) BUT ASM ' bsr _LibAllocPooled' BUT ASM ' addq.l #8, a7'
MACRO LibCreatePool(memflags, puddlesize, treshsize) IS Stores(memflags,puddlesize,treshsize) BUT ASM ' bsr _LibCreatePool' BUT ASM ' lea 12(a7), a7'
MACRO LibDeletePool(poolheader) IS Stores(poolheader) BUT ASM ' bsr _LibDeletePool' BUT ASM ' addq.l #4, a7'
MACRO LibFreePooled(poolheader, memory, memsize) IS Stores(poolheader,memory,memsize) BUT ASM ' bsr _LibDeletePool' BUT ASM ' lea 12(a7), a7'

/* Assorted functions in amiga.lib */

MACRO FastRand(seed) IS Stores(seed) BUT ASM ' bsr _FastRand' BUT ASM ' addq.l #4, a7'
MACRO RangeRand(maxvalue) IS Stores(maxvalue) BUT ASM ' bsr _RangeRand' BUT ASM ' addq.l #4, a7'
-> yaec-note : global RangeSeed can not be reached,
-> use this function instead. Returns oldseed.
MACRO SetRangeSeed(newseed) IS (D1 := newseed) BUT ASM ' move.l _RangeSeed(a4), d0' BUT ASM ' move.l d1, RangeSeed(a4)'

/* Graphics support functions in amiga.lib */

MACRO AddTOF(i, p, a) IS Stores(i,p,a) BUT ASM ' bsr _AddTOF' BUT ASM ' lea 12(a7), a7'
MACRO RemTOF(i) IS Stores(i) BUT ASM ' bsr _RemTOF' BUT ASM ' addq.l #4, a7'
MACRO waitbeam(b) IS Stores(b) BUT ASM ' bsr _waitbeam' BUT ASM ' addq.l #4, a7'

/* math support functions in amiga.lib */
-> yaec : uses motorola fast floating point, E uses IEEE. Reming them out..
->MACRO afp(string CHAR) (FLOAT) IS Stores(string) BUT ASM ' bsr _afp' BUT ASM ' addq.l #4, a7'
->MACRO arnd(place:LONG, exp:LONG, string CHAR) (VOID) IS Stores(place,exp,string) BUT ASM ' bsr _arnd' BUT ASM ' lea 12(a7), a7'
->MACRO dbf(exp:LONG, mant:LONG) (FLOAT) IS Stores(exp,mant) BUT ASM ' bsr _dbf' BUT ASM ' addq.l #8, a7'
->MACRO fpa(fnum:FLOAT, string CHAR) (LONG) IS Stores(fnum,string) BUT ASM ' bsr _fpa' BUT ASM ' addq.l #8, a7'
->MACRO fpbcd(fnum:FLOAT, string CHAR) (VOID) IS Stores(fnum,string) BUT ASM ' bsr _fpbcd' BUT ASM ' addq.l #8, a7'

/* Timer support functions in amiga.lib (V36 and higher only) */

MACRO TimeDelay(unit, secs, mseconds) IS Stores(unit,secs,mseconds) BUT ASM ' bsr _TimeDelay' BUT ASM ' lea 12(a7), a7'
MACRO DoTimer(tv, unit, command) IS Stores(tv,unit,command) BUT ASM ' bsr _DoTimer' BUT ASM ' lea 12(a7), a7'

/*  Commodities functions in amiga.lib (V36 and higher only) */

-> yaec : not sure how theese will work with yaec..or if they are any useful..
->MACRO ArgArrayDone() (VOID) IS ASM ' bsr _ArgArrayDone'
->MACRO ArgArrayInit(argc:LONG, argv ANY) (PTR TO ANY) IS Stores(argc,argv) BUT ASM ' bsr _ArgArrayInit' BUT ASM ' addq.l #8, a7'
->MACRO ArgInt(tt ANY, entry CHAR, defaultval:LONG) (LONG) IS Stores(tt,entry,defaultval) BUT ASM ' bsr _ArgInt' BUT ASM ' lea 12(a7), a7'
->MACRO ArgString(tt ANY, entry CHAR, defaulstring CHAR) (PTR TO CHAR) IS Stores(tt,entry,defaultval) BUT ASM ' bsr _ArgString' BUT ASM ' lea 12(a7), a7'

MACRO HotKey(description, port, id) IS Stores(description,port,id) BUT ASM ' bsr _HotKey' BUT ASM ' lea 12(a7), a7'
MACRO InvertString(str, km) IS Stores(str,km) BUT ASM ' bsr _InvertString' BUT ASM ' addq.l #8, a7'
MACRO FreeIEvents(events) IS Stores(events) BUT ASM ' bsr _FreeIEvents' BUT ASM ' addq.l #4, a7'

/* Commodities MACROs */
-> yaec: theese already exists in libraries/commodities.e..reming..
->MACRO CxFilter(d) IS CreateCxObj(CX_FILTER, d, 0)
->MACRO CxSender(port, id) IS CreateCxObj(CX_SEND, port, id)
->MACRO CxSignal(task, sig) IS CreateCxObj(CX_SIGNAL, task, sig)
->MACRO CxTranslate(ie) IS CreateCxObj(CX_TRANSLATE, ie, 0)
->MACRO CxDebug(id)                     (PTR TO cxobj) IS CreateCxObj(CX_DEBUG, id, 0)
->MACRO CxCustom(action, id) IS CreateCxObj(CX_CUSTOM, action, id)


/*  ARexx support functions in amiga.lib */

MACRO CheckRexxMsg(rexxmsg) IS Stores(rexxmsg) BUT ASM ' bsr _CheckRexxMsg' BUT ASM ' addq.l #4, a7'
MACRO GetRexxVar(rexxmsg, name, result) IS Stores(rexxmsg,name,result) BUT ASM ' bsr _GetRexxVar' BUT ASM ' lea 12(a7), a7'
MACRO SetRexxVar(rexxmsg, name, value, length) IS Stores(rexxmsg,name,value,length) BUT ASM ' bsr _SetRexxVar' BUT ASM ' lea 16(a7), a7'

/*  Intuition hook and boopsi support functions in amiga.lib. */
/*  These functions do not require any particular ROM revision */
/*  to operate correctly, though they deal with concepts first introduced */
/*  in V36.  These functions would work with compatibly-implemented */
/*  hooks or objects under V34. */

MACRO CallHookA(hookptr, obj, msg) IS Stores(hookptr,obj,msg) BUT ASM ' bsr _CallHookA' BUT ASM ' lea 12(a7), a7'
MACRO CallHook(hookptr, obj,...) IS Stores(hookptr,obj,...) BUT ASM ' bsr _CallHook' BUT Rems(VARARGS+2*4) BUT D0
MACRO DoMethodA(obj, msg) IS Stores(obj,msg) BUT ASM ' bsr _DoMethodA' BUT ASM ' addq.l #8, a7'
MACRO DoMethod(obj, methodid,...) IS Stores(obj,methodid,...) BUT ASM ' bsr _DoMethod' BUT Rems(VARARGS+2*4) BUT D0
MACRO DoSuperMethodA(cl, obj, message) IS Stores(cl,obj,message) BUT ASM ' bsr _DoSuperMethodA' BUT ASM ' lea 12(a7), a7'
MACRO DoSuperMethod(cl, obj, methodid,...) IS Stores(cl,obj,methodid,...) BUT ASM ' bsr _DoSuperMethod' BUT Rems(VARARGS+3*4) BUT D0
MACRO CoerceMethodA(cl, obj, message) IS Stores(cl,obj,message) BUT ASM ' bsr _CoerceMethodA' BUT ASM ' lea 12(a7), a7'
MACRO CoerceMethod(cl, obj, methodid,...) IS Stores(cl,obj,methodid,...) BUT ASM ' bsr _CoerceMethod' BUT Rems(VARARGS+3*4) BUT D0
MACRO SetSuperAttrs(cl, obj, tag1,...) IS Stores(cl,obj,tag1,...) BUT ASM ' bsr _SetSuperAttrs' BUT Rems(VARARGS+3*4) BUT D0

/*  Network-support functions in amiga.lib. */
/*  ACrypt() first appeared in later V39 versions of amiga.lib, but */
/*  operates correctly under V37 and up. */

MACRO ACrypt(buffer, password, username) IS Stores(buffer,password,username) BUT ASM ' bsr _ACrypt' BUT ASM ' lea 12(a7), a7'


