OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V34 or higher (Release 1.3) ---
MACRO KillRAD0() IS (A6:=ramdrivedevice) BUT ASM ' jsr -42(a6)'
-> --- functions in V36 or higher (Release 2.0) ---
MACRO KillRAD(unit) IS (D0:=unit) BUT (A6:=ramdrivedevice) BUT ASM ' jsr -48(a6)'
