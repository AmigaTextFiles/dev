
* $Id: WHDLoadPatch.s 1.1 2003/06/22 19:11:15 wepl Exp wepl $

	INCDIR	Includes:
	INCLUDE UserSymbols.i
	INCLUDE	whdload.i

	dc.l		.name
	dc.b		OREDSYM
	ORedSymbol	<PLCMD_END>,$ff,PLCMD_END
	ORedSymbol	<PLCMD_R>,$ff,PLCMD_R
	ORedSymbol	<PLCMD_P>,$ff,PLCMD_P
	ORedSymbol	<PLCMD_PS>,$ff,PLCMD_PS
	ORedSymbol	<PLCMD_S>,$ff,PLCMD_S
	ORedSymbol	<PLCMD_I>,$ff,PLCMD_I
	ORedSymbol	<PLCMD_B>,$ff,PLCMD_B
	ORedSymbol	<PLCMD_W>,$ff,PLCMD_W
	ORedSymbol	<PLCMD_L>,$ff,PLCMD_L
	ORedSymbol	<PLCMD_A>,$ff,PLCMD_A
	ORedSymbol	<PLCMD_PA>,$ff,PLCMD_PA
	ORedSymbol	<PLCMD_NOP>,$ff,PLCMD_NOP
	ORedSymbol	<PLCMD_C>,$ff,PLCMD_C
	ORedSymbol	<PLCMD_CB>,$ff,PLCMD_CB
	ORedSymbol	<PLCMD_CW>,$ff,PLCMD_CW
	ORedSymbol	<PLCMD_CL>,$ff,PLCMD_CL
	ORedSymbol	<PLCMD_PSS>,$ff,PLCMD_PSS
	ORedSymbol	<PLCMD_NEXT>,$ff,PLCMD_NEXT
	ORedSymbol	<PLCMD_AB>,$ff,PLCMD_AB
	ORedSymbol	<PLCMD_AW>,$ff,PLCMD_AW
	ORedSymbol	<PLCMD_AL>,$ff,PLCMD_AL
	ORedSymbol	<PLCMD_DATA>,$ff,PLCMD_DATA
	ORedSymbol	<WORD>,$8000,$8000
	dc.b		ENDBASE
.name	dc.b		'WHDL Commands Patch',0

