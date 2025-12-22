' example 2
' Version : $Id: example2.bas V0.1
' Compiler:	HBC 2.0+
' Includes:	3.1
' Author:   steffen.leistner@styx.in-chmenitz.de
' Status:   Freeware

'******************************************************************************

DEFLNG a-z

REM $JUMPS
REM $NOWINDOW
REM $NOLIBRARY
REM $NOSTACK
REM $NOARRAY
REM $NOLINES
REM $NOVARCHECKS
REM $NOAUTODIM
REM $MINSTACK 10000

REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE utility.bh
REM $INCLUDE fileid.bh

FUNCTION FileList&(f$)
	SHARED workbuf&, finf&
	LOCAL buf&, flk&, stat&, junk&, ftyp&, nln&, fls$, cmm$, cln&, fh&
	
	FileList& = RETURN_WARN&
	buf& = AllocVec&(1024&, MEMF_ANY& OR MEMF_CLEAR&)
	IF buf&
		strgoff& = buf& + 512&
		flk& = Lock& (SADD(f$), ACCESS_READ&)
		IF flk&
			stat& = Examine& (flk&, buf&)
			IF stat&
				FileList& = RETURN_OK&
				WHILE stat& <> NULL&
					stat& = ExNext& (flk&, buf&)
					IF stat& <> NULL&
						ftyp& = PEEKL(buf& + fib_DirEntryType%)
						SELECT CASE ftyp&
							CASE ST_FILE&
								CopyMem SADD(f$), strgoff&, LEN(f$)
								junk& = AddPart&(strgoff&, buf& + fib_FileName%, 512&)
								fls$ = PEEK$(strgoff&)
								ft$ = ""
								fh& = xOpen&(strgoff&, MODE_OLDFILE&)
								IF fh&
									IF xRead&(fh&, workbuf&, 1200&)
										FIIdentify workbuf&, finf&
										ft$ = PEEK$(PEEKL(finf& + FI_Description%))
									END IF
									junk& = xClose&(fh&)
								END IF
								CopyMem buf& + fib_Date%, workbuf&, DateStamp_sizeof%
								POKEB workbuf& + dat_Format%, FORMAT_DOS&
								POKEB workbuf& + dat_Flags%, DTF_SUBST&
								POKEL workbuf& + dat_StrDay%, NULL&
								POKEL workbuf& + dat_StrDate%, workbuf& + 50&
								POKEL workbuf& + dat_StrTime%, NULL&
								junk& = DateToStr&(workbuf&)
								PRINT fls$; SPACE$(MAX(50% - LEN(fls$),3%)); PEEK$(workbuf& + 50&); SPACE$(3%); FORMATL$(PEEKL(buf& + fib_Size%), "#########"); SPACE$(3%); ft$
							CASE ST_USERDIR&
								CopyMem SADD(f$), strgoff&, LEN(f$)
								junk& = AddPart&(strgoff&, buf& + fib_FileName%, 512&)
								junk& = FileList&(PEEK$(strgoff&) + CHR$(0))
						END SELECT
					END IF
					IF INKEY$ <> ""
						EXIT WHILE
					END IF
				WEND
			END IF
			UnLock flk&
		END IF
		FreeVec buf&
	END IF
END FUNCTION


LIBRARY OPEN "exec.library", 37&
LIBRARY OPEN "dos.library"
LIBRARY OPEN "FileID.library", MIN_FIDLIB_VER&


IF PEEKL(SYSTAB + 8)		'Workbench
	WINDOW 1,"FileID.library Example 2",,23
ELSE						'CLI
	PRINT : PRINT "- FileID.library Example 2 -" : PRINT
END IF

IF LEN(COMMAND$) > NULL&
	file$ = COMMAND$
ELSE
	file$ = "DEVS:"
END IF

IF NOT FEXISTS(file$)
	PRINT "File not exists."
	IF PEEKL(SYSTAB + 8)
		SLEEP
		WINDOW CLOSE 1
	END IF
	SYSTEM RETURN_WARN&
END IF

finf& = FIAllocFileInfo&
IF finf&
	workbuf& = AllocVec&(1500&, MEMF_ANY& OR MEMF_CLEAR&)
	IF workbuf&
		file$ = file$ + CHR$(0%)
		IF FileList(file$) = RETURN_WARN&
			PRINT "Can't list directory "; file$
		END IF
		FreeVec workbuf&
	END IF
	FIFreeFileInfo finf&
END IF

IF PEEKL(SYSTAB + 8)
	SLEEP
	WINDOW CLOSE 1
END IF

SYSTEM RETURN_OK&

'******************************************************************************

DATA "$VER: example2 V0.1 (01-01-99) "