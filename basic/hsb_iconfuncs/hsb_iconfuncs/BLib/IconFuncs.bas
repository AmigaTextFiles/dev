'' $Id: IconFunc.bas, V1.4 1998-01-03 $
'' $VER: IconFunc.bas V1.4
'' 
'' Compiler: HBC 2.0
'' Includes: 3.1
''
'' Author: steffen.leistner@styx.in-chemnitz.de
'' Copyright: © Steffen Leistner 1996-98
'' Status: FreeWare, use on your own Risk
'' 
''
'' include this: exec.bh, intuition.bh, dos.bh, workbench.bh, icon.bh, utility.bh
'' open libs:    exec.library, intuition.library, dos.library, workbench.library
''               icon.library

'******************************************************************************

'returns the full path and name of the current program

FUNCTION FullProgramName$
	LOCAL workbuf&, thistask&, programname$
	FullProgramName$ = ""
	
	workbuf& = AllocVec&(512&, MEMF_PUBLIC& OR MEMF_CLEAR&)
	IF workbuf& = NULL&
		EXIT FUNCTION
	END IF

	IF GetProgramName&(workbuf&, 512&)			'Start from CLI
		programname$ = PEEK$(workbuf&)
	ELSE										'Start from Workbench
		Forbid
		thistask& = FindTask&(NULL&)
		Permit
		programname$ = PEEK$(PEEKL(thistask& + tc_Node% + ln_Name%))
	END IF

	IF GetCurrentDirName& (workbuf&, 512&)
		IF AddPart&(workbuf&, SADD(programname$ + CHR$(0)), 512&)
			FullProgramName$ = PEEK$(workbuf&)
		END IF
	END IF
	FreeVec workbuf&

END FUNCTION

'******************************************************************************

'reads the Tooltype-Entries from a given Icon

'	wbobject$ = full path and name of the wbobject (without ".info")
'	tooltypes$() = array of tooltypes, see example
'	results$() = array of string results, should by empty before call the function

FUNCTION ReadToolTypes&(wbobject$, tooltypes$(), results$())
	LOCAL diskobj&, z%
	ReadToolTypes& = NULL&
	
	diskobj& = GetDiskObject&(SADD(wbobject$ + CHR$(0%)))
	IF diskobj&
		FOR z% = 0% TO UBOUND(tooltypes$)
			results$(z%) = PEEK$(FindToolType&(PEEKL(diskobj& + do_ToolTypes%), _
							SADD(tooltypes$(z%) + CHR$(0%))))
		NEXT z%
		ReadToolTypes& = TRUE&
		FreeDiskObject diskobj&
	END IF
	
END FUNCTION

'******************************************************************************

'save tooltypes to a given wbobject

'	wbobject$ = full path and name of the wbobject (without ".info")
'	deftool$ = name of the default tool (only project/disk icons)
'	ttype$() = array of complete tooltypes (eg. "FOOBAR=987654321")

SUB SaveToolTypes (wbobject$, deftool$, ttype$())
	LOCAL diskobj&, z%
	
	diskobj& = GetDiskObjectNew&(SADD(wbobject$ + CHR$(0%)))
	IF diskobj&
		junk& = FRE(" ")
		DIM args&(UBOUND(ttype$) + 1%)
		FOR z% = 0% TO UBOUND(ttype$)
			args&(z%) = SADD(ttype$(z%) + CHR$(0%))
		NEXT z%
		POKEL diskobj& + do_ToolTypes%, VARPTR(args&(0%))
		IF PEEKW(diskobj& + do_Type%) = WBPROJECT&
			POKEL dobj& + do_DefaultTool%, SADD(deftool$ + CHR$(0%))
		END IF
		junk& = PutDiskObject& (SADD(wbobject$ + CHR$(0%)), diskobj&)
		FreeDiskObject diskobj&
		ERASE args&
	END IF

END SUB

'******************************************************************************

'edit a Icon via workbench or dopus - functions

'	win& = address of parent window (NULL& is valid)
'	icon$ = full path and name to the icon

SUB EditIcon (win&, icon$)
	IF (icon$ <> "")
		IF FEXISTS(icon$)
			pname$ = icon$ + CHR$(0%)
			POKEB PathPart&(SADD(pname$)), 0%
		
			Forbid
			IF FindPort&(SADD("DOPUS.1" + CHR$(0%)))
				Permit
				
				cic% = PEEKB(SYSTAB + 33%)
				POKEB SYSTAB + 33%, 0%
				
				tempscript$ = "T:DOIconInfo.rx"
				ffile% = FREEFILE
				OPEN tempscript$ FOR OUTPUT AS #ffile%
					PRINT #ffile%, "/* Show Icon via DOpus */"
					PRINT #ffile%, "ADDRESS 'DOPUS.1'"
					PRINT #ffile%, "DOPUS FRONT"
					PRINT #ffile%, "COMMAND wait IconInfo "; CHR$(34%); icon$; CHR$(34%)
					PRINT #ffile%, "EXIT"
				CLOSE #ffile%	
				
				junk& = SystemTagList&(SADD("SYS:Rexxc/RX " + tempscript$ + CHR$(0%)), NULL&)
				KILL tempscript$
				POKEB SYSTAB + 33%, cic%
			
			ELSE
				Permit
				
				IF win& <> NULL&
					scr& = PEEKL(win& + WScreen%)
				ELSE
					scr& = LockPubScreen&(NULL&)
				END IF
			
				lck& = Lock&(SADD(pname$), ACCESS_READ&)
				IF lck&
					old& = CurrentDir&(lck&)
					fls$ = PEEK$(FilePart&(SADD(icon$ + CHR$(0%))))
					fln$ = LEFT$(fls$, LEN(fls$) - 5%) + CHR$(0%)
					WBInfo lck&, SADD(fln$), scr&
					junk& = CurrentDir&(old&)
					UnLock lck&
				END IF
			
				IF win& = NULL&
					UnLockPubScreen NULL&, scr&
				END IF
			END IF
		END IF
	END IF
END SUB