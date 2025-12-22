OPT INLINE, POINTER, PREPROCESS
MODULE 'target/time'

->returns the current time (in our standard format)
PROC CurrentTime(zone0local1utc2quick=0) RETURNS time:BIGVALUE IS IF zone0local1utc2quick=2 THEN time(NIL) - 946684800 #ifndef pe_TargetOS_Linux !!BIGVALUE #endif ELSE globalTime(zone0local1utc2quick=1)

PRIVATE
PROC globalTime(utc:BOOL) RETURNS time:BIGVALUE
	DEF absolute[1]:ARRAY OF TIME_T, global:PTR TO tm, dst
	
	time(absolute)
	IF utc
		global := gmtime(absolute)
		dst := 0
	ELSE
		global := localtime(absolute)
		dst := IF global.isdst = 1 THEN 3600 ELSE 0		->add DST adjustment
	ENDIF
	time := mktime(global) + dst - 946684800 #ifndef pe_TargetOS_Linux !!BIGVALUE #endif
ENDPROC
PUBLIC
