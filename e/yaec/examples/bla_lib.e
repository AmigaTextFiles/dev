OPT MODULE
OPT EXPORT
-> Module created with E:bin/fd2module from YAECv18 package.
OPT NDDC
->  FD created with YAEC 1.9a
#macro Func1(x,y,z) IS Stores(blabase,x,y,z) BUT Loads(A6,D0,A0,A1) BUT ASM ' jsr -30(a6)'
#macro Func2(x,y) IS Stores(blabase,x,y) BUT Loads(A6,D0,A0) BUT ASM ' jsr -36(a6)'
#macro Func3() IS (A6:=blabase) BUT ASM ' jsr -42(a6)'
