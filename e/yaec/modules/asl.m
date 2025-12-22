OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V36 or higher (Release 2.0) ---
-> 
->  OBSOLETE -- Please use the generic requester functions instead
-> 
MACRO AllocFileRequest() IS (A6:=aslbase) BUT ASM ' jsr -30(a6)'
MACRO FreeFileRequest(fileReq) IS (A0:=fileReq) BUT (A6:=aslbase) BUT ASM ' jsr -36(a6)'
MACRO RequestFile(fileReq) IS (A0:=fileReq) BUT (A6:=aslbase) BUT ASM ' jsr -42(a6)'
MACRO AllocAslRequest(reqType,tagList) IS Stores(aslbase,reqType,tagList) BUT Loads(A6,D0,A0) BUT ASM ' jsr -48(a6)'
MACRO FreeAslRequest(requester) IS (A0:=requester) BUT (A6:=aslbase) BUT ASM ' jsr -54(a6)'
MACRO AslRequest(requester,tagList) IS Stores(aslbase,requester,tagList) BUT Loads(A6,A0,A1) BUT ASM ' jsr -60(a6)'
