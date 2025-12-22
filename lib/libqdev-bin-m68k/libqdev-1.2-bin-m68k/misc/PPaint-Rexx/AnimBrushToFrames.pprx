/* Personal Paint Amiga Rexx script - Copyright © 1995-1997 Cloanto Italia srl */

/* $VER: AnimBrushToFrames.pprx 1.0 */

/** ENG
  This script converts the current anim-brush to frames.

  Its a hacked AnimBrushToAnim.pprx 1.2 since i was unable to find
  one such script.
*/

IF ARG(1, EXISTS) THEN
	PARSE ARG PPPORT
ELSE
	PPPORT = 'PPAINT'

IF ~SHOW('P', PPPORT) THEN DO
	IF EXISTS('PPaint:PPaint') THEN DO
		ADDRESS COMMAND 'Run >NIL: PPaint:PPaint'
		DO 30 WHILE ~SHOW('P',PPPORT)
			 ADDRESS COMMAND 'Wait >NIL: 1 SEC'
		END
	END
	ELSE DO
		SAY "Personal Paint could not be loaded."
		EXIT 10
	END
END

IF ~SHOW('P', PPPORT) THEN DO
	SAY 'Personal Paint Rexx port could not be opened'
	EXIT 10
END

ADDRESS VALUE PPPORT
OPTIONS RESULTS
OPTIONS FAILAT 10000

	
	txt_req_sel       = 'Select Format and Root Name'
	txt_err_abort     = 'User abort during save'
	txt_err_save      = 'Error during save: '
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'


Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END


LockGUI

GetBrushAttributes 'FRAMES'
frnum = RESULT
IF frnum = 0 THEN DO
	LoadAnimBrush
	IF RC = 0 THEN DO
		GetBrushAttributes 'FRAMES'
		frnum = RESULT
	END
END
IF frnum > 0 THEN DO
	GetBrushAttributes 'WIDTH'
	bw = RESULT
	GetBrushAttributes 'HEIGHT'
	bh = RESULT
	GetBrushAttributes 'COLORS'
	bcol = RESULT
	GetBrushAttributes 'DISPLAY'
	bdisp = RESULT
	GetBrushAttributes 'HANDLEX'
	bhx = RESULT
	GetBrushAttributes 'HANDLEY'
	bhy = RESULT
	GetBrushAttributes 'LENGTH'
	bfl = RESULT
	GetBrushAttributes 'FRAMEPOSITION'
	bfp = RESULT


	RequestFile '"'txt_req_sel'" SAVEMODE LISTFORMATS FORCE'
	IF RC = 0 THEN DO
		savedata = RESULT
		endf = INDEX(savedata, '"', 2)
		filename = SUBSTR(savedata, 2, endf - 2)
		filedata = SUBSTR(savedata, endf + 1)

		npos1 = INDEX(filename, '0')
		IF npos1 > 0 THEN DO
			ndigits = 1
			fnlen = LENGTH(filename)
			DO npos = npos1 + 1 TO fnlen
				IF SUBSTR(filename, npos, 1) = '0' THEN
					ndigits = ndigits + 1
				ELSE
					LEAVE
			END
		END


		errcode = 0

		DO fnum = 1 TO frnum
			IF npos1 > 0 THEN
				fname = LEFT(filename, npos1 - 1) || RIGHT(fnum, ndigits, "0") || SUBSTR(filename, npos)
			ELSE
				fname = filename || "." || RIGHT(fnum, 3, "0")

			SetBrushAttributes 'HANDLEX 0 HANDLEY 0 LENGTH' frnum 'FRAMEPOSITION 'fnum

			SaveBrush '"'fname'"'filedata 'FORCE QUIET'

			IF RC ~= 0 THEN DO
				IF RC = 5 THEN
					errmess = txt_err_abort
				ELSE
					errmess = txt_err_save || RC
				errcode = RC
				LEAVE
			END
		END

		IF errcode > 0 THEN
			RequestNotify 'PROMPT "'errmess'"'
	END
END

UnlockGUI
