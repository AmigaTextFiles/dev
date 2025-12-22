INITBYTE	MACRO	* &offset,&value
		dc.b	$e0
		dc.b	0
		dc.w	\1
		dc.b	\2
		dc.b	0
		ENDM

INITWORD	MACRO	* &offset,&value
		dc.b	$d0
		dc.b	0
		dc.w	\1
		dc.w	\2
		ENDM

INITLONG	MACRO	* &offset,&value
		dc.b	$c0
		dc.b	0
		dc.w	\1
		dc.l	\2
		ENDM


