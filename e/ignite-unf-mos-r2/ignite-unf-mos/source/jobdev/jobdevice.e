OPT NOSTARTUP, MORPHOS, EXENAME = 'job.device', PREPROCESS

-> June 2010: OpenDevice unit can now be a previsouly opended unit (by address! (io.unit))
-> otherwise just pass -1 for a new unit.

MODULE 'morphos/exec/libraries'
MODULE 'exec/resident'
MODULE 'exec/io'
MODULE 'exec/lists'
MODULE 'exec/memory'
MODULE 'exec/ports'
MODULE 'exec/nodes'
MODULE 'exec/devices'
MODULE 'exec/errors'
MODULE 'amigalib/boopsi'
MODULE 'morphos/emul/emulregs'
MODULE 'amigalib/lists'
MODULE 'morphos/dos/dostags'
MODULE 'morphos/exec/tasks'
MODULE 'dos/dos'
MODULE 'dos/dosextens'
MODULE 'utility/tagitem'

MODULE '*jobdefs'

#ifdef DEBUG
   #define DEBUGF(str,...) DebugF(str,...)
#else
   #define DEBUGF(str,...)
#endif

ENUM SUBMSG_NONE, SUBMSG_DIE

OBJECT devunit OF mln
   port:PTR TO mp
   opencnt:INT
   priority:INT
   execbase
   dosbase
   currmsg:PTR TO devunit
ENDOBJECT

OBJECT devbase OF lib
   pad2:INT
   seglist:LONG -> unused here
   execbase
   dosbase
   unitlist:mlh
ENDOBJECT

#define DEV_NAME 'job.device'
#define DEV_IDSTR 'job.device by LS ' + _DATE_

CONST DEV_VERSION = 1,
      DEV_REVISION = 0

PROC norun() IS -1

STATIC devname    = DEV_NAME,
       devidstr   = DEV_IDSTR,
       devtag     = [
                 RTC_MATCHWORD,
                 devtag,
                 endskip,
                 RTF_PPC,
                 DEV_VERSION,
                 NT_DEVICE,
                 0,
                 devname,
                 devidstr,
                 sysv_rtinit,
                 0,
                 NIL
                     ]:rt

devFuncTable:
   PTR FUNCARRAY_32BIT_NATIVE
   PTR devOpen, devClose, devExpunge, devExt, devBeginIO, devAbortIO
   PTR -1

endskip:


PROC sysv_rtinit(dum, seglist, execbase)
   DEF device:PTR TO devbase, a, dosbase

   DEBUGF('job.device/init\n')

   dosbase:= OpenLibrary('dos.library', 50)
   IF dosbase = NIL THEN RETURN NIL

   device := MakeLibrary(devFuncTable, NIL, NIL, SIZEOF devbase, NIL)
   IF device = NIL
      CloseLibrary(dosbase)
      RETURN NIL
   ENDIF

   DEBUGF('device=$\h\n', device)
   NewList(device.unitlist)

   device.dosbase := dosbase
   device.execbase := execbase
   device.seglist := seglist

   device.version := DEV_VERSION
   device.revision := DEV_REVISION
   device.flags := LIBF_SUMUSED OR LIBF_CHANGED
   device.ln.name := devname
   device.idstring := devidstr
   device.ln.type := NT_DEVICE

   AddDevice(device)

ENDPROC device

PROC devOpen()
   DEF device:REG, iob:REG PTR TO io, unitnum:REG, flags:REG

   LWZ device, REG_A6
   LWZ iob, REG_A1
   LWZ unitnum, REG_D0
   LWZ flags, REG_D1  -> dont care for now

ENDPROC openJobDevice(device, iob, unitnum, flags)

PROC devClose()
   DEF iob:REG PTR TO io, unit:PTR TO devunit, a

   LWZ iob, REG_A1

ENDPROC closeJobDevice(iob)

PROC devExpunge()
   DEF device:REG PTR TO lib
   LWZ device, REG_A6
   RETURN expungeJobDevice(device)
ENDPROC

PROC devExt()
ENDPROC NIL

PROC devBeginIO()
   DEF device:REG PTR TO devbase, iob:REG PTR TO jobmsg
   DEF execbase, msg:PTR TO jobmsg

   LWZ device, REG_A6
   LWZ iob, REG_A1

   execbase := device.execbase

   DEBUGF('devBeginIO()\n')

   iob.break := NIL

   SELECT iob.io.command
   CASE CMD_RESET   -> abort all requests
      Forbid()
      -> remove and reply all queued ioreqs
      WHILE msg := GetMsg(iob.io.unit::devunit.port)
         msg.io.error := IOERR_ABORTED
         ReplyMsg(msg)
      ENDWHILE
      msg := iob.io.unit::devunit.currmsg
      IF msg THEN msg.break := JMBREAKF_ABORT
      Permit()
   CASE CMD_FLUSH   -> abort all queued requests
      Forbid()
      -> remove and reply all queued ioreqs
      WHILE msg := GetMsg(iob.io.unit::devunit.port)
         msg.io.error := IOERR_ABORTED
         ReplyMsg(msg)
      ENDWHILE
      Permit()
   DEFAULT          -> requests we handle in unit process
      iob.io.flags := NIL -> clear quick bit
      PutMsg(iob.io.unit::devunit.port, iob)
   ENDSELECT

   DEBUGF('devBeginIO() DONE\n')

ENDPROC

PROC devAbortIO()
   DEF iob:REG PTR TO jobmsg
   LWZ iob, REG_A1

   DEBUGF('devAbortIO()\n')

   IF iob.io.mn.ln.type = NT_MESSAGE THEN iob.break := iob.break OR JMBREAKF_ABORT
ENDPROC

EXPORT PROC openJobDevice(device:PTR TO devbase, iob:PTR TO io, unit:PTR TO devunit, flags)
   DEF execbase, dosbase, process

   execbase := device.execbase
   dosbase := device.dosbase

   DEBUGF('internalDevOpen($\h, $\h, \d, $\h)\n', device, iob, unitnum, flags)

   device.opencnt++

   IF unit = -1 -> we want new unit ?
      unit := AllocVec(SIZEOF devunit, MEMF_CLEAR OR MEMF_PUBLIC)
      IF unit = NIL THEN JUMP internaldevopen_err
      AddTail(device.unitlist, unit)
      iob.unit := unit
      unit.execbase := execbase
      unit.dosbase := dosbase
      process := spawnUnitProcess({unitProc}, 0, 'job.device process', unit)
      IF process = NIL THEN JUMP internaldevopen_err
   ELSE
      -> use old unit
      IFN unitexists(device, unit)
         DebugF('job.device/OpenDevice: wrong unit $\h\n', unit)
         unit := NIL
         JUMP internaldevopen_err
      ENDIF
      iob.unit := unit
   ENDIF

   iob.mn.ln.type := NT_REPLYMSG -> for CheckIO/AbortIO/WaitIO
   iob.device := device
   unit.opencnt++

   DEBUGF('internalDevOpen DONE\n')

   RETURN NIL

internaldevopen_err:

   device.opencnt--

   IF unit THEN FreeVec(unit)
   iob.error := -1 -> for now
   iob.device := NIL -> safe to close it anyway

ENDPROC -1

PROC unitexists(device:PTR TO devbase, unit:PTR TO devunit)
   DEF node:PTR TO mln
   node := device.unitlist.head
   WHILE node.succ
      IF node = unit THEN RETURN TRUE
      node := node.succ
   ENDWHILE
ENDPROC FALSE

PROC spawnUnitProcess(code, pri, name, unit:PTR TO devunit)
   DEF task, execbase, dosbase
   DEF tags[16]:ARRAY OF tagitem

   DEBUGF('spawnProcess($\h, \d, "\s", $\h)\n', code,pri,name,unit)

   execbase := unit.execbase
   dosbase := unit.dosbase

   tags[0].tag := NP_ENTRY
   tags[0].data := code
   tags[1].tag := NP_PRIORITY
   tags[1].data := pri
   tags[2].tag := NP_NAME
   tags[2].data := name
   tags[3].tag := NP_CodeType
   tags[3].data := CODETYPE_PPC
   tags[4].tag := NP_PPCStackSize
   tags[4].data := 16000
   tags[5].tag := NP_PPC_Arg1
   tags[5].data := unit
   tags[6].tag := NIL
   tags[6].data := NIL


   task := CreateNewProc(tags)

   IF task
      DEBUGF('spawnProcess: task created, waiting for unit.port\n')
      WHILEN unit.port DO Delay(1)
   ENDIF
   DEBUGF('spawnProcess done: task = $\h, unit.port = $\h\n', task, unit.port)
   IF unit.port = -1 -> error ?
      RemTask(task)
      RETURN NIL
   ENDIF
ENDPROC task


EXPORT PROC closeJobDevice(iob:PTR TO io)
   DEF device:PTR TO devbase, x, execbase

   DEBUGF('internalDevClose($\h)\n', iob)

   device := iob.device

   IF device = NIL THEN RETURN NIL -> alrady closed/never open/failed open

   execbase := device.execbase

   device.opencnt--
   iob.unit.opencnt--

   IF iob.unit.opencnt = 0
      iob.command := SUBMSG_DIE
      PutMsg(iob.unit::devunit.port, iob)
      WaitPort(iob.mn.replyport)
      GetMsg(iob.mn.replyport)
      Remove(iob.unit)
      FreeVec(iob.unit)
   ENDIF

   iob.device := NIL

   IF device.opencnt = 0 THEN RETURN expungeJobDevice(device)

ENDPROC NIL

PROC expungeJobDevice(lib:PTR TO devbase)
   DEF seglist, execbase

   seglist := lib.seglist
   execbase := lib.execbase

   IF lib.opencnt > 0
      lib.flags OR= LIBF_DELEXP
      RETURN NIL
   ENDIF

   CloseLibrary(lib.dosbase)
   Remove(lib)
   FreeMem(lib - lib.negsize, lib.negsize + lib.possize)

ENDPROC seglist


PROC unitProc(unit:PTR TO devunit)
   DEF msg:PTR TO jobmsg, func(PTR), execbase, process:PTR TO process

   DEBUGF('subtask init!\n')

   execbase := unit.execbase

   process := FindTask(NIL)

   ->unit.port := process.msgport  OOPS breaks if func() uses pr_msgport!
   unit.port := CreateMsgPort()

   IFN unit.port
      unit.port := -1
      RETURN NIL
   ENDIF

   SetTaskPri(FindTask(NIL), unit.priority)

   DEBUGF('subtask running!\n')

   LOOP
      WaitPort(unit.port)
      WHILE (msg := GetMsg(unit.port))
         IF msg.io.command = SUBMSG_DIE
            DeleteMsgPort(unit.port)
            Forbid()
            ReplyMsg(msg)
            RETURN NIL
         ELSE
            unit.currmsg := msg
            IF msg.priority <> unit.priority
               unit.priority := msg.priority
               SetTaskPri(FindTask(NIL), msg.priority)
            ENDIF
            DEBUGF('unitProcess: func()\n')
            func := msg.jobfunc
            func(msg)
            unit.currmsg := NIL
            ReplyMsg(msg)
            DEBUGF('unitProcess: func() DONE\n')
         ENDIF
      ENDWHILE
   ENDLOOP

ENDPROC NIL

