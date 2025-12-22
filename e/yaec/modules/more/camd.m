OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
->  "camd.library"
-> 
->  --------------------- Locks
-> 
MACRO LockCAMD(locktype) IS (D0:=locktype) BUT (A6:=camdbase) BUT ASM ' jsr -30(a6)'
MACRO UnlockCAMD(lock) IS (A0:=lock) BUT (A6:=camdbase) BUT ASM ' jsr -36(a6)'
-> 
->  --------------------- MidiNode
-> 
MACRO CreateMidiA(name,tags) IS Stores(camdbase,name,tags) BUT Loads(A6,A0,A1) BUT ASM ' jsr -42(a6)'
MACRO DeleteMidi(mi) IS (A0:=mi) BUT (A6:=camdbase) BUT ASM ' jsr -48(a6)'
MACRO SetMidiAttrsA(mi,tags) IS Stores(camdbase,mi,tags) BUT Loads(A6,A0,A1) BUT ASM ' jsr -54(a6)'
MACRO GetMidiAttrsA(mi,tags) IS Stores(camdbase,mi,tags) BUT Loads(A6,A0,A1) BUT ASM ' jsr -60(a6)'
MACRO NextMidi(mi) IS (A0:=mi) BUT (A6:=camdbase) BUT ASM ' jsr -66(a6)'
MACRO FindMidi(name) IS (A1:=name) BUT (A6:=camdbase) BUT ASM ' jsr -72(a6)'
MACRO FlushMidi(mi) IS (A0:=mi) BUT (A6:=camdbase) BUT ASM ' jsr -78(a6)'
-> 
->  --------------------- MidiLink
-> 
MACRO AddMidiLinkA(mi,type,tags) IS Stores(camdbase,mi,type,tags) BUT Loads(A6,A0,D0,A1) BUT ASM ' jsr -84(a6)'
MACRO RemoveMidiLink(ml) IS (A0:=ml) BUT (A6:=camdbase) BUT ASM ' jsr -90(a6)'
MACRO SetMidiLinkAttrsA(ml,tags) IS Stores(camdbase,ml,tags) BUT Loads(A6,A0,A1) BUT ASM ' jsr -96(a6)'
MACRO GetMidiLinkAttrsA(ml,tags) IS Stores(camdbase,ml,tags) BUT Loads(A6,A0,A1) BUT ASM ' jsr -102(a6)'
MACRO NextClusterLink(mc,ml,type) IS Stores(camdbase,mc,ml,type) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -108(a6)'
MACRO NextMidiLink(mi,ml,type) IS Stores(camdbase,mi,ml,type) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -114(a6)'
MACRO MidiLinkConnected(ml) IS (A0:=ml) BUT (A6:=camdbase) BUT ASM ' jsr -120(a6)'
-> 
->  --------------------- MidiCluster
-> 
MACRO NextCluster(mc) IS (A0:=mc) BUT (A6:=camdbase) BUT ASM ' jsr -126(a6)'
MACRO FindCluster(name) IS (A0:=name) BUT (A6:=camdbase) BUT ASM ' jsr -132(a6)'
-> 
->  --------------------- Message
-> 
MACRO PutMidi(ml,msgdata) IS Stores(camdbase,ml,msgdata) BUT Loads(A6,A0,D0) BUT ASM ' jsr -138(a6)'
MACRO GetMidi(mi,msg) IS Stores(camdbase,mi,msg) BUT Loads(A6,A0,A1) BUT ASM ' jsr -144(a6)'
MACRO WaitMidi(mi,msg) IS Stores(camdbase,mi,msg) BUT Loads(A6,A0,A1) BUT ASM ' jsr -150(a6)'
MACRO PutSysEx(ml,buffer) IS Stores(camdbase,ml,buffer) BUT Loads(A6,A0,A1) BUT ASM ' jsr -156(a6)'
MACRO GetSysEx(mi,buffer,len) IS Stores(camdbase,mi,buffer,len) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -162(a6)'
MACRO QuerySysEx(mi) IS (A0:=mi) BUT (A6:=camdbase) BUT ASM ' jsr -168(a6)'
MACRO SkipSysEx(mi) IS (A0:=mi) BUT (A6:=camdbase) BUT ASM ' jsr -174(a6)'
MACRO GetMidiErr(mi) IS (A0:=mi) BUT (A6:=camdbase) BUT ASM ' jsr -180(a6)'
MACRO MidiMsgType(msg) IS (A0:=msg) BUT (A6:=camdbase) BUT ASM ' jsr -186(a6)'
MACRO MidiMsgLen(status) IS (D0:=status) BUT (A6:=camdbase) BUT ASM ' jsr -192(a6)'
MACRO ParseMidi(ml,buffer,length) IS Stores(camdbase,ml,buffer,length) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -198(a6)'
-> 
->  --------------------- Device
-> 
MACRO OpenMidiDevice(name) IS (A0:=name) BUT (A6:=camdbase) BUT ASM ' jsr -204(a6)'
MACRO CloseMidiDevice(mdd) IS (A0:=mdd) BUT (A6:=camdbase) BUT ASM ' jsr -210(a6)'
-> 
->  --------------------- External functions
-> 
MACRO RethinkCAMD() IS (A6:=camdbase) BUT ASM ' jsr -216(a6)'
MACRO StartClusterNotify(node) IS (A0:=node) BUT (A6:=camdbase) BUT ASM ' jsr -222(a6)'
MACRO EndClusterNotify(node) IS (A0:=node) BUT (A6:=camdbase) BUT ASM ' jsr -228(a6)'
-> 
