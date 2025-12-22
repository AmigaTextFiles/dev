OPT MODULE, PREPROCESS

-> toolsabox/thread.e 68k version by LS 2004-07
-> July 2008: fixed newProcess() problem in library mode.
-> July 2008: ECX 1.10.0: now makes use of ___initcode global.

-> todo: make 100% reentrant like abox version

MODULE 'exec/tasks', 'dos/dos', 'utility/tagitem',
       'dos/dostags', 'exec/memory'
MODULE 'dos/dosextens'

#ifdef DEBUG
   #define DEBUGF(str,...) DebugF(str,...)
#else
   #define DEBUGF(str,...)
#endif

OBJECT startinfo
   mother:PTR TO tc
   mothersignum:LONG
   err:LONG
   return:LONG
   globalreg:LONG
   arg:LONG
   proc:LONG
ENDOBJECT


-> returns task/NIL, return/error
-> caller MUST have valid global environment set up !
EXPORT PROC newProcess(code, pri, name, arg, stack=NIL, tags=NIL) HANDLE
   DEF si=NIL:PTR TO startinfo, task, err

   si := AllocMem(SIZEOF startinfo, MEMF_CLEAR OR MEMF_PUBLIC)
   IF si = NIL
      err := "MEM"
      JUMP np_err
   ENDIF

   si.mother := FindTask(0)
   si.mothersignum := AllocSignal(-1)
   IF si.mothersignum = -1
      err := "SIG"
      JUMP np_err
   ENDIF
   si.globalreg := A4
   si.arg := arg
   si.proc := code
   PutLong({sistore}, si)
   task := CreateNewProc([NP_ENTRY,{entry},
                          NP_NAME,name,
                          NP_PRIORITY, pri,
                          NP_STACKSIZE, IF stack THEN stack ELSE 10000,
                          IF tags = NIL THEN TAG_DONE ELSE TAG_MORE,
                          tags])

   IF task = NIL
      err := "PROC"
      JUMP np_err
   ENDIF

   Wait(Shl(1,si.mothersignum))

   IF si.err
      err := si.err
   ELSE
      FreeSignal(si.mothersignum)
      RETURN task, si.return
   ENDIF

np_err:

   IF si
      IF si.mothersignum <> -1 THEN FreeSignal(si.mothersignum)
      FreeMem(si, SIZEOF startinfo)
   ENDIF

ENDPROC NIL, err


sistore: LONG 0
PROC entry()
   DEF si:PTR TO startinfo
   DEF proc, regs[19]:ARRAY OF LONG, r
   DEF mem:PTR TO LONG, next

   -> save regs
   ->MOVEM.L D2-D7/A2-A6, -(A7)
   -> load global reg
   MOVE.L sistore, A0
   MOVE.L A0, si
   MOVE.L .globalreg(A0:startinfo), A4
   -> call thread procedure
   proc := si.proc
   DEBUGF('proc(si=$\h, si.arg=$\h)\n', si, si.arg)
   r := proc(si, si.arg)

   -> make sure mother task is not doing anything
   Forbid()
   IF r
      -> signal on error
      si.err := r
      Signal(si.mother, Shl(1,si.mothersignum))
   ELSE
      -> free on success
      FreeMem(si, SIZEOF startinfo)
   ENDIF
   -> new environment to free ?
   IF (arg = NIL) AND (librarybase = NIL)
      mem := ___memlist
      WHILE mem
         next := mem[]
         FreeMem(mem, mem[1])
         mem := next
      ENDWHILE
      IF conout
         Read(conout,0,0)
         Close(conout)
      ENDIF
      IF ___mempool THEN DeletePool(___mempool)
      FreeVec(___rwdata)
   ENDIF
   -> restore regs
   ->MOVEM.L (A7)+, D2-D7/A2-A6
ENDPROC

EXPORT PROC releaseSuccess(si:PTR TO startinfo,return=NIL)
   si.return := return
   Signal(si.mother, Shl(1,si.mothersignum))
ENDPROC


/* call this to get new (cleared) global environment */
/* does not work in libraries */
EXPORT PROC newEnvironment()
   DEF size, mem, newenv
   DEF exec, dos, gfx, intui
   DEF thistask:PTR TO tc, mempool, init
   size := ___rwdatasize -> 2.0
   mem := AllocVec(size, MEMF_CLEAR OR MEMF_PUBLIC)
   IF mem = NIL THEN RETURN NIL
   mempool := CreatePool(MEMF_CLEAR OR MEMF_PUBLIC, 4096, 4096)
   IF mempool = NIL
      FreeVec(mem)
      RETURN NIL
   ENDIF
   thistask := FindTask(0)
   exec := execbase
   dos := dosbase
   intui := intuitionbase
   gfx := gfxbase
   init := ___initcode -> 1.10.0
   init(mem)
   execbase := exec
   dosbase := dos
   gfxbase := gfx
   intuitionbase := intui
   ___mempool := mempool
   ___rwdata := mem
   ___rwdatasize := size -> 2.0
   ___stackbottom := thistask.splower
   ___initcode := init
ENDPROC TRUE



