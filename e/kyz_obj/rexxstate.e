OPT MODULE
OPT PREPROCESS

MODULE 'rexxsyslib', 'dos/dostags', 'exec/ports', 'rexx/rxslib', 'rexx/storage'

DEF rexxsysbase:PTR TO rxslib -> local copy of rexxsysbase

RAISE "LIB" IF OpenLibrary()=NIL

/****** rexxstate.m/--overview-- *******************************************
*
*   PURPOSE
*	To control the global aspects of the ARexx system.
*
*   OVERVIEW
*	ARexx  is  an  interpreter program which has the ability to trace,
*	start,  pause,  and  cancel  the  ARexx scripts that it runs. This
*	object allows you to control these global ARexx processes:
*
*	- whether ARexx is running or not (RexxMast / RXC)
*	  running(), start(), shutdown()
*	- whether ARexx scripts are suspended or not
*	  suspended(), suspend(), resume()
*	- whether the ARexx console is open or not (TCO/TCC)
*	  console_open(), open_console(), close_console()
*	- whether ARexx is running in trace mode or not (TS/TE).
*	  tracing(), trace_on(), trace_off()
*
*	There  is  also  a method to immediately and irreversibly halt all
*	running ARexx programs, which simulates the HI command.
*
*   NOTE
*	The  state  of  ARexx  is global, and this class respects that, it
*	shows  and sets this global ARexx state, it does not hold seperate
*	states  in  individual  instances of the class, so therefore using
*	more than one instance does not make sense, and is unneccessary.
*
*	This class is based on the guts of commands in SYS:RexxC/
*
*	Still todo is RXSET, RX is done by other/sendrexx.m and
*	WaitForPort / RXLIB aren't all that useful?!
*
****************************************************************************
*
*
*/

EXPORT OBJECT rexxstate
ENDOBJECT

/****** rexxstate.m/new *******************************************
*
*   NAME
*	rexxstate.new() -- Constructor.
*
*   SYNOPSIS
*	new()
*
*   FUNCTION
*	Initialises an instance of the rexxstate class. Raises "LIB" if it
*	cannot open 'rexxsyslib.library' version 33 or better.
*
*   SEE ALSO
*	end()
*
****************************************************************************
*
*
*/

EXPORT PROC new() OF rexxstate IS rexxsysbase := OpenLibrary(RXSNAME, 33)

/****** rexxstate.m/end *******************************************
*
*   NAME
*	rexxstate.end() -- Destructor.
*
*   SYNOPSIS
*	end()
*
*   FUNCTION
*	Closes resources used by an instance of the rexxstate class.
*
*   SEE ALSO
*	new()
*
****************************************************************************
*
*
*/

EXPORT PROC end() OF rexxstate IS CloseLibrary(rexxsysbase)



/****** rexxstate.m/running ******************************************
*
*   NAME
*	rexxstate.running() -- test if ARexx is running.
*
*   SYNOPSIS
*	running := running()
*
*   FUNCTION
*	Determines whether ARexx is running or not.
*
*   RESULT
*	running - TRUE if RexxMast is running, FALSE otherwise.
*
*   SEE ALSO
*	start(), shutdown()
*
******************************************************************************
*
*/

EXPORT PROC running() OF rexxstate IS
 IF port() THEN getflag(RLFB_CLOSE)=0 ELSE FALSE

/****** rexxstate.m/start ******************************************
*
*   NAME
*	rexxstate.start() -- start up ARexx.
*
*   SYNOPSIS
*	succeeded := start()
*
*   FUNCTION
*	Starts up the RexxMast program, which starts the ARexx system.
*
*   RESULT
*	succeeded - TRUE if RexxMast is now running, FALSE otherwise.
*
*   SEE ALSO
*	shutdown(), running()
*
******************************************************************************
*
*/

EXPORT PROC start() OF rexxstate
  DEF n

  IF self.running() = TRUE THEN RETURN TRUE

  -> attempt to start RexxMast (0=success)
  IF n := SystemTagList('RexxMast', NIL) THEN
     n := SystemTagList('SYS:System/RexxMast', NIL)

  -> if we succeeded in starting a program called RexxMast
  -> then wait for port to show up or timeout after 10 seconds
  IF n = 0
    n := 50; WHILE (port() = NIL) AND (n > 0) DO Delay(n-- BUT 10)
  ENDIF
ENDPROC self.running()

/****** rexxstate.m/shutdown ******************************************
*
*   NAME
*	rexxstate.shutdown() -- shut down ARexx.
*
*   SYNOPSIS
*	succeeded := shutdown()
*
*   FUNCTION
*	Shuts down ARexx.
*
*   RESULT
*	succeeded - TRUE if ARexx stops running, FALSE otherwise.
*
*   SEE ALSO
*	start(), running()
*
******************************************************************************
*
*/

EXPORT PROC shutdown() OF rexxstate IS send_msg(RXCLOSE)


/****** rexxstate.m/suspended ******************************************
*
*   NAME
*	rexxstate.suspended() -- check if ARexx programs are suspended.
*
*   SYNOPSIS
*	suspended := suspended()
*
*   FUNCTION
*	Checks if ARexx is currently running its programs or not.
*
*   RESULT
*	suspended - TRUE if ARexx is suspending programs, otherwise FALSE.
*
*   SEE ALSO
*	suspend(), resume()
*
******************************************************************************
*
*/
/****** rexxstate.m/suspend ******************************************
*
*   NAME
*	rexxstate.suspend() -- suspend the running of ARexx programs.
*
*   SYNOPSIS
*	success := suspend()
*
*   FUNCTION
*	Puts all running ARexx programs on hold.
*
*   RESULT
*	success - TRUE if ARexx programs are now suspended, otherwise FALSE.
*
*   SEE ALSO
*	suspended(), resume()
*
******************************************************************************
*
*/
/****** rexxstate.m/resume ******************************************
*
*   NAME
*	rexxstate.resume() -- resume running ARexx programs.
*
*   SYNOPSIS
*	success := resume()
*
*   FUNCTION
*	Lets ARexx program execution continue.
*
*   RESULT
*	success - TRUE if ARexx programs are now running, otherwise FALSE.
*
*   SEE ALSO
*	suspended(), suspend()
*
******************************************************************************
*
*/

EXPORT PROC suspended() OF rexxstate IS getflag(RLFB_SUSP)
EXPORT PROC suspend()   OF rexxstate IS setflag(RLFB_SUSP, TRUE)
EXPORT PROC resume()    OF rexxstate IS setflag(RLFB_SUSP, FALSE)

/****** rexxstate.m/tracing ******************************************
*
*   NAME
*	rexxstate.tracing() -- check if ARexx trace mode is on.
*
*   SYNOPSIS
*	tracing := tracing()
*
*   FUNCTION
*	Checks if ARexx is in trace mode or not.
*
*   RESULT
*	tracing - TRUE if ARexx is in trace mode, otherwise FALSE.
*
*   SEE ALSO
*	trace_on(), trace_off()
*
******************************************************************************
*
*/
/****** rexxstate.m/trace_on ******************************************
*
*   NAME
*	rexxstate.trace_on() -- turn ARexx trace mode on.
*
*   SYNOPSIS
*	success := trace_on()
*
*   FUNCTION
*	Turns  ARexx  trace  mode  on.  Program execution flow will now be
*	listed  to  the  trace  console (if it is open) or to the standard
*	output of the programs in question.
*
*   RESULT
*	success - TRUE if ARexx is now in trace mode, otherwise FALSE.
*
*   SEE ALSO
*	tracing(), trace_off()
*
******************************************************************************
*
*/
/****** rexxstate.m/trace_off ******************************************
*
*   NAME
*	rexxstate.trace_off() -- turn ARexx trace mode off.
*
*   SYNOPSIS
*	success := trace_off()
*
*   FUNCTION
*	Turns ARexx trace mode off.
*
*   RESULT
*	success - TRUE if ARexx is now out of trace mode, otherwise FALSE.
*
*   SEE ALSO
*	tracing(), trace_on()
*
******************************************************************************
*
*/

EXPORT PROC tracing()   OF rexxstate IS getflag(RLFB_TRACE)
EXPORT PROC trace_on()  OF rexxstate IS setflag(RLFB_TRACE, TRUE)
EXPORT PROC trace_off() OF rexxstate IS setflag(RLFB_TRACE, FALSE)

/****** rexxstate.m/console_open ******************************************
*
*   NAME
*	rexxstate.console_open() -- check if ARexx trace console is open.
*
*   SYNOPSIS
*	open := console_open()
*
*   FUNCTION
*	Checks if the ARexx trace and debugging console is open or not.
*
*   RESULT
*	open - TRUE if the console is open, otherwise FALSE.
*
*   SEE ALSO
*	open_console(), close_console()
*
******************************************************************************
*
*/
/****** rexxstate.m/open_console ******************************************
*
*   NAME
*	rexxstate.open_console() -- open the ARexx trace console.
*
*   SYNOPSIS
*	succeeded := open_console()
*
*   FUNCTION
*	Opens the ARexx trace and debugging console, like the TCO command.
*
*   RESULT
*	succeeded - TRUE if the console is now open, otherwise FALSE.
*
*   SEE ALSO
*	console_open(), close_console()
*
******************************************************************************
*
*/
/****** rexxstate.m/close_console ******************************************
*
*   NAME
*	rexxstate.close_console() -- close the ARexx trace console.
*
*   SYNOPSIS
*	succeeded := close_console()
*
*   FUNCTION
*	Shuts the ARexx trace and debugging console, like the TCC command.
*
*   RESULT
*	succeeded - TRUE if the console is now shut, otherwise FALSE.
*
*   SEE ALSO
*	console_open(), open_console()
*
******************************************************************************
*
*/

EXPORT PROC console_open()  OF rexxstate IS rexxsysbase.tracefh <> NIL
EXPORT PROC open_console()  OF rexxstate IS send_msg(RXTCOPN)
EXPORT PROC close_console() OF rexxstate IS send_msg(RXTCCLS)

/****** rexxstate.m/halt ******************************************
*
*   NAME
*	rexxstate.halt() -- end all currently running ARexx programs.
*
*   SYNOPSIS
*	halt()
*
*   FUNCTION
*	Halts  all  currently  running  ARexx programs and ends them. When
*	this returns, all programs are most likely to be in the process of
*	ending. This does not shut down ARexx.
*
******************************************************************************
*
*/

EXPORT PROC halt() OF rexxstate IS setflag(RLFB_HALT, TRUE)

->----------------------------------------------------------------------------

PROC port() IS FindPort(RXSDIR)

PROC setflag(flag, state)
  DEF p:PTR TO mp
  Forbid()
  LockRexxBase(0)
  IF state
    rexxsysbase.flags := rexxsysbase.flags OR Shl(1, flag)
  ELSE
    rexxsysbase.flags := rexxsysbase.flags AND Not(Shl(1, flag))
  ENDIF    
  UnlockRexxBase(0)
  IF p := port() THEN Signal(p.sigtask, Shl(1, p.sigbit))
  Permit()
ENDPROC p <> NIL

PROC getflag(flag)
  DEF ret
  LockRexxBase(0)
  ret := rexxsysbase.flags AND Shl(1, flag)
  UnlockRexxBase(0)
ENDPROC ret <> 0

PROC send_msg(action)
  DEF msg:PTR TO rexxmsg, p:PTR TO mp, res=FALSE

  IF msg := CreateRexxMsg(NIL, NIL, NIL)
    msg.action := action OR RXFF_NONRET
    Forbid()
    IF p := port()
      PutMsg(p, msg)
      res := TRUE
    ENDIF
    Permit()
  ENDIF
ENDPROC res
