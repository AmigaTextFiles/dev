    IFND FLUSH_DEFS_I
FLUSH_DEFS_I SET 1

; --------------------------------------------------------------
; Project name: FLUSHLibrary	Launched: 01/04/92	by Ms...
; --------------------------------------------------------------
; This file "flush.library general definitions"
; 	created: 01/04/92		last modified: 07/04/92
; 	version: 1.1			PV: 002
; These are general data, needed by client programs.
;
; FLUSH:Defs.I (C) Marc Schaefer 1992     flush@alphanet.imp.com

; Library version.

FLUSH_VERSION	EQU	1

; Defines.

MODE_SIGNALME	EQU	1		; See documentation
MODE_HANDLER	EQU	2
MODE_MSG	EQU	3

ALERT_MISCLOSE	EQU	$9201		; Close, subscribe list not empty.
ALERT_DISERR	EQU	$9202		; FlushDisableAnnounce, illegal try.
ALERT_ENERR	EQU	$9203		; Illegal mode FlushEnableAnnounce.
ALERT_TRASHERR	EQU	$9204		; List trashed.

AO_FlushLib	EQU	$9200		; For you: If you failed to open it.

; Library name.

FLUSHNAME:	MACRO
		DC.B	"flush.library",0
		ENDM

    ENDC !FLUSH_DEFS_I
