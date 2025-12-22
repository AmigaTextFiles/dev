OPT AMIGAOS4, MODULE, PREPROCESS

-> tools/thread.e by LS 2004-2008



-> July 2008: fied problem with newProcess() in library mode.
-> July 2008: ECX 1.10.0: now makes use of ___initcode global.
-> October 2008: OS4 version, uses new ___rwdatasize.

MODULE 'exec/tasks', 'dos/dos', 'utility/tagitem', 'dos/dostags', 'exec/memory'
MODULE 'dos/dosextens', 'exec/execbase'

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

   si := AllocMem(SIZEOF startinfo, MEMF_CLEAR OR MEMF_SHARED)
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
                          NP_STACKSIZE, IF stack THEN stack ELSE 16000,
                          NP_UserData, si,
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



PROC entry(argstr,arglen,execbase:PTR TO execbase)
   DEF proc, regs[19]:ARRAY OF LONG, r
   DEF mem:PTR TO LONG, next, si:PTR TO startinfo
   DEF execiface, r13, tc:PTR TO tc
   -> save regs
   STMW R13, regs

   execiface := execbase.maininterface

   -> get userdata
   tc := FindTask(NIL)
   si := tc.userdata

   -> get global reg
   r13 := si.globalreg
   LWZ R13, r13

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
      DeletePool(___mempool)
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
   DEF execi, dosi, gfxi, intuii
   DEF thistask:PTR TO tc, init
   size := ___rwdatasize -> 2.0, size now in private global
   mem := AllocVec(size, MEMF_CLEAR OR MEMF_SHARED)
   IF mem = NIL THEN RETURN NIL
   exec := execbase
   dos := dosbase
   intui := intuitionbase
   gfx := gfxbase

   execi := execiface
   dosi := dosiface
   gfxi := gfxiface
   intuii := intuitioniface

   thistask := FindTask(0)
   init := ___initcode -> 1.10.0
   init(mem)

   execbase := exec
   dosbase := dos
   gfxbase := gfx
   intuitionbase := intui

   execiface:= execi
   dosiface := dosi
   gfxiface := gfxi
   intuitioniface := intuii

   ___mempool := CreatePool(NIL, 4096, 256)
   IFN ___mempool
      FreeVec(mem)
      RETURN NIL
   ENDIF
   ___rwdata := mem
   ___rwdatasize  := size
   ___stackbottom := thistask.splower
   ___initcode := init
ENDPROC TRUE


