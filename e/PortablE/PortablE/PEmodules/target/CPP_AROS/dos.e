OPT NATIVE, INLINE
PUBLIC MODULE 'target/dos/bptr', 'target/dos/datetime', 'target/dos/dos', 'target/dos/dosasl', 'target/dos/dosextens', 'target/dos/doshunks', 'target/dos/dostags', 'target/dos/exall', 'target/dos/filehandler', /*'target/dos/filesystem',*/ 'target/dos/notify', 'target/dos/rdargs', 'target/dos/record', 'target/dos/stdio', 'target/dos/var'
MODULE 'target/aros/libcall', 'target/dos/dos', 'target/dos/dosextens', 'target/dos/record', 'target/dos/rdargs', 'target/dos/dosasl', 'target/dos/var', 'target/dos/notify', 'target/dos/datetime', 'target/dos/dostags', 'target/dos/exall', 'target/aros/preprocessor/variadic/cast2iptr'
MODULE 'target/exec/types', 'target/aros/system', 'target/defines/dos'
MODULE 'target/utility/tagitem', 'target/exec/ports', 'target/exec/devices', 'target/exec'
{
#include <proto/dos.h>
}
{
struct DosLibrary* DOSBase = NULL;
}
NATIVE {CLIB_DOS_PROTOS_H} CONST
NATIVE {PROTO_DOS_H} CONST

NATIVE {DOSBase} DEF dosbase:NATIVE {struct DosLibrary*} PTR TO lib

->automatic opening of dos library
PROC new()
	dosbase := OpenLibrary('dos.library', 39)
	IF dosbase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

->automatic closing of dos library
PROC end()
	CloseLibrary(dosbase)
ENDPROC


->AROS aliases
NATIVE {ExamineFH} PROC
PROC ExamineFH(lock:BPTR, fib:PTR TO fileinfoblock) IS Examine(lock, fib)
NATIVE {UnLock} PROC
PROC UnLock(file:BPTR) IS Close(file)
NATIVE {NameFromFH} PROC
PROC NameFromFH(lock:BPTR, buffer:/*STRPTR*/ ARRAY OF CHAR, length:VALUE) IS NameFromLock(lock, buffer, length)
NATIVE {DupLockFromFH} PROC
PROC DupLockFromFH(lock:BPTR) IS DupLock(lock)


NATIVE {AllocDosObjectTagList} PROC	->AllocDosObjectTagList(...) AllocDosObject(__VA_ARGS__)
NATIVE {CreateNewProcTagList} PROC	->CreateNewProcTagList(...) CreateNewProc(__VA_ARGS__)
NATIVE {NewLoadSegTagList} PROC	->NewLoadSegTagList(...) NewLoadSeg(__VA_ARGS__)
NATIVE {System} PROC	->System(...) SystemTagList(__VA_ARGS__)

/* Prototypes for stubs in amiga.lib */
NATIVE {AllocDosObjectTags} PROC
->PROC AllocDosObjectTags(type:ULONG, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {AllocDosObjectTags(} type {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR2
NATIVE {CreateNewProcTags} PROC
->PROC CreateNewProcTags(tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {CreateNewProcTags(} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO process
NATIVE {NewLoadSegTags} PROC
->PROC NewLoadSegTags(file:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {NewLoadSegTags(} file {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!BPTR
NATIVE {SystemTags} PROC
PROC SystemTags(command:/*STRPTR*/ ARRAY OF CHAR, tag=0:ULONG, ...) IS NATIVE {SystemTags(} command {,} tag {,} ... {)} ENDNATIVE !!VALUE

NATIVE {FWritef} PROC
PROC Fwritef( fh:BPTR, format:/*STRPTR*/ ARRAY OF CHAR, format2=0:ULONG, ... ) IS NATIVE {FWritef(} fh {,} format {,} format2 {,} ... {)} ENDNATIVE
NATIVE {FPrintf} PROC
PROC Fprintf( fh:BPTR, format:/*STRPTR*/ ARRAY OF CHAR, format2=0:ULONG, ... ) IS NATIVE {FPrintf(} fh {,} format {,} format2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {Printf} PROC
PROC Printf( format:/*STRPTR*/ ARRAY OF CHAR, format2=0:ULONG, ... ) IS NATIVE {Printf(} format {,} format2 {,} ... {)} ENDNATIVE !!VALUE

NATIVE {Open} PROC
PROC Open(name:/*CONST_STRPTR*/ ARRAY OF CHAR, accessMode:VALUE) IS NATIVE {Open(} name {,} accessMode {)} ENDNATIVE !!BPTR
NATIVE {Close} PROC
PROC Close(file:BPTR) IS NATIVE {-(BOOLEAN)(0!=Close(} file {))} ENDNATIVE !!BOOL
NATIVE {Read} PROC
PROC Read(file:BPTR, buffer:APTR, length:VALUE) IS NATIVE {Read(} file {,} buffer {,} length {)} ENDNATIVE !!VALUE
NATIVE {Write} PROC
PROC Write(file:BPTR, buffer:CONST_APTR, length:VALUE) IS NATIVE {Write(} file {,} buffer {,} length {)} ENDNATIVE !!VALUE
NATIVE {Input} PROC
PROC Input() IS NATIVE {Input()} ENDNATIVE !!BPTR
NATIVE {Output} PROC
PROC Output() IS NATIVE {Output()} ENDNATIVE !!BPTR
NATIVE {Seek} PROC
PROC Seek(file:BPTR, position:VALUE, mode:VALUE) IS NATIVE {Seek(} file {,} position {,} mode {)} ENDNATIVE !!VALUE
NATIVE {DeleteFile} PROC
PROC DeleteFile(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=DeleteFile(} name {))} ENDNATIVE !!BOOL
NATIVE {Rename} PROC
PROC Rename(oldName:/*CONST_STRPTR*/ ARRAY OF CHAR, newName:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=Rename(} oldName {,} newName {))} ENDNATIVE !!BOOL
NATIVE {Lock} PROC
PROC Lock(name:/*CONST_STRPTR*/ ARRAY OF CHAR, accessMode:VALUE) IS NATIVE {Lock(} name {,} accessMode {)} ENDNATIVE !!BPTR
NATIVE {DupLock} PROC
PROC DupLock(lock:BPTR) IS NATIVE {DupLock(} lock {)} ENDNATIVE !!BPTR
NATIVE {Examine} PROC
PROC Examine(lock:BPTR, fib:PTR TO fileinfoblock) IS NATIVE {-(BOOLEAN)(0!=Examine(} lock {,} fib {))} ENDNATIVE !!BOOL
NATIVE {ExNext} PROC
PROC ExNext(lock:BPTR, fileInfoBlock:PTR TO fileinfoblock) IS NATIVE {-(BOOLEAN)(0!=ExNext(} lock {,} fileInfoBlock {))} ENDNATIVE !!BOOL
NATIVE {Info} PROC
PROC Info(lock:BPTR, parameterBlock:PTR TO infodata) IS NATIVE {-(BOOLEAN)(0!=Info(} lock {,} parameterBlock {))} ENDNATIVE !!BOOL
NATIVE {CreateDir} PROC
PROC CreateDir(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {CreateDir(} name {)} ENDNATIVE !!BPTR
NATIVE {CurrentDir} PROC
PROC CurrentDir(lock:BPTR) IS NATIVE {CurrentDir(} lock {)} ENDNATIVE !!BPTR
NATIVE {IoErr} PROC
PROC IoErr() IS NATIVE {IoErr()} ENDNATIVE !!VALUE
NATIVE {CreateProc} PROC
PROC CreateProc(name:/*CONST_STRPTR*/ ARRAY OF CHAR, pri:VALUE, segList:BPTR, stackSize:VALUE) IS NATIVE {CreateProc(} name {,} pri {,} segList {,} stackSize {)} ENDNATIVE !!PTR TO mp
NATIVE {Exit} PROC
PROC Exit(returnCode:VALUE) IS NATIVE {Exit(} returnCode {)} ENDNATIVE
NATIVE {LoadSeg} PROC
PROC LoadSeg(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {LoadSeg(} name {)} ENDNATIVE !!BPTR
NATIVE {UnLoadSeg} PROC
PROC UnLoadSeg(seglist:BPTR) IS NATIVE {-UnLoadSeg(} seglist {)} ENDNATIVE !!INT
NATIVE {DeviceProc} PROC
PROC DeviceProc(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {DeviceProc(} name {)} ENDNATIVE !!PTR TO mp
NATIVE {SetComment} PROC
PROC SetComment(name:/*STRPTR*/ ARRAY OF CHAR, comment:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=SetComment(} name {,} comment {))} ENDNATIVE !!BOOL
NATIVE {SetProtection} PROC
PROC SetProtection(name:/*CONST_STRPTR*/ ARRAY OF CHAR, protect:ULONG) IS NATIVE {-(BOOLEAN)(0!=SetProtection(} name {,} protect {))} ENDNATIVE !!BOOL
->NATIVE {DateStamp} PROC
PROC DateStamp(date:PTR TO datestamp) IS NATIVE {DateStamp(} date {)} ENDNATIVE !!PTR TO datestamp
NATIVE {Delay} PROC
PROC Delay(timeout:ULONG) IS NATIVE {Delay(} timeout {)} ENDNATIVE
NATIVE {WaitForChar} PROC
PROC WaitForChar(file:BPTR, timeout:VALUE) IS NATIVE {-(BOOLEAN)(0!=WaitForChar(} file {,} timeout {))} ENDNATIVE !!BOOL
NATIVE {ParentDir} PROC
PROC ParentDir(lock:BPTR) IS NATIVE {ParentDir(} lock {)} ENDNATIVE !!BPTR
NATIVE {IsInteractive} PROC
PROC IsInteractive(file:BPTR) IS NATIVE {-(BOOLEAN)(0!=IsInteractive(} file {))} ENDNATIVE !!BOOL
NATIVE {Execute} PROC
PROC Execute(string:/*STRPTR*/ ARRAY OF CHAR, input:BPTR, output:BPTR) IS NATIVE {-(BOOLEAN)(0!=Execute(} string {,} input {,} output {))} ENDNATIVE !!BOOL
NATIVE {AllocDosObject} PROC
PROC AllocDosObject(type:ULONG, tags:ARRAY OF tagitem) IS NATIVE {AllocDosObject(} type {,} tags {)} ENDNATIVE !!APTR2
NATIVE {FreeDosObject} PROC
PROC FreeDosObject(type:ULONG, ptr:APTR2) IS NATIVE {FreeDosObject(} type {,} ptr {)} ENDNATIVE
NATIVE {DoPkt} PROC
PROC DoPkt(port:PTR TO mp, action:VALUE, arg1:VALUE, arg2:VALUE, arg3:VALUE, arg4:VALUE, arg5:VALUE) IS NATIVE {DoPkt(} port {,} action {,} arg1 {,} arg2 {,} arg3 {,} arg4 {,} arg5 {)} ENDNATIVE !!VALUE
NATIVE {SendPkt} PROC
PROC SendPkt(dp:PTR TO dospacket, port:PTR TO mp, replyport:PTR TO mp) IS NATIVE {SendPkt(} dp {,} port {,} replyport {)} ENDNATIVE
NATIVE {WaitPkt} PROC
PROC WaitPkt() IS NATIVE {WaitPkt()} ENDNATIVE !!PTR TO dospacket
NATIVE {ReplyPkt} PROC
PROC ReplyPkt(dp:PTR TO dospacket, res1:VALUE, res2:VALUE) IS NATIVE {ReplyPkt(} dp {,} res1 {,} res2 {)} ENDNATIVE
NATIVE {AbortPkt} PROC
PROC AbortPkt(port:PTR TO mp, pkt:PTR TO dospacket) IS NATIVE {AbortPkt(} port {,} pkt {)} ENDNATIVE
NATIVE {LockRecord} PROC
PROC LockRecord(fh:BPTR, offset:ULONG, length:ULONG, mode:ULONG, timeout:ULONG) IS NATIVE {-(BOOLEAN)(0!=LockRecord(} fh {,} offset {,} length {,} mode {,} timeout {))} ENDNATIVE !!BOOL
NATIVE {LockRecords} PROC
PROC LockRecords(recArray:PTR TO recordlock, timeout:ULONG) IS NATIVE {-(BOOLEAN)(0!=LockRecords(} recArray {,} timeout {))} ENDNATIVE !!BOOL
NATIVE {UnLockRecord} PROC
PROC UnLockRecord(fh:BPTR, offset:ULONG, length:ULONG) IS NATIVE {-(BOOLEAN)(0!=UnLockRecord(} fh {,} offset {,} length {))} ENDNATIVE !!BOOL
NATIVE {UnLockRecords} PROC
PROC UnLockRecords(recArray:PTR TO recordlock) IS NATIVE {-(BOOLEAN)(0!=UnLockRecords(} recArray {))} ENDNATIVE !!BOOL
NATIVE {SelectInput} PROC
PROC SelectInput(fh:BPTR) IS NATIVE {SelectInput(} fh {)} ENDNATIVE !!BPTR
NATIVE {SelectOutput} PROC
PROC SelectOutput(fh:BPTR) IS NATIVE {SelectOutput(} fh {)} ENDNATIVE !!BPTR
NATIVE {FGetC} PROC
PROC FgetC(file:BPTR) IS NATIVE {FGetC(} file {)} ENDNATIVE !!VALUE
NATIVE {FPutC} PROC
PROC FputC(file:BPTR, character:VALUE) IS NATIVE {FPutC(} file {,} character {)} ENDNATIVE !!VALUE
NATIVE {UnGetC} PROC
PROC UnGetC(file:BPTR, character:VALUE) IS NATIVE {UnGetC(} file {,} character {)} ENDNATIVE !!VALUE
NATIVE {FRead} PROC
PROC Fread(fh:BPTR, block:APTR, blocklen:ULONG, number:ULONG) IS NATIVE {FRead(} fh {,} block {,} blocklen {,} number {)} ENDNATIVE !!VALUE
NATIVE {FWrite} PROC
PROC Fwrite(fh:BPTR, block:APTR, blocklen:ULONG, numblocks:ULONG) IS NATIVE {FWrite(} fh {,} block {,} blocklen {,} numblocks {)} ENDNATIVE !!VALUE
NATIVE {FGets} PROC
PROC Fgets(fh:BPTR, buf:/*STRPTR*/ ARRAY OF CHAR, buflen:ULONG) IS NATIVE {FGets(} fh {,} buf {,} buflen {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {FPuts} PROC
PROC Fputs(file:BPTR, string:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {FPuts(} file {,} string {)} ENDNATIVE !!VALUE
NATIVE {VFWritef} PROC
PROC VfWritef(fh:BPTR, fmt:/*STRPTR*/ ARRAY OF CHAR, argarray:RAWARG) IS NATIVE {VFWritef(} fh {,} fmt {,} argarray {)} ENDNATIVE !!VALUE
NATIVE {VFPrintf} PROC
PROC VfPrintf(file:BPTR, format:/*CONST_STRPTR*/ ARRAY OF CHAR, argarray:RAWARG) IS NATIVE {VFPrintf(} file {,} format {,} argarray {)} ENDNATIVE !!VALUE
NATIVE {Flush} PROC
PROC Flush(file:BPTR) IS NATIVE {Flush(} file {)} ENDNATIVE !!VALUE
NATIVE {SetVBuf} PROC
PROC SetVBuf(file:BPTR, buff:/*STRPTR*/ ARRAY OF CHAR, type:VALUE, size:VALUE) IS NATIVE {SetVBuf(} file {,} buff {,} type {,} size {)} ENDNATIVE !!VALUE
NATIVE {OpenFromLock} PROC
PROC OpenFromLock(lock:BPTR) IS NATIVE {OpenFromLock(} lock {)} ENDNATIVE !!BPTR
NATIVE {ParentOfFH} PROC
PROC ParentOfFH(fh:BPTR) IS NATIVE {ParentOfFH(} fh {)} ENDNATIVE !!BPTR
NATIVE {SetFileDate} PROC
PROC SetFileDate(name:/*CONST_STRPTR*/ ARRAY OF CHAR, date:PTR TO datestamp) IS NATIVE {-(BOOLEAN)(0!=SetFileDate(} name {,} date {))} ENDNATIVE !!BOOL
NATIVE {NameFromLock} PROC
PROC NameFromLock(lock:BPTR, buffer:/*STRPTR*/ ARRAY OF CHAR, length:VALUE) IS NATIVE {-(BOOLEAN)(0!=NameFromLock(} lock {,} buffer {,} length {))} ENDNATIVE !!BOOL
NATIVE {SplitName} PROC
PROC SplitName(name:/*CONST_STRPTR*/ ARRAY OF CHAR, seperator:ULONG, buf:/*STRPTR*/ ARRAY OF CHAR, oldpos:VALUE, size:VALUE) IS NATIVE {SplitName(} name {,} seperator {,} buf {,} oldpos {,} size {)} ENDNATIVE !!VALUE
NATIVE {SameLock} PROC
PROC SameLock(lock1:BPTR, lock2:BPTR) IS NATIVE {SameLock(} lock1 {,} lock2 {)} ENDNATIVE !!VALUE
NATIVE {SetMode} PROC
PROC SetMode(fh:BPTR, mode:VALUE) IS NATIVE {-(BOOLEAN)(0!=SetMode(} fh {,} mode {))} ENDNATIVE !!BOOL
NATIVE {ExAll} PROC
PROC ExAll(lock:BPTR, buffer:PTR TO exalldata, size:VALUE, data:VALUE, control:PTR TO exallcontrol) IS NATIVE {-(BOOLEAN)(0!=ExAll(} lock {,} buffer {,} size {,} data {,} control {))} ENDNATIVE !!BOOL
NATIVE {ReadLink} PROC
PROC ReadLink(port:PTR TO mp, lock:BPTR, path:/*STRPTR*/ ARRAY OF CHAR, buffer:/*STRPTR*/ ARRAY OF CHAR, size:ULONG) IS NATIVE {ReadLink(} port {,} lock {,} path {,} buffer {,} size {)} ENDNATIVE !!VALUE
NATIVE {MakeLink} PROC
PROC MakeLink(name:/*STRPTR*/ ARRAY OF CHAR, dest:NATIVE {SIPTR} VALUE, soft:VALUE) IS NATIVE {-(BOOLEAN)(0!=MakeLink(} name {,} dest {,} soft {))} ENDNATIVE !!BOOL
NATIVE {ChangeMode} PROC
PROC ChangeMode(type:ULONG, object:BPTR, newmode:ULONG) IS NATIVE {-(BOOLEAN)(0!=ChangeMode(} type {,} object {,} newmode {))} ENDNATIVE !!BOOL
NATIVE {SetFileSize} PROC
PROC SetFileSize(file:BPTR, offset:VALUE, mode:VALUE) IS NATIVE {SetFileSize(} file {,} offset {,} mode {)} ENDNATIVE !!VALUE
NATIVE {SetIoErr} PROC
PROC SetIoErr(result:VALUE) IS NATIVE {SetIoErr(} result {)} ENDNATIVE !!VALUE
NATIVE {Fault} PROC
PROC Fault(code:VALUE, header:/*CONST_STRPTR*/ ARRAY OF CHAR, buffer:/*STRPTR*/ ARRAY OF CHAR, len:VALUE) IS NATIVE {Fault(} code {,} header {,} buffer {,} len {)} ENDNATIVE !!INT
NATIVE {PrintFault} PROC
PROC PrintFault(code:VALUE, header:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {PrintFault(} code {,} header {)} ENDNATIVE !!INT
NATIVE {ErrorReport} PROC
PROC ErrorReport(code:VALUE, type:VALUE, arg1:IPTR, device:PTR TO mp) IS NATIVE {-(BOOLEAN)(0!=ErrorReport(} code {,} type {,} arg1 {,} device {))} ENDNATIVE !!BOOL
NATIVE {DisplayError} PROC
PROC DisplayError(formatStr:/*CONST_STRPTR*/ ARRAY OF CHAR, flags:ULONG, args:APTR) IS NATIVE {DisplayError(} formatStr {,} flags {,} args {)} ENDNATIVE !!VALUE
NATIVE {Cli} PROC
PROC Cli() IS NATIVE {Cli()} ENDNATIVE !!PTR TO commandlineinterface
NATIVE {CreateNewProc} PROC
PROC CreateNewProc(tags:ARRAY OF tagitem) IS NATIVE {CreateNewProc(} tags {)} ENDNATIVE !!PTR TO process
NATIVE {RunCommand} PROC
PROC RunCommand(segList:BPTR, stacksize:ULONG, argptr:/*STRPTR*/ ARRAY OF CHAR, argsize:ULONG) IS NATIVE {RunCommand(} segList {,} stacksize {,} argptr {,} argsize {)} ENDNATIVE !!VALUE
NATIVE {GetConsoleTask} PROC
PROC GetConsoleTask() IS NATIVE {GetConsoleTask()} ENDNATIVE !!PTR TO mp
NATIVE {SetConsoleTask} PROC
PROC SetConsoleTask(handler:PTR TO mp) IS NATIVE {SetConsoleTask(} handler {)} ENDNATIVE !!PTR TO mp
NATIVE {GetFileSysTask} PROC
PROC GetFileSysTask() IS NATIVE {GetFileSysTask()} ENDNATIVE !!PTR TO mp
NATIVE {SetFileSysTask} PROC
PROC SetFileSysTask(task:PTR TO mp) IS NATIVE {SetFileSysTask(} task {)} ENDNATIVE !!PTR TO mp
NATIVE {GetArgStr} PROC
PROC GetArgStr() IS NATIVE {GetArgStr()} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {SetArgStr} PROC
PROC SetArgStr(string:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {SetArgStr(} string {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {FindCliProc} PROC
PROC FindCliProc(num:ULONG) IS NATIVE {FindCliProc(} num {)} ENDNATIVE !!PTR TO process
NATIVE {MaxCli} PROC
PROC MaxCli() IS NATIVE {MaxCli()} ENDNATIVE !!ULONG
NATIVE {SetCurrentDirName} PROC
PROC SetCurrentDirName(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=SetCurrentDirName(} name {))} ENDNATIVE !!BOOL
NATIVE {GetCurrentDirName} PROC
PROC GetCurrentDirName(buf:/*STRPTR*/ ARRAY OF CHAR, len:VALUE) IS NATIVE {-(BOOLEAN)(0!=GetCurrentDirName(} buf {,} len {))} ENDNATIVE !!BOOL
NATIVE {SetProgramName} PROC
PROC SetProgramName(name:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=SetProgramName(} name {))} ENDNATIVE !!BOOL
NATIVE {GetProgramName} PROC
PROC GetProgramName(buf:/*STRPTR*/ ARRAY OF CHAR, len:VALUE) IS NATIVE {-(BOOLEAN)(0!=GetProgramName(} buf {,} len {))} ENDNATIVE !!BOOL
NATIVE {SetPrompt} PROC
PROC SetPrompt(name:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=SetPrompt(} name {))} ENDNATIVE !!BOOL
NATIVE {GetPrompt} PROC
PROC GetPrompt(buf:/*STRPTR*/ ARRAY OF CHAR, len:VALUE) IS NATIVE {-(BOOLEAN)(0!=GetPrompt(} buf {,} len {))} ENDNATIVE !!BOOL
NATIVE {SetProgramDir} PROC
PROC SetProgramDir(lock:BPTR) IS NATIVE {SetProgramDir(} lock {)} ENDNATIVE !!BPTR
NATIVE {GetProgramDir} PROC
PROC GetProgramDir() IS NATIVE {GetProgramDir()} ENDNATIVE !!BPTR
NATIVE {SystemTagList} PROC
PROC SystemTagList(command:/*CONST_STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {SystemTagList(} command {,} tags {)} ENDNATIVE !!VALUE
NATIVE {AssignLock} PROC
PROC AssignLock(name:/*CONST_STRPTR*/ ARRAY OF CHAR, lock:BPTR) IS NATIVE {-(BOOLEAN)(0!=AssignLock(} name {,} lock {))} ENDNATIVE !!BOOL
NATIVE {AssignLate} PROC
PROC AssignLate(name:/*CONST_STRPTR*/ ARRAY OF CHAR, path:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=AssignLate(} name {,} path {))} ENDNATIVE !!BOOL
NATIVE {AssignPath} PROC
PROC AssignPath(name:/*CONST_STRPTR*/ ARRAY OF CHAR, path:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=AssignPath(} name {,} path {))} ENDNATIVE !!BOOL
NATIVE {AssignAdd} PROC
PROC AssignAdd(name:/*CONST_STRPTR*/ ARRAY OF CHAR, lock:BPTR) IS NATIVE {-(BOOLEAN)(0!=AssignAdd(} name {,} lock {))} ENDNATIVE !!BOOL
NATIVE {RemAssignList} PROC
PROC RemAssignList(name:/*STRPTR*/ ARRAY OF CHAR, lock:BPTR) IS NATIVE {RemAssignList(} name {,} lock {)} ENDNATIVE !!VALUE
NATIVE {GetDeviceProc} PROC
PROC GetDeviceProc(name:/*STRPTR*/ ARRAY OF CHAR, dp:PTR TO devproc) IS NATIVE {GetDeviceProc(} name {,} dp {)} ENDNATIVE !!PTR TO devproc
NATIVE {FreeDeviceProc} PROC
PROC FreeDeviceProc(dp:PTR TO devproc) IS NATIVE {FreeDeviceProc(} dp {)} ENDNATIVE
NATIVE {LockDosList} PROC
PROC LockDosList(flags:ULONG) IS NATIVE {LockDosList(} flags {)} ENDNATIVE !!PTR TO doslist
NATIVE {UnLockDosList} PROC
PROC UnLockDosList(flags:ULONG) IS NATIVE {UnLockDosList(} flags {)} ENDNATIVE
NATIVE {AttemptLockDosList} PROC
PROC AttemptLockDosList(flags:ULONG) IS NATIVE {AttemptLockDosList(} flags {)} ENDNATIVE !!PTR TO doslist
NATIVE {RemDosEntry} PROC
PROC RemDosEntry(dlist:PTR TO doslist) IS NATIVE {-(BOOLEAN)(0!=RemDosEntry(} dlist {))} ENDNATIVE !!BOOL
NATIVE {AddDosEntry} PROC
PROC AddDosEntry(dlist:PTR TO doslist) IS NATIVE {AddDosEntry(} dlist {)} ENDNATIVE !!VALUE
NATIVE {FindDosEntry} PROC
PROC FindDosEntry(dlist:PTR TO doslist, name:/*CONST_STRPTR*/ ARRAY OF CHAR, flags:ULONG) IS NATIVE {FindDosEntry(} dlist {,} name {,} flags {)} ENDNATIVE !!PTR TO doslist
NATIVE {NextDosEntry} PROC
PROC NextDosEntry(dlist:PTR TO doslist, flags:ULONG) IS NATIVE {NextDosEntry(} dlist {,} flags {)} ENDNATIVE !!PTR TO doslist
NATIVE {MakeDosEntry} PROC
PROC MakeDosEntry(name:/*CONST_STRPTR*/ ARRAY OF CHAR, type:VALUE) IS NATIVE {MakeDosEntry(} name {,} type {)} ENDNATIVE !!PTR TO doslist
NATIVE {FreeDosEntry} PROC
PROC FreeDosEntry(dlist:PTR TO doslist) IS NATIVE {FreeDosEntry(} dlist {)} ENDNATIVE
NATIVE {IsFileSystem} PROC
PROC IsFileSystem(devicename:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IsFileSystem(} devicename {))} ENDNATIVE !!BOOL
NATIVE {Format} PROC
PROC Format(devicename:/*CONST_STRPTR*/ ARRAY OF CHAR, volumename:/*CONST_STRPTR*/ ARRAY OF CHAR, dostype:ULONG) IS NATIVE {-(BOOLEAN)(0!=Format(} devicename {,} volumename {,} dostype {))} ENDNATIVE !!BOOL
NATIVE {Relabel} PROC
PROC Relabel(drive:/*CONST_STRPTR*/ ARRAY OF CHAR, newname:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=Relabel(} drive {,} newname {))} ENDNATIVE !!BOOL
NATIVE {Inhibit} PROC
PROC Inhibit(name:/*CONST_STRPTR*/ ARRAY OF CHAR, onoff:VALUE) IS NATIVE {-(BOOLEAN)(0!=Inhibit(} name {,} onoff {))} ENDNATIVE !!BOOL
NATIVE {AddBuffers} PROC
PROC AddBuffers(devicename:/*CONST_STRPTR*/ ARRAY OF CHAR, numbuffers:VALUE) IS NATIVE {AddBuffers(} devicename {,} numbuffers {)} ENDNATIVE !!VALUE
NATIVE {CompareDates} PROC
PROC CompareDates(date1:PTR TO datestamp, date2:PTR TO datestamp) IS NATIVE {CompareDates(} date1 {,} date2 {)} ENDNATIVE !!VALUE
NATIVE {DateToStr} PROC
PROC DateToStr(datetime:PTR TO datetime) IS NATIVE {-(BOOLEAN)(0!=DateToStr(} datetime {))} ENDNATIVE !!BOOL
NATIVE {StrToDate} PROC
PROC StrToDate(datetime:PTR TO datetime) IS NATIVE {-(BOOLEAN)(0!=StrToDate(} datetime {))} ENDNATIVE !!BOOL
NATIVE {InternalLoadSeg} PROC
PROC InternalLoadSeg(fh:BPTR, table:BPTR, functionarray:NATIVE {LONG_FUNC*} PTR, stack:PTR TO SLONG) IS NATIVE {InternalLoadSeg(} fh {,} table {,} functionarray {,} stack {)} ENDNATIVE !!BPTR
NATIVE {InternalUnLoadSeg} PROC
PROC InternalUnLoadSeg(seglist:BPTR, freefunc:NATIVE {VOID_FUNC} PTR) IS NATIVE {-(BOOLEAN)(0!=InternalUnLoadSeg(} seglist {,} freefunc {))} ENDNATIVE !!BOOL
NATIVE {NewLoadSeg} PROC
PROC NewLoadSeg(file:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {NewLoadSeg(} file {,} tags {)} ENDNATIVE !!BPTR
NATIVE {AddSegment} PROC
PROC AddSegment(name:/*CONST_STRPTR*/ ARRAY OF CHAR, seg:BPTR, type:VALUE) IS NATIVE {-AddSegment(} name {,} seg {,} type {)} ENDNATIVE !!INT
NATIVE {FindSegment} PROC
PROC FindSegment(name:/*STRPTR*/ ARRAY OF CHAR, seg:PTR TO segment, system:INT) IS NATIVE {FindSegment(} name {,} seg {, -} system {)} ENDNATIVE !!PTR TO segment
NATIVE {RemSegment} PROC
PROC RemSegment(seg:PTR TO segment) IS NATIVE {RemSegment(} seg {)} ENDNATIVE !!VALUE
NATIVE {CheckSignal} PROC
PROC CheckSignal(mask:VALUE) IS NATIVE {CheckSignal(} mask {)} ENDNATIVE !!VALUE
NATIVE {ReadArgs} PROC
PROC ReadArgs(template:/*CONST_STRPTR*/ ARRAY OF CHAR, array:ARRAY OF IPTR, rdargs:PTR TO rdargs) IS NATIVE {ReadArgs(} template {,} array {,} rdargs {)} ENDNATIVE !!PTR TO rdargs
NATIVE {FindArg} PROC
PROC FindArg(template:/*CONST_STRPTR*/ ARRAY OF CHAR, keyword:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {FindArg(} template {,} keyword {)} ENDNATIVE !!VALUE
NATIVE {ReadItem} PROC
PROC ReadItem(buffer:/*STRPTR*/ ARRAY OF CHAR, maxchars:VALUE, input:PTR TO csource) IS NATIVE {ReadItem(} buffer {,} maxchars {,} input {)} ENDNATIVE !!VALUE
NATIVE {StrToLong} PROC
PROC StrToLong(string:/*CONST_STRPTR*/ ARRAY OF CHAR, value:ARRAY OF SLONG) IS NATIVE {StrToLong(} string {,} value {)} ENDNATIVE !!VALUE
NATIVE {MatchFirst} PROC
PROC MatchFirst(pat:/*STRPTR*/ ARRAY OF CHAR, ap:PTR TO anchorpath) IS NATIVE {MatchFirst(} pat {,} ap {)} ENDNATIVE !!VALUE
NATIVE {MatchNext} PROC
PROC MatchNext(ap:PTR TO anchorpath) IS NATIVE {MatchNext(} ap {)} ENDNATIVE !!VALUE
NATIVE {MatchEnd} PROC
PROC MatchEnd(ap:PTR TO anchorpath) IS NATIVE {MatchEnd(} ap {)} ENDNATIVE
NATIVE {ParsePattern} PROC
PROC ParsePattern(Source:/*STRPTR*/ ARRAY OF CHAR, Dest:/*STRPTR*/ ARRAY OF CHAR, DestLength:VALUE) IS NATIVE {ParsePattern(} Source {,} Dest {,} DestLength {)} ENDNATIVE !!VALUE
NATIVE {MatchPattern} PROC
PROC MatchPattern(pat:/*STRPTR*/ ARRAY OF CHAR, str:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=MatchPattern(} pat {,} str {))} ENDNATIVE !!BOOL
->NATIVE {Error} PROC
->PROC Error() IS NATIVE {Error()} ENDNATIVE !!BPTR
NATIVE {FreeArgs} PROC
PROC FreeArgs(args:PTR TO rdargs) IS NATIVE {FreeArgs(} args {)} ENDNATIVE
->NATIVE {SelectError} PROC
->PROC SelectError(fh:BPTR) IS NATIVE {SelectError(} fh {)} ENDNATIVE !!BPTR
NATIVE {FilePart} PROC
PROC FilePart(path:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {FilePart(} path {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {PathPart} PROC
PROC PathPart(path:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {PathPart(} path {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {AddPart} PROC
PROC AddPart(dirname:/*STRPTR*/ ARRAY OF CHAR, filename:/*CONST_STRPTR*/ ARRAY OF CHAR, size:ULONG) IS NATIVE {-(BOOLEAN)(0!=AddPart(} dirname {,} filename {,} size {))} ENDNATIVE !!BOOL
NATIVE {StartNotify} PROC
PROC StartNotify(notify:PTR TO notifyrequest) IS NATIVE {-(BOOLEAN)(0!=StartNotify(} notify {))} ENDNATIVE !!BOOL
NATIVE {EndNotify} PROC
PROC EndNotify(notify:PTR TO notifyrequest) IS NATIVE {EndNotify(} notify {)} ENDNATIVE
NATIVE {SetVar} PROC
PROC SetVar(name:/*CONST_STRPTR*/ ARRAY OF CHAR, buffer:/*CONST_STRPTR*/ ARRAY OF CHAR, size:VALUE, flags:VALUE) IS NATIVE {-(BOOLEAN)(0!=SetVar(} name {,} buffer {,} size {,} flags {))} ENDNATIVE !!BOOL
NATIVE {GetVar} PROC
PROC GetVar(name:/*CONST_STRPTR*/ ARRAY OF CHAR, buffer:/*STRPTR*/ ARRAY OF CHAR, size:VALUE, flags:VALUE) IS NATIVE {GetVar(} name {,} buffer {,} size {,} flags {)} ENDNATIVE !!VALUE
NATIVE {DeleteVar} PROC
PROC DeleteVar(name:/*CONST_STRPTR*/ ARRAY OF CHAR, flags:ULONG) IS NATIVE {-(BOOLEAN)(0!=DeleteVar(} name {,} flags {))} ENDNATIVE !!BOOL
NATIVE {FindVar} PROC
PROC FindVar(name:/*CONST_STRPTR*/ ARRAY OF CHAR, type:ULONG) IS NATIVE {FindVar(} name {,} type {)} ENDNATIVE !!PTR TO localvar
->NATIVE {DosGetLocalizedString} PROC
->PROC DosGetLocalizedString(stringNum:VALUE) IS NATIVE {DosGetLocalizedString(} stringNum {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {CliInitNewcli} PROC
PROC CliInitNewcli(dp:PTR TO dospacket) IS NATIVE {CliInitNewcli(} dp {)} ENDNATIVE !!IPTR
NATIVE {CliInitRun} PROC
PROC CliInitRun(dp:PTR TO dospacket) IS NATIVE {CliInitRun(} dp {)} ENDNATIVE !!IPTR
NATIVE {WriteChars} PROC
PROC WriteChars(buf:/*STRPTR*/ ARRAY OF CHAR, buflen:ULONG) IS NATIVE {WriteChars(} buf {,} buflen {)} ENDNATIVE !!VALUE
NATIVE {PutStr} PROC
PROC PutStr(string:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {PutStr(} string {)} ENDNATIVE !!VALUE
NATIVE {VPrintf} PROC
PROC Vprintf(format:/*CONST_STRPTR*/ ARRAY OF CHAR, argarray:RAWARG) IS NATIVE {VPrintf(} format {,} argarray {)} ENDNATIVE !!VALUE
->NATIVE {Pipe} PROC
->PROC Pipe(name:/*CONST_STRPTR*/ ARRAY OF CHAR, reader:PTR TO BPTR, writer:PTR TO BPTR) IS NATIVE {Pipe(} name {,} reader {,} writer {)} ENDNATIVE !!VALUE
NATIVE {ParsePatternNoCase} PROC
PROC ParsePatternNoCase(Source:/*STRPTR*/ ARRAY OF CHAR, Dest:/*STRPTR*/ ARRAY OF CHAR, DestLength:VALUE) IS NATIVE {ParsePatternNoCase(} Source {,} Dest {,} DestLength {)} ENDNATIVE !!VALUE
NATIVE {MatchPatternNoCase} PROC
PROC MatchPatternNoCase(pat:/*STRPTR*/ ARRAY OF CHAR, str:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=MatchPatternNoCase(} pat {,} str {))} ENDNATIVE !!BOOL
NATIVE {DosGetString} PROC
PROC DosGetString(stringNu:VALUE) IS NATIVE {DosGetString(} stringNu {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {SameDevice} PROC
PROC SameDevice(lock1:BPTR, lock2:BPTR) IS NATIVE {-(BOOLEAN)(0!=SameDevice(} lock1 {,} lock2 {))} ENDNATIVE !!BOOL
NATIVE {ExAllEnd} PROC
PROC ExAllEnd(lock:BPTR, buffer:PTR TO exalldata, size:VALUE, data:VALUE, control:PTR TO exallcontrol) IS NATIVE {ExAllEnd(} lock {,} buffer {,} size {,} data {,} control {)} ENDNATIVE
NATIVE {SetOwner} PROC
PROC SetOwner(name:/*STRPTR*/ ARRAY OF CHAR, owner_info:ULONG) IS NATIVE {-(BOOLEAN)(0!=SetOwner(} name {,} owner_info {))} ENDNATIVE !!BOOL
