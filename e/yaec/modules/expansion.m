OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V33 or higher (Release 1.2) ---
MACRO AddConfigDev(configDev) IS (A0:=configDev) BUT (A6:=expansionbase) BUT ASM ' jsr -30(a6)'
-> --- functions in V36 or higher (Release 2.0) ---
MACRO AddBootNode(bootPri,flags,deviceNode,configDev) IS Stores(expansionbase,bootPri,flags,deviceNode,configDev) BUT Loads(A6,D0,D1,A0,A1) BUT ASM ' jsr -36(a6)'
-> --- functions in V33 or higher (Release 1.2) ---
MACRO AllocBoardMem(slotSpec) IS (D0:=slotSpec) BUT (A6:=expansionbase) BUT ASM ' jsr -42(a6)'
MACRO AllocConfigDev() IS (A6:=expansionbase) BUT ASM ' jsr -48(a6)'
MACRO AllocExpansionMem(numSlots,slotAlign) IS Stores(expansionbase,numSlots,slotAlign) BUT Loads(A6,D0,D1) BUT ASM ' jsr -54(a6)'
MACRO ConfigBoard(board,configDev) IS Stores(expansionbase,board,configDev) BUT Loads(A6,A0,A1) BUT ASM ' jsr -60(a6)'
MACRO ConfigChain(baseAddr) IS (A0:=baseAddr) BUT (A6:=expansionbase) BUT ASM ' jsr -66(a6)'
MACRO FindConfigDev(oldConfigDev,manufacturer,product) IS Stores(expansionbase,oldConfigDev,manufacturer,product) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -72(a6)'
MACRO FreeBoardMem(startSlot,slotSpec) IS Stores(expansionbase,startSlot,slotSpec) BUT Loads(A6,D0,D1) BUT ASM ' jsr -78(a6)'
MACRO FreeConfigDev(configDev) IS (A0:=configDev) BUT (A6:=expansionbase) BUT ASM ' jsr -84(a6)'
MACRO FreeExpansionMem(startSlot,numSlots) IS Stores(expansionbase,startSlot,numSlots) BUT Loads(A6,D0,D1) BUT ASM ' jsr -90(a6)'
MACRO ReadExpansionByte(board,offset) IS Stores(expansionbase,board,offset) BUT Loads(A6,A0,D0) BUT ASM ' jsr -96(a6)'
MACRO ReadExpansionRom(board,configDev) IS Stores(expansionbase,board,configDev) BUT Loads(A6,A0,A1) BUT ASM ' jsr -102(a6)'
MACRO RemConfigDev(configDev) IS (A0:=configDev) BUT (A6:=expansionbase) BUT ASM ' jsr -108(a6)'
MACRO WriteExpansionByte(board,offset,byte) IS Stores(expansionbase,board,offset,byte) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -114(a6)'
MACRO ObtainConfigBinding() IS (A6:=expansionbase) BUT ASM ' jsr -120(a6)'
MACRO ReleaseConfigBinding() IS (A6:=expansionbase) BUT ASM ' jsr -126(a6)'
MACRO SetCurrentBinding(currentBinding,bindingSize) IS Stores(expansionbase,currentBinding,bindingSize) BUT Loads(A6,A0,D0) BUT ASM ' jsr -132(a6)'
MACRO GetCurrentBinding(currentBinding,bindingSize) IS Stores(expansionbase,currentBinding,bindingSize) BUT Loads(A6,A0,D0) BUT ASM ' jsr -138(a6)'
MACRO MakeDosNode(parmPacket) IS (A0:=parmPacket) BUT (A6:=expansionbase) BUT ASM ' jsr -144(a6)'
MACRO AddDosNode(bootPri,flags,deviceNode) IS Stores(expansionbase,bootPri,flags,deviceNode) BUT Loads(A6,D0,D1,A0) BUT ASM ' jsr -150(a6)'
