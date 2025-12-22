pattern AddConfigDev(_configDev) is
	push a6;
	a0:=_configDev;
	a6:=ExpansionBase; jsr [a6-30];
	pop a6;
endp;															# ADDCONFIGDEV

pattern AddBootNode(_bootPri,_flags,_deviceNode,_configDev) is
	push a6;
	safe d0.l:=_bootPri; d1.l:=_flags; a0:=_deviceNode; a1:=_configDev;;
	a6:=ExpansionBase; jsr [a6-36];
	pop a6;
endp;															# ADDBOOTNODE

pattern AllocBoardMem(_slotSpec) is
	push a6;
	d0.l:=_slotSpec;
	a6:=ExpansionBase; jsr [a6-42];
	pop a6;
endp;															# ALLOCBOARDMEM

pattern AllocConfigDev is
	push a6;
	a6:=ExpansionBase; jsr [a6-48];
	pop a6;
endp;															# ALLOCCONFIGDEV

pattern AllocExpansionMem(_numSlots,_slotAlign) is
	push a6;
	safe d0.l:=_numSlots; d1.l:=_slotAlign;;
	a6:=ExpansionBase; jsr [a6-54];
	pop a6;
endp;															# ALLOCEXPANSIONMEM

pattern ConfigBoard(_board,_configDev) is
	push a6;
	safe a0:=_board; a1:=_configDev;;
	a6:=ExpansionBase; jsr [a6-60];
	pop a6;
endp;															# CONFIGBOARD

pattern ConfigChain(_baseAddr) is
	push a6;
	a0:=_baseAddr;
	a6:=ExpansionBase; jsr [a6-66];
	pop a6;
endp;															# CONFIGCHAIN

pattern FindConfigDev(_oldConfigDev,_manufacturer,_product) is
	push a6;
	safe a0:=_oldConfigDev; d0.l:=_manufacturer; d1.l:=_product;;
	a6:=ExpansionBase; jsr [a6-72];
	pop a6;
endp;															# FINDCONFIGDEV

pattern FreeBoardMem(_startSlot,_slotSpec) is
	push a6;
	safe d0.l:=_startSlot; d1.l:=_slotSpec;;
	a6:=ExpansionBase; jsr [a6-78];
	pop a6;
endp;															# FREEBOARDMEM

pattern FreeConfigDev(_configDev) is
	push a6;
	a0:=_configDev;
	a6:=ExpansionBase; jsr [a6-84];
	pop a6;
endp;															# FREECONFIGDEV

pattern FreeExpansionMem(_startSlot,_numSlots) is
	push a6;
	safe d0.l:=_startSlot; d1.l:=_numSlots;;
	a6:=ExpansionBase; jsr [a6-90];
	pop a6;
endp;															# FREEEXPANSIONMEM

pattern ReadExpansionByte(_board,_offset) is
	push a6;
	safe a0:=_board; d0.l:=_offset;;
	a6:=ExpansionBase; jsr [a6-96];
	pop a6;
endp;															# READEXPANSIONBYTE

pattern ReadExpansionRom(_board,_configDev) is
	push a6;
	safe a0:=_board; a1:=_configDev;;
	a6:=ExpansionBase; jsr [a6-102];
	pop a6;
endp;															# READEXPANSIONROM

pattern RemConfigDev(_configDev) is
	push a6;
	a0:=_configDev;
	a6:=ExpansionBase; jsr [a6-108];
	pop a6;
endp;															# REMCONFIGDEV

pattern WriteExpansionByte(_board,_offset,_byte) is
	push a6;
	safe a0:=_board; d0.l:=_offset; d1.l:=_byte;;
	a6:=ExpansionBase; jsr [a6-114];
	pop a6;
endp;															# WRITEEXPANSIONBYTE

pattern ObtainConfigBinding is
	push a6;
	a6:=ExpansionBase; jsr [a6-120];
	pop a6;
endp;															# OBTAINCONFIGBINDING

pattern ReleaseConfigBinding is
	push a6;
	a6:=ExpansionBase; jsr [a6-126];
	pop a6;
endp;															# RELEASECONFIGBINDING

pattern SetCurrentBinding(_currentBinding,_bindingSize) is
	push a6;
	safe a0:=_currentBinding; d0.l:=_bindingSize;;
	a6:=ExpansionBase; jsr [a6-132];
	pop a6;
endp;															# SETCURRENTBINDING

pattern GetCurrentBinding(_currentBinding,_bindingSize) is
	push a6;
	safe a0:=_currentBinding; d0.l:=_bindingSize;;
	a6:=ExpansionBase; jsr [a6-138];
	pop a6;
endp;															# GETCURRENTBINDING

pattern MakeDosNode(_parmPacket) is
	push a6;
	a0:=_parmPacket;
	a6:=ExpansionBase; jsr [a6-144];
	pop a6;
endp;															# MAKEDOSNODE

pattern AddDosNode(_bootPri,_flags,_deviceNode) is
	push a6;
	safe d0.l:=_bootPri; d1.l:=_flags; a0:=_deviceNode;;
	a6:=ExpansionBase; jsr [a6-150];
	pop a6;
endp;															# ADDDOSNODE

pattern expansionPrivate1 is
	push a6;
	a6:=ExpansionBase; jsr [a6-156];
	pop a6;
endp;															# EXPANSIONPRIVATE1

pattern expansionPrivate2 is
	push a6;
	a6:=ExpansionBase; jsr [a6-162];
	pop a6;
endp;															# EXPANSIONPRIVATE2

