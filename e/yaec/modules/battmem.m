OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO ObtainBattSemaphore() IS (A6:=battmembase) BUT ASM ' jsr -6(a6)'
MACRO ReleaseBattSemaphore() IS (A6:=battmembase) BUT ASM ' jsr -12(a6)'
MACRO ReadBattMem(buffer,offset,length) IS Stores(battmembase,buffer,offset,length) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -18(a6)'
MACRO WriteBattMem(buffer,offset,length) IS Stores(battmembase,buffer,offset,length) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -24(a6)'
