	IFND	FLUSH_FLUSH_LIB_I
FLUSH_FLUSH_LIB_I	SET	1

; --------------------------------------------------------------
; Project name: FLUSHLibrary    Launched: 01/04/92      by Ms...
; --------------------------------------------------------------
; This file "flush.library offset jumps"
;       created: 01/04/92               last modified: 07/04/92
;       version: 1.1                    PV: 003
; These are general data, needed by client programs.
; These are offset jumps.
;
; FLUSH:FLUSH_LIB.I (C) Marc Schaefer 1992 flush@alphanet.imp.com

_LVOFlushDo			EQU	-30
_LVOFlushEnableAnnounce		EQU	-36
_LVOFlushDisableAnnounce	EQU	-42

	IFND	FLUSH_FLUSH_ASM
	XREF	_FlushBase
	ENDC

	ENDC	!FLUSH_FLUSH_LIB_I
