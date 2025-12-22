OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V36 or higher (Release 2.0) ---
-> 
MACRO AddAppWindowA(id,userdata,window,msgport,taglist) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(workbenchbase,id,userdata,window,msgport,taglist) BUT Loads(A6,D0,D1,A0,A1,A2) BUT ASM ' jsr -48(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
MACRO RemoveAppWindow(appWindow) IS (A0:=appWindow) BUT (A6:=workbenchbase) BUT ASM ' jsr -54(a6)'
-> 
MACRO AddAppIconA(id,userdata,text,msgport,lock,diskobj,taglist) IS ASM ' movem.l d2-d7/a2-a5,-(a7)' BUT Stores(workbenchbase,id,userdata,text,msgport,lock,diskobj,taglist) BUT Loads(A6,D0,D1,A0,A1,A2,A3,A4) BUT ASM ' jsr -60(a6)' BUT ASM ' movem.l (a7)+, d2-d7/a2-a5'
-> 
MACRO RemoveAppIcon(appIcon) IS (A0:=appIcon) BUT (A6:=workbenchbase) BUT ASM ' jsr -66(a6)'
-> 
MACRO AddAppMenuItemA(id,userdata,text,msgport,taglist) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(workbenchbase,id,userdata,text,msgport,taglist) BUT Loads(A6,D0,D1,A0,A1,A2) BUT ASM ' jsr -72(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
MACRO RemoveAppMenuItem(appMenuItem) IS (A0:=appMenuItem) BUT (A6:=workbenchbase) BUT ASM ' jsr -78(a6)'
-> 
-> --- functions in V39 or higher (Release 3) ---
-> 
-> 
MACRO WBInfo(lock,name,screen) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(workbenchbase,lock,name,screen) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -90(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
-> --- (5 function slots reserved here) ---
-> 
