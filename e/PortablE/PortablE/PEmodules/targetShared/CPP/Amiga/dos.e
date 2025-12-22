OPT PREPROCESS	->for CreateNewProc()
MODULE 'target/dos'
MODULE 'target/exec', 'target/utility/tagitem'	->for CreateNewProc()

DEF arg:ARRAY OF CHAR

PRIVATE
DEF argString=NILS:STRING
PUBLIC

PROC new()
	DEF args:ARRAY OF CHAR, len
	
	IF args := GetArgStr()
		len := StrLen(args)
		NEW argString[len]
		
		StrCopy(argString, args)
		IF len > 0
			IF argString[len-1] = "\n" THEN SetStr(argString, len-1)
		ENDIF
	ENDIF
	
	arg := argString
ENDPROC

PROC end()
	END argString
ENDPROC

PROC CreateNewProc(tags:ARRAY OF tagitem) RETURNS proc:PTR TO process REPLACEMENT
	RETURN SUPER CreateNewProc([
		#ifdef pe_TargetOS_AmigaOS4
			NP_CHILD, TRUE,								->needed if the program will ever be linked with newlib (which is default on OS4)
			NP_NOTIFYONDEATHSIGTASK, FindTask(NILA),	->OS4.1+ only
		#endif
		#ifdef pe_TargetOS_MorphOS
			NP_CODETYPE, CODETYPE_PPC,					->needed or it will simply crash on MOS
		#endif
		IF tags THEN TAG_MORE ELSE TAG_END, tags
	]:tagitem)
ENDPROC
