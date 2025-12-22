OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO AllocUnit(unitNum) IS (D0:=unitNum) BUT (A6:=diskbase) BUT ASM ' jsr -6(a6)'
MACRO FreeUnit(unitNum) IS (D0:=unitNum) BUT (A6:=diskbase) BUT ASM ' jsr -12(a6)'
MACRO GetUnit(unitPointer) IS (A1:=unitPointer) BUT (A6:=diskbase) BUT ASM ' jsr -18(a6)'
MACRO GiveUnit() IS (A6:=diskbase) BUT ASM ' jsr -24(a6)'
MACRO GetUnitID(unitNum) IS (D0:=unitNum) BUT (A6:=diskbase) BUT ASM ' jsr -30(a6)'
-> ------ new for V37 ------
MACRO ReadUnitID(unitNum) IS (D0:=unitNum) BUT (A6:=diskbase) BUT ASM ' jsr -36(a6)'
