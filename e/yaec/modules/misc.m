OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO AllocMiscResource(unitNum,name) IS Stores(miscbase,unitNum,name) BUT Loads(A6,D0,A1) BUT ASM ' jsr -6(a6)'
MACRO FreeMiscResource(unitNum) IS (D0:=unitNum) BUT (A6:=miscbase) BUT ASM ' jsr -12(a6)'
