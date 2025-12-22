OPT POWERPC, MODULE, PREPROCESS

-> toolsabox/thread.e by LS 2004

-> v46.     initial version
-> v47.     Bug in NewEnvironment() fixed.
-> v47.     Didnt close "conout" on exit, fixed.
-> 1.5.6:   Now requires ECX 1.5.6


-> ideas:
-> messageToDie(private, msg)
->   [ WaitPort(msg.replyport) ; GetMsg(msg.replyport) ]

-> even better, scrap aboce and use inthe thread a function like:
-> RETURN returnDeathMsg(private, msg)
-> when receiving message of death..
-> the handleDeathMsg() function puts address of message inside
-> the private structure, for later reply by the NP_ExitCode..
-> if this really works that is..

-> July 2008: fied problem with newProcess() in library mode.
-> July 2008: ECX 1.10.0: now makes use of ___initcode global.

MODULE 'morphos/exec/tasks', 'dos/dos', 'utility/tagitem', 'morphos/dos/dostags', 'exec/memory'
MODULE 'dos/dosextens'

#define DEBUGF(str,...) ->DebugF(str,...)

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
   si.globalreg := R13
   si.arg := arg
   si.proc := code
   task := CreateNewProc([NP_ENTRY,{entry},
                          NP_NAME,name,
                          NP_PRIORITY, pri,
                          NP_CodeType, CODETYPE_PPC,
                          NP_PPCStackSize, IF stack THEN stack ELSE 16000,
                          NP_STACKSIZE, 10000,
                          NP_PPC_Arg1, si,
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



PROC entry(si:PTR TO startinfo)
   DEF proc, regs[19]:ARRAY OF LONG, r
   DEF mem:PTR TO LONG, next

   -> save regs
   STMW R13, regs
   -> load global reg
   LWZ R13, .globalreg(R3:startinfo)
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
      FreeVec(___rwdata)
   ENDIF
   -> restore regs
   LMW R13, regs
ENDPROC

EXPORT PROC releaseSuccess(si:PTR TO startinfo,return=NIL)
   si.return := return
   Signal(si.mother, Shl(1,si.mothersignum))
ENDPROC


-> no worky in library mode for now
EXPORT PROC newEnvironment()
   DEF size, mem, newenv
   DEF exec, dos, gfx, intui
   DEF thistask:PTR TO tc, etask:PTR TO etask, init
   size := ___rwdatasize -> 2.0, size now in private global
   mem := AllocVec(size, MEMF_CLEAR OR MEMF_PUBLIC)
   IF mem = NIL THEN RETURN NIL
   exec := execbase
   dos := dosbase
   intui := intuitionbase
   gfx := gfxbase
   thistask := FindTask(0)
   init := ___initcode -> 1.10.0
   init(mem)
   etask := thistask.etask
   execbase := exec
   dosbase := dos
   gfxbase := gfx
   intuitionbase := intui
   ___mempool := etask.mempool
   ___rwdata := mem
   ___stackbottom := etask.ppcsplower
   ___initcode := init
ENDPROC TRUE


