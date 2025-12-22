OPT MODULE, POWERPC, MORPHOS, PREPROCESS

-> ECX:modules/otherabox/ecode.e

-> 68k version by Jason R Hulance 1995 (UsefulV2)
-> ppc rewrite by Leif Salomonsson 2007

-> March 2008: eCodePPC() trashed R3, breaking possible arguments, fixed. (LS).

-> July 2008: arguments where completely broken, seems 68k stack has had
-> return address poped away when we end up in ppc code.. fixed.
-> (args start at 0(REG_A7) now).

-> January 2009: fixed sEntry (interrupt server). zeroflag was set for *non* zero return..


OBJECT gate
   trapcode:LONG
   trapfunc
   function
   oldr13
   stubcode[0]:ARRAY OF LONG
ENDOBJECT
-> ppc stub proc follows directly after


MODULE 'morphos/exec',
       'exec/memory',
       'exec/execbase',
       'hardware/custom',
       'morphos/emul/emulinterface',
       'morphos/emul/emulregs',
       'powerpc/simple'

/*
** NOTE!
** eCodeTask() returns a powerpc entry. do not feed result to any old code that wants a 68k entry!
** eCodePPC() is like eCode() but returns a real PPC entry instead of a gated entry.
**
** The "func" argument to below functions is always a ppc procedure.
*/

-> Wraps an E function so it can still access globals, even from other tasks.
EXPORT PROC eCode(func) IS setup(func,{entry},{end}, TRAP_LIB)

-> Wraps an E function so it can still access globals, even from other (PPC!) tasks.
EXPORT PROC eCodePPC(func) IS setup(func,{entry},{end}, NIL)

-> Wraps an E function as above, but also preserves the non-scratch registers. (ppc=same as eCode())
EXPORT PROC eCodePreserve(func) IS eCode(func)

-> Wraps an E function for use with aboxlib/tasks.m/createTask()
EXPORT PROC eCodeTask(func) IS eCodePPC(func)

-> Wraps an E function for use as an ASL hook
EXPORT PROC eCodeASLHook(func) IS setup(func,{aEntry},{aEnd}, TRAP_LIB)

-> Wraps an E function for use as an CX custom function
EXPORT PROC eCodeCxCustom(func) IS setup(func,{cEntry},{cEnd}, TRAP_LIB)

-> Wraps an E function for use as a GEL collision function
EXPORT PROC eCodeCollision(func) IS eCodeCxCustom(func)

-> Wraps an E function for use as an interrupt handler
EXPORT PROC eCodeIntHandler(func) IS setup(func,{hEntry},{hEnd}, TRAP_LIB)

-> Wraps an E function for use as an interrupt server
EXPORT PROC eCodeIntServer(func) IS setup(func,{sEntry},{sEnd}, TRAP_LIBD0D1A0A1SR)

-> Wraps an E function for use as a software interrupt
EXPORT PROC eCodeSoftInt(func) IS setup(func,{iEntry},{iEnd}, TRAP_LIB)

-> Wraps an E function as eCode(), but swaps the order of two args
EXPORT PROC eCodeSwapArgs(func) IS setup(func,{oEntry},{oEnd}, TRAP_LIB)

EXPORT PROC eCodeDispose(mem) IS IF mem THEN Dispose(mem) ELSE NIL

PROC setup(func, addr, end, trapcode) HANDLE
  DEF mem:PTR TO gate, len
  len := end-addr
  mem:=NewM(SIZEOF gate + len, MEMF_PUBLIC)
  mem.trapcode := IF trapcode THEN trapcode SHL 16 ELSE 18 SHL 26 OR SIZEOF gate
  mem.trapfunc := mem.stubcode
  mem.function := func
  mem.oldr13 := R13
  -> Fully relocatable code can be copied to another memory location
  CopyMemQuick(addr, mem.stubcode, len)
  CacheFlushDataInstArea(mem,SIZEOF gate + len)
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


PROC aEntry()
  DEF r13
  LWZ R6, REG_A7
  LWZ R3, 0(R6)
  LWZ R4, 4(R6)
  LWZ R5, 12(R6)
  LA R7, aEntry
  STW R13, r13
  LWZ R13, -4(R7)
  LWZ R0, -8(R7)
  MTCTR R0
  BCTRL
  LWZ R13, r13
ENDPROC R3
aEnd:

PROC cEntry()
  DEF r13
  LWZ R6, REG_A7
  LWZ R3, 0(R6)
  LWZ R4, 4(R6)
  LA R7, cEntry
  STW R13, r13
  LWZ R13, -4(R7)
  LWZ R0, -8(R7)
  MTCTR R0
  BCTRL
  LWZ R13, r13
ENDPROC R3
cEnd:


PROC hEntry()
   DEF r13
   LA R5, hEntry
   STW R13, r13
   LWZ R13, -4(R5)
   LWZ R3, REG_A1
   LWZ R4, REG_D1
   LWZ R0, -8(R5)
   MTCTR R0
   BCTRL
   LWZ R13, r13
ENDPROC R3
hEnd:


PROC sEntry()
   DEF r13, x, sr
   LA R5, sEntry
   STW R13, r13
   LWZ R13, -4(R5)
   LWZ R3, REG_A1
   LWZ R0, -8(R5)
   MTCTR R0
   BCTRL
   ->LIW R4, CUSTOMADDR   -> not needed on morphos
   ->STW R4, REG_A0
   x := R3
   sr := IFN x THEN 4 ELSE 0   -> set zero flag ifn x
   LWZ R0, sr
   STW R0, REG_SR -> return zero flag
   LWZ R13, r13
ENDPROC
sEnd:

PROC iEntry()
   DEF r13, a6
   LA R5, iEntry
   STW R13, r13
   LWZ R13, -4(R5)
   LWZ R3, REG_A1
   LWZ R0, REG_A6
   STW R0, a6
   LWZ R0, -8(R5)
   MTCTR R0
   BCTRL
   LWZ R0, a6
   STW R0, REG_A6
   LWZ R13, r13
ENDPROC R3
iEnd:

PROC oEntry()
  DEF r13
  LWZ R5, REG_A7
  LWZ R3, 0(R5)
  LWZ R4, 4(R5)
  LA R7, oEntry
  STW R13, r13
  LWZ R13, -4(R7)
  LWZ R0, -8(R7)
  MTCTR R0
  BCTRL
  LWZ R13, r13
ENDPROC R3
oEnd:


