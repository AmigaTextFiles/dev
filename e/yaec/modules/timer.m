OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO AddTime(dest,src) IS Stores(timerbase,dest,src) BUT Loads(A6,A0,A1) BUT ASM ' jsr -42(a6)'
MACRO SubTime(dest,src) IS Stores(timerbase,dest,src) BUT Loads(A6,A0,A1) BUT ASM ' jsr -48(a6)'
MACRO CmpTime(dest,src) IS Stores(timerbase,dest,src) BUT Loads(A6,A0,A1) BUT ASM ' jsr -54(a6)'
MACRO ReadEClock(dest) IS (A0:=dest) BUT (A6:=timerbase) BUT ASM ' jsr -60(a6)'
MACRO GetSysTime(dest) IS (A0:=dest) BUT (A6:=timerbase) BUT ASM ' jsr -66(a6)'
