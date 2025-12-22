	IFND	wilddisplaytype2
wilddisplaytype2	SET	1

; Display,Type 2 defs.
; This type uses a CHUNKY display, with 256 colors. It's FIXED DEPTH, no support
; for 64 or 16 colors.
; This type is the best for a bit fast AGA and CGFX stuff.

		STRUCTURE 	FrameBuffer2,0		; NB: This is pointed also by the WildApp !!!
			APTR	fb2_Screen		; Screen struct.
			APTR	fb2_Chunky		; The chunky buffer
			WORD	fb2_ChunkyWidth		; the chunky buffer width (may be bigger than ViewWidth)
			WORD	fb2_ChunkyHeight	; the chunky buffer height (quite useless, but for completeness)
			WORD	fb2_ViewLeft
			WORD	fb2_ViewTop
			WORD	fb2_ViewWidth		; THE VIEW'S WIDTH!!! Your Draw HAVE TO STAY INTO THESE LIMITS !!!
			WORD	fb2_ViewHeight		; IDEM FOR HEIGHT! README: The Bitmap MAY BE BIGGER THAN THAT LIMITS! You MAY HAVE A MODULE TO ADD AT EVERY ROW ! CHECK IN THE Bitmap STRUCT!
			LONG	fb2_Flags		; flags
			LABEL	fb2_SIZE

	BITDEF	FB2,WildScreen,16			; If set, the screen is opened by wild (so is closed at end)

	ENDC			