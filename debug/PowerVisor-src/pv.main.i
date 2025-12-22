	;***
	;Node definition for our key-attachments
	;***
 STRUCTURE KeyAttachNode,LN_SIZE
	UWORD		ka_Code
	UWORD		ka_Qualifier
	APTR		ka_CommandString		;Command string for this key
	UWORD		ka_CommandLen			;Size of command string
	UWORD		ka_Flags					;See below
	LABEL		ka_SIZE

KAF_INVISIBLE	equ	1				;If set, command is not added in stringgadget
											;but executed directly using IDC commands
KAF_SNAP			equ	2				;If set, the command is 'snapped' to the
											;commandline
KAF_HOLDKEY		equ	4				;If set, we don't remove the key from the
											;input event list
KAF_ALWAYS		equ	8				;Executed using IDC commands and this happens
											;even if PowerVisor is 'busy'

	;***
	;Fake mementry for CreateTask
	;***
 STRUCTURE FakeMemEntry,0
	ULONG		fme_Regs
	ULONG		fme_Length
	LABEL		fme_SIZE

	;***
	;Fake memlist
	;***
me_TASK			equ	0
me_STACK			equ	1
me_NUMENTRIES	equ	2

 STRUCTURE FakeMemList,LN_SIZE
	UWORD		fml_NumEntries
	STRUCT	fml_ME,fme_SIZE*me_NUMENTRIES
	LABEL		fml_SIZE

;HardwareKey		equ	$bfec01

	;Constants for input.device
ESCAPEKEY		equ	$45
HELPKEY			equ	$5f
FRONTKEY			equ	$3a			;?
ENTERKEY			equ	$44
UPKEY				equ	$4c
DOWNKEY			equ	$4d
LEFTKEY			equ	$4f
RIGHTKEY			equ	$4e
HOMEKEY			equ	$3d
ENDKEY			equ	$1d
PGUPKEY			equ	$3f
PGDNKEY			equ	$1f
NUPKEY			equ	$3e
NDOWNKEY			equ	$1e
NLEFTKEY			equ	$2d
NRIGHTKEY		equ	$2f
NMIDKEY			equ	$2e
TABKEY			equ	$42

	;Codes for qualifiers
QUAL_LSHIFT		equ	$60
QUAL_RSHIFT		equ	$61
QUAL_CAPSLOCK	equ	$62
QUAL_CONTROL	equ	$63
QUAL_LALT		equ	$64
QUAL_RALT		equ	$65
QUAL_LCOMMAND	equ	$66
QUAL_RCOMMAND	equ	$67

	;Eyes for config file
EYE_START		equ	'PVcf'
EYE_MODE			equ	'mode'
EYE_ENTRIES		equ	'entr'
EYE_DEFLEN		equ	'dlen'
EYE_KEYS			equ	'keys'
EYE_SHARES		equ	'shar'
EYE_SCRFLAGS	equ	'sflg'
EYE_COORDS		equ	'coor'
EYE_SCRSIZE		equ	'ssiz'
EYE_FANPENS		equ	'fpen'
EYE_PENS			equ	'pens'
EYE_STACKFAIL	equ	'stfa'
EYE_DEBUGPREF	equ	'dbpr'
EYE_HISTMAX		equ	'hmax'
EYE_FONT			equ	'font'
EYE_TATTRIB		equ	'tatt'

ENTRY_IS_ROUT		equ	1
ENTRY_IS_ADDRESS	equ	0

	;Macro to define a config entry
EYEENTRY macro *
		dc.l	EYE_\1
		dc.w	\3				;Size
		dc.w	ENTRY_IS_\2
		dc.l	\4				;Address
		endm

	;Macro to define a mode argument
DEFCM	macro	*
		dc.l	MArg\1,moF_\2,(\3&mof_\2)<<mo_\2
		endm

;	;Macro to define a command
;DEFC	macro	*
;		dc.l	Com\1,Rout\1
;		endm

	;Macro to define a preferences command
DEFP	macro	*
		dc.l	PArg\1,PRout\1
		endm

	;Macro to define an ARexx command
ADEF	macro	*
		dc.l	Com\1,USER_FUNCTION,Rout\1
		endm

	;Macro to define an ARexx command
ADEFS	macro	*
		dc.l	Com\1,USER_RETURNSTR,Rout\1
		endm

	;Macro to define an ARexx command
AFUN	macro	*
		dc.l	Str\1,USER_FUNCTION,Func\1
		endm

	;Macro to define an ARexx command
AFUNS	macro	*
		dc.l	Str\1,USER_RETURNSTR,Func\1
		endm
