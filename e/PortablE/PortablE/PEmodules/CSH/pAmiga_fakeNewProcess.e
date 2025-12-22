/* CSH/pAmiga_fakeNewProcess.e 01-04-2013
	A kludge to work-around C++ not working reliably with CreateNewProc().
	Copyright (c) 2010, 2011, 2012, 2013 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/
/*
Note that this has the same procedure interface as in the pAmiga_realNewProcess
module, which does use CreateNewProc().  The *only* differences are:

1.  Your new process does not share global variables; so you must pass a pointer
to your state using "parameter".

2.  For new processes, the FINALLY in your main() will be executed without any
of your previous main() code being executed.  This should not normally be a
problem, since PTRs will still be NIL.

3.  Each process must NOT deallocate memory allocated by another process.
*/

OPT INITLAST
OPT PREPROCESS
OPT POINTER
MODULE 'dos', 'exec', 'wb', 'utility/tagitem'
MODULE 'utility'	->for GetTagData()
MODULE 'std/pShell', 'std/pCallback', 'CSH/pAmigaDos'

/*****************************/

OBJECT processInfo
	input  :BPTR
	output :BPTR
->#	program:BPTR
	
	->parameters
	procedure:PTR
	name:ARRAY OF CHAR
	parameter
	priority
	
	->return info
	process:PTR TO process
ENDOBJECT

DEF magicCookie:ARRAY OF CHAR
DEF childParam=0
DEF programLock:BPTR

PROC createChildProcessFake(procedure:PTR, parameter=0, name=NILA:ARRAY OF CHAR, tagList=NILA:ARRAY OF tagitem) RETURNS child:PTR TO process
	DEF parent:PTR TO tc, info:OWNS PTR TO processInfo, infoValue[9]:STRING, cmd:STRING, error
	
	info := NIL
	
	utilitybase := OpenLibrary(utilityname, 0)
	parent := FindTask(NILA)
	
	->store parameters in object
	NEW info
	info.procedure := procedure - CALLBACK dummy()
	info.name      := name
	info.parameter := parameter
	
	->launch self with object as parameter
	info.input    := Open('CONSOLE:', MODE_OLDFILE)		->was '*' not 'CONSOLE:'
	info.output   := Open('CONSOLE:', MODE_NEWFILE)
->#	info.program  := programLock
	info.process  := NIL
	info.priority := IF tagList THEN GetTagData(NP_PRIORITY, parent.ln.pri, tagList) ELSE parent.ln.pri
	StringF( infoValue, '$\h', info)
	cmd := StrJoin('"', programPathFromLock(), '" ', magicCookie, infoValue, '\n')
	error := SystemTagList(cmd, [
		SYS_ASYNCH, TRUE,
		SYS_INPUT,  info.input,
		SYS_OUTPUT, info.output,
		IF name THEN NP_NAME ELSE TAG_IGNORE, name,
		IF tagList THEN TAG_MORE ELSE TAG_END, tagList
	]:tagitem)
	
	IF error = -1
		Close(info.input)
		Close(info.output)
		RETURN NIL
	ENDIF
	
	/*
	->launch self with object as parameter
	info.process := NIL
	StringF( infoValue, '$\h', info)
	cmd := StrJoin('Run <>Nil: "', programPathFromLock(), '" ', magicCookie, infoValue, '\n')
	SystemTagList(cmd, [
		IF name THEN NP_NAME ELSE TAG_IGNORE, name,
		IF tagList THEN TAG_MORE ELSE TAG_END, tagList
	]:tagitem)
	*/
	
	/*
	DEF stackValue[10]:STRING
	
	->launch self with object as parameter
	info.process := NIL
	StringF( infoValue, '$\h', info)
	StringF(stackValue,  '\d', stack)
	cmd := StrJoin('Stack ', stackValue, '\nRun <>Nil: "', programPathFromLock(), '" ', magicCookie, infoValue, '\n')
	IF ExecuteCommand(cmd) = FALSE THEN RETURN NIL
	
	->restore the (approximate) old stack value
	StringF(stackValue, '\d', StackSize())
	cmd := StrJoin('Stack ', stackValue, '\n')
	ExecuteCommand(cmd)
	*/
	
	->wait for executable to read object & store it's own process in the object
	REPEAT
		Delay(5)	->1/10th of second
		child := info.process
	UNTIL (child <> NIL) OR CtrlC()
FINALLY
	END cmd, info
	CloseLibrary(utilitybase)
ENDPROC

PROC infoParameterOfChildProcessFake() RETURNS parameter
	parameter := childParam
ENDPROC


PROC new()
	DEF abort:BOOL, /*conHandle:PTR,*/ oldLnName:ARRAY OF CHAR
	DEF params:ARRAY OF CHAR, infoValue[9]:STRING, info:PTR TO processInfo
	DEF procedure:PTR, name:OWNS STRING, parameter, priority, process:PTR TO process
	
	abort := FALSE
	/*conHandle := NIL*/
	magicCookie := '\x80!"£$%^&'
	
	params := ShellArgs()
	IF StrCmp(params, magicCookie, StrLen(magicCookie))
		->(executable was launched by createChildProcessFake()) so redirect I/O from NIL: back to CON:
		/*
		conHandle := OpenInOut('CON:////Output window/WAIT/CLOSE/AUTO/SCREEN *')			->I could put "name" in the window title...
		SetStdOut(conHandle)
		->SetStdIn(conHandle)	->using the same handle twice may be bad, according to SystemTagList() anyway...
		*/
		
		->decode parameter
		StrCopy(infoValue, params, ALL, StrLen(magicCookie))
		info := Val(infoValue) !!PTR
		
		->duplicate the caller's program lock
->#		programLock := DupLock(info.program)
		->obtain a lock, so that child can also call createChildProcessFake()
		programLock := Lock(programPath(), ACCESS_READ)
		
		->copy parameters from object
		procedure := info.procedure + CALLBACK dummy()
		name      := IF info.name THEN StrJoin(info.name) ELSE NILS
		parameter := info.parameter
		priority  := info.priority
		
		->tell caller/parent we are done
		process := FindTask(NILA) !!PTR
		info.process := process
		
		->execute the procedure
		IF name
			oldLnName := process.task.ln.name
			IF StrCmp(name, oldLnName)
				END name
			ELSE
				process.task.ln.name := name
			ENDIF
		ENDIF
		#ifdef pe_TargetOS_AROS
			->(AROS's SystemTagList() seems to ignore NP_PRIORITY)
			SetTaskPri(FindTask(NILA), priority)
		#endif
		
		childParam := parameter
		call0empty(procedure)
		
		IF name
			process.task.ln.name := oldLnName
		ENDIF
		
		->prevent main program from ever running (a slightly dodgy hack)
		abort := TRUE
	ELSE
		->(executable was launched by user) so lock program executable to prevent createChildProcessFake() from being able to fail
		programLock := Lock(programPath(), ACCESS_READ)
	ENDIF
FINALLY
	END name
	/*IF conHandle THEN CloseInOut(conHandle)*/
	
	IF abort THEN Raise(0)
ENDPROC

PROC end()
	IF programLock THEN UnLock(programLock)
ENDPROC

PRIVATE

PROC dummy()
ENDPROC

PROC programPath() RETURNS path:OWNS STRING
	DEF progName:OWNS STRING, progDirLock:BPTR, temp:OWNS STRING
	
	->retrieve our program's path
	IF wbmessage
		->(run from Workbench)
		path := pathOfWbArg(wbmessage.arglist[0])
	ELSE
		->(run from Shell)
		IF temp := strSafeGetProgramName()
			progName, path := splitPath(temp)
			END temp
		ENDIF
		
		progDirLock := GetProgramDir()
		
		IF (progDirLock <> 0) AND (progName <> NILS)
			path := fullPath(progDirLock, progName)
		ENDIF
	ENDIF
ENDPROC


PROC programPathFromLock() RETURNS path:OWNS STRING
	IF programLock = NIL THEN Throw("EPU", 'pAmiga_fakeNewProcess; programPathFromLock(); missing lock')
	
	path := strSafeNameFromLock(programLock)
	IF path = NILS THEN Throw("BUG", 'pAmiga_fakeNewProcess; programPathFromLock(); failed to get path from program lock')
ENDPROC

PUBLIC
