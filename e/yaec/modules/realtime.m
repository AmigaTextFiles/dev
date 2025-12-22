OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V37 or higher (Release 2.04) ---
-> 
->  Locks
-> 
MACRO LockRealTime(lockType) IS (D0:=lockType) BUT (A6:=realtimebase) BUT ASM ' jsr -30(a6)'
MACRO UnlockRealTime(lock) IS (A0:=lock) BUT (A6:=realtimebase) BUT ASM ' jsr -36(a6)'
-> 
->  Conductor
-> 
MACRO CreatePlayerA(tagList) IS (A0:=tagList) BUT (A6:=realtimebase) BUT ASM ' jsr -42(a6)'
MACRO DeletePlayer(player) IS (A0:=player) BUT (A6:=realtimebase) BUT ASM ' jsr -48(a6)'
MACRO SetPlayerAttrsA(player,tagList) IS Stores(realtimebase,player,tagList) BUT Loads(A6,A0,A1) BUT ASM ' jsr -54(a6)'
MACRO SetConductorState(player,state,time) IS Stores(realtimebase,player,state,time) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -60(a6)'
MACRO ExternalSync(player,minTime,maxTime) IS Stores(realtimebase,player,minTime,maxTime) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -66(a6)'
MACRO NextConductor(previousConductor) IS (A0:=previousConductor) BUT (A6:=realtimebase) BUT ASM ' jsr -72(a6)'
MACRO FindConductor(name) IS (A0:=name) BUT (A6:=realtimebase) BUT ASM ' jsr -78(a6)'
MACRO GetPlayerAttrsA(player,tagList) IS Stores(realtimebase,player,tagList) BUT Loads(A6,A0,A1) BUT ASM ' jsr -84(a6)'
