/* dos.h 53.29 (10.8.2015) */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/dos/anchorpath', 'target/dos/datetime', 'target/dos/dos', 'target/dos/dosasl', 'target/dos/dosextens', 'target/dos/doshunks', 'target/dos/dostags', 'target/dos/dos_lib', 'target/dos/errors', 'target/dos/exall', 'target/dos/filehandler', 'target/dos/mount', 'target/dos/notify', /**/'target/dos/obsolete',/**/ 'target/dos/path', 'target/dos/rdargs', 'target/dos/record', 'target/dos/stdio', 'target/dos/var'
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/dos/dos', 'target/dos/dosextens', 'target/dos/record', 'target/dos/rdargs', 'target/dos/dosasl', 'target/dos/var', 'target/dos/notify', 'target/dos/datetime', 'target/dos/exall', 'target/dos/filehandler', 'target/dos/dostags', 'target/dos/mount', 'target/dos/doshunks', 'target/dos/path', 'target/dos/anchorpath'
MODULE 'target/utility/tagitem', 'target/utility/hooks'
{
#include <proto/dos.h>
}
{
//#ifndef __NEWLIB_H__
//struct Library* DOSBase = NULL;
//struct DOSIFace* IDOS = NULL;
//#endif
}
NATIVE {CLIB_DOS_PROTOS_H} CONST
NATIVE {PROTO_DOS_H} CONST
NATIVE {PRAGMA_DOS_H} CONST
NATIVE {INLINE4_DOS_H} CONST
NATIVE {DOS_INTERFACE_DEF_H} CONST

NATIVE {DOSBase} DEF dosbase:PTR TO lib
NATIVE {IDOS} DEF

->automatic opening of dos library
PROC new()
	dosbase := OpenLibrary('dos.library', 0)
	IF dosbase=NIL THEN CleanUp(RETURN_ERROR)
	
	NATIVE {IDOS = (struct DOSIFace *) IExec->GetInterface((struct Library *)} dosbase{, "main", 1, NULL)} ENDNATIVE
ENDPROC

->automatic closing of dos library
PROC end()
	{IExec->DropInterface((struct Interface *) IDOS)}
	CloseLibrary(dosbase)
ENDPROC

->NATIVE {Open} PROC
PROC Open(name:/*CONST_STRPTR*/ ARRAY OF CHAR, accessMode:VALUE) IS NATIVE {IDOS->Open(} name {,} accessMode {)} ENDNATIVE !!BPTR
->NATIVE {Close} PROC
PROC Close(file:BPTR) IS NATIVE {-(BOOLEAN)(0!=IDOS->Close(} file {))} ENDNATIVE !!BOOL
->NATIVE {Read} PROC
PROC Read(file:BPTR, buffer:APTR, length:VALUE) IS NATIVE {IDOS->Read(} file {,} buffer {,} length {)} ENDNATIVE !!VALUE
->NATIVE {Write} PROC
PROC Write(file:BPTR, buffer:CONST_APTR, length:VALUE) IS NATIVE {IDOS->Write(} file {,} buffer {,} length {)} ENDNATIVE !!VALUE
->NATIVE {Input} PROC
PROC Input() IS NATIVE {IDOS->Input()} ENDNATIVE !!BPTR
->NATIVE {Output} PROC
PROC Output() IS NATIVE {IDOS->Output()} ENDNATIVE !!BPTR
->NATIVE {Seek} PROC
PROC Seek(file:BPTR, position:VALUE, offset:VALUE) IS NATIVE {IDOS->Seek(} file {,} position {,} offset {)} ENDNATIVE !!VALUE
->NATIVE {Delete} PROC
PROC DeleteFile(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->Delete(} name {))} ENDNATIVE !!BOOL
->NATIVE {Rename} PROC
PROC Rename(oldName:/*CONST_STRPTR*/ ARRAY OF CHAR, newName:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->Rename(} oldName {,} newName {))} ENDNATIVE !!BOOL
->NATIVE {Lock} PROC
PROC Lock(name:/*CONST_STRPTR*/ ARRAY OF CHAR, type:VALUE) IS NATIVE {IDOS->Lock(} name {,} type {)} ENDNATIVE !!BPTR
->NATIVE {UnLock} PROC
PROC UnLock(lock:BPTR) IS NATIVE {IDOS->UnLock(} lock {)} ENDNATIVE
->NATIVE {DupLock} PROC
PROC DupLock(lock:BPTR) IS NATIVE {IDOS->DupLock(} lock {)} ENDNATIVE !!BPTR
->NATIVE {Examine} PROC
PROC Examine(lock:BPTR, fileInfoBlock:PTR TO fileinfoblock) IS NATIVE {-(BOOLEAN)(0!=IDOS->Examine(} lock {,} fileInfoBlock {))} ENDNATIVE !!BOOL
->NATIVE {ExNext} PROC
PROC ExNext(lock:BPTR, fileInfoBlock:PTR TO fileinfoblock) IS NATIVE {-(BOOLEAN)(0!=IDOS->ExNext(} lock {,} fileInfoBlock {))} ENDNATIVE !!BOOL
->NATIVE {Info} PROC
PROC Info(lock:BPTR, parameterBlock:PTR TO infodata) IS NATIVE {-(BOOLEAN)(0!=IDOS->Info(} lock {,} parameterBlock {))} ENDNATIVE !!BOOL
->NATIVE {CreateDir} PROC
PROC CreateDir(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->CreateDir(} name {)} ENDNATIVE !!BPTR
->NATIVE {SetCurrentDir} PROC
PROC CurrentDir(lock:BPTR) IS NATIVE {IDOS->SetCurrentDir(} lock {)} ENDNATIVE !!BPTR
->NATIVE {IoErr} PROC
PROC IoErr() IS NATIVE {IDOS->IoErr()} ENDNATIVE !!VALUE
->NATIVE {CreateProc} PROC
PROC CreateProc(name:/*CONST_STRPTR*/ ARRAY OF CHAR, pri:VALUE, segList:BPTR, stackSize:VALUE) IS NATIVE {IDOS->CreateProc(} name {,} pri {,} segList {,} stackSize {)} ENDNATIVE !!PTR TO mp
->NATIVE {OBSOLETEExit} PROC
->PROC ObSOLETEExit(returnCode:VALUE) IS NATIVE {IDOS->OBSOLETEExit(} returnCode {)} ENDNATIVE
->NATIVE {OBSOLETELoadSeg} PROC
->PROC ObSOLETELoadSeg(name:/*CONST_STRPTR*/ ARRAY OF CHAR, hunktab:BPTR, stream:BPTR) IS NATIVE {IDOS->OBSOLETELoadSeg(} name {,} hunktab {,} stream {)} ENDNATIVE !!BPTR
->NATIVE {UnLoadSeg} PROC
PROC UnLoadSeg(seglist:BPTR) IS NATIVE {IDOS->UnLoadSeg(} seglist {)} ENDNATIVE !!VALUE
->NATIVE {PRIVATEDoPkt32} PROC
->PROC PrIVATEDoPkt32(port:PTR TO mp, action:VALUE, arg1:VALUE, arg2:VALUE, arg3:VALUE, arg4:VALUE, arg5:VALUE, arg6:VALUE, arg7:VALUE) IS NATIVE {IDOS->PRIVATEDoPkt32(} port {,} action {,} arg1 {,} arg2 {,} arg3 {,} arg4 {,} arg5 {,} arg6 {,} arg7 {)} ENDNATIVE !!VALUE
->NATIVE {LoadSeg} PROC
PROC LoadSeg(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->LoadSeg(} name {)} ENDNATIVE !!BPTR
->NATIVE {DeviceProc} PROC
PROC DeviceProc(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->DeviceProc(} name {)} ENDNATIVE !!PTR TO mp
->NATIVE {SetComment} PROC
PROC SetComment(name:/*CONST_STRPTR*/ ARRAY OF CHAR, comment:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->SetComment(} name {,} comment {))} ENDNATIVE !!BOOL
->NATIVE {SetProtection} PROC
PROC SetProtection(name:/*CONST_STRPTR*/ ARRAY OF CHAR, protect:ULONG) IS NATIVE {-(BOOLEAN)(0!=IDOS->SetProtection(} name {,} protect {))} ENDNATIVE !!BOOL
->NATIVE {DateStamp} PROC
PROC DateStamp(date:PTR TO datestamp) IS NATIVE {IDOS->DateStamp(} date {)} ENDNATIVE !!PTR TO datestamp
->NATIVE {Delay} PROC
PROC Delay(timeout:VALUE) IS NATIVE {IDOS->Delay(} timeout {)} ENDNATIVE
->NATIVE {WaitForChar} PROC
PROC WaitForChar(file:BPTR, timeout:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->WaitForChar(} file {,} timeout {))} ENDNATIVE !!BOOL
->NATIVE {ParentDir} PROC
PROC ParentDir(lock:BPTR) IS NATIVE {IDOS->ParentDir(} lock {)} ENDNATIVE !!BPTR
->NATIVE {IsInteractive} PROC
PROC IsInteractive(file:BPTR) IS NATIVE {-(BOOLEAN)(0!=IDOS->IsInteractive(} file {))} ENDNATIVE !!BOOL
->NATIVE {Execute} PROC
PROC Execute(string:/*CONST_STRPTR*/ ARRAY OF CHAR, file:BPTR, file2:BPTR) IS NATIVE {-(BOOLEAN)(0!=IDOS->Execute(} string {,} file {,} file2 {))} ENDNATIVE !!BOOL
->NATIVE {AllocDosObject} PROC
PROC AllocDosObject(type:ULONG, tags:ARRAY OF tagitem) IS NATIVE {IDOS->AllocDosObject(} type {,} tags {)} ENDNATIVE !!APTR2
->NATIVE {AllocDosObjectTagList} PROC
PROC AllocDosObjectTagList(type:ULONG, tags:ARRAY OF tagitem) IS NATIVE {IDOS->AllocDosObjectTagList(} type {,} tags {)} ENDNATIVE !!APTR2
->NATIVE {AllocDosObjectTags} PROC
->PROC AllocDosObjectTags(type:ULONG, type2=0:ULONG, ...) IS NATIVE {IDOS->AllocDosObjectTags(} type {,} type2 {,} ... {)} ENDNATIVE !!APTR2
->NATIVE {FreeDosObject} PROC
PROC FreeDosObject(type:ULONG, ptr:APTR2) IS NATIVE {IDOS->FreeDosObject(} type {,} ptr {)} ENDNATIVE
->NATIVE {DoPkt} PROC
PROC DoPkt(port:PTR TO mp, action:VALUE, arg1:VALUE, arg2:VALUE, arg3:VALUE, arg4:VALUE, arg5:VALUE) IS NATIVE {IDOS->DoPkt(} port {,} action {,} arg1 {,} arg2 {,} arg3 {,} arg4 {,} arg5 {)} ENDNATIVE !!VALUE
->NATIVE {DoPkt0} PROC
PROC DoPkt0(port:PTR TO mp, action:VALUE) IS NATIVE {IDOS->DoPkt0(} port {,} action {)} ENDNATIVE !!VALUE
->NATIVE {DoPkt1} PROC
PROC DoPkt1(port:PTR TO mp, action:VALUE, arg1:VALUE) IS NATIVE {IDOS->DoPkt1(} port {,} action {,} arg1 {)} ENDNATIVE !!VALUE
->NATIVE {DoPkt2} PROC
PROC DoPkt2(port:PTR TO mp, action:VALUE, arg1:VALUE, arg2:VALUE) IS NATIVE {IDOS->DoPkt2(} port {,} action {,} arg1 {,} arg2 {)} ENDNATIVE !!VALUE
->NATIVE {DoPkt3} PROC
PROC DoPkt3(port:PTR TO mp, action:VALUE, arg1:VALUE, arg2:VALUE, arg3:VALUE) IS NATIVE {IDOS->DoPkt3(} port {,} action {,} arg1 {,} arg2 {,} arg3 {)} ENDNATIVE !!VALUE
->NATIVE {DoPkt4} PROC
PROC DoPkt4(port:PTR TO mp, action:VALUE, arg1:VALUE, arg2:VALUE, arg3:VALUE, arg4:VALUE) IS NATIVE {IDOS->DoPkt4(} port {,} action {,} arg1 {,} arg2 {,} arg3 {,} arg4 {)} ENDNATIVE !!VALUE
->NATIVE {SendPkt} PROC
PROC SendPkt(dp:PTR TO dospacket, port:PTR TO mp, replyport:PTR TO mp) IS NATIVE {IDOS->SendPkt(} dp {,} port {,} replyport {)} ENDNATIVE
->NATIVE {WaitPkt} PROC
PROC WaitPkt(task_replyport:PTR TO mp) IS NATIVE {IDOS->WaitPkt(} task_replyport {)} ENDNATIVE !!PTR TO dospacket
->NATIVE {ReplyPkt} PROC
PROC ReplyPkt(dp:PTR TO dospacket, res1:VALUE, res2:VALUE) IS NATIVE {IDOS->ReplyPkt(} dp {,} res1 {,} res2 {)} ENDNATIVE !!VALUE
->NATIVE {OBSOLETELockRecord} PROC
->PROC ObSOLETELockRecord(fh:BPTR, offset:ULONG, length:ULONG, mode:ULONG, timeout:ULONG) IS NATIVE {-(BOOLEAN)(0!=IDOS->OBSOLETELockRecord(} fh {,} offset {,} length {,} mode {,} timeout {))} ENDNATIVE !!BOOL
->NATIVE {LockRecords} PROC
PROC LockRecords(recArray:PTR TO recordlock, timeout:ULONG) IS NATIVE {-(BOOLEAN)(0!=IDOS->LockRecords(} recArray {,} timeout {))} ENDNATIVE !!BOOL
->NATIVE {OBSOLETEUnLockRecord} PROC
->PROC ObSOLETEUnLockRecord(fh:BPTR, offset:ULONG, length:ULONG) IS NATIVE {-(BOOLEAN)(0!=IDOS->OBSOLETEUnLockRecord(} fh {,} offset {,} length {))} ENDNATIVE !!BOOL
->NATIVE {UnLockRecords} PROC
PROC UnLockRecords(recArray:PTR TO recordlock) IS NATIVE {-(BOOLEAN)(0!=IDOS->UnLockRecords(} recArray {))} ENDNATIVE !!BOOL
->NATIVE {SelectInput} PROC
PROC SelectInput(fh:BPTR) IS NATIVE {IDOS->SelectInput(} fh {)} ENDNATIVE !!BPTR
->NATIVE {SelectOutput} PROC
PROC SelectOutput(fh:BPTR) IS NATIVE {IDOS->SelectOutput(} fh {)} ENDNATIVE !!BPTR
->NATIVE {FGetC} PROC
PROC FgetC(fh:BPTR) IS NATIVE {IDOS->FGetC(} fh {)} ENDNATIVE !!VALUE
->NATIVE {FPutC} PROC
PROC FputC(fh:BPTR, ch:VALUE) IS NATIVE {IDOS->FPutC(} fh {,} ch {)} ENDNATIVE !!VALUE
->NATIVE {UnGetC} PROC
PROC UnGetC(fh:BPTR, character:VALUE) IS NATIVE {IDOS->UnGetC(} fh {,} character {)} ENDNATIVE !!VALUE
->NATIVE {FRead} PROC
PROC Fread(fh:BPTR, block:APTR, blocklen:ULONG, number:ULONG) IS NATIVE {IDOS->FRead(} fh {,} block {,} blocklen {,} number {)} ENDNATIVE !!ULONG
->NATIVE {FWrite} PROC
PROC Fwrite(fh:BPTR, block:CONST_APTR, blocklen:ULONG, number:ULONG) IS NATIVE {IDOS->FWrite(} fh {,} block {,} blocklen {,} number {)} ENDNATIVE !!ULONG
->NATIVE {FGets} PROC
PROC Fgets(fh:BPTR, buf:/*STRPTR*/ ARRAY OF CHAR, buflen:ULONG) IS NATIVE {IDOS->FGets(} fh {,} buf {,} buflen {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {FPuts} PROC
PROC Fputs(fh:BPTR, str:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->FPuts(} fh {,} str {)} ENDNATIVE !!VALUE
->NATIVE {OBSOLETEVFWritef} PROC
->PROC ObSOLETEVFWritef(fh:BPTR, format:/*CONST_STRPTR*/ ARRAY OF CHAR, argarray:ARRAY OF VALUE) IS NATIVE {IDOS->OBSOLETEVFWritef(} fh {,} format {,} argarray {)} ENDNATIVE
->NATIVE {OBSOLETEFWritef} PROC
->PROC ObSOLETEFWritef(fh:BPTR, format:/*CONST_STRPTR*/ ARRAY OF CHAR, format2=0:ULONG, ...) IS NATIVE {IDOS->OBSOLETEFWritef(} fh {,} format {,} format2 {,} ... {)} ENDNATIVE
->NATIVE {VFPrintf} PROC
PROC VfPrintf(fh:BPTR, format:/*CONST_STRPTR*/ ARRAY OF CHAR, argarray:CONST_APTR) IS NATIVE {IDOS->VFPrintf(} fh {,} format {,} argarray {)} ENDNATIVE !!VALUE
->NATIVE {FPrintf} PROC
PROC Fprintf(fh:BPTR, format:/*CONST_STRPTR*/ ARRAY OF CHAR, format2=0:ULONG, ...) IS NATIVE {IDOS->FPrintf(} fh {,} format {,} format2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {FFlush} PROC
PROC Flush(fh:BPTR) IS NATIVE {IDOS->FFlush(} fh {)} ENDNATIVE !!VALUE
->NATIVE {SetVBuf} PROC
PROC SetVBuf(fh:BPTR, buff:/*STRPTR*/ ARRAY OF CHAR, type:VALUE, size:VALUE) IS NATIVE {IDOS->SetVBuf(} fh {,} buff {,} type {,} size {)} ENDNATIVE !!VALUE
->NATIVE {DupLockFromFH} PROC
PROC DupLockFromFH(fh:BPTR) IS NATIVE {IDOS->DupLockFromFH(} fh {)} ENDNATIVE !!BPTR
->NATIVE {OpenFromLock} PROC
PROC OpenFromLock(lock:BPTR) IS NATIVE {IDOS->OpenFromLock(} lock {)} ENDNATIVE !!BPTR
->NATIVE {ParentOfFH} PROC
PROC ParentOfFH(fh:BPTR) IS NATIVE {IDOS->ParentOfFH(} fh {)} ENDNATIVE !!BPTR
->NATIVE {ExamineFH} PROC
PROC ExamineFH(fh:BPTR, fib:PTR TO fileinfoblock) IS NATIVE {-(BOOLEAN)(0!=IDOS->ExamineFH(} fh {,} fib {))} ENDNATIVE !!BOOL
->NATIVE {SetDate} PROC
PROC SetFileDate(name:/*CONST_STRPTR*/ ARRAY OF CHAR, date:PTR TO datestamp) IS NATIVE {-(BOOLEAN)(0!=IDOS->SetDate(} name {,} date {))} ENDNATIVE !!BOOL
->NATIVE {NameFromLock} PROC
PROC NameFromLock(lock:BPTR, buffer:/*STRPTR*/ ARRAY OF CHAR, len:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->NameFromLock(} lock {,} buffer {,} len {))} ENDNATIVE !!BOOL
->NATIVE {NameFromFH} PROC
PROC NameFromFH(fh:BPTR, buffer:/*STRPTR*/ ARRAY OF CHAR, len:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->NameFromFH(} fh {,} buffer {,} len {))} ENDNATIVE !!BOOL
->NATIVE {SplitName} PROC
PROC SplitName(name:/*CONST_STRPTR*/ ARRAY OF CHAR, separator:VALUE, buf:/*STRPTR*/ ARRAY OF CHAR, oldpos:VALUE, size:VALUE) IS NATIVE {IDOS->SplitName(} name {,} separator {,} buf {,} oldpos {,} size {)} ENDNATIVE !!VALUE
->NATIVE {SameLock} PROC
PROC SameLock(lock1:BPTR, lock2:BPTR) IS NATIVE {IDOS->SameLock(} lock1 {,} lock2 {)} ENDNATIVE !!VALUE
->NATIVE {SetMode} PROC
PROC SetMode(fh:BPTR, mode:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->SetMode(} fh {,} mode {))} ENDNATIVE !!BOOL
->NATIVE {ExAll} PROC
PROC ExAll(lock:BPTR, buffer:PTR TO exalldata, size:VALUE, data:VALUE, control:PTR TO exallcontrol) IS NATIVE {-(BOOLEAN)(0!=IDOS->ExAll(} lock {,} buffer {,} size {,} data {,} control {))} ENDNATIVE !!BOOL
->NATIVE {ReadSoftLink} PROC
PROC ReadLink(port:PTR TO mp, lock:BPTR, path:/*CONST_STRPTR*/ ARRAY OF CHAR, buffer:/*STRPTR*/ ARRAY OF CHAR, size:ULONG) IS NATIVE {IDOS->ReadSoftLink(} port {,} lock {,} path {,} buffer {,} size {)} ENDNATIVE !!VALUE
->NATIVE {MakeLink} PROC
PROC MakeLink(name:/*CONST_STRPTR*/ ARRAY OF CHAR, dest:APTR, soft:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->MakeLink(} name {,} dest {,} soft {))} ENDNATIVE !!BOOL
->NATIVE {ChangeMode} PROC
PROC ChangeMode(type:VALUE, fh:BPTR, newmode:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->ChangeMode(} type {,} fh {,} newmode {))} ENDNATIVE !!BOOL
->NATIVE {SetFileSize} PROC
PROC SetFileSize(fh:BPTR, pos:VALUE, mode:VALUE) IS NATIVE {IDOS->SetFileSize(} fh {,} pos {,} mode {)} ENDNATIVE !!VALUE
->NATIVE {SetIoErr} PROC
PROC SetIoErr(result:VALUE) IS NATIVE {IDOS->SetIoErr(} result {)} ENDNATIVE !!VALUE
->NATIVE {Fault} PROC
PROC Fault(code:VALUE, header:/*CONST_STRPTR*/ ARRAY OF CHAR, buffer:/*STRPTR*/ ARRAY OF CHAR, len:VALUE) IS NATIVE {IDOS->Fault(} code {,} header {,} buffer {,} len {)} ENDNATIVE !!VALUE
->NATIVE {PrintFault} PROC
PROC PrintFault(code:VALUE, header:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->PrintFault(} code {,} header {)} ENDNATIVE !!VALUE
->NATIVE {ErrorReport} PROC
PROC ErrorReport(code:VALUE, type:VALUE, arg1:ULONG, device:PTR TO mp) IS NATIVE {-(BOOLEAN)(0!=IDOS->ErrorReport(} code {,} type {,} arg1 {,} device {))} ENDNATIVE !!BOOL
->NATIVE {PRIVATERequester} PROC
->PROC PrIVATERequester(s1:/*CONST_STRPTR*/ ARRAY OF CHAR, s2:/*CONST_STRPTR*/ ARRAY OF CHAR, s3:/*CONST_STRPTR*/ ARRAY OF CHAR, idcmp:VALUE) IS NATIVE {IDOS->PRIVATERequester(} s1 {,} s2 {,} s3 {,} idcmp {)} ENDNATIVE !!VALUE
->NATIVE {Cli} PROC
PROC Cli() IS NATIVE {IDOS->Cli()} ENDNATIVE !!PTR TO commandlineinterface
->NATIVE {CreateNewProc} PROC
PROC CreateNewProc(tags:ARRAY OF tagitem) IS NATIVE {IDOS->CreateNewProc(} tags {)} ENDNATIVE !!PTR TO process
->NATIVE {CreateNewProcTagList} PROC
PROC CreateNewProcTagList(tags:ARRAY OF tagitem) IS NATIVE {IDOS->CreateNewProcTagList(} tags {)} ENDNATIVE !!PTR TO process
->NATIVE {CreateNewProcTags} PROC
->PROC CreateNewProcTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {IDOS->CreateNewProcTags(} param {,} param2 {,} ... {)} ENDNATIVE !!PTR TO process
->NATIVE {RunCommand} PROC
PROC RunCommand(seg:BPTR, stack:ULONG, paramptr:/*CONST_STRPTR*/ ARRAY OF CHAR, paramlen:VALUE) IS NATIVE {IDOS->RunCommand(} seg {,} stack {,} paramptr {,} paramlen {)} ENDNATIVE !!VALUE
->NATIVE {GetConsolePort} PROC
PROC GetConsoleTask() IS NATIVE {IDOS->GetConsolePort()} ENDNATIVE !!PTR TO mp
->NATIVE {SetConsolePort} PROC
PROC SetConsoleTask(port:PTR TO mp) IS NATIVE {IDOS->SetConsolePort(} port {)} ENDNATIVE !!PTR TO mp
->NATIVE {GetFileSysPort} PROC
PROC GetFileSysTask() IS NATIVE {IDOS->GetFileSysPort()} ENDNATIVE !!PTR TO mp
->NATIVE {SetFileSysPort} PROC
PROC SetFileSysTask(port:PTR TO mp) IS NATIVE {IDOS->SetFileSysPort(} port {)} ENDNATIVE !!PTR TO mp
->NATIVE {GetArgStr} PROC
PROC GetArgStr() IS NATIVE {IDOS->GetArgStr()} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {SetArgStr} PROC
PROC SetArgStr(string:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->SetArgStr(} string {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {FindCliProc} PROC
PROC FindCliProc(num:ULONG) IS NATIVE {IDOS->FindCliProc(} num {)} ENDNATIVE !!PTR TO process
->NATIVE {MaxCli} PROC
PROC MaxCli() IS NATIVE {IDOS->MaxCli()} ENDNATIVE !!ULONG
->NATIVE {SetCliCurrentDirName} PROC
PROC SetCurrentDirName(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->SetCliCurrentDirName(} name {))} ENDNATIVE !!BOOL
->NATIVE {GetCliCurrentDirName} PROC
PROC GetCurrentDirName(buf:/*STRPTR*/ ARRAY OF CHAR, len:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->GetCliCurrentDirName(} buf {,} len {))} ENDNATIVE !!BOOL
->NATIVE {SetCliProgramName} PROC
PROC SetProgramName(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->SetCliProgramName(} name {))} ENDNATIVE !!BOOL
->NATIVE {GetCliProgramName} PROC
PROC GetProgramName(buf:/*STRPTR*/ ARRAY OF CHAR, len:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->GetCliProgramName(} buf {,} len {))} ENDNATIVE !!BOOL
->NATIVE {SetCliPrompt} PROC
PROC SetPrompt(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->SetCliPrompt(} name {))} ENDNATIVE !!BOOL
->NATIVE {GetCliPrompt} PROC
PROC GetPrompt(buf:/*STRPTR*/ ARRAY OF CHAR, len:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->GetCliPrompt(} buf {,} len {))} ENDNATIVE !!BOOL
->NATIVE {SetProgramDir} PROC
PROC SetProgramDir(lock:BPTR) IS NATIVE {IDOS->SetProgramDir(} lock {)} ENDNATIVE !!BPTR
->NATIVE {GetProgramDir} PROC
PROC GetProgramDir() IS NATIVE {IDOS->GetProgramDir()} ENDNATIVE !!BPTR
->NATIVE {SystemTagList} PROC
PROC SystemTagList(command:/*CONST_STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {IDOS->SystemTagList(} command {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {System} PROC
PROC System(command:/*CONST_STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {IDOS->System(} command {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {SystemTags} PROC
PROC SystemTags(command:/*CONST_STRPTR*/ ARRAY OF CHAR, tag=0:ULONG, ...) IS NATIVE {IDOS->SystemTags(} command {,} tag {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {AssignLock} PROC
PROC AssignLock(name:/*CONST_STRPTR*/ ARRAY OF CHAR, lock:BPTR) IS NATIVE {-(BOOLEAN)(0!=IDOS->AssignLock(} name {,} lock {))} ENDNATIVE !!BOOL
->NATIVE {AssignLate} PROC
PROC AssignLate(name:/*CONST_STRPTR*/ ARRAY OF CHAR, path:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->AssignLate(} name {,} path {))} ENDNATIVE !!BOOL
->NATIVE {AssignPath} PROC
PROC AssignPath(name:/*CONST_STRPTR*/ ARRAY OF CHAR, path:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->AssignPath(} name {,} path {))} ENDNATIVE !!BOOL
->NATIVE {AssignAdd} PROC
PROC AssignAdd(name:/*CONST_STRPTR*/ ARRAY OF CHAR, lock:BPTR) IS NATIVE {-(BOOLEAN)(0!=IDOS->AssignAdd(} name {,} lock {))} ENDNATIVE !!BOOL
->NATIVE {RemAssignList} PROC
PROC RemAssignList(name:/*CONST_STRPTR*/ ARRAY OF CHAR, lock:BPTR) IS NATIVE {IDOS->RemAssignList(} name {,} lock {)} ENDNATIVE !!VALUE
->NATIVE {GetDeviceProc} PROC
PROC GetDeviceProc(name:/*CONST_STRPTR*/ ARRAY OF CHAR, dp:PTR TO devproc) IS NATIVE {IDOS->GetDeviceProc(} name {,} dp {)} ENDNATIVE !!PTR TO devproc
->NATIVE {FreeDeviceProc} PROC
PROC FreeDeviceProc(dp:PTR TO devproc) IS NATIVE {IDOS->FreeDeviceProc(} dp {)} ENDNATIVE
->NATIVE {LockDosList} PROC
PROC LockDosList(flags:ULONG) IS NATIVE {IDOS->LockDosList(} flags {)} ENDNATIVE !!PTR TO doslist
->NATIVE {UnLockDosList} PROC
PROC UnLockDosList(flags:ULONG) IS NATIVE {IDOS->UnLockDosList(} flags {)} ENDNATIVE
->NATIVE {AttemptLockDosList} PROC
PROC AttemptLockDosList(flags:ULONG) IS NATIVE {IDOS->AttemptLockDosList(} flags {)} ENDNATIVE !!PTR TO doslist
->NATIVE {RemDosEntry} PROC
PROC RemDosEntry(dlist:PTR TO doslist) IS NATIVE {-(BOOLEAN)(0!=IDOS->RemDosEntry(} dlist {))} ENDNATIVE !!BOOL
->NATIVE {AddDosEntry} PROC
PROC AddDosEntry(dlist:PTR TO doslist) IS NATIVE {IDOS->AddDosEntry(} dlist {)} ENDNATIVE !!VALUE
->NATIVE {FindDosEntry} PROC
PROC FindDosEntry(dlist:PTR TO doslist, name:/*CONST_STRPTR*/ ARRAY OF CHAR, flags:ULONG) IS NATIVE {IDOS->FindDosEntry(} dlist {,} name {,} flags {)} ENDNATIVE !!PTR TO doslist
->NATIVE {NextDosEntry} PROC
PROC NextDosEntry(dlist:PTR TO doslist, flags:ULONG) IS NATIVE {IDOS->NextDosEntry(} dlist {,} flags {)} ENDNATIVE !!PTR TO doslist
->NATIVE {MakeDosEntry} PROC
PROC MakeDosEntry(name:/*CONST_STRPTR*/ ARRAY OF CHAR, type:VALUE) IS NATIVE {IDOS->MakeDosEntry(} name {,} type {)} ENDNATIVE !!PTR TO doslist
->NATIVE {FreeDosEntry} PROC
PROC FreeDosEntry(dlist:PTR TO doslist) IS NATIVE {IDOS->FreeDosEntry(} dlist {)} ENDNATIVE
->NATIVE {IsFileSystem} PROC
PROC IsFileSystem(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->IsFileSystem(} name {))} ENDNATIVE !!BOOL
->NATIVE {Format} PROC
PROC Format(filesystem:/*CONST_STRPTR*/ ARRAY OF CHAR, volumename:/*CONST_STRPTR*/ ARRAY OF CHAR, dostype:ULONG, flags:ULONG) IS NATIVE {-(BOOLEAN)(0!=IDOS->Format(} filesystem {,} volumename {,} dostype {,} flags {))} ENDNATIVE !!BOOL
->NATIVE {Relabel} PROC
PROC Relabel(drive:/*CONST_STRPTR*/ ARRAY OF CHAR, newname:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->Relabel(} drive {,} newname {))} ENDNATIVE !!BOOL
->NATIVE {Inhibit} PROC
PROC Inhibit(name:/*CONST_STRPTR*/ ARRAY OF CHAR, onoff:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->Inhibit(} name {,} onoff {))} ENDNATIVE !!BOOL
->NATIVE {AddBuffers} PROC
PROC AddBuffers(name:/*CONST_STRPTR*/ ARRAY OF CHAR, number:VALUE) IS NATIVE {IDOS->AddBuffers(} name {,} number {)} ENDNATIVE !!VALUE
->NATIVE {CompareDates} PROC
PROC CompareDates(date1:PTR TO datestamp, date2:PTR TO datestamp) IS NATIVE {IDOS->CompareDates(} date1 {,} date2 {)} ENDNATIVE !!VALUE
->NATIVE {DateToStr} PROC
PROC DateToStr(datetime:PTR TO datetime) IS NATIVE {-(BOOLEAN)(0!=IDOS->DateToStr(} datetime {))} ENDNATIVE !!BOOL
->NATIVE {StrToDate} PROC
PROC StrToDate(datetime:PTR TO datetime) IS NATIVE {-(BOOLEAN)(0!=IDOS->StrToDate(} datetime {))} ENDNATIVE !!BOOL
->NATIVE {OBSOLETEInternalLoadSeg} PROC
->PROC ObSOLETEInternalLoadSeg(fh:BPTR, table:BPTR, funcarray:ARRAY OF VALUE) IS NATIVE {IDOS->OBSOLETEInternalLoadSeg(} fh {,} table {,} funcarray {)} ENDNATIVE !!BPTR
->NATIVE {OBSOLETEInternalUnLoadSeg} PROC
->PROC ObSOLETEInternalUnLoadSeg(seglist:BPTR, freefunc:PTR /*VOID (*freefunc )()*/) IS NATIVE {-(BOOLEAN)(0!=IDOS->OBSOLETEInternalUnLoadSeg(} seglist {, (VOID (*)()) } freefunc {))} ENDNATIVE !!BOOL
->NATIVE {OBSOLETENewLoadSeg} PROC
->PROC ObSOLETENewLoadSeg(file:/*CONST_STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {IDOS->OBSOLETENewLoadSeg(} file {,} tags {)} ENDNATIVE !!BPTR
->NATIVE {OBSOLETENewLoadSegTagList} PROC
->PROC ObSOLETENewLoadSegTagList(file:/*CONST_STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {IDOS->OBSOLETENewLoadSegTagList(} file {,} tags {)} ENDNATIVE !!BPTR
->NATIVE {OBSOLETENewLoadSegTags} PROC
->->PROC ObSOLETENewLoadSegTags(file:/*CONST_STRPTR*/ ARRAY OF CHAR, file2=0:ULONG, ...) IS NATIVE {IDOS->OBSOLETENewLoadSegTags(} file {,} file2 {,} ... {)} ENDNATIVE !!BPTR
->NATIVE {AddSegment} PROC
PROC AddSegment(name:/*CONST_STRPTR*/ ARRAY OF CHAR, seg:BPTR, type:VALUE) IS NATIVE {IDOS->AddSegment(} name {,} seg {,} type {)} ENDNATIVE !!VALUE
->NATIVE {FindSegment} PROC
PROC FindSegment(name:/*CONST_STRPTR*/ ARRAY OF CHAR, seg:PTR TO segment, sys:VALUE) IS NATIVE {IDOS->FindSegment(} name {,} seg {,} sys {)} ENDNATIVE !!PTR TO segment
->NATIVE {RemSegment} PROC
PROC RemSegment(seg:PTR TO segment) IS NATIVE {IDOS->RemSegment(} seg {)} ENDNATIVE !!VALUE
->NATIVE {CheckSignal} PROC
PROC CheckSignal(mask:ULONG) IS NATIVE {IDOS->CheckSignal(} mask {)} ENDNATIVE !!ULONG
->NATIVE {ReadArgs} PROC
PROC ReadArgs(arg_template:/*CONST_STRPTR*/ ARRAY OF CHAR, array:ARRAY OF VALUE, args:PTR TO rdargs) IS NATIVE {IDOS->ReadArgs(} arg_template {,} array {,} args {)} ENDNATIVE !!PTR TO rdargs
->NATIVE {FindArg} PROC
PROC FindArg(arg_template:/*CONST_STRPTR*/ ARRAY OF CHAR, keyword:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->FindArg(} arg_template {,} keyword {)} ENDNATIVE !!VALUE
->NATIVE {ReadItem} PROC
PROC ReadItem(buffer:/*STRPTR*/ ARRAY OF CHAR, maxchars:VALUE, cSource:PTR TO csource) IS NATIVE {IDOS->ReadItem(} buffer {,} maxchars {,} cSource {)} ENDNATIVE !!VALUE
->NATIVE {StrToLong} PROC
PROC StrToLong(string:/*CONST_STRPTR*/ ARRAY OF CHAR, value:ARRAY OF VALUE) IS NATIVE {IDOS->StrToLong(} string {,} value {)} ENDNATIVE !!VALUE
->NATIVE {MatchFirst} PROC
PROC MatchFirst(pat:/*CONST_STRPTR*/ ARRAY OF CHAR, anchor:PTR TO anchorpath) IS NATIVE {IDOS->MatchFirst(} pat {,} anchor {)} ENDNATIVE !!VALUE
->NATIVE {MatchNext} PROC
PROC MatchNext(anchor:PTR TO anchorpath) IS NATIVE {IDOS->MatchNext(} anchor {)} ENDNATIVE !!VALUE
->NATIVE {MatchEnd} PROC
PROC MatchEnd(anchor:PTR TO anchorpath) IS NATIVE {IDOS->MatchEnd(} anchor {)} ENDNATIVE
->NATIVE {ParsePattern} PROC
PROC ParsePattern(pat:/*CONST_STRPTR*/ ARRAY OF CHAR, buf:/*STRPTR*/ ARRAY OF CHAR, buflen:VALUE) IS NATIVE {IDOS->ParsePattern(} pat {,} buf {,} buflen {)} ENDNATIVE !!VALUE
->NATIVE {MatchPattern} PROC
PROC MatchPattern(pat:/*CONST_STRPTR*/ ARRAY OF CHAR, str:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->MatchPattern(} pat {,} str {))} ENDNATIVE !!BOOL
->NATIVE {FreeArgs} PROC
PROC FreeArgs(args:PTR TO rdargs) IS NATIVE {IDOS->FreeArgs(} args {)} ENDNATIVE
->NATIVE {FilePart} PROC
PROC FilePart(path:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->FilePart(} path {)} ENDNATIVE !!CONST_STRPTR
->NATIVE {PathPart} PROC
PROC PathPart(path:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->PathPart(} path {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {AddPart} PROC
PROC AddPart(destdirname:/*STRPTR*/ ARRAY OF CHAR, filename:/*CONST_STRPTR*/ ARRAY OF CHAR, size:ULONG) IS NATIVE {-(BOOLEAN)(0!=IDOS->AddPart(} destdirname {,} filename {,} size {))} ENDNATIVE !!BOOL
->NATIVE {StartNotify} PROC
PROC StartNotify(notify:PTR TO notifyrequest) IS NATIVE {-(BOOLEAN)(0!=IDOS->StartNotify(} notify {))} ENDNATIVE !!BOOL
->NATIVE {EndNotify} PROC
PROC EndNotify(notify:PTR TO notifyrequest) IS NATIVE {IDOS->EndNotify(} notify {)} ENDNATIVE !!VALUE
->NATIVE {SetVar} PROC
PROC SetVar(name:/*CONST_STRPTR*/ ARRAY OF CHAR, buffer:/*CONST_STRPTR*/ ARRAY OF CHAR, size:VALUE, flags:ULONG) IS NATIVE {-(BOOLEAN)(0!=IDOS->SetVar(} name {,} buffer {,} size {,} flags {))} ENDNATIVE !!BOOL
->NATIVE {GetVar} PROC
PROC GetVar(name:/*CONST_STRPTR*/ ARRAY OF CHAR, buffer:/*STRPTR*/ ARRAY OF CHAR, size:VALUE, flags:ULONG) IS NATIVE {IDOS->GetVar(} name {,} buffer {,} size {,} flags {)} ENDNATIVE !!VALUE
->NATIVE {DeleteVar} PROC
PROC DeleteVar(name:/*CONST_STRPTR*/ ARRAY OF CHAR, flags:ULONG) IS NATIVE {-(BOOLEAN)(0!=IDOS->DeleteVar(} name {,} flags {))} ENDNATIVE !!BOOL
->NATIVE {FindVar} PROC
PROC FindVar(name:/*CONST_STRPTR*/ ARRAY OF CHAR, type:ULONG) IS NATIVE {IDOS->FindVar(} name {,} type {)} ENDNATIVE !!PTR TO localvar
->NATIVE {PRIVATECliInit} PROC
->PROC PrIVATECliInit(dp:PTR TO dospacket) IS NATIVE {IDOS->PRIVATECliInit(} dp {)} ENDNATIVE !!VALUE
->NATIVE {CliInitNewcli} PROC
PROC CliInitNewcli(dp:PTR TO dospacket) IS NATIVE {IDOS->CliInitNewcli(} dp {)} ENDNATIVE !!VALUE
->NATIVE {CliInitRun} PROC
PROC CliInitRun(dp:PTR TO dospacket) IS NATIVE {IDOS->CliInitRun(} dp {)} ENDNATIVE !!VALUE
->NATIVE {WriteChars} PROC
PROC WriteChars(buf:/*CONST_STRPTR*/ ARRAY OF CHAR, buflen:ULONG) IS NATIVE {IDOS->WriteChars(} buf {,} buflen {)} ENDNATIVE !!VALUE
->NATIVE {PutStr} PROC
PROC PutStr(str:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->PutStr(} str {)} ENDNATIVE !!VALUE
->NATIVE {VPrintf} PROC
PROC Vprintf(format:/*CONST_STRPTR*/ ARRAY OF CHAR, argarray:CONST_APTR) IS NATIVE {IDOS->VPrintf(} format {,} argarray {)} ENDNATIVE !!VALUE
->NATIVE {Printf} PROC
PROC Printf(format:/*CONST_STRPTR*/ ARRAY OF CHAR, format2=0:ULONG, ...) IS NATIVE {IDOS->Printf(} format {,} format2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {ParsePatternNoCase} PROC
PROC ParsePatternNoCase(pat:/*CONST_STRPTR*/ ARRAY OF CHAR, buf:/*STRPTR*/ ARRAY OF CHAR, buflen:VALUE) IS NATIVE {IDOS->ParsePatternNoCase(} pat {,} buf {,} buflen {)} ENDNATIVE !!VALUE
->NATIVE {MatchPatternNoCase} PROC
PROC MatchPatternNoCase(pat:/*CONST_STRPTR*/ ARRAY OF CHAR, str:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-(BOOLEAN)(0!=IDOS->MatchPatternNoCase(} pat {,} str {))} ENDNATIVE !!BOOL
->NATIVE {PRIVATEDosGetString} PROC
->PROC PrIVATEDosGetString(num:VALUE) IS NATIVE {IDOS->PRIVATEDosGetString(} num {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {SameDevice} PROC
PROC SameDevice(lock1:BPTR, lock2:BPTR) IS NATIVE {-(BOOLEAN)(0!=IDOS->SameDevice(} lock1 {,} lock2 {))} ENDNATIVE !!BOOL
->NATIVE {ExAllEnd} PROC
PROC ExAllEnd(lock:BPTR, buffer:PTR TO exalldata, size:VALUE, data:VALUE, control:PTR TO exallcontrol) IS NATIVE {IDOS->ExAllEnd(} lock {,} buffer {,} size {,} data {,} control {)} ENDNATIVE
->NATIVE {SetOwner} PROC
PROC SetOwner(name:/*CONST_STRPTR*/ ARRAY OF CHAR, owner_info:ULONG) IS NATIVE {-(BOOLEAN)(0!=IDOS->SetOwner(} name {,} owner_info {))} ENDNATIVE !!BOOL
->NATIVE {GetEntryData} PROC
PROC GetEntryData() IS NATIVE {IDOS->GetEntryData()} ENDNATIVE !!VALUE
->NATIVE {ReadLineItem} PROC
PROC ReadLineItem(buffer:/*STRPTR*/ ARRAY OF CHAR, maxchars:VALUE, taglist:ARRAY OF tagitem) IS NATIVE {IDOS->ReadLineItem(} buffer {,} maxchars {,} taglist {)} ENDNATIVE !!VALUE
->NATIVE {ReadLineItemTags} PROC
->PROC ReadLineItemTags(buffer:/*STRPTR*/ ARRAY OF CHAR, maxchars:VALUE, maxchars2=0:ULONG, ...) IS NATIVE {IDOS->ReadLineItemTags(} buffer {,} maxchars {,} maxchars2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {PRIVATEInternalRunCommand} PROC
->PROC PrIVATEInternalRunCommand(seg:BPTR, stksize:ULONG, args:/*CONST_STRPTR*/ ARRAY OF CHAR, arglen:VALUE) IS NATIVE {IDOS->PRIVATEInternalRunCommand(} seg {,} stksize {,} args {,} arglen {)} ENDNATIVE !!VALUE
->NATIVE {GetCurrentDir} PROC
PROC GetCurrentDir() IS NATIVE {IDOS->GetCurrentDir()} ENDNATIVE !!BPTR
->NATIVE {NonBlockingModifyDosEntry} PROC
PROC NonBlockingModifyDosEntry(dl:PTR TO doslist, mode:VALUE, arg1:APTR, arg2:APTR) IS NATIVE {IDOS->NonBlockingModifyDosEntry(} dl {,} mode {,} arg1 {,} arg2 {)} ENDNATIVE !!VALUE
->NATIVE {SecondsToDateStamp} PROC
PROC SecondsToDateStamp(seconds:ULONG, ds:PTR TO datestamp) IS NATIVE {IDOS->SecondsToDateStamp(} seconds {,} ds {)} ENDNATIVE !!PTR TO datestamp
->NATIVE {DateStampToSeconds} PROC
PROC DateStampToSeconds(ds:PTR TO datestamp) IS NATIVE {IDOS->DateStampToSeconds(} ds {)} ENDNATIVE !!ULONG
->NATIVE {FixDateStamp} PROC
PROC FixDateStamp(ds:PTR TO datestamp) IS NATIVE {IDOS->FixDateStamp(} ds {)} ENDNATIVE !!VALUE
->NATIVE {AddDates} PROC
PROC AddDates(to:PTR TO datestamp, from:PTR TO datestamp) IS NATIVE {IDOS->AddDates(} to {,} from {)} ENDNATIVE !!VALUE
->NATIVE {SubtractDates} PROC
PROC SubtractDates(to:PTR TO datestamp, from:PTR TO datestamp) IS NATIVE {IDOS->SubtractDates(} to {,} from {)} ENDNATIVE !!VALUE
->NATIVE {AddSegmentTagList} PROC
PROC AddSegmentTagList(name:/*CONST_STRPTR*/ ARRAY OF CHAR, type:VALUE, tags:ARRAY OF tagitem) IS NATIVE {IDOS->AddSegmentTagList(} name {,} type {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {ParseCapturePattern} PROC
PROC ParseCapturePattern(pat:/*CONST_STRPTR*/ ARRAY OF CHAR, dst:/*STRPTR*/ ARRAY OF CHAR, length:VALUE, casesen:VALUE) IS NATIVE {IDOS->ParseCapturePattern(} pat {,} dst {,} length {,} casesen {)} ENDNATIVE !!VALUE
->NATIVE {CapturePattern} PROC
PROC CapturePattern(pat:/*CONST_STRPTR*/ ARRAY OF CHAR, str:/*CONST_STRPTR*/ ARRAY OF CHAR, casesen:VALUE, cap:PTR TO PTR /*TO capturedexpression*/) IS NATIVE {IDOS->CapturePattern(} pat {,} str {,} casesen {, (CapturedExpression ** ) } cap {)} ENDNATIVE !!VALUE
->NATIVE {ReleaseCapturedExpressions} PROC
PROC ReleaseCapturedExpressions(first:PTR TO capturedexpression) IS NATIVE {IDOS->ReleaseCapturedExpressions(} first {)} ENDNATIVE
->NATIVE {FindTrackedAddress} PROC
PROC FindTrackedAddress(address:CONST_APTR, hook:PTR TO hook) IS NATIVE {IDOS->FindTrackedAddress(} address {,} hook {)} ENDNATIVE
->NATIVE {TrackAddressList} PROC
PROC TrackAddressList(name:/*CONST_STRPTR*/ ARRAY OF CHAR, segment:BPTR, extra_info:CONST_APTR, extra_info_size:VALUE, aas:PTR TO addressandsize, num_pairs:VALUE) IS NATIVE {IDOS->TrackAddressList(} name {,} segment {,} extra_info {,} extra_info_size {,} aas {,} num_pairs {)} ENDNATIVE !!VALUE
->NATIVE {TrackSegmentList} PROC
PROC TrackSegmentList(name:/*CONST_STRPTR*/ ARRAY OF CHAR, segment:BPTR, extra_info:CONST_APTR, extra_info_size:VALUE) IS NATIVE {IDOS->TrackSegmentList(} name {,} segment {,} extra_info {,} extra_info_size {)} ENDNATIVE !!VALUE
->NATIVE {UnTrackAddress} PROC
PROC UnTrackAddress(address:APTR) IS NATIVE {IDOS->UnTrackAddress(} address {)} ENDNATIVE
->NATIVE {UnTrackSegmentList} PROC
PROC UnTrackSegmentList(segment:BPTR) IS NATIVE {IDOS->UnTrackSegmentList(} segment {)} ENDNATIVE
->NATIVE {GetExitData} PROC
PROC GetExitData() IS NATIVE {IDOS->GetExitData()} ENDNATIVE !!VALUE
->NATIVE {PutErrStr} PROC
PROC PutErrStr(str:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->PutErrStr(} str {)} ENDNATIVE !!VALUE
->NATIVE {ErrorOutput} PROC
PROC ErrorOutput() IS NATIVE {IDOS->ErrorOutput()} ENDNATIVE !!BPTR
->NATIVE {SelectErrorOutput} PROC
PROC SelectErrorOutput(fh:BPTR) IS NATIVE {IDOS->SelectErrorOutput(} fh {)} ENDNATIVE !!BPTR
->NATIVE {MountDevice} PROC
PROC MountDevice(name:/*CONST_STRPTR*/ ARRAY OF CHAR, type:VALUE, tags:ARRAY OF tagitem) IS NATIVE {IDOS->MountDevice(} name {,} type {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {MountDeviceTags} PROC
->PROC MountDeviceTags(name:/*CONST_STRPTR*/ ARRAY OF CHAR, type:VALUE, type2=0:ULONG, ...) IS NATIVE {IDOS->MountDeviceTags(} name {,} type {,} type2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {SetProcWindow} PROC
PROC SetProcWindow(win:CONST_APTR) IS NATIVE {IDOS->SetProcWindow(} win {)} ENDNATIVE !!APTR
->NATIVE {FindSegmentStackSize} PROC
PROC FindSegmentStackSize(segment:BPTR) IS NATIVE {IDOS->FindSegmentStackSize(} segment {)} ENDNATIVE !!ULONG
->NATIVE {CalculateSegmentChecksum} PROC
PROC CalculateSegmentChecksum(segment:BPTR) IS NATIVE {IDOS->CalculateSegmentChecksum(} segment {)} ENDNATIVE !!ULONG
->NATIVE {AllocSegList} PROC
PROC AllocSegList(entry:CONST_APTR, data:CONST_APTR, datalen:ULONG, identkey:ULONG) IS NATIVE {IDOS->AllocSegList(} entry {,} data {,} datalen {,} identkey {)} ENDNATIVE !!BPTR
->NATIVE {GetSegListInfo} PROC
PROC GetSegListInfo(seglist:BPTR, tags:ARRAY OF tagitem) IS NATIVE {IDOS->GetSegListInfo(} seglist {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {GetSegListInfoTags} PROC
->PROC GetSegListInfoTags(seglist:BPTR, seglist2=0:ULONG, ...) IS NATIVE {IDOS->GetSegListInfoTags(} seglist {,} seglist2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {AddSegListTail} PROC
PROC AddSegListTail(bseglist_head:BPTR, bseg_new:BPTR) IS NATIVE {IDOS->AddSegListTail(} bseglist_head {,} bseg_new {)} ENDNATIVE !!VALUE
->NATIVE {DevNameFromLock} PROC
PROC DevNameFromLock(lock:BPTR, buffer:/*STRPTR*/ ARRAY OF CHAR, buflen:VALUE, mode:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->DevNameFromLock(} lock {,} buffer {,} buflen {,} mode {))} ENDNATIVE !!BOOL
->NATIVE {GetProcMsgPort} PROC
PROC GetProcMsgPort(proc:PTR TO process) IS NATIVE {IDOS->GetProcMsgPort(} proc {)} ENDNATIVE !!PTR TO mp
->NATIVE {WaitForData} PROC
PROC WaitForData(stream:BPTR, data_direction:VALUE, timeout:VALUE) IS NATIVE {IDOS->WaitForData(} stream {,} data_direction {,} timeout {)} ENDNATIVE !!VALUE
->NATIVE {SetBlockingMode} PROC
PROC SetBlockingMode(stream:BPTR, new_blocking_mode:VALUE) IS NATIVE {IDOS->SetBlockingMode(} stream {,} new_blocking_mode {)} ENDNATIVE !!VALUE
->NATIVE {SetCurrentCmdPathList} PROC
PROC SetCurrentCmdPathList(pn:PTR TO pathnode) IS NATIVE {IDOS->SetCurrentCmdPathList(} pn {)} ENDNATIVE !!PTR TO pathnode
->NATIVE {AllocateCmdPathList} PROC
PROC AllocateCmdPathList(first_lock:BPTR) IS NATIVE {IDOS->AllocateCmdPathList(} first_lock {)} ENDNATIVE !!PTR TO pathnode
->NATIVE {FreeCmdPathList} PROC
PROC FreeCmdPathList(pn:PTR TO pathnode) IS NATIVE {IDOS->FreeCmdPathList(} pn {)} ENDNATIVE
->NATIVE {RemoveCmdPathNode} PROC
PROC RemoveCmdPathNode(pn:PTR TO pathnode, lock:BPTR) IS NATIVE {IDOS->RemoveCmdPathNode(} pn {,} lock {)} ENDNATIVE !!PTR TO pathnode
->NATIVE {AddCmdPathNode} PROC
PROC AddCmdPathNode(pn:PTR TO pathnode, lock:BPTR, where:VALUE) IS NATIVE {IDOS->AddCmdPathNode(} pn {,} lock {,} where {)} ENDNATIVE !!PTR TO pathnode
->NATIVE {SearchCmdPathList} PROC
PROC SearchCmdPathList(pn:PTR TO pathnode, h:PTR TO hook, name:/*CONST_STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {IDOS->SearchCmdPathList(} pn {,} h {,} name {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {SearchCmdPathListTags} PROC
->PROC SearchCmdPathListTags(pn:PTR TO pathnode, h:PTR TO hook, name:/*CONST_STRPTR*/ ARRAY OF CHAR, name2=0:ULONG, ...) IS NATIVE {IDOS->SearchCmdPathListTags(} pn {,} h {,} name {,} name2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {ScanVars} PROC
PROC ScanVars(hook:PTR TO hook, flags:ULONG, userdata:CONST_APTR) IS NATIVE {IDOS->ScanVars(} hook {,} flags {,} userdata {)} ENDNATIVE !!VALUE
->NATIVE {GetProcSegList} PROC
PROC GetProcSegList(proc:PTR TO process, flags:ULONG) IS NATIVE {IDOS->GetProcSegList(} proc {,} flags {)} ENDNATIVE !!BPTR
->NATIVE {HexToLong} PROC
PROC HexToLong(string:/*CONST_STRPTR*/ ARRAY OF CHAR, value_ptr:PTR TO ULONG) IS NATIVE {IDOS->HexToLong(} string {,} value_ptr {)} ENDNATIVE !!VALUE
->NATIVE {GetDeviceProcFlags} PROC
PROC GetDeviceProcFlags(name:/*CONST_STRPTR*/ ARRAY OF CHAR, odp:PTR TO devproc, flags:ULONG) IS NATIVE {IDOS->GetDeviceProcFlags(} name {,} odp {,} flags {)} ENDNATIVE !!PTR TO devproc
->NATIVE {DosControl} PROC
PROC DosControl(tags:ARRAY OF tagitem) IS NATIVE {IDOS->DosControl(} tags {)} ENDNATIVE !!VALUE
->NATIVE {DosControlTags} PROC
->PROC DosControlTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {IDOS->DosControlTags(} param {,} param2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {CreateDirTree} PROC
PROC CreateDirTree(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->CreateDirTree(} name {)} ENDNATIVE !!BPTR
->NATIVE {NotifyVar} PROC
PROC NotifyVar(name:/*CONST_STRPTR*/ ARRAY OF CHAR, hook:PTR TO hook, flags:VALUE, userdata:CONST_APTR) IS NATIVE {IDOS->NotifyVar(} name {,} hook {,} flags {,} userdata {)} ENDNATIVE !!VALUE
->NATIVE {GetDiskFileSystemData} PROC
PROC GetDiskFileSystemData(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->GetDiskFileSystemData(} name {)} ENDNATIVE !!PTR TO filesystemdata
->NATIVE {FreeDiskFileSystemData} PROC
PROC FreeDiskFileSystemData(fsd:PTR TO filesystemdata) IS NATIVE {IDOS->FreeDiskFileSystemData(} fsd {)} ENDNATIVE
->NATIVE {FOpen} PROC
PROC Fopen(name:/*CONST_STRPTR*/ ARRAY OF CHAR, mode:VALUE, bufsize:VALUE) IS NATIVE {IDOS->FOpen(} name {,} mode {,} bufsize {)} ENDNATIVE !!BPTR
->NATIVE {FClose} PROC
PROC Fclose(scb:BPTR) IS NATIVE {IDOS->FClose(} scb {)} ENDNATIVE !!VALUE
->NATIVE {FOpenFromLock} PROC
PROC FopenFromLock(lock:BPTR, bufsize:VALUE) IS NATIVE {IDOS->FOpenFromLock(} lock {,} bufsize {)} ENDNATIVE !!BPTR
->NATIVE {TimedDosRequester} PROC
PROC TimedDosRequester(tags:ARRAY OF tagitem) IS NATIVE {IDOS->TimedDosRequester(} tags {)} ENDNATIVE !!VALUE
->NATIVE {TimedDosRequesterTags} PROC
->PROC TimedDosRequesterTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {IDOS->TimedDosRequesterTags(} param {,} param2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {RenameDosEntry} PROC
PROC RenameDosEntry(dlist:PTR TO doslist, newname:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->RenameDosEntry(} dlist {,} newname {)} ENDNATIVE !!VALUE
->NATIVE {DismountDevice} PROC
PROC DismountDevice(name:/*CONST_STRPTR*/ ARRAY OF CHAR, flags:ULONG, reserved:APTR) IS NATIVE {IDOS->DismountDevice(} name {,} flags {,} reserved {)} ENDNATIVE !!VALUE
->NATIVE {DupFileHandle} PROC
PROC DupFileHandle(scb:BPTR) IS NATIVE {IDOS->DupFileHandle(} scb {)} ENDNATIVE !!BPTR
->NATIVE {DevNameFromFH} PROC
PROC DevNameFromFH(scb:BPTR, buffer:/*STRPTR*/ ARRAY OF CHAR, buflen:VALUE, mode:VALUE) IS NATIVE {-(BOOLEAN)(0!=IDOS->DevNameFromFH(} scb {,} buffer {,} buflen {,} mode {))} ENDNATIVE !!BOOL
->NATIVE {AssignAddToList} PROC
PROC AssignAddToList(name:/*CONST_STRPTR*/ ARRAY OF CHAR, lock:BPTR, endpos:VALUE) IS NATIVE {IDOS->AssignAddToList(} name {,} lock {,} endpos {)} ENDNATIVE !!VALUE
->NATIVE {SetFileHandleAttr} PROC
PROC SetFileHandleAttr(fh:BPTR, tags:ARRAY OF tagitem) IS NATIVE {IDOS->SetFileHandleAttr(} fh {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {SetFileHandleAttrTags} PROC
->PROC SetFileHandleAttrTags(fh:BPTR, fh2=0:ULONG, ...) IS NATIVE {IDOS->SetFileHandleAttrTags(} fh {,} fh2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {FileSystemAttr} PROC
PROC FileSystemAttr(tags:ARRAY OF tagitem) IS NATIVE {IDOS->FileSystemAttr(} tags {)} ENDNATIVE !!VALUE
->NATIVE {FileSystemAttrTags} PROC
->PROC FileSystemAttrTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {IDOS->FileSystemAttrTags(} param {,} param2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {FReadLine} PROC
PROC FreadLine(fh:BPTR, frld:PTR TO freadlinedata) IS NATIVE {IDOS->FReadLine(} fh {,} frld {)} ENDNATIVE !!VALUE
->NATIVE {CopyStringBSTRToC} PROC
PROC CopyStringBSTRToC(bsrc:BSTR, dst:/*STRPTR*/ ARRAY OF CHAR, siz:ULONG) IS NATIVE {IDOS->CopyStringBSTRToC(} bsrc {,} dst {,} siz {)} ENDNATIVE !!ULONG
->NATIVE {CopyStringCToBSTR} PROC
PROC CopyStringCToBSTR(src:/*CONST_STRPTR*/ ARRAY OF CHAR, bdest:BSTR, siz:ULONG) IS NATIVE {IDOS->CopyStringCToBSTR(} src {,} bdest {,} siz {)} ENDNATIVE !!ULONG
->NATIVE {GetFilePosition} PROC
PROC GetFilePosition(fh:BPTR) IS NATIVE {IDOS->GetFilePosition(} fh {)} ENDNATIVE !!BIGVALUE
->NATIVE {ChangeFilePosition} PROC
PROC ChangeFilePosition(file:BPTR, position:BIGVALUE, offset:VALUE) IS NATIVE {IDOS->ChangeFilePosition(} file {,} position {,} offset {)} ENDNATIVE !!VALUE
->NATIVE {ChangeFileSize} PROC
PROC ChangeFileSize(fh:BPTR, pos:BIGVALUE, mode:VALUE) IS NATIVE {IDOS->ChangeFileSize(} fh {,} pos {,} mode {)} ENDNATIVE !!VALUE
->NATIVE {GetFileSize} PROC
PROC GetFileSize(fh:BPTR) IS NATIVE {IDOS->GetFileSize(} fh {)} ENDNATIVE !!BIGVALUE
->NATIVE {PRIVATEDoPkt64} PROC
PROC PrIVATEDoPkt64(sendport:PTR TO mp, type:VALUE, arg1:VALUE, arg2:BIGVALUE, arg3:VALUE, arg4:VALUE, arg5:BIGVALUE) IS NATIVE {IDOS->PRIVATEDoPkt64(} sendport {,} type {,} arg1 {,} arg2 {,} arg3 {,} arg4 {,} arg5 {)} ENDNATIVE !!BIGVALUE
->NATIVE {ProcessScan} PROC
PROC ProcessScan(hook:PTR TO hook, userdata:CONST_APTR, reserved:ULONG) IS NATIVE {IDOS->ProcessScan(} hook {,} userdata {,} reserved {)} ENDNATIVE !!VALUE
->NATIVE {NotifyDosListChange} PROC
PROC NotifyDosListChange(process:PTR TO process, signalnum:ULONG, reserved:ULONG) IS NATIVE {IDOS->NotifyDosListChange(} process {,} signalnum {,} reserved {)} ENDNATIVE !!VALUE
->NATIVE {NotifyProcListChange} PROC
PROC NotifyProcListChange(process:PTR TO process, signalnum:ULONG, reserved:ULONG) IS NATIVE {IDOS->NotifyProcListChange(} process {,} signalnum {,} reserved {)} ENDNATIVE !!VALUE
->NATIVE {GetDiskInfo} PROC
PROC GetDiskInfo(tags:ARRAY OF tagitem) IS NATIVE {IDOS->GetDiskInfo(} tags {)} ENDNATIVE !!VALUE
->NATIVE {GetDiskInfoTags} PROC
->PROC GetDiskInfoTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {IDOS->GetDiskInfoTags(} param {,} param2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {WriteProtectVolume} PROC
PROC WriteProtectVolume(name:/*CONST_STRPTR*/ ARRAY OF CHAR, on_off:VALUE, passkey:ULONG, reserved:VALUE) IS NATIVE {IDOS->WriteProtectVolume(} name {,} on_off {,} passkey {,} reserved {)} ENDNATIVE !!VALUE
->NATIVE {ExamineObject} PROC
PROC ExamineObject(ctags:ARRAY OF tagitem) IS NATIVE {IDOS->ExamineObject(} ctags {)} ENDNATIVE !!PTR TO examinedata
->NATIVE {ExamineObjectTags} PROC
->PROC ExamineObjectTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {IDOS->ExamineObjectTags(} param {,} param2 {,} ... {)} ENDNATIVE !!PTR TO examinedata
->NATIVE {ExamineDir} PROC
PROC ExamineDir(context:APTR) IS NATIVE {IDOS->ExamineDir(} context {)} ENDNATIVE !!PTR TO examinedata
->NATIVE {ObtainDirContext} PROC
PROC ObtainDirContext(ctags:ARRAY OF tagitem) IS NATIVE {IDOS->ObtainDirContext(} ctags {)} ENDNATIVE !!APTR
->NATIVE {ObtainDirContextTags} PROC
->PROC ObtainDirContextTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {IDOS->ObtainDirContextTags(} param {,} param2 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {ReleaseDirContext} PROC
PROC ReleaseDirContext(contx:APTR) IS NATIVE {IDOS->ReleaseDirContext(} contx {)} ENDNATIVE
->NATIVE {GetOwnerInfo} PROC
PROC GetOwnerInfo(tags:ARRAY OF tagitem) IS NATIVE {IDOS->GetOwnerInfo(} tags {)} ENDNATIVE !!VALUE
->NATIVE {GetOwnerInfoTags} PROC
->PROC GetOwnerInfoTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {IDOS->GetOwnerInfoTags(} param {,} param2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {SetOwnerInfo} PROC
PROC SetOwnerInfo(tags:ARRAY OF tagitem) IS NATIVE {IDOS->SetOwnerInfo(} tags {)} ENDNATIVE !!VALUE
->NATIVE {SetOwnerInfoTags} PROC
->PROC SetOwnerInfoTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {IDOS->SetOwnerInfoTags(} param {,} param2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {LockTagList} PROC
PROC LockTagList(tags:ARRAY OF tagitem) IS NATIVE {IDOS->LockTagList(} tags {)} ENDNATIVE !!BPTR
->NATIVE {LockTags} PROC
->PROC LockTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {IDOS->LockTags(} param {,} param2 {,} ... {)} ENDNATIVE !!BPTR
->NATIVE {GetPID} PROC
PROC GetPID(process:PTR TO process, which:VALUE) IS NATIVE {IDOS->GetPID(} process {,} which {)} ENDNATIVE !!ULONG
->NATIVE {FlushVolume} PROC
PROC FlushVolume(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->FlushVolume(} name {)} ENDNATIVE !!VALUE
->NATIVE {ObtainConsoleData} PROC
PROC ObtainConsoleData(ctags:ARRAY OF tagitem) IS NATIVE {IDOS->ObtainConsoleData(} ctags {)} ENDNATIVE !!PTR TO consolewindowdata
->NATIVE {ObtainConsoleDataTags} PROC
->PROC ObtainConsoleDataTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {IDOS->ObtainConsoleDataTags(} param {,} param2 {,} ... {)} ENDNATIVE !!PTR TO consolewindowdata
->NATIVE {ReleaseConsoleData} PROC
PROC ReleaseConsoleData(data:PTR TO consolewindowdata) IS NATIVE {IDOS->ReleaseConsoleData(} data {)} ENDNATIVE
->NATIVE {Serialize} PROC
PROC Serialize(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDOS->Serialize(} name {)} ENDNATIVE !!VALUE
->NATIVE {NameFromPort} PROC
PROC NameFromPort(port:PTR TO mp, buffer:/*STRPTR*/ ARRAY OF CHAR, buflen:VALUE, add_colon:VALUE) IS NATIVE {IDOS->NameFromPort(} port {,} buffer {,} buflen {,} add_colon {)} ENDNATIVE !!VALUE
->NATIVE {DevNameFromPort} PROC
PROC DevNameFromPort(port:PTR TO mp, buffer:/*STRPTR*/ ARRAY OF CHAR, buflen:VALUE, add_colon:VALUE) IS NATIVE {IDOS->DevNameFromPort(} port {,} buffer {,} buflen {,} add_colon {)} ENDNATIVE !!VALUE
->NATIVE {SameFH} PROC
PROC SameFH(scb1:BPTR, scb2:BPTR) IS NATIVE {IDOS->SameFH(} scb1 {,} scb2 {)} ENDNATIVE !!VALUE
->NATIVE {LockRecord} PROC
PROC LockRecord(fh:BPTR, offset:BIGVALUE, length:BIGVALUE, mode:ULONG, timeout:ULONG) IS NATIVE {IDOS->LockRecord(} fh {,} offset {,} length {,} mode {,} timeout {)} ENDNATIVE !!VALUE
->NATIVE {UnLockRecord} PROC
PROC UnLockRecord(fh:BPTR, offset:BIGVALUE, length:BIGVALUE) IS NATIVE {IDOS->UnLockRecord(} fh {,} offset {,} length {)} ENDNATIVE !!VALUE
->NATIVE {IsFileSystemPort} PROC
PROC IsFileSystemPort(port:PTR TO mp) IS NATIVE {IDOS->IsFileSystemPort(} port {)} ENDNATIVE !!VALUE
->NATIVE {InhibitPort} PROC
PROC InhibitPort(port:PTR TO mp, state:VALUE) IS NATIVE {IDOS->InhibitPort(} port {,} state {)} ENDNATIVE !!VALUE
->NATIVE {FormatPort} PROC
PROC FormatPort(port:PTR TO mp, volumename:/*CONST_STRPTR*/ ARRAY OF CHAR, dostype:ULONG, flags:ULONG) IS NATIVE {IDOS->FormatPort(} port {,} volumename {,} dostype {,} flags {)} ENDNATIVE !!VALUE
->NATIVE {SerializePort} PROC
PROC SerializePort(port:PTR TO mp) IS NATIVE {IDOS->SerializePort(} port {)} ENDNATIVE !!VALUE
->NATIVE {FlushVolumePort} PROC
PROC FlushVolumePort(port:PTR TO mp) IS NATIVE {IDOS->FlushVolumePort(} port {)} ENDNATIVE !!VALUE
->NATIVE {FileHandleScan} PROC
PROC FileHandleScan(hook:PTR TO hook, userdata:CONST_APTR, reserved:ULONG) IS NATIVE {IDOS->FileHandleScan(} hook {,} userdata {,} reserved {)} ENDNATIVE !!VALUE
->NATIVE {GetFileSystemVectorPort} PROC
PROC GetFileSystemVectorPort(port:PTR TO mp, min_version:ULONG) IS NATIVE {IDOS->GetFileSystemVectorPort(} port {,} min_version {)} ENDNATIVE !!PTR TO filesystemvectorport
->NATIVE {ResolvePath} PROC
PROC ResolvePath(port:PTR TO mp, path:/*CONST_STRPTR*/ ARRAY OF CHAR, inlock:BPTR, out:/*STRPTR*/ ARRAY OF CHAR, outlen:ULONG, outdir:PTR TO BPTR, slcount:PTR TO ULONG) IS NATIVE {IDOS->ResolvePath(} port {,} path {,} inlock {,} out {,} outlen {,} outdir {,} slcount {)} ENDNATIVE !!VALUE
->NATIVE {WriteProtectVolumePort} PROC
PROC WriteProtectVolumePort(port:PTR TO mp, on_off:VALUE, passkey:ULONG, reserved:VALUE) IS NATIVE {IDOS->WriteProtectVolumePort(} port {,} on_off {,} passkey {,} reserved {)} ENDNATIVE !!VALUE
->NATIVE {AsyncIO} PROC
PROC AsyncIO(tags:ARRAY OF tagitem) IS NATIVE {-(BOOLEAN)(0!=IDOS->AsyncIO(} tags {))} ENDNATIVE !!BOOL
->NATIVE {AsyncIOTags} PROC
PROC AsyncIOTags(param:VALUE, param2=0:ULONG, ...) IS NATIVE {-(BOOLEAN)(0!=IDOS->AsyncIOTags(} param {,} param2 {,} ... {))} ENDNATIVE !!BOOL
->NATIVE {WaitForChildExit} PROC
PROC WaitForChildExit(pid:ULONG) IS NATIVE {-(BOOLEAN)(0!=IDOS->WaitForChildExit(} pid {))} ENDNATIVE !!BOOL
->NATIVE {CheckForChildExit} PROC
PROC CheckForChildExit(pid:ULONG) IS NATIVE {-(BOOLEAN)(0!=IDOS->CheckForChildExit(} pid {))} ENDNATIVE !!BOOL
