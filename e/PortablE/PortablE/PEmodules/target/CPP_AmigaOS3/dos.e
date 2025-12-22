/* C++ module, for $VER: dos_protos.h 40.2 (6.6.1998) */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/dos/dos', 'target/dos/datetime', 'target/dos/dosasl', 'target/dos/dosextens', 'target/dos/doshunks', 'target/dos/dostags', 'target/dos/dos_lib', 'target/dos/exall', 'target/dos/notify', 'target/dos/rdargs', 'target/dos/record', 'target/dos/var'
MODULE 'target/dos/dos', 'target/dos/dosextens', 'target/dos/record', 'target/dos/rdargs', 'target/dos/dosasl', 'target/dos/var', 'target/dos/notify', 'target/dos/datetime', 'target/dos/exall', 'target/utility/tagitem'
MODULE 'target/exec'
{
#include <proto/dos.h>
}
{
struct DosLibrary* DOSBase = NULL;
}
NATIVE {CLIB_DOS_PROTOS_H} CONST
NATIVE {_PROTO_DOS_H} CONST
NATIVE {PRAGMA_DOS_H} CONST
NATIVE {PRAGMAS_DOS_PRAGMAS_H} CONST

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


NATIVE {Open} PROC
PROC Open( name:ARRAY OF CHAR, accessMode:VALUE ) IS NATIVE {Open(} name {,} accessMode {)} ENDNATIVE !!BPTR
NATIVE {Close} PROC
PROC Close( file:BPTR ) IS NATIVE {-(BOOLEAN)(0!=Close(} file {))} ENDNATIVE !!BOOL
NATIVE {Read} PROC
PROC Read( file:BPTR, buffer:APTR, length:VALUE ) IS NATIVE {Read(} file {,} buffer {,} length {)} ENDNATIVE !!VALUE
NATIVE {Write} PROC
PROC Write( file:BPTR, buffer:APTR, length:VALUE ) IS NATIVE {Write(} file {,} buffer {,} length {)} ENDNATIVE !!VALUE
NATIVE {Input} PROC
PROC Input( ) IS NATIVE {Input()} ENDNATIVE !!BPTR
NATIVE {Output} PROC
PROC Output( ) IS NATIVE {Output()} ENDNATIVE !!BPTR
NATIVE {Seek} PROC
PROC Seek( file:BPTR, position:VALUE, offset:VALUE ) IS NATIVE {Seek(} file {,} position {,} offset {)} ENDNATIVE !!VALUE
NATIVE {DeleteFile} PROC
PROC DeleteFile( name:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=DeleteFile(} name {))} ENDNATIVE !!BOOL
NATIVE {Rename} PROC
PROC Rename( oldName:ARRAY OF CHAR, newName:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=Rename(} oldName {,} newName {))} ENDNATIVE !!BOOL
NATIVE {Lock} PROC
PROC Lock( name:ARRAY OF CHAR, type:VALUE ) IS NATIVE {Lock(} name {,} type {)} ENDNATIVE !!BPTR
NATIVE {UnLock} PROC
PROC UnLock( lock:BPTR ) IS NATIVE {UnLock(} lock {)} ENDNATIVE
NATIVE {DupLock} PROC
PROC DupLock( lock:BPTR ) IS NATIVE {DupLock(} lock {)} ENDNATIVE !!BPTR
NATIVE {Examine} PROC
PROC Examine( lock:BPTR, fileInfoBlock:PTR TO fileinfoblock ) IS NATIVE {-(BOOLEAN)(0!=Examine(} lock {,} fileInfoBlock {))} ENDNATIVE !!BOOL
NATIVE {ExNext} PROC
PROC ExNext( lock:BPTR, fileInfoBlock:PTR TO fileinfoblock ) IS NATIVE {-(BOOLEAN)(0!=ExNext(} lock {,} fileInfoBlock {))} ENDNATIVE !!BOOL
NATIVE {Info} PROC
PROC Info( lock:BPTR, parameterBlock:PTR TO infodata ) IS NATIVE {-(BOOLEAN)(0!=Info(} lock {,} parameterBlock {))} ENDNATIVE !!BOOL
NATIVE {CreateDir} PROC
PROC CreateDir( name:ARRAY OF CHAR ) IS NATIVE {CreateDir(} name {)} ENDNATIVE !!BPTR
NATIVE {CurrentDir} PROC
PROC CurrentDir( lock:BPTR ) IS NATIVE {CurrentDir(} lock {)} ENDNATIVE !!BPTR
NATIVE {IoErr} PROC
PROC IoErr( ) IS NATIVE {IoErr()} ENDNATIVE !!VALUE
NATIVE {CreateProc} PROC
PROC CreateProc( name:ARRAY OF CHAR, pri:VALUE, segList:BPTR, stackSize:VALUE ) IS NATIVE {CreateProc(} name {,} pri {,} segList {,} stackSize {)} ENDNATIVE !!PTR TO mp
NATIVE {Exit} PROC
PROC Exit( returnCode:VALUE ) IS NATIVE {Exit(} returnCode {)} ENDNATIVE
NATIVE {LoadSeg} PROC
PROC LoadSeg( name:ARRAY OF CHAR ) IS NATIVE {LoadSeg(} name {)} ENDNATIVE !!BPTR
NATIVE {UnLoadSeg} PROC
PROC UnLoadSeg( seglist:BPTR ) IS NATIVE {UnLoadSeg(} seglist {)} ENDNATIVE
NATIVE {DeviceProc} PROC
PROC DeviceProc( name:ARRAY OF CHAR ) IS NATIVE {DeviceProc(} name {)} ENDNATIVE !!PTR TO mp
NATIVE {SetComment} PROC
PROC SetComment( name:ARRAY OF CHAR, comment:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=SetComment(} name {,} comment {))} ENDNATIVE !!BOOL
NATIVE {SetProtection} PROC
PROC SetProtection( name:ARRAY OF CHAR, protect:VALUE ) IS NATIVE {-(BOOLEAN)(0!=SetProtection(} name {,} protect {))} ENDNATIVE !!BOOL
->NATIVE {DateStamp} PROC
PROC DateStamp( date:PTR TO datestamp ) IS NATIVE {DateStamp(} date {)} ENDNATIVE !!PTR TO datestamp
NATIVE {Delay} PROC
PROC Delay( timeout:VALUE ) IS NATIVE {Delay(} timeout {)} ENDNATIVE
NATIVE {WaitForChar} PROC
PROC WaitForChar( file:BPTR, timeout:VALUE ) IS NATIVE {-(BOOLEAN)(0!=WaitForChar(} file {,} timeout {))} ENDNATIVE !!BOOL
NATIVE {ParentDir} PROC
PROC ParentDir( lock:BPTR ) IS NATIVE {ParentDir(} lock {)} ENDNATIVE !!BPTR
NATIVE {IsInteractive} PROC
PROC IsInteractive( file:BPTR ) IS NATIVE {-(BOOLEAN)(0!=IsInteractive(} file {))} ENDNATIVE !!BOOL
NATIVE {Execute} PROC
PROC Execute( string:ARRAY OF CHAR, file:BPTR, file2:BPTR ) IS NATIVE {-(BOOLEAN)(0!=Execute(} string {,} file {,} file2 {))} ENDNATIVE !!BOOL

/*--- functions in V36 or higher (Release 2.0) ---*/
/*	DOS Object creation/deletion */
NATIVE {AllocDosObject} PROC
PROC AllocDosObject( type:ULONG, tags:ARRAY OF tagitem ) IS NATIVE {AllocDosObject(} type {,} tags {)} ENDNATIVE !!APTR2
NATIVE {AllocDosObjectTagList} PROC
PROC AllocDosObjectTagList( type:ULONG, tags:ARRAY OF tagitem ) IS NATIVE {AllocDosObjectTagList(} type {,} tags {)} ENDNATIVE !!APTR2
NATIVE {AllocDosObjectTags} PROC
->PROC AllocDosObjectTags( type:ULONG, tag1type:ULONG, tag1type2=0:ULONG, ... ) IS NATIVE {AllocDosObjectTags(} type {,} tag1type {,} tag1type2 {,} ... {)} ENDNATIVE !!APTR2
NATIVE {FreeDosObject} PROC
PROC FreeDosObject( type:ULONG, ptr:APTR2 ) IS NATIVE {FreeDosObject(} type {,} ptr {)} ENDNATIVE

/*	Packet Level routines */
NATIVE {DoPkt} PROC
PROC DoPkt( port:PTR TO mp, action:VALUE, arg1:VALUE, arg2:VALUE, arg3:VALUE, arg4:VALUE, arg5:VALUE ) IS NATIVE {DoPkt(} port {,} action {,} arg1 {,} arg2 {,} arg3 {,} arg4 {,} arg5 {)} ENDNATIVE !!VALUE
NATIVE {DoPkt0} PROC
PROC DoPkt0( port:PTR TO mp, action:VALUE ) IS NATIVE {DoPkt0(} port {,} action {)} ENDNATIVE !!VALUE
NATIVE {DoPkt1} PROC
PROC DoPkt1( port:PTR TO mp, action:VALUE, arg1:VALUE ) IS NATIVE {DoPkt1(} port {,} action {,} arg1 {)} ENDNATIVE !!VALUE
NATIVE {DoPkt2} PROC
PROC DoPkt2( port:PTR TO mp, action:VALUE, arg1:VALUE, arg2:VALUE ) IS NATIVE {DoPkt2(} port {,} action {,} arg1 {,} arg2 {)} ENDNATIVE !!VALUE
NATIVE {DoPkt3} PROC
PROC DoPkt3( port:PTR TO mp, action:VALUE, arg1:VALUE, arg2:VALUE, arg3:VALUE ) IS NATIVE {DoPkt3(} port {,} action {,} arg1 {,} arg2 {,} arg3 {)} ENDNATIVE !!VALUE
NATIVE {DoPkt4} PROC
PROC DoPkt4( port:PTR TO mp, action:VALUE, arg1:VALUE, arg2:VALUE, arg3:VALUE, arg4:VALUE ) IS NATIVE {DoPkt4(} port {,} action {,} arg1 {,} arg2 {,} arg3 {,} arg4 {)} ENDNATIVE !!VALUE
NATIVE {SendPkt} PROC
PROC SendPkt( dp:PTR TO dospacket, port:PTR TO mp, replyport:PTR TO mp ) IS NATIVE {SendPkt(} dp {,} port {,} replyport {)} ENDNATIVE
NATIVE {WaitPkt} PROC
PROC WaitPkt( ) IS NATIVE {WaitPkt()} ENDNATIVE !!PTR TO dospacket
NATIVE {ReplyPkt} PROC
PROC ReplyPkt( dp:PTR TO dospacket, res1:VALUE, res2:VALUE ) IS NATIVE {ReplyPkt(} dp {,} res1 {,} res2 {)} ENDNATIVE
NATIVE {AbortPkt} PROC
PROC AbortPkt( port:PTR TO mp, pkt:PTR TO dospacket ) IS NATIVE {AbortPkt(} port {,} pkt {)} ENDNATIVE

/*	Record Locking */
NATIVE {LockRecord} PROC
PROC LockRecord( fh:BPTR, offset:ULONG, length:ULONG, mode:ULONG, timeout:ULONG ) IS NATIVE {-(BOOLEAN)(0!=LockRecord(} fh {,} offset {,} length {,} mode {,} timeout {))} ENDNATIVE !!BOOL
NATIVE {LockRecords} PROC
PROC LockRecords( recArray:ARRAY OF recordlock, timeout:ULONG ) IS NATIVE {-(BOOLEAN)(0!=LockRecords(} recArray {,} timeout {))} ENDNATIVE !!BOOL
NATIVE {UnLockRecord} PROC
PROC UnLockRecord( fh:BPTR, offset:ULONG, length:ULONG ) IS NATIVE {-(BOOLEAN)(0!=UnLockRecord(} fh {,} offset {,} length {))} ENDNATIVE !!BOOL
NATIVE {UnLockRecords} PROC
PROC UnLockRecords( recArray:ARRAY OF recordlock ) IS NATIVE {-(BOOLEAN)(0!=UnLockRecords(} recArray {))} ENDNATIVE !!BOOL

/*	Buffered File I/O */
NATIVE {SelectInput} PROC
PROC SelectInput( fh:BPTR ) IS NATIVE {SelectInput(} fh {)} ENDNATIVE !!BPTR
NATIVE {SelectOutput} PROC
PROC SelectOutput( fh:BPTR ) IS NATIVE {SelectOutput(} fh {)} ENDNATIVE !!BPTR
NATIVE {FGetC} PROC
PROC FgetC( fh:BPTR ) IS NATIVE {FGetC(} fh {)} ENDNATIVE !!VALUE
NATIVE {FPutC} PROC
PROC FputC( fh:BPTR, ch:VALUE ) IS NATIVE {FPutC(} fh {,} ch {)} ENDNATIVE !!VALUE
NATIVE {UnGetC} PROC
PROC UnGetC( fh:BPTR, character:VALUE ) IS NATIVE {UnGetC(} fh {,} character {)} ENDNATIVE !!VALUE
NATIVE {FRead} PROC
PROC Fread( fh:BPTR, block:APTR, blocklen:ULONG, number:ULONG ) IS NATIVE {FRead(} fh {,} block {,} blocklen {,} number {)} ENDNATIVE !!VALUE
NATIVE {FWrite} PROC
PROC Fwrite( fh:BPTR, block:APTR, blocklen:ULONG, number:ULONG ) IS NATIVE {FWrite(} fh {,} block {,} blocklen {,} number {)} ENDNATIVE !!VALUE
NATIVE {FGets} PROC
PROC Fgets( fh:BPTR, buf:ARRAY OF CHAR, buflen:ULONG ) IS NATIVE {FGets(} fh {,} buf {,} buflen {)} ENDNATIVE !!ARRAY OF CHAR
NATIVE {FPuts} PROC
PROC Fputs( fh:BPTR, str:ARRAY OF CHAR ) IS NATIVE {FPuts(} fh {,} str {)} ENDNATIVE !!VALUE
NATIVE {VFWritef} PROC
PROC VfWritef( fh:BPTR, format:ARRAY OF CHAR, argarray:ARRAY OF VALUE ) IS NATIVE {VFWritef(} fh {,} format {,} argarray {)} ENDNATIVE
NATIVE {FWritef} PROC
PROC Fwritef( fh:BPTR, format:ARRAY OF CHAR, format2=0:ULONG, ... ) IS NATIVE {FWritef(} fh {,} format {,} format2 {,} ... {)} ENDNATIVE
NATIVE {VFPrintf} PROC
PROC VfPrintf( fh:BPTR, format:ARRAY OF CHAR, argarray:APTR ) IS NATIVE {VFPrintf(} fh {,} format {,} argarray {)} ENDNATIVE !!VALUE
NATIVE {FPrintf} PROC
PROC Fprintf( fh:BPTR, format:ARRAY OF CHAR, format2=0:ULONG, ... ) IS NATIVE {FPrintf(} fh {,} format {,} format2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {Flush} PROC
PROC Flush( fh:BPTR ) IS NATIVE {Flush(} fh {)} ENDNATIVE !!VALUE
NATIVE {SetVBuf} PROC
PROC SetVBuf( fh:BPTR, buff:ARRAY OF CHAR, type:VALUE, size:VALUE ) IS NATIVE {SetVBuf(} fh {,} buff {,} type {,} size {)} ENDNATIVE !!VALUE

/*	DOS Object Management */
NATIVE {DupLockFromFH} PROC
PROC DupLockFromFH( fh:BPTR ) IS NATIVE {DupLockFromFH(} fh {)} ENDNATIVE !!BPTR
NATIVE {OpenFromLock} PROC
PROC OpenFromLock( lock:BPTR ) IS NATIVE {OpenFromLock(} lock {)} ENDNATIVE !!BPTR
NATIVE {ParentOfFH} PROC
PROC ParentOfFH( fh:BPTR ) IS NATIVE {ParentOfFH(} fh {)} ENDNATIVE !!BPTR
NATIVE {ExamineFH} PROC
PROC ExamineFH( fh:BPTR, fib:PTR TO fileinfoblock ) IS NATIVE {-(BOOLEAN)(0!=ExamineFH(} fh {,} fib {))} ENDNATIVE !!BOOL
NATIVE {SetFileDate} PROC
PROC SetFileDate( name:ARRAY OF CHAR, date:PTR TO datestamp ) IS NATIVE {-(BOOLEAN)(0!=SetFileDate(} name {,} date {))} ENDNATIVE !!BOOL
NATIVE {NameFromLock} PROC
PROC NameFromLock( lock:BPTR, buffer:ARRAY OF CHAR, len:VALUE ) IS NATIVE {-(BOOLEAN)(0!=NameFromLock(} lock {,} buffer {,} len {))} ENDNATIVE !!BOOL
NATIVE {NameFromFH} PROC
PROC NameFromFH( fh:BPTR, buffer:ARRAY OF CHAR, len:VALUE ) IS NATIVE {-(BOOLEAN)(0!=NameFromFH(} fh {,} buffer {,} len {))} ENDNATIVE !!BOOL
NATIVE {SplitName} PROC
PROC SplitName( name:ARRAY OF CHAR, separator:ULONG, buf:ARRAY OF CHAR, oldpos:VALUE, size:VALUE ) IS NATIVE {SplitName(} name {,} separator {,} buf {,} oldpos {,} size {)} ENDNATIVE !!INT
NATIVE {SameLock} PROC
PROC SameLock( lock1:BPTR, lock2:BPTR ) IS NATIVE {SameLock(} lock1 {,} lock2 {)} ENDNATIVE !!VALUE
NATIVE {SetMode} PROC
PROC SetMode( fh:BPTR, mode:VALUE ) IS NATIVE {-(BOOLEAN)(0!=SetMode(} fh {,} mode {))} ENDNATIVE !!BOOL
NATIVE {ExAll} PROC
PROC ExAll( lock:BPTR, buffer:ARRAY OF exalldata, size:VALUE, data:VALUE, control:PTR TO exallcontrol ) IS NATIVE {-(BOOLEAN)(0!=ExAll(} lock {,} buffer {,} size {,} data {,} control {))} ENDNATIVE !!BOOL
NATIVE {ReadLink} PROC
PROC ReadLink( port:PTR TO mp, lock:BPTR, path:ARRAY OF CHAR, buffer:ARRAY OF CHAR, size:ULONG ) IS NATIVE {ReadLink(} port {,} lock {,} path {,} buffer {,} size {)} ENDNATIVE !!VALUE
NATIVE {MakeLink} PROC
PROC MakeLink( name:ARRAY OF CHAR, dest:VALUE, soft:VALUE ) IS NATIVE {-(BOOLEAN)(0!=MakeLink(} name {,} dest {,} soft {))} ENDNATIVE !!BOOL
NATIVE {ChangeMode} PROC
PROC ChangeMode( type:VALUE, fh:BPTR, newmode:VALUE ) IS NATIVE {-(BOOLEAN)(0!=ChangeMode(} type {,} fh {,} newmode {))} ENDNATIVE !!BOOL
NATIVE {SetFileSize} PROC
PROC SetFileSize( fh:BPTR, pos:VALUE, mode:VALUE ) IS NATIVE {SetFileSize(} fh {,} pos {,} mode {)} ENDNATIVE !!VALUE

/*	Error Handling */
NATIVE {SetIoErr} PROC
PROC SetIoErr( result:VALUE ) IS NATIVE {SetIoErr(} result {)} ENDNATIVE !!VALUE
NATIVE {Fault} PROC
PROC Fault( code:VALUE, header:ARRAY OF CHAR, buffer:ARRAY OF CHAR, len:VALUE ) IS NATIVE {Fault(} code {,} header {,} buffer {,} len {)} ENDNATIVE !!INT
NATIVE {PrintFault} PROC
PROC PrintFault( code:VALUE, header:ARRAY OF CHAR ) IS NATIVE {PrintFault(} code {,} header {)} ENDNATIVE !!INT
NATIVE {ErrorReport} PROC
PROC ErrorReport( code:VALUE, type:VALUE, arg1:ULONG, device:PTR TO mp ) IS NATIVE {-(BOOLEAN)(0!=ErrorReport(} code {,} type {,} arg1 {,} device {))} ENDNATIVE !!BOOL

/*	Process Management */
NATIVE {Cli} PROC
PROC Cli( ) IS NATIVE {Cli()} ENDNATIVE !!PTR TO commandlineinterface
NATIVE {CreateNewProc} PROC
PROC CreateNewProc( tags:ARRAY OF tagitem ) IS NATIVE {CreateNewProc(} tags {)} ENDNATIVE !!PTR TO process
NATIVE {CreateNewProcTagList} PROC
PROC CreateNewProcTagList( tags:ARRAY OF tagitem ) IS NATIVE {CreateNewProcTagList(} tags {)} ENDNATIVE !!PTR TO process
NATIVE {CreateNewProcTags} PROC
->PROC CreateNewProcTags( tag1type:ULONG, tag1type2=0:ULONG, ... ) IS NATIVE {CreateNewProcTags(} tag1type {,} tag1type2 {,} ... {)} ENDNATIVE !!PTR TO process
NATIVE {RunCommand} PROC
PROC RunCommand( seg:BPTR, stack:VALUE, paramptr:ARRAY OF CHAR, paramlen:VALUE ) IS NATIVE {RunCommand(} seg {,} stack {,} paramptr {,} paramlen {)} ENDNATIVE !!VALUE
NATIVE {GetConsoleTask} PROC
PROC GetConsoleTask( ) IS NATIVE {GetConsoleTask()} ENDNATIVE !!PTR TO mp
NATIVE {SetConsoleTask} PROC
PROC SetConsoleTask( task:PTR TO mp ) IS NATIVE {SetConsoleTask(} task {)} ENDNATIVE !!PTR TO mp
NATIVE {GetFileSysTask} PROC
PROC GetFileSysTask( ) IS NATIVE {GetFileSysTask()} ENDNATIVE !!PTR TO mp
NATIVE {SetFileSysTask} PROC
PROC SetFileSysTask( task:PTR TO mp ) IS NATIVE {SetFileSysTask(} task {)} ENDNATIVE !!PTR TO mp
NATIVE {GetArgStr} PROC
PROC GetArgStr( ) IS NATIVE {GetArgStr()} ENDNATIVE !!ARRAY OF CHAR
NATIVE {SetArgStr} PROC
PROC SetArgStr( string:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=SetArgStr(} string {))} ENDNATIVE !!BOOL
NATIVE {FindCliProc} PROC
PROC FindCliProc( num:ULONG ) IS NATIVE {FindCliProc(} num {)} ENDNATIVE !!PTR TO process
NATIVE {MaxCli} PROC
PROC MaxCli( ) IS NATIVE {MaxCli()} ENDNATIVE !!ULONG
NATIVE {SetCurrentDirName} PROC
PROC SetCurrentDirName( name:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=SetCurrentDirName(} name {))} ENDNATIVE !!BOOL
NATIVE {GetCurrentDirName} PROC
PROC GetCurrentDirName( buf:ARRAY OF CHAR, len:VALUE ) IS NATIVE {-(BOOLEAN)(0!=GetCurrentDirName(} buf {,} len {))} ENDNATIVE !!BOOL
NATIVE {SetProgramName} PROC
PROC SetProgramName( name:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=SetProgramName(} name {))} ENDNATIVE !!BOOL
NATIVE {GetProgramName} PROC
PROC GetProgramName( buf:ARRAY OF CHAR, len:VALUE ) IS NATIVE {-(BOOLEAN)(0!=GetProgramName(} buf {,} len {))} ENDNATIVE !!BOOL
NATIVE {SetPrompt} PROC
PROC SetPrompt( name:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=SetPrompt(} name {))} ENDNATIVE !!BOOL
NATIVE {GetPrompt} PROC
PROC GetPrompt( buf:ARRAY OF CHAR, len:VALUE ) IS NATIVE {-(BOOLEAN)(0!=GetPrompt(} buf {,} len {))} ENDNATIVE !!BOOL
NATIVE {SetProgramDir} PROC
PROC SetProgramDir( lock:BPTR ) IS NATIVE {SetProgramDir(} lock {)} ENDNATIVE !!BPTR
NATIVE {GetProgramDir} PROC
PROC GetProgramDir( ) IS NATIVE {GetProgramDir()} ENDNATIVE !!BPTR

/*	Device List Management */
NATIVE {SystemTagList} PROC
PROC SystemTagList( command:ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {SystemTagList(} command {,} tags {)} ENDNATIVE !!VALUE
NATIVE {System} PROC
PROC System( command:ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {System(} command {,} tags {)} ENDNATIVE !!VALUE
NATIVE {SystemTags} PROC
PROC SystemTags(command:ARRAY OF CHAR, tag=0:ULONG, ...) IS NATIVE {SystemTags(} command {,} tag {,} ... {)} ENDNATIVE !!VALUE
NATIVE {AssignLock} PROC
PROC AssignLock( name:ARRAY OF CHAR, lock:BPTR ) IS NATIVE {-(BOOLEAN)(0!=AssignLock(} name {,} lock {))} ENDNATIVE !!BOOL
NATIVE {AssignLate} PROC
PROC AssignLate( name:ARRAY OF CHAR, path:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=AssignLate(} name {,} path {))} ENDNATIVE !!BOOL
NATIVE {AssignPath} PROC
PROC AssignPath( name:ARRAY OF CHAR, path:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=AssignPath(} name {,} path {))} ENDNATIVE !!BOOL
NATIVE {AssignAdd} PROC
PROC AssignAdd( name:ARRAY OF CHAR, lock:BPTR ) IS NATIVE {-(BOOLEAN)(0!=AssignAdd(} name {,} lock {))} ENDNATIVE !!BOOL
NATIVE {RemAssignList} PROC
PROC RemAssignList( name:ARRAY OF CHAR, lock:BPTR ) IS NATIVE {RemAssignList(} name {,} lock {)} ENDNATIVE !!VALUE
NATIVE {GetDeviceProc} PROC
PROC GetDeviceProc( name:ARRAY OF CHAR, dp:PTR TO devproc ) IS NATIVE {GetDeviceProc(} name {,} dp {)} ENDNATIVE !!PTR TO devproc
NATIVE {FreeDeviceProc} PROC
PROC FreeDeviceProc( dp:PTR TO devproc ) IS NATIVE {FreeDeviceProc(} dp {)} ENDNATIVE
NATIVE {LockDosList} PROC
PROC LockDosList( flags:ULONG ) IS NATIVE {LockDosList(} flags {)} ENDNATIVE !!PTR TO doslist
NATIVE {UnLockDosList} PROC
PROC UnLockDosList( flags:ULONG ) IS NATIVE {UnLockDosList(} flags {)} ENDNATIVE
NATIVE {AttemptLockDosList} PROC
PROC AttemptLockDosList( flags:ULONG ) IS NATIVE {AttemptLockDosList(} flags {)} ENDNATIVE !!PTR TO doslist
NATIVE {RemDosEntry} PROC
PROC RemDosEntry( dlist:PTR TO doslist ) IS NATIVE {-(BOOLEAN)(0!=RemDosEntry(} dlist {))} ENDNATIVE !!BOOL
NATIVE {AddDosEntry} PROC
PROC AddDosEntry( dlist:PTR TO doslist ) IS NATIVE {AddDosEntry(} dlist {)} ENDNATIVE !!VALUE
NATIVE {FindDosEntry} PROC
PROC FindDosEntry( dlist:PTR TO doslist, name:ARRAY OF CHAR, flags:ULONG ) IS NATIVE {FindDosEntry(} dlist {,} name {,} flags {)} ENDNATIVE !!PTR TO doslist
NATIVE {NextDosEntry} PROC
PROC NextDosEntry( dlist:PTR TO doslist, flags:ULONG ) IS NATIVE {NextDosEntry(} dlist {,} flags {)} ENDNATIVE !!PTR TO doslist
NATIVE {MakeDosEntry} PROC
PROC MakeDosEntry( name:ARRAY OF CHAR, type:VALUE ) IS NATIVE {MakeDosEntry(} name {,} type {)} ENDNATIVE !!PTR TO doslist
NATIVE {FreeDosEntry} PROC
PROC FreeDosEntry( dlist:PTR TO doslist ) IS NATIVE {FreeDosEntry(} dlist {)} ENDNATIVE
NATIVE {IsFileSystem} PROC
PROC IsFileSystem( name:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=IsFileSystem(} name {))} ENDNATIVE !!BOOL

/*	Handler Interface */
NATIVE {Format} PROC
PROC Format( filesystem:ARRAY OF CHAR, volumename:ARRAY OF CHAR, dostype:ULONG ) IS NATIVE {-(BOOLEAN)(0!=Format(} filesystem {,} volumename {,} dostype {))} ENDNATIVE !!BOOL
NATIVE {Relabel} PROC
PROC Relabel( drive:ARRAY OF CHAR, newname:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=Relabel(} drive {,} newname {))} ENDNATIVE !!BOOL
NATIVE {Inhibit} PROC
PROC Inhibit( name:ARRAY OF CHAR, onoff:VALUE ) IS NATIVE {-(BOOLEAN)(0!=Inhibit(} name {,} onoff {))} ENDNATIVE !!BOOL
NATIVE {AddBuffers} PROC
PROC AddBuffers( name:ARRAY OF CHAR, number:VALUE ) IS NATIVE {AddBuffers(} name {,} number {)} ENDNATIVE !!VALUE

/*	Date, Time Routines */
NATIVE {CompareDates} PROC
PROC CompareDates( date1:PTR TO datestamp, date2:PTR TO datestamp ) IS NATIVE {CompareDates(} date1 {,} date2 {)} ENDNATIVE !!VALUE
NATIVE {DateToStr} PROC
PROC DateToStr( datetime:PTR TO datetime ) IS NATIVE {-(BOOLEAN)(0!=DateToStr(} datetime {))} ENDNATIVE !!BOOL
NATIVE {StrToDate} PROC
PROC StrToDate( datetime:PTR TO datetime ) IS NATIVE {-(BOOLEAN)(0!=StrToDate(} datetime {))} ENDNATIVE !!BOOL

/*	Image Management */
NATIVE {InternalLoadSeg} PROC
PROC InternalLoadSeg( fh:BPTR, table:BPTR, funcarray:ARRAY OF VALUE, stack:PTR TO VALUE ) IS NATIVE {InternalLoadSeg(} fh {,} table {,} funcarray {,} stack {)} ENDNATIVE !!BPTR
NATIVE {InternalUnLoadSeg} PROC
PROC InternalUnLoadSeg( seglist:BPTR, freefunc:PTR /*VOID (*CONST freefunc)()*/ ) IS NATIVE {-(BOOLEAN)(0!=InternalUnLoadSeg(} seglist {, (VOID (*)()) } freefunc {))} ENDNATIVE !!BOOL
NATIVE {NewLoadSeg} PROC
PROC NewLoadSeg( file:ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {NewLoadSeg(} file {,} tags {)} ENDNATIVE !!BPTR
NATIVE {NewLoadSegTagList} PROC
PROC NewLoadSegTagList( file:ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {NewLoadSegTagList(} file {,} tags {)} ENDNATIVE !!BPTR
NATIVE {NewLoadSegTags} PROC
->PROC NewLoadSegTags( file:ARRAY OF CHAR, tag1type:ULONG, tag1type2=0:ULONG, ... ) IS NATIVE {NewLoadSegTags(} file {,} tag1type {,} tag1type2 {,} ... {)} ENDNATIVE !!BPTR
NATIVE {AddSegment} PROC
PROC AddSegment( name:ARRAY OF CHAR, seg:BPTR, system:VALUE ) IS NATIVE {AddSegment(} name {,} seg {,} system {)} ENDNATIVE !!VALUE
NATIVE {FindSegment} PROC
PROC FindSegment( name:ARRAY OF CHAR, seg:PTR TO segment, system:VALUE ) IS NATIVE {FindSegment(} name {,} seg {,} system {)} ENDNATIVE !!PTR TO segment
NATIVE {RemSegment} PROC
PROC RemSegment( seg:PTR TO segment ) IS NATIVE {RemSegment(} seg {)} ENDNATIVE !!VALUE

/*	Command Support */
NATIVE {CheckSignal} PROC
PROC CheckSignal( mask:VALUE ) IS NATIVE {CheckSignal(} mask {)} ENDNATIVE !!VALUE
NATIVE {ReadArgs} PROC
PROC ReadArgs( arg_template:ARRAY OF CHAR, array:ARRAY OF VALUE, args:PTR TO rdargs ) IS NATIVE {ReadArgs(} arg_template {,} array {,} args {)} ENDNATIVE !!PTR TO rdargs
NATIVE {FindArg} PROC
PROC FindArg( keyword:ARRAY OF CHAR, arg_template:ARRAY OF CHAR ) IS NATIVE {FindArg(} keyword {,} arg_template {)} ENDNATIVE !!VALUE
NATIVE {ReadItem} PROC
PROC ReadItem( name:ARRAY OF CHAR, maxchars:VALUE, cSource:PTR TO csource ) IS NATIVE {ReadItem(} name {,} maxchars {,} cSource {)} ENDNATIVE !!VALUE
NATIVE {StrToLong} PROC
PROC StrToLong( string:ARRAY OF CHAR, value:ARRAY OF VALUE ) IS NATIVE {StrToLong(} string {,} value {)} ENDNATIVE !!VALUE
NATIVE {MatchFirst} PROC
PROC MatchFirst( pat:ARRAY OF CHAR, anchor:PTR TO anchorpath ) IS NATIVE {MatchFirst(} pat {,} anchor {)} ENDNATIVE !!VALUE
NATIVE {MatchNext} PROC
PROC MatchNext( anchor:PTR TO anchorpath ) IS NATIVE {MatchNext(} anchor {)} ENDNATIVE !!VALUE
NATIVE {MatchEnd} PROC
PROC MatchEnd( anchor:PTR TO anchorpath ) IS NATIVE {MatchEnd(} anchor {)} ENDNATIVE
NATIVE {ParsePattern} PROC
PROC ParsePattern( pat:ARRAY OF CHAR, buf:ARRAY OF CHAR, buflen:VALUE ) IS NATIVE {ParsePattern(} pat {,} buf {,} buflen {)} ENDNATIVE !!VALUE
NATIVE {MatchPattern} PROC
PROC MatchPattern( pat:ARRAY OF CHAR, str:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=MatchPattern(} pat {,} str {))} ENDNATIVE !!BOOL
NATIVE {FreeArgs} PROC
PROC FreeArgs( args:PTR TO rdargs ) IS NATIVE {FreeArgs(} args {)} ENDNATIVE
NATIVE {FilePart} PROC
PROC FilePart( path:ARRAY OF CHAR ) IS NATIVE {FilePart(} path {)} ENDNATIVE !!ARRAY OF CHAR
NATIVE {PathPart} PROC
PROC PathPart( path:ARRAY OF CHAR ) IS NATIVE {PathPart(} path {)} ENDNATIVE !!ARRAY OF CHAR
NATIVE {AddPart} PROC
PROC AddPart( dirname:ARRAY OF CHAR, filename:ARRAY OF CHAR, size:ULONG ) IS NATIVE {-(BOOLEAN)(0!=AddPart(} dirname {,} filename {,} size {))} ENDNATIVE !!BOOL

/*	Notification */
NATIVE {StartNotify} PROC
PROC StartNotify( notify:PTR TO notifyrequest ) IS NATIVE {-(BOOLEAN)(0!=StartNotify(} notify {))} ENDNATIVE !!BOOL
NATIVE {EndNotify} PROC
PROC EndNotify( notify:PTR TO notifyrequest ) IS NATIVE {EndNotify(} notify {)} ENDNATIVE

/*	Environment Variable functions */
NATIVE {SetVar} PROC
PROC SetVar( name:ARRAY OF CHAR, buffer:ARRAY OF CHAR, size:VALUE, flags:VALUE ) IS NATIVE {-(BOOLEAN)(0!=SetVar(} name {,} buffer {,} size {,} flags {))} ENDNATIVE !!BOOL
NATIVE {GetVar} PROC
PROC GetVar( name:ARRAY OF CHAR, buffer:ARRAY OF CHAR, size:VALUE, flags:VALUE ) IS NATIVE {GetVar(} name {,} buffer {,} size {,} flags {)} ENDNATIVE !!VALUE
NATIVE {DeleteVar} PROC
PROC DeleteVar( name:ARRAY OF CHAR, flags:ULONG ) IS NATIVE {-(BOOLEAN)(0!=DeleteVar(} name {,} flags {))} ENDNATIVE !!BOOL
NATIVE {FindVar} PROC
PROC FindVar( name:ARRAY OF CHAR, type:ULONG ) IS NATIVE {FindVar(} name {,} type {)} ENDNATIVE !!PTR TO localvar
NATIVE {CliInitNewcli} PROC
PROC CliInitNewcli( dp:PTR TO dospacket ) IS NATIVE {CliInitNewcli(} dp {)} ENDNATIVE !!VALUE
NATIVE {CliInitRun} PROC
PROC CliInitRun( dp:PTR TO dospacket ) IS NATIVE {CliInitRun(} dp {)} ENDNATIVE !!VALUE
NATIVE {WriteChars} PROC
PROC WriteChars( buf:ARRAY OF CHAR, buflen:ULONG ) IS NATIVE {WriteChars(} buf {,} buflen {)} ENDNATIVE !!VALUE
NATIVE {PutStr} PROC
PROC PutStr( str:ARRAY OF CHAR ) IS NATIVE {PutStr(} str {)} ENDNATIVE !!VALUE
NATIVE {VPrintf} PROC
PROC Vprintf( format:ARRAY OF CHAR, argarray:APTR ) IS NATIVE {VPrintf(} format {,} argarray {)} ENDNATIVE !!VALUE
NATIVE {Printf} PROC
PROC Printf( format:ARRAY OF CHAR, format2=0:ULONG, ... ) IS NATIVE {Printf(} format {,} format2 {,} ... {)} ENDNATIVE !!VALUE
/* these were unimplemented until dos 36.147 */
NATIVE {ParsePatternNoCase} PROC
PROC ParsePatternNoCase( pat:ARRAY OF CHAR, buf:ARRAY OF UBYTE, buflen:VALUE ) IS NATIVE {ParsePatternNoCase(} pat {,} buf {,} buflen {)} ENDNATIVE !!VALUE
NATIVE {MatchPatternNoCase} PROC
PROC MatchPatternNoCase( pat:ARRAY OF CHAR, str:ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=MatchPatternNoCase(} pat {,} str {))} ENDNATIVE !!BOOL
/* this was added for V37 dos, returned 0 before then. */
NATIVE {SameDevice} PROC
PROC SameDevice( lock1:BPTR, lock2:BPTR ) IS NATIVE {-(BOOLEAN)(0!=SameDevice(} lock1 {,} lock2 {))} ENDNATIVE !!BOOL

/* NOTE: the following entries did NOT exist before ks 36.303 (2.02) */
/* If you are going to use them, open dos.library with version 37 */

/* These calls were added for V39 dos: */
NATIVE {ExAllEnd} PROC
PROC ExAllEnd( lock:BPTR, buffer:PTR TO exalldata, size:VALUE, data:VALUE, control:PTR TO exallcontrol ) IS NATIVE {ExAllEnd(} lock {,} buffer {,} size {,} data {,} control {)} ENDNATIVE
NATIVE {SetOwner} PROC
PROC SetOwner( name:ARRAY OF CHAR, owner_info:VALUE ) IS NATIVE {-(BOOLEAN)(0!=SetOwner(} name {,} owner_info {))} ENDNATIVE !!BOOL
