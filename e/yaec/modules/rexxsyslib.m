OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V33 or higher (Release 1.2) ---
-> 
MACRO CreateArgstring(string,length) IS Stores(rexxsysbase,string,length) BUT Loads(A6,A0,D0) BUT ASM ' jsr -126(a6)'
MACRO DeleteArgstring(argstring) IS (A0:=argstring) BUT (A6:=rexxsysbase) BUT ASM ' jsr -132(a6)'
MACRO LengthArgstring(argstring) IS (A0:=argstring) BUT (A6:=rexxsysbase) BUT ASM ' jsr -138(a6)'
MACRO CreateRexxMsg(port,extension,host) IS Stores(rexxsysbase,port,extension,host) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -144(a6)'
MACRO DeleteRexxMsg(packet) IS (A0:=packet) BUT (A6:=rexxsysbase) BUT ASM ' jsr -150(a6)'
MACRO ClearRexxMsg(msgptr,count) IS Stores(rexxsysbase,msgptr,count) BUT Loads(A6,A0,D0) BUT ASM ' jsr -156(a6)'
MACRO FillRexxMsg(msgptr,count,mask) IS Stores(rexxsysbase,msgptr,count,mask) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -162(a6)'
MACRO IsRexxMsg(msgptr) IS (A0:=msgptr) BUT (A6:=rexxsysbase) BUT ASM ' jsr -168(a6)'
-> 
-> 
MACRO LockRexxBase(resource) IS (D0:=resource) BUT (A6:=rexxsysbase) BUT ASM ' jsr -450(a6)'
MACRO UnlockRexxBase(resource) IS (D0:=resource) BUT (A6:=rexxsysbase) BUT ASM ' jsr -456(a6)'
-> 
