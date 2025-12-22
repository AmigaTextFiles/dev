OPT PREPROCESS
MODULE 'exec', 'exec/memory'

PROC MemAvail() RETURNS sizeInBytes:BIGVALUE
	->this does NOT exactly mirror the type allocated by 'PE/Amiga/Mem', as AvailMem(MEMF_PRIVATE) returns 0
	#ifdef pe_TargetOS_AmigaOS4
		RETURN AvailMem(MEMF_SHARED OR MEMF_LARGEST)
	#else
		RETURN AvailMem(MEMF_PUBLIC OR MEMF_LARGEST)
	#endif
	->RETURN AvailMem(MEMF_ANY OR MEMF_LARGEST)
ENDPROC
