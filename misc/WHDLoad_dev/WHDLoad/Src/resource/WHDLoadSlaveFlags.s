
* $Id: WHDLoadSlaveFlags.s 1.2 2003/06/03 06:27:30 wepl Exp $

	INCDIR	Includes:
	INCLUDE UserSymbols.i
	INCLUDE	whdload.i

	dc.l		name
	dc.b		OREDSYM
	ORedSymbol	<WHDLF_Disk>,WHDLF_Disk,WHDLF_Disk
	ORedSymbol	<WHDLF_NoError>,WHDLF_NoError,WHDLF_NoError
	ORedSymbol	<WHDLF_EmulTrap>,WHDLF_EmulTrap,WHDLF_EmulTrap
	ORedSymbol	<WHDLF_NoDivZero>,WHDLF_NoDivZero,WHDLF_NoDivZero
	ORedSymbol	<WHDLF_Req68020>,WHDLF_Req68020,WHDLF_Req68020
	ORedSymbol	<WHDLF_ReqAGA>,WHDLF_ReqAGA,WHDLF_ReqAGA
	ORedSymbol	<WHDLF_NoKbd>,WHDLF_NoKbd,WHDLF_NoKbd
	ORedSymbol	<WHDLF_EmulLineA>,WHDLF_EmulLineA,WHDLF_EmulLineA
	ORedSymbol	<WHDLF_EmulTrapV>,WHDLF_EmulTrapV,WHDLF_EmulTrapV
	ORedSymbol	<WHDLF_EmulChk>,WHDLF_EmulChk,WHDLF_EmulChk
	ORedSymbol	<WHDLF_EmulPriv>,WHDLF_EmulPriv,WHDLF_EmulPriv
	ORedSymbol	<WHDLF_EmulLineF>,WHDLF_EmulLineF,WHDLF_EmulLineF
	ORedSymbol	<WHDLF_ClearMem>,WHDLF_ClearMem,WHDLF_ClearMem
	ORedSymbol	<WHDLF_Examine>,WHDLF_Examine,WHDLF_Examine
	ORedSymbol	<WHDLF_EmulDivZero>,WHDLF_EmulDivZero,WHDLF_EmulDivZero
	dc.b		ENDBASE
name	dc.b		'WHDL Slave Flags',0
