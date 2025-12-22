OPT MODULE, AMIGAOS4, PREPROCESS

-> amigaos4/other/ecode.e

-> 68k version by Jason R Hulance 1995 (UsefulV2)

-> October 2008: OS4 version by LS.  *UNDER CONSTRUCTION*

OBJECT gate
   jump:LONG
   func:LONG
   oldr13
   stubcode[0]:ARRAY OF LONG
ENDOBJECT
-> ppc stub proc follows directly after


MODULE 'exec/memory',
       'exec/execbase',
       'hardware/custom',
       'powerpc/simple'

/*
** NOTE!
** eCodeTask() returns a powerpc entry. do not feed result to any old code that wants a 68k entry!
** eCodePPC() is like eCode() but returns a real PPC entry instead of a gated entry.
**
** The "func" argument to below functions is always a ppc procedure.
*/

-> Wraps an E function so it can still access globals, even from other tasks.
EXPORT PROC eCode(func) IS setup(func,{entry},{end})

-> Wraps an E function so it can still access globals, even from other (PPC!) tasks.
EXPORT PROC eCodePPC(func) IS eCode(func)

-> Wraps an E function as above, but also preserves the non-scratch registers. (ppc=same as eCode())
EXPORT PROC eCodePreserve(func) IS eCode(func)

-> Wraps an E function for use with aboxlib/tasks.m/createTask()
EXPORT PROC eCodeTask(func) IS eCode(func)

-> rest is unimplemented for now.

EXPORT PROC eCodeDispose(mem) IS IF mem THEN Dispose(mem) ELSE NIL

PROC setup(func, addr, end) HANDLE
  DEF mem:PTR TO gate, len
  len := end-addr
  mem:=NewM(SIZEOF gate + len, MEMF_EXECUTABLE OR MEMF_SHARED)
  mem.jump := 18 SHL 26 OR SIZEOF gate
  mem.func := func
  mem.oldr13 := R13
  -> Fully relocatable code can be copied to another memory location
  CopyMemQuick(addr, mem.stubcode, len)
  CacheClearU()
  RETURN mem
EXCEPT
  RETURN NIL
ENDPROC

PROC entry()
  DEF r13
  STW R13, r13
  LA R12, entry
  LWZ R13, -4(R12)
  LWZ R0, -8(R12)
  MTCTR R0
  BCTRL -> call function
  LWZ R13, r13
ENDPROC R3
end:




