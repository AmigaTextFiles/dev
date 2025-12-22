
* $Id: RawDICSlaveFlags.s 1.1 2004/01/20 00:31:42 wepl Exp wepl $

	INCDIR	Includes:
	INCLUDE UserSymbols.i
	INCLUDE	RawDIC.i

	dc.l		name
	dc.b		OREDSYM
	ORedSymbol	<SFLG_DEBUG>,SFLG_DEBUG,SFLG_DEBUG
	dc.b		ENDBASE
name	dc.b		'RawDIC Slave Flags',0

