OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO OwnCard(handle) IS (A1:=handle) BUT (A6:=cardresource) BUT ASM ' jsr -6(a6)'
MACRO ReleaseCard(handle,flags) IS Stores(cardresource,handle,flags) BUT Loads(A6,A1,D0) BUT ASM ' jsr -12(a6)'
MACRO GetCardMap() IS (A6:=cardresource) BUT ASM ' jsr -18(a6)'
MACRO BeginCardAccess(handle) IS (A1:=handle) BUT (A6:=cardresource) BUT ASM ' jsr -24(a6)'
MACRO EndCardAccess(handle) IS (A1:=handle) BUT (A6:=cardresource) BUT ASM ' jsr -30(a6)'
MACRO ReadCardStatus() IS (A6:=cardresource) BUT ASM ' jsr -36(a6)'
MACRO CardResetRemove(handle,flag) IS Stores(cardresource,handle,flag) BUT Loads(A6,A1,D0) BUT ASM ' jsr -42(a6)'
MACRO CardMiscControl(handle,control_bits) IS Stores(cardresource,handle,control_bits) BUT Loads(A6,A1,D1) BUT ASM ' jsr -48(a6)'
MACRO CardAccessSpeed(handle,nanoseconds) IS Stores(cardresource,handle,nanoseconds) BUT Loads(A6,A1,D0) BUT ASM ' jsr -54(a6)'
MACRO CardProgramVoltage(handle,voltage) IS Stores(cardresource,handle,voltage) BUT Loads(A6,A1,D0) BUT ASM ' jsr -60(a6)'
MACRO CardResetCard(handle) IS (A1:=handle) BUT (A6:=cardresource) BUT ASM ' jsr -66(a6)'
MACRO CopyTuple(handle,buffer,tuplecode,size) IS Stores(cardresource,handle,buffer,tuplecode,size) BUT Loads(A6,A1,A0,D1,D0) BUT ASM ' jsr -72(a6)'
MACRO DeviceTuple(tuple_data,storage) IS Stores(cardresource,tuple_data,storage) BUT Loads(A6,A0,A1) BUT ASM ' jsr -78(a6)'
MACRO IfAmigaXIP(handle) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(cardresource,handle) BUT Loads(A6,A2) BUT ASM ' jsr -84(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO CardForceChange() IS (A6:=cardresource) BUT ASM ' jsr -90(a6)'
MACRO CardChangeCount() IS (A6:=cardresource) BUT ASM ' jsr -96(a6)'
MACRO CardInterface() IS (A6:=cardresource) BUT ASM ' jsr -102(a6)'
