OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO ResetBattClock() IS (A6:=battclockbase) BUT ASM ' jsr -6(a6)'
MACRO ReadBattClock() IS (A6:=battclockbase) BUT ASM ' jsr -12(a6)'
MACRO WriteBattClock(time) IS (D0:=time) BUT (A6:=battclockbase) BUT ASM ' jsr -18(a6)'
