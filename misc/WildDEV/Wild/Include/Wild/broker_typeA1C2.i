	IFND	WILDBROKERTYPE2
WILDBROKERTYPE2	SET	1

	include	wild/tdcore_typeA1.i

; type 2 of broker.
; this type : sorts the points (from high to low) and calcs
; the x steps, and cuts top and bottom the polygons.
; then calcs i startings and steps

; IMPORTANT: SEE broker_typeA1C1.i to see my Y,DEY and more conventions!!

		STRUCTURE	BrokerData2,t1bs_Broker
			WORD	t1bs_topY
			WORD	t1bs_hiDEY		; how many rows for hi part ?
			WORD	t1bs_hiIa		; 8.8 math
			WORD	t1bs_hiSIa		; 8.8 math
			LONG	t1bs_hiXa
			LONG	t1bs_hiXb		; 16.16 math 
			LONG	t1bs_hiSXa
			LONG	t1bs_hiSXb		; 16.16 math
			APTR	t1bs_TopSxEdge		; for my use: POINTS TO TMP OF THE Highest SX EDGE 
			APTR	t1bs_TopDxEdge		; same of topsx!	
			APTR	t1bs_BotDxEdge		; same of topsx! (that strange order because by movem use, so no time to sort)
			APTR	t1bs_BotSxEdge		; same of topsx!
			WORD	t1bs_loDEY
			WORD	t1bs_loSIa
			LONG	t1bs_loSXa
			LONG	t1bs_loSXb		; only steps: you have the X !
			WORD	t1bs_HSI		; Horizontal Step of I (see note)			
			LABEL	t1bs_morethan2

; NB: that struct is a bit unsorted: because of a my optim with movem !
;     Sorting is quite useless, also the Stop containing 0 is cutted.
;     It was used by me for a optim in a loop, but it's very useless,
;     i saw. I keep it on type 1 because i'm lazy.
; HSx note: That's the horizontal step of x.
; It's always the same during the y descending, because the interpolation of shading is linear.

		STRUCTURE	BrokerDataEdge2,t1ed_Broker
			APTR	t1ed_HighPoint		; NB: this POINT TO THE TEMP STRUCT, NOT TO THE REAL POINT STRUCT!
			APTR	t1ed_LowPoint
			WORD	t1ed_topCUT
			WORD	t1ed_bottomCUT
			WORD	t1ed_topY
			WORD	t1ed_DEY
			LONG	t1ed_X
			LONG	t1ed_SX
			WORD	t1ed_I			; intensity
			WORD	t1ed_SI
			LABEL	t1ed_morethan2

	ENDC
	
