#ifndef _INLINE_DOS_H
#define _INLINE_DOS_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef DOS_BASE_NAME
#define DOS_BASE_NAME DOSBase
#endif

#define Open(name, accessMode) \
	LP2(0x1e, BPTR, Open, CONST_STRPTR, name, d1, LONG, accessMode, d2, \
	, DOS_BASE_NAME)

#define Close(file) \
	LP1(0x24, LONG, Close, BPTR, file, d1, \
	, DOS_BASE_NAME)

#define Read(file, buffer, length) \
	LP3(0x2a, LONG, Read, BPTR, file, d1, APTR, buffer, d2, LONG, length, d3, \
	, DOS_BASE_NAME)

#define Write(file, buffer, length) \
	LP3(0x30, LONG, Write, BPTR, file, d1, const APTR, buffer, d2, LONG, length, d3, \
	, DOS_BASE_NAME)

#define Input() \
	LP0(0x36, BPTR, Input, \
	, DOS_BASE_NAME)

#define Output() \
	LP0(0x3c, BPTR, Output, \
	, DOS_BASE_NAME)

#define Seek(file, position, offset) \
	LP3(0x42, LONG, Seek, BPTR, file, d1, LONG, position, d2, LONG, offset, d3, \
	, DOS_BASE_NAME)

#define DeleteFile(name) \
	LP1(0x48, LONG, DeleteFile, CONST_STRPTR, name, d1, \
	, DOS_BASE_NAME)

#define Rename(oldName, newName) \
	LP2(0x4e, LONG, Rename, CONST_STRPTR, oldName, d1, CONST_STRPTR, newName, d2, \
	, DOS_BASE_NAME)

#define Lock(name, type) \
	LP2(0x54, BPTR, Lock, CONST_STRPTR, name, d1, LONG, type, d2, \
	, DOS_BASE_NAME)

#define UnLock(lock) \
	LP1NR(0x5a, UnLock, BPTR, lock, d1, \
	, DOS_BASE_NAME)

#define DupLock(lock) \
	LP1(0x60, BPTR, DupLock, BPTR, lock, d1, \
	, DOS_BASE_NAME)

#define Examine(lock, fileInfoBlock) \
	LP2(0x66, LONG, Examine, BPTR, lock, d1, struct FileInfoBlock *, fileInfoBlock, d2, \
	, DOS_BASE_NAME)

#define ExNext(lock, fileInfoBlock) \
	LP2(0x6c, LONG, ExNext, BPTR, lock, d1, struct FileInfoBlock *, fileInfoBlock, d2, \
	, DOS_BASE_NAME)

#define Info(lock, parameterBlock) \
	LP2(0x72, LONG, Info, BPTR, lock, d1, struct InfoData *, parameterBlock, d2, \
	, DOS_BASE_NAME)

#define CreateDir(name) \
	LP1(0x78, BPTR, CreateDir, CONST_STRPTR, name, d1, \
	, DOS_BASE_NAME)

#define CurrentDir(lock) \
	LP1(0x7e, BPTR, CurrentDir, BPTR, lock, d1, \
	, DOS_BASE_NAME)

#define IoErr() \
	LP0(0x84, LONG, IoErr, \
	, DOS_BASE_NAME)

#define CreateProc(name, pri, segList, stackSize) \
	LP4(0x8a, struct MsgPort *, CreateProc, CONST_STRPTR, name, d1, LONG, pri, d2, BPTR, segList, d3, LONG, stackSize, d4, \
	, DOS_BASE_NAME)

#define Exit(returnCode) \
	LP1NR(0x90, Exit, LONG, returnCode, d1, \
	, DOS_BASE_NAME)

#define LoadSeg(name) \
	LP1(0x96, BPTR, LoadSeg, CONST_STRPTR, name, d1, \
	, DOS_BASE_NAME)

#define UnLoadSeg(seglist) \
	LP1NR(0x9c, UnLoadSeg, BPTR, seglist, d1, \
	, DOS_BASE_NAME)

#define DeviceProc(name) \
	LP1(0xae, struct MsgPort *, DeviceProc, CONST_STRPTR, name, d1, \
	, DOS_BASE_NAME)

#define SetComment(name, comment) \
	LP2(0xb4, LONG, SetComment, CONST_STRPTR, name, d1, CONST_STRPTR, comment, d2, \
	, DOS_BASE_NAME)

#define SetProtection(name, protect) \
	LP2(0xba, LONG, SetProtection, CONST_STRPTR, name, d1, LONG, protect, d2, \
	, DOS_BASE_NAME)

#define DateStamp(date) \
	LP1(0xc0, struct DateStamp *, DateStamp, struct DateStamp *, date, d1, \
	, DOS_BASE_NAME)

#define Delay(timeout) \
	LP1NR(0xc6, Delay, LONG, timeout, d1, \
	, DOS_BASE_NAME)

#define WaitForChar(file, timeout) \
	LP2(0xcc, LONG, WaitForChar, BPTR, file, d1, LONG, timeout, d2, \
	, DOS_BASE_NAME)

#define ParentDir(lock) \
	LP1(0xd2, BPTR, ParentDir, BPTR, lock, d1, \
	, DOS_BASE_NAME)

#define IsInteractive(file) \
	LP1(0xd8, LONG, IsInteractive, BPTR, file, d1, \
	, DOS_BASE_NAME)

#define Execute(string, file, file2) \
	LP3(0xde, LONG, Execute, CONST_STRPTR, string, d1, BPTR, file, d2, BPTR, file2, d3, \
	, DOS_BASE_NAME)

#define AllocDosObject(type, tags) \
	LP2(0xe4, APTR, AllocDosObject, ULONG, type, d1, const struct TagItem *, tags, d2, \
	, DOS_BASE_NAME)

#define AllocDosObjectTagList(type, tags) AllocDosObject((type), (tags))

#ifndef NO_INLINE_STDARG
#define AllocDosObjectTags(type, tags...) \
	({ULONG _tags[] = {tags}; AllocDosObject((type), (const struct TagItem *) _tags);})
#endif

#define FreeDosObject(type, ptr) \
	LP2NR(0xea, FreeDosObject, ULONG, type, d1, APTR, ptr, d2, \
	, DOS_BASE_NAME)

#define DoPkt(port, action, arg1, arg2, arg3, arg4, arg5) \
	LP7(0xf0, LONG, DoPkt, struct MsgPort *, port, d1, LONG, action, d2, LONG, arg1, d3, LONG, arg2, d4, LONG, arg3, d5, LONG, arg4, d6, LONG, arg5, d7, \
	, DOS_BASE_NAME)

#define DoPkt0(port, action) \
	LP2(0xf0, LONG, DoPkt0, struct MsgPort *, port, d1, LONG, action, d2, \
	, DOS_BASE_NAME)

#define DoPkt1(port, action, arg1) \
	LP3(0xf0, LONG, DoPkt1, struct MsgPort *, port, d1, LONG, action, d2, LONG, arg1, d3, \
	, DOS_BASE_NAME)

#define DoPkt2(port, action, arg1, arg2) \
	LP4(0xf0, LONG, DoPkt2, struct MsgPort *, port, d1, LONG, action, d2, LONG, arg1, d3, LONG, arg2, d4, \
	, DOS_BASE_NAME)

#define DoPkt3(port, action, arg1, arg2, arg3) \
	LP5(0xf0, LONG, DoPkt3, struct MsgPort *, port, d1, LONG, action, d2, LONG, arg1, d3, LONG, arg2, d4, LONG, arg3, d5, \
	, DOS_BASE_NAME)

#define DoPkt4(port, action, arg1, arg2, arg3, arg4) \
	LP6(0xf0, LONG, DoPkt4, struct MsgPort *, port, d1, LONG, action, d2, LONG, arg1, d3, LONG, arg2, d4, LONG, arg3, d5, LONG, arg4, d6, \
	, DOS_BASE_NAME)

#define SendPkt(dp, port, replyport) \
	LP3NR(0xf6, SendPkt, struct DosPacket *, dp, d1, struct MsgPort *, port, d2, struct MsgPort *, replyport, d3, \
	, DOS_BASE_NAME)

#define WaitPkt() \
	LP0(0xfc, struct DosPacket *, WaitPkt, \
	, DOS_BASE_NAME)

#define ReplyPkt(dp, res1, res2) \
	LP3NR(0x102, ReplyPkt, struct DosPacket *, dp, d1, LONG, res1, d2, LONG, res2, d3, \
	, DOS_BASE_NAME)

#define AbortPkt(port, pkt) \
	LP2NR(0x108, AbortPkt, struct MsgPort *, port, d1, struct DosPacket *, pkt, d2, \
	, DOS_BASE_NAME)

#define LockRecord(fh, offset, length, mode, timeout) \
	LP5(0x10e, BOOL, LockRecord, BPTR, fh, d1, ULONG, offset, d2, ULONG, length, d3, ULONG, mode, d4, ULONG, timeout, d5, \
	, DOS_BASE_NAME)

#define LockRecords(recArray, timeout) \
	LP2(0x114, BOOL, LockRecords, struct RecordLock *, recArray, d1, ULONG, timeout, d2, \
	, DOS_BASE_NAME)

#define UnLockRecord(fh, offset, length) \
	LP3(0x11a, BOOL, UnLockRecord, BPTR, fh, d1, ULONG, offset, d2, ULONG, length, d3, \
	, DOS_BASE_NAME)

#define UnLockRecords(recArray) \
	LP1(0x120, BOOL, UnLockRecords, struct RecordLock *, recArray, d1, \
	, DOS_BASE_NAME)

#define SelectInput(fh) \
	LP1(0x126, BPTR, SelectInput, BPTR, fh, d1, \
	, DOS_BASE_NAME)

#define SelectOutput(fh) \
	LP1(0x12c, BPTR, SelectOutput, BPTR, fh, d1, \
	, DOS_BASE_NAME)

#define FGetC(fh) \
	LP1(0x132, LONG, FGetC, BPTR, fh, d1, \
	, DOS_BASE_NAME)

#define FPutC(fh, ch) \
	LP2(0x138, LONG, FPutC, BPTR, fh, d1, LONG, ch, d2, \
	, DOS_BASE_NAME)

#define UnGetC(fh, character) \
	LP2(0x13e, LONG, UnGetC, BPTR, fh, d1, LONG, character, d2, \
	, DOS_BASE_NAME)

#define FRead(fh, block, blocklen, number) \
	LP4(0x144, LONG, FRead, BPTR, fh, d1, APTR, block, d2, ULONG, blocklen, d3, ULONG, number, d4, \
	, DOS_BASE_NAME)

#define FWrite(fh, block, blocklen, number) \
	LP4(0x14a, LONG, FWrite, BPTR, fh, d1, const APTR, block, d2, ULONG, blocklen, d3, ULONG, number, d4, \
	, DOS_BASE_NAME)

#define FGets(fh, buf, buflen) \
	LP3(0x150, STRPTR, FGets, BPTR, fh, d1, STRPTR, buf, d2, ULONG, buflen, d3, \
	, DOS_BASE_NAME)

#define FPuts(fh, str) \
	LP2(0x156, LONG, FPuts, BPTR, fh, d1, CONST_STRPTR, str, d2, \
	, DOS_BASE_NAME)

#define VFWritef(fh, format, argarray) \
	LP3NR(0x15c, VFWritef, BPTR, fh, d1, CONST_STRPTR, format, d2, const LONG *, argarray, d3, \
	, DOS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define FWritef(fh, format, tags...) \
	({ULONG _tags[] = {tags}; VFWritef((fh), (format), (const LONG *) _tags);})
#endif

#define VFPrintf(fh, format, argarray) \
	LP3(0x162, LONG, VFPrintf, BPTR, fh, d1, CONST_STRPTR, format, d2, const APTR, argarray, d3, \
	, DOS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define FPrintf(fh, format, tags...) \
	({ULONG _tags[] = {tags}; VFPrintf((fh), (format), (const APTR) _tags);})
#endif

#define Flush(fh) \
	LP1(0x168, LONG, Flush, BPTR, fh, d1, \
	, DOS_BASE_NAME)

#define SetVBuf(fh, buff, type, size) \
	LP4(0x16e, LONG, SetVBuf, BPTR, fh, d1, STRPTR, buff, d2, LONG, type, d3, LONG, size, d4, \
	, DOS_BASE_NAME)

#define DupLockFromFH(fh) \
	LP1(0x174, BPTR, DupLockFromFH, BPTR, fh, d1, \
	, DOS_BASE_NAME)

#define OpenFromLock(lock) \
	LP1(0x17a, BPTR, OpenFromLock, BPTR, lock, d1, \
	, DOS_BASE_NAME)

#define ParentOfFH(fh) \
	LP1(0x180, BPTR, ParentOfFH, BPTR, fh, d1, \
	, DOS_BASE_NAME)

#define ExamineFH(fh, fib) \
	LP2(0x186, BOOL, ExamineFH, BPTR, fh, d1, struct FileInfoBlock *, fib, d2, \
	, DOS_BASE_NAME)

#define SetFileDate(name, date) \
	LP2(0x18c, LONG, SetFileDate, CONST_STRPTR, name, d1, const struct DateStamp *, date, d2, \
	, DOS_BASE_NAME)

#define NameFromLock(lock, buffer, len) \
	LP3(0x192, LONG, NameFromLock, BPTR, lock, d1, STRPTR, buffer, d2, LONG, len, d3, \
	, DOS_BASE_NAME)

#define NameFromFH(fh, buffer, len) \
	LP3(0x198, LONG, NameFromFH, BPTR, fh, d1, STRPTR, buffer, d2, LONG, len, d3, \
	, DOS_BASE_NAME)

#define SplitName(name, separator, buf, oldpos, size) \
	LP5(0x19e, WORD, SplitName, CONST_STRPTR, name, d1, ULONG, separator, d2, STRPTR, buf, d3, LONG, oldpos, d4, LONG, size, d5, \
	, DOS_BASE_NAME)

#define SameLock(lock1, lock2) \
	LP2(0x1a4, LONG, SameLock, BPTR, lock1, d1, BPTR, lock2, d2, \
	, DOS_BASE_NAME)

#define SetMode(fh, mode) \
	LP2(0x1aa, LONG, SetMode, BPTR, fh, d1, LONG, mode, d2, \
	, DOS_BASE_NAME)

#define ExAll(lock, buffer, size, data, control) \
	LP5(0x1b0, LONG, ExAll, BPTR, lock, d1, struct ExAllData *, buffer, d2, LONG, size, d3, LONG, data, d4, struct ExAllControl *, control, d5, \
	, DOS_BASE_NAME)

#define ReadLink(port, lock, path, buffer, size) \
	LP5(0x1b6, LONG, ReadLink, struct MsgPort *, port, d1, BPTR, lock, d2, CONST_STRPTR, path, d3, STRPTR, buffer, d4, ULONG, size, d5, \
	, DOS_BASE_NAME)

#define MakeLink(name, dest, soft) \
	LP3(0x1bc, LONG, MakeLink, CONST_STRPTR, name, d1, LONG, dest, d2, LONG, soft, d3, \
	, DOS_BASE_NAME)

#define ChangeMode(type, fh, newmode) \
	LP3(0x1c2, LONG, ChangeMode, LONG, type, d1, BPTR, fh, d2, LONG, newmode, d3, \
	, DOS_BASE_NAME)

#define SetFileSize(fh, pos, mode) \
	LP3(0x1c8, LONG, SetFileSize, BPTR, fh, d1, LONG, pos, d2, LONG, mode, d3, \
	, DOS_BASE_NAME)

#define SetIoErr(result) \
	LP1(0x1ce, LONG, SetIoErr, LONG, result, d1, \
	, DOS_BASE_NAME)

#define Fault(code, header, buffer, len) \
	LP4(0x1d4, BOOL, Fault, LONG, code, d1, STRPTR, header, d2, STRPTR, buffer, d3, LONG, len, d4, \
	, DOS_BASE_NAME)

#define PrintFault(code, header) \
	LP2(0x1da, BOOL, PrintFault, LONG, code, d1, CONST_STRPTR, header, d2, \
	, DOS_BASE_NAME)

#define ErrorReport(code, type, arg1, device) \
	LP4(0x1e0, LONG, ErrorReport, LONG, code, d1, LONG, type, d2, ULONG, arg1, d3, struct MsgPort *, device, d4, \
	, DOS_BASE_NAME)

#define Cli() \
	LP0(0x1ec, struct CommandLineInterface *, Cli, \
	, DOS_BASE_NAME)

#define CreateNewProc(tags) \
	LP1(0x1f2, struct Process *, CreateNewProc, const struct TagItem *, tags, d1, \
	, DOS_BASE_NAME)

#define CreateNewProcTagList(tags) CreateNewProc((tags))

#ifndef NO_INLINE_STDARG
#define CreateNewProcTags(tags...) \
	({ULONG _tags[] = {tags}; CreateNewProc((const struct TagItem *) _tags);})
#endif

#define RunCommand(seg, stack, paramptr, paramlen) \
	LP4(0x1f8, LONG, RunCommand, BPTR, seg, d1, LONG, stack, d2, CONST_STRPTR, paramptr, d3, LONG, paramlen, d4, \
	, DOS_BASE_NAME)

#define GetConsoleTask() \
	LP0(0x1fe, struct MsgPort *, GetConsoleTask, \
	, DOS_BASE_NAME)

#define SetConsoleTask(task) \
	LP1(0x204, struct MsgPort *, SetConsoleTask, const struct MsgPort *, task, d1, \
	, DOS_BASE_NAME)

#define GetFileSysTask() \
	LP0(0x20a, struct MsgPort *, GetFileSysTask, \
	, DOS_BASE_NAME)

#define SetFileSysTask(task) \
	LP1(0x210, struct MsgPort *, SetFileSysTask, const struct MsgPort *, task, d1, \
	, DOS_BASE_NAME)

#define GetArgStr() \
	LP0(0x216, STRPTR, GetArgStr, \
	, DOS_BASE_NAME)

#define SetArgStr(string) \
	LP1(0x21c, BOOL, SetArgStr, CONST_STRPTR, string, d1, \
	, DOS_BASE_NAME)

#define FindCliProc(num) \
	LP1(0x222, struct Process *, FindCliProc, ULONG, num, d1, \
	, DOS_BASE_NAME)

#define MaxCli() \
	LP0(0x228, ULONG, MaxCli, \
	, DOS_BASE_NAME)

#define SetCurrentDirName(name) \
	LP1(0x22e, BOOL, SetCurrentDirName, CONST_STRPTR, name, d1, \
	, DOS_BASE_NAME)

#define GetCurrentDirName(buf, len) \
	LP2(0x234, BOOL, GetCurrentDirName, STRPTR, buf, d1, LONG, len, d2, \
	, DOS_BASE_NAME)

#define SetProgramName(name) \
	LP1(0x23a, BOOL, SetProgramName, CONST_STRPTR, name, d1, \
	, DOS_BASE_NAME)

#define GetProgramName(buf, len) \
	LP2(0x240, BOOL, GetProgramName, STRPTR, buf, d1, LONG, len, d2, \
	, DOS_BASE_NAME)

#define SetPrompt(name) \
	LP1(0x246, BOOL, SetPrompt, CONST_STRPTR, name, d1, \
	, DOS_BASE_NAME)

#define GetPrompt(buf, len) \
	LP2(0x24c, BOOL, GetPrompt, STRPTR, buf, d1, LONG, len, d2, \
	, DOS_BASE_NAME)

#define SetProgramDir(lock) \
	LP1(0x252, BPTR, SetProgramDir, BPTR, lock, d1, \
	, DOS_BASE_NAME)

#define GetProgramDir() \
	LP0(0x258, BPTR, GetProgramDir, \
	, DOS_BASE_NAME)

#define SystemTagList(command, tags) \
	LP2(0x25e, LONG, SystemTagList, CONST_STRPTR, command, d1, const struct TagItem *, tags, d2, \
	, DOS_BASE_NAME)

#define System(command, tags) SystemTagList((command), (tags))

#ifndef NO_INLINE_STDARG
#define SystemTags(command, tags...) \
	({ULONG _tags[] = {tags}; SystemTagList((command), (const struct TagItem *) _tags);})
#endif

#define AssignLock(name, lock) \
	LP2(0x264, LONG, AssignLock, CONST_STRPTR, name, d1, BPTR, lock, d2, \
	, DOS_BASE_NAME)

#define AssignLate(name, path) \
	LP2(0x26a, BOOL, AssignLate, CONST_STRPTR, name, d1, CONST_STRPTR, path, d2, \
	, DOS_BASE_NAME)

#define AssignPath(name, path) \
	LP2(0x270, BOOL, AssignPath, CONST_STRPTR, name, d1, CONST_STRPTR, path, d2, \
	, DOS_BASE_NAME)

#define AssignAdd(name, lock) \
	LP2(0x276, BOOL, AssignAdd, CONST_STRPTR, name, d1, BPTR, lock, d2, \
	, DOS_BASE_NAME)

#define RemAssignList(name, lock) \
	LP2(0x27c, LONG, RemAssignList, CONST_STRPTR, name, d1, BPTR, lock, d2, \
	, DOS_BASE_NAME)

#define GetDeviceProc(name, dp) \
	LP2(0x282, struct DevProc *, GetDeviceProc, CONST_STRPTR, name, d1, struct DevProc *, dp, d2, \
	, DOS_BASE_NAME)

#define FreeDeviceProc(dp) \
	LP1NR(0x288, FreeDeviceProc, struct DevProc *, dp, d1, \
	, DOS_BASE_NAME)

#define LockDosList(flags) \
	LP1(0x28e, struct DosList *, LockDosList, ULONG, flags, d1, \
	, DOS_BASE_NAME)

#define UnLockDosList(flags) \
	LP1NR(0x294, UnLockDosList, ULONG, flags, d1, \
	, DOS_BASE_NAME)

#define AttemptLockDosList(flags) \
	LP1(0x29a, struct DosList *, AttemptLockDosList, ULONG, flags, d1, \
	, DOS_BASE_NAME)

#define RemDosEntry(dlist) \
	LP1(0x2a0, BOOL, RemDosEntry, struct DosList *, dlist, d1, \
	, DOS_BASE_NAME)

#define AddDosEntry(dlist) \
	LP1(0x2a6, LONG, AddDosEntry, struct DosList *, dlist, d1, \
	, DOS_BASE_NAME)

#define FindDosEntry(dlist, name, flags) \
	LP3(0x2ac, struct DosList *, FindDosEntry, const struct DosList *, dlist, d1, CONST_STRPTR, name, d2, ULONG, flags, d3, \
	, DOS_BASE_NAME)

#define NextDosEntry(dlist, flags) \
	LP2(0x2b2, struct DosList *, NextDosEntry, const struct DosList *, dlist, d1, ULONG, flags, d2, \
	, DOS_BASE_NAME)

#define MakeDosEntry(name, type) \
	LP2(0x2b8, struct DosList *, MakeDosEntry, CONST_STRPTR, name, d1, LONG, type, d2, \
	, DOS_BASE_NAME)

#define FreeDosEntry(dlist) \
	LP1NR(0x2be, FreeDosEntry, struct DosList *, dlist, d1, \
	, DOS_BASE_NAME)

#define IsFileSystem(name) \
	LP1(0x2c4, BOOL, IsFileSystem, CONST_STRPTR, name, d1, \
	, DOS_BASE_NAME)

#define Format(filesystem, volumename, dostype) \
	LP3(0x2ca, BOOL, Format, CONST_STRPTR, filesystem, d1, CONST_STRPTR, volumename, d2, ULONG, dostype, d3, \
	, DOS_BASE_NAME)

#define Relabel(drive, newname) \
	LP2(0x2d0, LONG, Relabel, CONST_STRPTR, drive, d1, CONST_STRPTR, newname, d2, \
	, DOS_BASE_NAME)

#define Inhibit(name, onoff) \
	LP2(0x2d6, LONG, Inhibit, CONST_STRPTR, name, d1, LONG, onoff, d2, \
	, DOS_BASE_NAME)

#define AddBuffers(name, number) \
	LP2(0x2dc, LONG, AddBuffers, CONST_STRPTR, name, d1, LONG, number, d2, \
	, DOS_BASE_NAME)

#define CompareDates(date1, date2) \
	LP2(0x2e2, LONG, CompareDates, const struct DateStamp *, date1, d1, const struct DateStamp *, date2, d2, \
	, DOS_BASE_NAME)

#define DateToStr(datetime) \
	LP1(0x2e8, LONG, DateToStr, struct DateTime *, datetime, d1, \
	, DOS_BASE_NAME)

#define StrToDate(datetime) \
	LP1(0x2ee, LONG, StrToDate, struct DateTime *, datetime, d1, \
	, DOS_BASE_NAME)

#define InternalLoadSeg(fh, table, funcarray, stack) \
	LP4(0x2f4, BPTR, InternalLoadSeg, BPTR, fh, d0, BPTR, table, a0, const LONG *, funcarray, a1, LONG *, stack, a2, \
	, DOS_BASE_NAME)

#define InternalUnLoadSeg(seglist, freefunc) \
	LP2FP(0x2fa, BOOL, InternalUnLoadSeg, BPTR, seglist, d1, __fpt, freefunc, a1, \
	, DOS_BASE_NAME, VOID (*__fpt)())

#define NewLoadSeg(file, tags) \
	LP2(0x300, BPTR, NewLoadSeg, CONST_STRPTR, file, d1, const struct TagItem *, tags, d2, \
	, DOS_BASE_NAME)

#define NewLoadSegTagList(file, tags) NewLoadSeg((file), (tags))

#ifndef NO_INLINE_STDARG
#define NewLoadSegTags(file, tags...) \
	({ULONG _tags[] = {tags}; NewLoadSeg((file), (const struct TagItem *) _tags);})
#endif

#define AddSegment(name, seg, system) \
	LP3(0x306, LONG, AddSegment, CONST_STRPTR, name, d1, BPTR, seg, d2, LONG, system, d3, \
	, DOS_BASE_NAME)

#define FindSegment(name, seg, system) \
	LP3(0x30c, struct Segment *, FindSegment, CONST_STRPTR, name, d1, const struct Segment *, seg, d2, LONG, system, d3, \
	, DOS_BASE_NAME)

#define RemSegment(seg) \
	LP1(0x312, LONG, RemSegment, struct Segment *, seg, d1, \
	, DOS_BASE_NAME)

#define CheckSignal(mask) \
	LP1(0x318, LONG, CheckSignal, LONG, mask, d1, \
	, DOS_BASE_NAME)

#define ReadArgs(arg_template, array, args) \
	LP3(0x31e, struct RDArgs *, ReadArgs, CONST_STRPTR, arg_template, d1, LONG *, array, d2, struct RDArgs *, args, d3, \
	, DOS_BASE_NAME)

#define FindArg(keyword, arg_template) \
	LP2(0x324, LONG, FindArg, CONST_STRPTR, keyword, d1, CONST_STRPTR, arg_template, d2, \
	, DOS_BASE_NAME)

#define ReadItem(name, maxchars, cSource) \
	LP3(0x32a, LONG, ReadItem, CONST_STRPTR, name, d1, LONG, maxchars, d2, struct CSource *, cSource, d3, \
	, DOS_BASE_NAME)

#define StrToLong(string, value) \
	LP2(0x330, LONG, StrToLong, CONST_STRPTR, string, d1, LONG *, value, d2, \
	, DOS_BASE_NAME)

#define MatchFirst(pat, anchor) \
	LP2(0x336, LONG, MatchFirst, CONST_STRPTR, pat, d1, struct AnchorPath *, anchor, d2, \
	, DOS_BASE_NAME)

#define MatchNext(anchor) \
	LP1(0x33c, LONG, MatchNext, struct AnchorPath *, anchor, d1, \
	, DOS_BASE_NAME)

#define MatchEnd(anchor) \
	LP1NR(0x342, MatchEnd, struct AnchorPath *, anchor, d1, \
	, DOS_BASE_NAME)

#define ParsePattern(pat, buf, buflen) \
	LP3(0x348, LONG, ParsePattern, CONST_STRPTR, pat, d1, STRPTR, buf, d2, LONG, buflen, d3, \
	, DOS_BASE_NAME)

#define MatchPattern(pat, str) \
	LP2(0x34e, BOOL, MatchPattern, CONST_STRPTR, pat, d1, STRPTR, str, d2, \
	, DOS_BASE_NAME)

#define FreeArgs(args) \
	LP1NR(0x35a, FreeArgs, struct RDArgs *, args, d1, \
	, DOS_BASE_NAME)

#define FilePart(path) \
	LP1(0x366, STRPTR, FilePart, CONST_STRPTR, path, d1, \
	, DOS_BASE_NAME)

#define PathPart(path) \
	LP1(0x36c, STRPTR, PathPart, CONST_STRPTR, path, d1, \
	, DOS_BASE_NAME)

#define AddPart(dirname, filename, size) \
	LP3(0x372, BOOL, AddPart, STRPTR, dirname, d1, CONST_STRPTR, filename, d2, ULONG, size, d3, \
	, DOS_BASE_NAME)

#define StartNotify(notify) \
	LP1(0x378, BOOL, StartNotify, struct NotifyRequest *, notify, d1, \
	, DOS_BASE_NAME)

#define EndNotify(notify) \
	LP1NR(0x37e, EndNotify, struct NotifyRequest *, notify, d1, \
	, DOS_BASE_NAME)

#define SetVar(name, buffer, size, flags) \
	LP4(0x384, BOOL, SetVar, CONST_STRPTR, name, d1, CONST_STRPTR, buffer, d2, LONG, size, d3, LONG, flags, d4, \
	, DOS_BASE_NAME)

#define GetVar(name, buffer, size, flags) \
	LP4(0x38a, LONG, GetVar, CONST_STRPTR, name, d1, STRPTR, buffer, d2, LONG, size, d3, LONG, flags, d4, \
	, DOS_BASE_NAME)

#define DeleteVar(name, flags) \
	LP2(0x390, LONG, DeleteVar, CONST_STRPTR, name, d1, ULONG, flags, d2, \
	, DOS_BASE_NAME)

#define FindVar(name, type) \
	LP2(0x396, struct LocalVar *, FindVar, CONST_STRPTR, name, d1, ULONG, type, d2, \
	, DOS_BASE_NAME)

#define CliInitNewcli(dp) \
	LP1(0x3a2, LONG, CliInitNewcli, struct DosPacket *, dp, a0, \
	, DOS_BASE_NAME)

#define CliInitRun(dp) \
	LP1(0x3a8, LONG, CliInitRun, struct DosPacket *, dp, a0, \
	, DOS_BASE_NAME)

#define WriteChars(buf, buflen) \
	LP2(0x3ae, LONG, WriteChars, CONST_STRPTR, buf, d1, ULONG, buflen, d2, \
	, DOS_BASE_NAME)

#define PutStr(str) \
	LP1(0x3b4, LONG, PutStr, CONST_STRPTR, str, d1, \
	, DOS_BASE_NAME)

#define VPrintf(format, argarray) \
	LP2(0x3ba, LONG, VPrintf, CONST_STRPTR, format, d1, const APTR, argarray, d2, \
	, DOS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define Printf(format, tags...) \
	({ULONG _tags[] = {tags}; VPrintf((format), (const APTR) _tags);})
#endif

#define ParsePatternNoCase(pat, buf, buflen) \
	LP3(0x3c6, LONG, ParsePatternNoCase, CONST_STRPTR, pat, d1, UBYTE *, buf, d2, LONG, buflen, d3, \
	, DOS_BASE_NAME)

#define MatchPatternNoCase(pat, str) \
	LP2(0x3cc, BOOL, MatchPatternNoCase, CONST_STRPTR, pat, d1, STRPTR, str, d2, \
	, DOS_BASE_NAME)

#define SameDevice(lock1, lock2) \
	LP2(0x3d8, BOOL, SameDevice, BPTR, lock1, d1, BPTR, lock2, d2, \
	, DOS_BASE_NAME)

#define ExAllEnd(lock, buffer, size, data, control) \
	LP5NR(0x3de, ExAllEnd, BPTR, lock, d1, struct ExAllData *, buffer, d2, LONG, size, d3, LONG, data, d4, struct ExAllControl *, control, d5, \
	, DOS_BASE_NAME)

#define SetOwner(name, owner_info) \
	LP2(0x3e4, BOOL, SetOwner, CONST_STRPTR, name, d1, LONG, owner_info, d2, \
	, DOS_BASE_NAME)

#endif /*  _INLINE_DOS_H  */
