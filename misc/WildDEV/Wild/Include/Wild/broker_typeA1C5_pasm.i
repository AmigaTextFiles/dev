.ifndef		WILDBROKERTYPE5
.set		WILDBROKERTYPE5,1

.include	"wild/tdcore_typeA1_pasm.i"

# type 5 of broker.
# this type : sorts the points (from high to low) and calcs
# the x steps, and cuts top and bottom the polygons.
# then calcs i startings and steps
# then resorts the txy a,b,c and calcs tx/ty startingt/steppings.

# IMPORTANT: SEE broker_typeA1C1.i to see my Y,DEY and more conventions!!

		STRUCTURE	BrokerData5,t1bs_Broker
			WORD	t1bs_topY
			WORD	t1bs_hiDEY		# how many rows for hi part ?
			WORD	t1bs_hiIa		# 8.8 math
			WORD	t1bs_hiSIa		# 8.8 math
			WORD	t1bs_hiTXa
			WORD	t1bs_hiTYa
			WORD	t1bs_hiSTXa
			WORD	t1bs_hiSTYa
			LONG	t1bs_hiXa
			LONG	t1bs_hiXb		# 16.16 math 
			LONG	t1bs_hiSXa
			LONG	t1bs_hiSXb		# 16.16 math
			APTR	t1bs_TopSxEdge		# for my use: POINTS TO TMP OF THE Highest SX EDGE 
			APTR	t1bs_TopDxEdge		# same of topsx!	
			APTR	t1bs_BotSxEdge		# same of topsx!
			WORD	t1bs_loDEY
			WORD	t1bs_loSIa
			WORD	t1bs_loSTXa
			WORD	t1bs_loSTYa
			LONG	t1bs_loSXa
			LONG	t1bs_loSXb		# only steps: you have the X !
			WORD	t1bs_HSI		# Horizontal Step of I (see note)			
			WORD	t1bs_HSTX		# same TX
			WORD	t1bs_HSTY		# same TY
			LABEL	t1bs_morethan5

# NB: that struct is a bit unsorted: because of a my optim with movem !
#     Sorting is quite useless, also the Stop containing 0 is cutted.
#     It was used by me for a optim in a loop, but it's very useless,
#     i saw. I keep it on type 1 because i'm lazy.
# HSx note: That's the horizontal step of x.
# It's always the same during the y descending, because the interpolation of shading is linear.
# NOTE!! There is NO MORE BotDX EDGE !!! WAS USELESS !!!! Kept in type 2, i'm lazy.

		STRUCTURE	BrokerDataEdge5,t1ed_Broker
			APTR	t1ed_HighPoint		# NB: this POINT TO THE TEMP STRUCT, NOT TO THE REAL POINT STRUCT!
			APTR	t1ed_LowPoint
			WORD	t1ed_topCUT
			WORD	t1ed_bottomCUT
			WORD	t1ed_topY
			WORD	t1ed_DEY
			LONG	t1ed_X
			LONG	t1ed_SX
			WORD	t1ed_I			# intensity
			WORD	t1ed_SI
			LABEL	t1ed_morethan5

.endif
	
