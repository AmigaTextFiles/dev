	IFND	wilddisplaytype1
wilddisplaytype1	SET	1

; Display,Type 1 defs.
; This type uses a PLANAR display,OS Friend becaude there are a screen and
; a rastport struct in the DisplayData1.
; This type will probably be used by mi first debug engines, just to see some skratchy 
; lines on screen. Like the JustWireView.PEngY in Escape.

; CONTROVERSE POINT:
; There is a problem about display. I use Types of display, but now IT'S DIFFERENT THAN
; TDCore TMP Structs!! The Display MAY BE USED ALSO BY THE APP!!! 
; That's a problem to solve. I'll think on...

		STRUCTURE 	FrameBuffer1,0		; NB: This is pointed also by the WildApp !!!
			APTR	fb1_Screen		; Screen struct.
			APTR	fb1_RastPort		; USE THIS !!! MAY BE DIFFERENT FROM SCREEN'S ONE !!!
			APTR	fb1_BitMap		; Fastly, not go into RP... (ALWAYS the same of RP !)
			WORD	fb1_ViewLeft
			WORD	fb1_ViewTop
			WORD	fb1_ViewWidth		; THE VIEW'S WIDTH!!! Your Draw HAVE TO STAY INTO THESE LIMITS !!!
			WORD	fb1_ViewHeight		; IDEM FOR HEIGHT! README: The Bitmap MAY BE BIGGER THAN THAT LIMITS! You MAY HAVE A MODULE TO ADD AT EVERY ROW ! CHECK IN THE Bitmap STRUCT!
			LONG	fb1_Flags		; flags
			LABEL	fb1_SIZE

	BITDEF	FB1,WildScreen,16			; If set, the screen is opened by wild (so is closed at end)

	ENDC			