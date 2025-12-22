
* $Id: WHDLoadSetCPUFlags.s 1.1 2003/03/29 13:31:10 wepl Exp $

	INCDIR	Includes:
	INCLUDE UserSymbols.i
	INCLUDE	whdload.i

	dc.l		name
	dc.b		OREDSYM
	ORedSymbol	<WCPUF_Base_NCS>,WCPUF_Base,WCPUF_Base_NCS
	ORedSymbol	<WCPUF_Base_NC>,WCPUF_Base,WCPUF_Base_NC
	ORedSymbol	<WCPUF_Base_WT>,WCPUF_Base,WCPUF_Base_WT
	ORedSymbol	<WCPUF_Base_CB>,WCPUF_Base,WCPUF_Base_CB
	ORedSymbol	<WCPUF_Exp_NCS>,WCPUF_Exp,WCPUF_Exp_NCS
	ORedSymbol	<WCPUF_Exp_NC>,WCPUF_Exp,WCPUF_Exp_NC
	ORedSymbol	<WCPUF_Exp_WT>,WCPUF_Exp,WCPUF_Exp_WT
	ORedSymbol	<WCPUF_Exp_CB>,WCPUF_Exp,WCPUF_Exp_CB
	ORedSymbol	<WCPUF_Slave_NCS>,WCPUF_Slave,WCPUF_Slave_NCS
	ORedSymbol	<WCPUF_Slave_NC>,WCPUF_Slave,WCPUF_Slave_NC
	ORedSymbol	<WCPUF_Slave_WT>,WCPUF_Slave,WCPUF_Slave_WT
	ORedSymbol	<WCPUF_Slave_CB>,WCPUF_Slave,WCPUF_Slave_CB
	ORedSymbol	<WCPUF_IC>,WCPUF_IC,WCPUF_IC
	ORedSymbol	<WCPUF_DC>,WCPUF_DC,WCPUF_DC
	ORedSymbol	<WCPUF_NWA>,WCPUF_NWA,WCPUF_NWA
	ORedSymbol	<WCPUF_SB>,WCPUF_SB,WCPUF_SB
	ORedSymbol	<WCPUF_BC>,WCPUF_BC,WCPUF_BC
	ORedSymbol	<WCPUF_SS>,WCPUF_SS,WCPUF_SS
	ORedSymbol	<WCPUF_FPU>,WCPUF_FPU,WCPUF_FPU
	dc.b		ENDBASE
name	dc.b		'WHDL SetCPU Flags',0
