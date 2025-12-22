MODULE 'exec', 'exec/io', 'timer', 'devices/timer'
MODULE 'CSH/pAmigaDos'

PRIVATE
DEF tr:timerequest
PUBLIC

PROC new()
	IF OpenDevice('timer.device', UNIT_VBLANK, tr.io, 0) = 0
		timerbase := tr.io.device
	ELSE
		timerbase := NIL
	ENDIF
ENDPROC

PROC end()
	CloseDevice(tr.io)
	timerbase := NIL
ENDPROC

->returns the current time (in our standard format)
PROC CurrentTime(zone0local1utc2quick=0) RETURNS bigTime:BIGVALUE
	DEF tv:timeval
	
	IF timerbase = NIL THEN Throw("DEV", 'pTime; CurrentTime(); unable to open the timer.device')
	
	GetSysTime(tv)
	bigTime := tv.secs - 694224000
	IF zone0local1utc2quick = 1 THEN bigTime := bigTime + utcOffset()
ENDPROC

PRIVATE
PROC utcOffset() RETURNS offsetInSecs
	DEF tzone:OWNS STRING, pos, chara:CHAR, value, read
	
	tzone := strSafeGetVar('TZONE', GVF_GLOBAL_ONLY)
	pos := 3
	IF pos > EstrLen(tzone) THEN RETURN 0
	
	->read hour offset
	WHILE chara := tzone[pos]
		IF (chara < "0") OR (chara > "9") AND (chara <> "-")
			->(not on a number) so keep looking
			pos++
			chara := 0
		ENDIF
	ENDWHILE IF chara
	
	IF chara = 0 THEN RETURN 0
	value, read := Val(tzone, NILA, pos)
	IF read = 0 THEN RETURN 0
	offsetInSecs := value * 3600
	pos := pos + read
	
	->read minute offset (if any)
	IF tzone[pos] = ":"
		pos++
		value, read := Val(tzone, NILA, pos)
		IF read <> 0
			IF offsetInSecs < 0 THEN value := -value
			offsetInSecs := offsetInSecs + (value*60)
		ENDIF
	ENDIF
	
	->check for optional DST part
	IF tzone[pos] <> 0
		->(DST is active)
		pos := pos + 3
		IF pos > EstrLen(tzone) THEN pos := EstrLen(tzone)
		
		->read hour offset
		WHILE chara := tzone[pos]
			IF (chara < "0") OR (chara > "9") AND (chara <> "-")
				->(not on a number) so keep looking
				pos++
				chara := 0
			ENDIF
		ENDWHILE IF chara
		
		IF chara
			value, read := Val(tzone, NILA, pos)
		ELSE
			read := 0
		ENDIF
		IF read = 0
			->(DST has default of 1 hour ahead) so UTC is 1 hour further behind us
			offsetInSecs := offsetInSecs - 3600
		ELSE
			offsetInSecs := value * 3600
			pos := pos + read
			
			->read minute offset (if any)
			IF tzone[pos] = ":"
				pos++
				value, read := Val(tzone, NILA, pos)
				IF read <> 0
					IF offsetInSecs < 0 THEN value := -value
					offsetInSecs := offsetInSecs + (value*60)
				ENDIF
			ENDIF
		ENDIF
	ENDIF
FINALLY
	END tzone
ENDPROC
PUBLIC
