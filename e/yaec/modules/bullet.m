OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO OpenEngine() IS (A6:=bulletbase) BUT ASM ' jsr -30(a6)'
MACRO CloseEngine(glyphEngine) IS (A0:=glyphEngine) BUT (A6:=bulletbase) BUT ASM ' jsr -36(a6)'
MACRO SetInfoA(glyphEngine,tagList) IS Stores(bulletbase,glyphEngine,tagList) BUT Loads(A6,A0,A1) BUT ASM ' jsr -42(a6)'
MACRO ObtainInfoA(glyphEngine,tagList) IS Stores(bulletbase,glyphEngine,tagList) BUT Loads(A6,A0,A1) BUT ASM ' jsr -48(a6)'
MACRO ReleaseInfoA(glyphEngine,tagList) IS Stores(bulletbase,glyphEngine,tagList) BUT Loads(A6,A0,A1) BUT ASM ' jsr -54(a6)'
