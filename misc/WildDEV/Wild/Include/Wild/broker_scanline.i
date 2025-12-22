	IFND	BROKER_SCANLINE
BROKER_SCANLINE	SET	1

*** Common structs for scanline methods in my brokers.

	STRUCTURE	ScanLineHeader,0
		WORD	sh_DEY			; number of headers (of rows!)
		APTR	sh_Buffer		; buffer for scanlines	
		STRUCT	sh_Expand,MLH_SIZE	; expanded buffer
		LONG	sh_RESERVED		; future: error quantization to realloc or not the primary buffer (now always reallocated)
		LONG	sh_BufSize		; size of buffer
		LONG	sh_TotSize		; size of total buffer (to compute the best med)
		LONG	sh_MedSize		; default size of buffer (medium)
		LONG	sh_Next			; next scanline address
		WORD	sh_Remain		; remaining scanlines to put in that buffer
		APTR	sh_Pool			; a pool, contained here because of optim.
		LABEL	sh_Headers		; all the headers of the rows.

; sh_Buffer is separated from sh_Expand just because (in the future) the sh_Buffer
; will be allocated once (and reallocated only when it's REALLY too small or big,
; so when the sum of errors is more than a certain quantity).

	STRUCTURE	ScanExpand,MLN_SIZE
		LABEL	se_Data

	STRUCTURE	ScanLine,0
		APTR	sl_Next			; * to next
		WORD	sl_XA
		WORD	sl_Len			; len in pixels
		WORD	sl_ID			; polygon ID
		BYTE	sl_Flags		; flags
		LABEL	sl_Extend
		BYTE	sl_Hole00
		LABEL	sl_SIZEOF

	STRUCTURE	XTendScanLine,sl_Extend
		BYTE	sl_Ia
		BYTE	sl_TXa
		BYTE	sl_TYa
		LABEL	slx_SIZEOF

	BITDEF	SL,Transparent,0		; that's transparent !!

; Initially, all scanlines headers are empty (=$0000000)
; That, when a scanline must be added, checks if it's down everyone present in the
; list of his row, and then adds himselt (even splitting, if necessary)

	ENDC