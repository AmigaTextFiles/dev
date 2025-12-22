#ifndef _VBCCINLINE_DOS_H
#define _VBCCINLINE_DOS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

BPTR __Open(struct DosLibrary *, CONST_STRPTR name, LONG accessMode) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-30\n"
	"\tblrl";
#define Open(name, accessMode) __Open(DOSBase, (name), (accessMode))

LONG __Close(struct DosLibrary *, BPTR file) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-36\n"
	"\tblrl";
#define Close(file) __Close(DOSBase, (file))

LONG __Read(struct DosLibrary *, BPTR file, APTR buffer, LONG length) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-42\n"
	"\tblrl";
#define Read(file, buffer, length) __Read(DOSBase, (file), (buffer), (length))

LONG __Write(struct DosLibrary *, BPTR file, const APTR buffer, LONG length) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-48\n"
	"\tblrl";
#define Write(file, buffer, length) __Write(DOSBase, (file), (buffer), (length))

BPTR __Input(struct DosLibrary *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-54\n"
	"\tblrl";
#define Input() __Input(DOSBase)

BPTR __Output(struct DosLibrary *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-60\n"
	"\tblrl";
#define Output() __Output(DOSBase)

LONG __Seek(struct DosLibrary *, BPTR file, LONG position, LONG offset) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-66\n"
	"\tblrl";
#define Seek(file, position, offset) __Seek(DOSBase, (file), (position), (offset))

LONG __DeleteFile(struct DosLibrary *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-72\n"
	"\tblrl";
#define DeleteFile(name) __DeleteFile(DOSBase, (name))

LONG __Rename(struct DosLibrary *, CONST_STRPTR oldName, CONST_STRPTR newName) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-78\n"
	"\tblrl";
#define Rename(oldName, newName) __Rename(DOSBase, (oldName), (newName))

BPTR __Lock(struct DosLibrary *, CONST_STRPTR name, LONG type) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-84\n"
	"\tblrl";
#define Lock(name, type) __Lock(DOSBase, (name), (type))

VOID __UnLock(struct DosLibrary *, BPTR lock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-90\n"
	"\tblrl";
#define UnLock(lock) __UnLock(DOSBase, (lock))

BPTR __DupLock(struct DosLibrary *, BPTR lock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-96\n"
	"\tblrl";
#define DupLock(lock) __DupLock(DOSBase, (lock))

LONG __Examine(struct DosLibrary *, BPTR lock, struct FileInfoBlock * fileInfoBlock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-102\n"
	"\tblrl";
#define Examine(lock, fileInfoBlock) __Examine(DOSBase, (lock), (fileInfoBlock))

LONG __ExNext(struct DosLibrary *, BPTR lock, struct FileInfoBlock * fileInfoBlock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-108\n"
	"\tblrl";
#define ExNext(lock, fileInfoBlock) __ExNext(DOSBase, (lock), (fileInfoBlock))

LONG __Info(struct DosLibrary *, BPTR lock, struct InfoData * parameterBlock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-114\n"
	"\tblrl";
#define Info(lock, parameterBlock) __Info(DOSBase, (lock), (parameterBlock))

BPTR __CreateDir(struct DosLibrary *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-120\n"
	"\tblrl";
#define CreateDir(name) __CreateDir(DOSBase, (name))

BPTR __CurrentDir(struct DosLibrary *, BPTR lock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-126\n"
	"\tblrl";
#define CurrentDir(lock) __CurrentDir(DOSBase, (lock))

LONG __IoErr(struct DosLibrary *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-132\n"
	"\tblrl";
#define IoErr() __IoErr(DOSBase)

struct MsgPort * __CreateProc(struct DosLibrary *, CONST_STRPTR name, LONG pri, BPTR segList, LONG stackSize) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tli\t3,-138\n"
	"\tblrl";
#define CreateProc(name, pri, segList, stackSize) __CreateProc(DOSBase, (name), (pri), (segList), (stackSize))

VOID __Exit(struct DosLibrary *, LONG returnCode) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-144\n"
	"\tblrl";
#define Exit(returnCode) __Exit(DOSBase, (returnCode))

BPTR __LoadSeg(struct DosLibrary *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-150\n"
	"\tblrl";
#define LoadSeg(name) __LoadSeg(DOSBase, (name))

VOID __UnLoadSeg(struct DosLibrary *, BPTR seglist) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-156\n"
	"\tblrl";
#define UnLoadSeg(seglist) __UnLoadSeg(DOSBase, (seglist))

struct MsgPort * __DeviceProc(struct DosLibrary *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-174\n"
	"\tblrl";
#define DeviceProc(name) __DeviceProc(DOSBase, (name))

LONG __SetComment(struct DosLibrary *, CONST_STRPTR name, CONST_STRPTR comment) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-180\n"
	"\tblrl";
#define SetComment(name, comment) __SetComment(DOSBase, (name), (comment))

LONG __SetProtection(struct DosLibrary *, CONST_STRPTR name, LONG protect) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-186\n"
	"\tblrl";
#define SetProtection(name, protect) __SetProtection(DOSBase, (name), (protect))

struct DateStamp * __DateStamp(struct DosLibrary *, struct DateStamp * date) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-192\n"
	"\tblrl";
#define DateStamp(date) __DateStamp(DOSBase, (date))

VOID __Delay(struct DosLibrary *, LONG timeout) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-198\n"
	"\tblrl";
#define Delay(timeout) __Delay(DOSBase, (timeout))

LONG __WaitForChar(struct DosLibrary *, BPTR file, LONG timeout) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-204\n"
	"\tblrl";
#define WaitForChar(file, timeout) __WaitForChar(DOSBase, (file), (timeout))

BPTR __ParentDir(struct DosLibrary *, BPTR lock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-210\n"
	"\tblrl";
#define ParentDir(lock) __ParentDir(DOSBase, (lock))

LONG __IsInteractive(struct DosLibrary *, BPTR file) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-216\n"
	"\tblrl";
#define IsInteractive(file) __IsInteractive(DOSBase, (file))

LONG __Execute(struct DosLibrary *, CONST_STRPTR string, BPTR file, BPTR file2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-222\n"
	"\tblrl";
#define Execute(string, file, file2) __Execute(DOSBase, (string), (file), (file2))

APTR __AllocDosObject(struct DosLibrary *, ULONG type, const struct TagItem * tags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-228\n"
	"\tblrl";
#define AllocDosObject(type, tags) __AllocDosObject(DOSBase, (type), (tags))

#define AllocDosObjectTagList(type, tags) __AllocDosObject((type), (tags), DOSBase)

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
APTR __AllocDosObjectTags(struct DosLibrary *, long, long, long, long, long, long, ULONG type, ULONG tags, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t10,4(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,8(2)\n"
	"\tli\t3,-228\n"
	"\tblrl";
#define AllocDosObjectTags(type, ...) __AllocDosObjectTags(DOSBase, 0, 0, 0, 0, 0, 0, (type), __VA_ARGS__)
#endif

VOID __FreeDosObject(struct DosLibrary *, ULONG type, APTR ptr) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-234\n"
	"\tblrl";
#define FreeDosObject(type, ptr) __FreeDosObject(DOSBase, (type), (ptr))

LONG __DoPkt(struct DosLibrary *, struct MsgPort * port, LONG action, LONG arg1, LONG arg2, LONG arg3, LONG arg4, LONG arg5) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tstw\t8,20(2)\n"
	"\tstw\t9,24(2)\n"
	"\tstw\t10,28(2)\n"
	"\tli\t3,-240\n"
	"\tblrl";
#define DoPkt(port, action, arg1, arg2, arg3, arg4, arg5) __DoPkt(DOSBase, (port), (action), (arg1), (arg2), (arg3), (arg4), (arg5))

LONG __DoPkt0(struct DosLibrary *, struct MsgPort * port, LONG action) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-240\n"
	"\tblrl";
#define DoPkt0(port, action) __DoPkt0(DOSBase, (port), (action))

LONG __DoPkt1(struct DosLibrary *, struct MsgPort * port, LONG action, LONG arg1) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-240\n"
	"\tblrl";
#define DoPkt1(port, action, arg1) __DoPkt1(DOSBase, (port), (action), (arg1))

LONG __DoPkt2(struct DosLibrary *, struct MsgPort * port, LONG action, LONG arg1, LONG arg2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tli\t3,-240\n"
	"\tblrl";
#define DoPkt2(port, action, arg1, arg2) __DoPkt2(DOSBase, (port), (action), (arg1), (arg2))

LONG __DoPkt3(struct DosLibrary *, struct MsgPort * port, LONG action, LONG arg1, LONG arg2, LONG arg3) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tstw\t8,20(2)\n"
	"\tli\t3,-240\n"
	"\tblrl";
#define DoPkt3(port, action, arg1, arg2, arg3) __DoPkt3(DOSBase, (port), (action), (arg1), (arg2), (arg3))

LONG __DoPkt4(struct DosLibrary *, struct MsgPort * port, LONG action, LONG arg1, LONG arg2, LONG arg3, LONG arg4) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tstw\t8,20(2)\n"
	"\tstw\t9,24(2)\n"
	"\tli\t3,-240\n"
	"\tblrl";
#define DoPkt4(port, action, arg1, arg2, arg3, arg4) __DoPkt4(DOSBase, (port), (action), (arg1), (arg2), (arg3), (arg4))

VOID __SendPkt(struct DosLibrary *, struct DosPacket * dp, struct MsgPort * port, struct MsgPort * replyport) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-246\n"
	"\tblrl";
#define SendPkt(dp, port, replyport) __SendPkt(DOSBase, (dp), (port), (replyport))

struct DosPacket * __WaitPkt(struct DosLibrary *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-252\n"
	"\tblrl";
#define WaitPkt() __WaitPkt(DOSBase)

VOID __ReplyPkt(struct DosLibrary *, struct DosPacket * dp, LONG res1, LONG res2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-258\n"
	"\tblrl";
#define ReplyPkt(dp, res1, res2) __ReplyPkt(DOSBase, (dp), (res1), (res2))

VOID __AbortPkt(struct DosLibrary *, struct MsgPort * port, struct DosPacket * pkt) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-264\n"
	"\tblrl";
#define AbortPkt(port, pkt) __AbortPkt(DOSBase, (port), (pkt))

BOOL __LockRecord(struct DosLibrary *, BPTR fh, ULONG offset, ULONG length, ULONG mode, ULONG timeout) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tstw\t8,20(2)\n"
	"\tli\t3,-270\n"
	"\tblrl";
#define LockRecord(fh, offset, length, mode, timeout) __LockRecord(DOSBase, (fh), (offset), (length), (mode), (timeout))

BOOL __LockRecords(struct DosLibrary *, struct RecordLock * recArray, ULONG timeout) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-276\n"
	"\tblrl";
#define LockRecords(recArray, timeout) __LockRecords(DOSBase, (recArray), (timeout))

BOOL __UnLockRecord(struct DosLibrary *, BPTR fh, ULONG offset, ULONG length) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-282\n"
	"\tblrl";
#define UnLockRecord(fh, offset, length) __UnLockRecord(DOSBase, (fh), (offset), (length))

BOOL __UnLockRecords(struct DosLibrary *, struct RecordLock * recArray) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-288\n"
	"\tblrl";
#define UnLockRecords(recArray) __UnLockRecords(DOSBase, (recArray))

BPTR __SelectInput(struct DosLibrary *, BPTR fh) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-294\n"
	"\tblrl";
#define SelectInput(fh) __SelectInput(DOSBase, (fh))

BPTR __SelectOutput(struct DosLibrary *, BPTR fh) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-300\n"
	"\tblrl";
#define SelectOutput(fh) __SelectOutput(DOSBase, (fh))

LONG __FGetC(struct DosLibrary *, BPTR fh) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-306\n"
	"\tblrl";
#define FGetC(fh) __FGetC(DOSBase, (fh))

LONG __FPutC(struct DosLibrary *, BPTR fh, LONG ch) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-312\n"
	"\tblrl";
#define FPutC(fh, ch) __FPutC(DOSBase, (fh), (ch))

LONG __UnGetC(struct DosLibrary *, BPTR fh, LONG character) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-318\n"
	"\tblrl";
#define UnGetC(fh, character) __UnGetC(DOSBase, (fh), (character))

LONG __FRead(struct DosLibrary *, BPTR fh, APTR block, ULONG blocklen, ULONG number) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tli\t3,-324\n"
	"\tblrl";
#define FRead(fh, block, blocklen, number) __FRead(DOSBase, (fh), (block), (blocklen), (number))

LONG __FWrite(struct DosLibrary *, BPTR fh, const APTR block, ULONG blocklen, ULONG number) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tli\t3,-330\n"
	"\tblrl";
#define FWrite(fh, block, blocklen, number) __FWrite(DOSBase, (fh), (block), (blocklen), (number))

STRPTR __FGets(struct DosLibrary *, BPTR fh, STRPTR buf, ULONG buflen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-336\n"
	"\tblrl";
#define FGets(fh, buf, buflen) __FGets(DOSBase, (fh), (buf), (buflen))

LONG __FPuts(struct DosLibrary *, BPTR fh, CONST_STRPTR str) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-342\n"
	"\tblrl";
#define FPuts(fh, str) __FPuts(DOSBase, (fh), (str))

VOID __VFWritef(struct DosLibrary *, BPTR fh, CONST_STRPTR format, const LONG * argarray) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-348\n"
	"\tblrl";
#define VFWritef(fh, format, argarray) __VFWritef(DOSBase, (fh), (format), (argarray))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
VOID __FWritef(struct DosLibrary *, long, long, long, long, long, BPTR fh, CONST_STRPTR format, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t9,4(2)\n"
	"\tstw\t10,8(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,12(2)\n"
	"\tli\t3,-348\n"
	"\tblrl";
#define FWritef(fh, ...) __FWritef(DOSBase, 0, 0, 0, 0, 0, (fh), __VA_ARGS__)
#endif

LONG __VFPrintf(struct DosLibrary *, BPTR fh, CONST_STRPTR format, const APTR argarray) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-354\n"
	"\tblrl";
#define VFPrintf(fh, format, argarray) __VFPrintf(DOSBase, (fh), (format), (argarray))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
LONG __FPrintf(struct DosLibrary *, long, long, long, long, long, BPTR fh, CONST_STRPTR format, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t9,4(2)\n"
	"\tstw\t10,8(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,12(2)\n"
	"\tli\t3,-354\n"
	"\tblrl";
#define FPrintf(fh, ...) __FPrintf(DOSBase, 0, 0, 0, 0, 0, (fh), __VA_ARGS__)
#endif

LONG __Flush(struct DosLibrary *, BPTR fh) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-360\n"
	"\tblrl";
#define Flush(fh) __Flush(DOSBase, (fh))

LONG __SetVBuf(struct DosLibrary *, BPTR fh, STRPTR buff, LONG type, LONG size) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tli\t3,-366\n"
	"\tblrl";
#define SetVBuf(fh, buff, type, size) __SetVBuf(DOSBase, (fh), (buff), (type), (size))

BPTR __DupLockFromFH(struct DosLibrary *, BPTR fh) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-372\n"
	"\tblrl";
#define DupLockFromFH(fh) __DupLockFromFH(DOSBase, (fh))

BPTR __OpenFromLock(struct DosLibrary *, BPTR lock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-378\n"
	"\tblrl";
#define OpenFromLock(lock) __OpenFromLock(DOSBase, (lock))

BPTR __ParentOfFH(struct DosLibrary *, BPTR fh) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-384\n"
	"\tblrl";
#define ParentOfFH(fh) __ParentOfFH(DOSBase, (fh))

BOOL __ExamineFH(struct DosLibrary *, BPTR fh, struct FileInfoBlock * fib) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-390\n"
	"\tblrl";
#define ExamineFH(fh, fib) __ExamineFH(DOSBase, (fh), (fib))

LONG __SetFileDate(struct DosLibrary *, CONST_STRPTR name, const struct DateStamp * date) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-396\n"
	"\tblrl";
#define SetFileDate(name, date) __SetFileDate(DOSBase, (name), (date))

LONG __NameFromLock(struct DosLibrary *, BPTR lock, STRPTR buffer, LONG len) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-402\n"
	"\tblrl";
#define NameFromLock(lock, buffer, len) __NameFromLock(DOSBase, (lock), (buffer), (len))

LONG __NameFromFH(struct DosLibrary *, BPTR fh, STRPTR buffer, LONG len) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-408\n"
	"\tblrl";
#define NameFromFH(fh, buffer, len) __NameFromFH(DOSBase, (fh), (buffer), (len))

WORD __SplitName(struct DosLibrary *, CONST_STRPTR name, ULONG separator, STRPTR buf, LONG oldpos, LONG size) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tstw\t8,20(2)\n"
	"\tli\t3,-414\n"
	"\tblrl";
#define SplitName(name, separator, buf, oldpos, size) __SplitName(DOSBase, (name), (separator), (buf), (oldpos), (size))

LONG __SameLock(struct DosLibrary *, BPTR lock1, BPTR lock2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-420\n"
	"\tblrl";
#define SameLock(lock1, lock2) __SameLock(DOSBase, (lock1), (lock2))

LONG __SetMode(struct DosLibrary *, BPTR fh, LONG mode) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-426\n"
	"\tblrl";
#define SetMode(fh, mode) __SetMode(DOSBase, (fh), (mode))

LONG __ExAll(struct DosLibrary *, BPTR lock, struct ExAllData * buffer, LONG size, LONG data, struct ExAllControl * control) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tstw\t8,20(2)\n"
	"\tli\t3,-432\n"
	"\tblrl";
#define ExAll(lock, buffer, size, data, control) __ExAll(DOSBase, (lock), (buffer), (size), (data), (control))

LONG __ReadLink(struct DosLibrary *, struct MsgPort * port, BPTR lock, CONST_STRPTR path, STRPTR buffer, ULONG size) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tstw\t8,20(2)\n"
	"\tli\t3,-438\n"
	"\tblrl";
#define ReadLink(port, lock, path, buffer, size) __ReadLink(DOSBase, (port), (lock), (path), (buffer), (size))

LONG __MakeLink(struct DosLibrary *, CONST_STRPTR name, LONG dest, LONG soft) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-444\n"
	"\tblrl";
#define MakeLink(name, dest, soft) __MakeLink(DOSBase, (name), (dest), (soft))

LONG __ChangeMode(struct DosLibrary *, LONG type, BPTR fh, LONG newmode) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-450\n"
	"\tblrl";
#define ChangeMode(type, fh, newmode) __ChangeMode(DOSBase, (type), (fh), (newmode))

LONG __SetFileSize(struct DosLibrary *, BPTR fh, LONG pos, LONG mode) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-456\n"
	"\tblrl";
#define SetFileSize(fh, pos, mode) __SetFileSize(DOSBase, (fh), (pos), (mode))

LONG __SetIoErr(struct DosLibrary *, LONG result) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-462\n"
	"\tblrl";
#define SetIoErr(result) __SetIoErr(DOSBase, (result))

BOOL __Fault(struct DosLibrary *, LONG code, STRPTR header, STRPTR buffer, LONG len) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tli\t3,-468\n"
	"\tblrl";
#define Fault(code, header, buffer, len) __Fault(DOSBase, (code), (header), (buffer), (len))

BOOL __PrintFault(struct DosLibrary *, LONG code, CONST_STRPTR header) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-474\n"
	"\tblrl";
#define PrintFault(code, header) __PrintFault(DOSBase, (code), (header))

LONG __ErrorReport(struct DosLibrary *, LONG code, LONG type, ULONG arg1, struct MsgPort * device) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tli\t3,-480\n"
	"\tblrl";
#define ErrorReport(code, type, arg1, device) __ErrorReport(DOSBase, (code), (type), (arg1), (device))

struct CommandLineInterface * __Cli(struct DosLibrary *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-492\n"
	"\tblrl";
#define Cli() __Cli(DOSBase)

struct Process * __CreateNewProc(struct DosLibrary *, const struct TagItem * tags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-498\n"
	"\tblrl";
#define CreateNewProc(tags) __CreateNewProc(DOSBase, (tags))

#define CreateNewProcTagList(tags) __CreateNewProc((tags), DOSBase)

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
struct Process * __CreateNewProcTags(struct DosLibrary *, long, long, long, long, long, long, long, ULONG tags, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-498\n"
	"\tblrl";
#define CreateNewProcTags(...) __CreateNewProcTags(DOSBase, 0, 0, 0, 0, 0, 0, 0, __VA_ARGS__)
#endif

LONG __RunCommand(struct DosLibrary *, BPTR seg, LONG stack, CONST_STRPTR paramptr, LONG paramlen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tli\t3,-504\n"
	"\tblrl";
#define RunCommand(seg, stack, paramptr, paramlen) __RunCommand(DOSBase, (seg), (stack), (paramptr), (paramlen))

struct MsgPort * __GetConsoleTask(struct DosLibrary *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-510\n"
	"\tblrl";
#define GetConsoleTask() __GetConsoleTask(DOSBase)

struct MsgPort * __SetConsoleTask(struct DosLibrary *, const struct MsgPort * task) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-516\n"
	"\tblrl";
#define SetConsoleTask(task) __SetConsoleTask(DOSBase, (task))

struct MsgPort * __GetFileSysTask(struct DosLibrary *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-522\n"
	"\tblrl";
#define GetFileSysTask() __GetFileSysTask(DOSBase)

struct MsgPort * __SetFileSysTask(struct DosLibrary *, const struct MsgPort * task) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-528\n"
	"\tblrl";
#define SetFileSysTask(task) __SetFileSysTask(DOSBase, (task))

STRPTR __GetArgStr(struct DosLibrary *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-534\n"
	"\tblrl";
#define GetArgStr() __GetArgStr(DOSBase)

BOOL __SetArgStr(struct DosLibrary *, CONST_STRPTR string) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-540\n"
	"\tblrl";
#define SetArgStr(string) __SetArgStr(DOSBase, (string))

struct Process * __FindCliProc(struct DosLibrary *, ULONG num) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-546\n"
	"\tblrl";
#define FindCliProc(num) __FindCliProc(DOSBase, (num))

ULONG __MaxCli(struct DosLibrary *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-552\n"
	"\tblrl";
#define MaxCli() __MaxCli(DOSBase)

BOOL __SetCurrentDirName(struct DosLibrary *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-558\n"
	"\tblrl";
#define SetCurrentDirName(name) __SetCurrentDirName(DOSBase, (name))

BOOL __GetCurrentDirName(struct DosLibrary *, STRPTR buf, LONG len) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-564\n"
	"\tblrl";
#define GetCurrentDirName(buf, len) __GetCurrentDirName(DOSBase, (buf), (len))

BOOL __SetProgramName(struct DosLibrary *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-570\n"
	"\tblrl";
#define SetProgramName(name) __SetProgramName(DOSBase, (name))

BOOL __GetProgramName(struct DosLibrary *, STRPTR buf, LONG len) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-576\n"
	"\tblrl";
#define GetProgramName(buf, len) __GetProgramName(DOSBase, (buf), (len))

BOOL __SetPrompt(struct DosLibrary *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-582\n"
	"\tblrl";
#define SetPrompt(name) __SetPrompt(DOSBase, (name))

BOOL __GetPrompt(struct DosLibrary *, STRPTR buf, LONG len) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-588\n"
	"\tblrl";
#define GetPrompt(buf, len) __GetPrompt(DOSBase, (buf), (len))

BPTR __SetProgramDir(struct DosLibrary *, BPTR lock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-594\n"
	"\tblrl";
#define SetProgramDir(lock) __SetProgramDir(DOSBase, (lock))

BPTR __GetProgramDir(struct DosLibrary *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-600\n"
	"\tblrl";
#define GetProgramDir() __GetProgramDir(DOSBase)

LONG __SystemTagList(struct DosLibrary *, CONST_STRPTR command, const struct TagItem * tags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-606\n"
	"\tblrl";
#define SystemTagList(command, tags) __SystemTagList(DOSBase, (command), (tags))

#define System(command, tags) __SystemTagList((command), (tags), DOSBase)

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
LONG __SystemTags(struct DosLibrary *, long, long, long, long, long, long, CONST_STRPTR command, ULONG tags, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t10,4(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,8(2)\n"
	"\tli\t3,-606\n"
	"\tblrl";
#define SystemTags(command, ...) __SystemTags(DOSBase, 0, 0, 0, 0, 0, 0, (command), __VA_ARGS__)
#endif

LONG __AssignLock(struct DosLibrary *, CONST_STRPTR name, BPTR lock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-612\n"
	"\tblrl";
#define AssignLock(name, lock) __AssignLock(DOSBase, (name), (lock))

BOOL __AssignLate(struct DosLibrary *, CONST_STRPTR name, CONST_STRPTR path) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-618\n"
	"\tblrl";
#define AssignLate(name, path) __AssignLate(DOSBase, (name), (path))

BOOL __AssignPath(struct DosLibrary *, CONST_STRPTR name, CONST_STRPTR path) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-624\n"
	"\tblrl";
#define AssignPath(name, path) __AssignPath(DOSBase, (name), (path))

BOOL __AssignAdd(struct DosLibrary *, CONST_STRPTR name, BPTR lock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-630\n"
	"\tblrl";
#define AssignAdd(name, lock) __AssignAdd(DOSBase, (name), (lock))

LONG __RemAssignList(struct DosLibrary *, CONST_STRPTR name, BPTR lock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-636\n"
	"\tblrl";
#define RemAssignList(name, lock) __RemAssignList(DOSBase, (name), (lock))

struct DevProc * __GetDeviceProc(struct DosLibrary *, CONST_STRPTR name, struct DevProc * dp) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-642\n"
	"\tblrl";
#define GetDeviceProc(name, dp) __GetDeviceProc(DOSBase, (name), (dp))

VOID __FreeDeviceProc(struct DosLibrary *, struct DevProc * dp) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-648\n"
	"\tblrl";
#define FreeDeviceProc(dp) __FreeDeviceProc(DOSBase, (dp))

struct DosList * __LockDosList(struct DosLibrary *, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-654\n"
	"\tblrl";
#define LockDosList(flags) __LockDosList(DOSBase, (flags))

VOID __UnLockDosList(struct DosLibrary *, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-660\n"
	"\tblrl";
#define UnLockDosList(flags) __UnLockDosList(DOSBase, (flags))

struct DosList * __AttemptLockDosList(struct DosLibrary *, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-666\n"
	"\tblrl";
#define AttemptLockDosList(flags) __AttemptLockDosList(DOSBase, (flags))

BOOL __RemDosEntry(struct DosLibrary *, struct DosList * dlist) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-672\n"
	"\tblrl";
#define RemDosEntry(dlist) __RemDosEntry(DOSBase, (dlist))

LONG __AddDosEntry(struct DosLibrary *, struct DosList * dlist) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-678\n"
	"\tblrl";
#define AddDosEntry(dlist) __AddDosEntry(DOSBase, (dlist))

struct DosList * __FindDosEntry(struct DosLibrary *, const struct DosList * dlist, CONST_STRPTR name, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-684\n"
	"\tblrl";
#define FindDosEntry(dlist, name, flags) __FindDosEntry(DOSBase, (dlist), (name), (flags))

struct DosList * __NextDosEntry(struct DosLibrary *, const struct DosList * dlist, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-690\n"
	"\tblrl";
#define NextDosEntry(dlist, flags) __NextDosEntry(DOSBase, (dlist), (flags))

struct DosList * __MakeDosEntry(struct DosLibrary *, CONST_STRPTR name, LONG type) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-696\n"
	"\tblrl";
#define MakeDosEntry(name, type) __MakeDosEntry(DOSBase, (name), (type))

VOID __FreeDosEntry(struct DosLibrary *, struct DosList * dlist) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-702\n"
	"\tblrl";
#define FreeDosEntry(dlist) __FreeDosEntry(DOSBase, (dlist))

BOOL __IsFileSystem(struct DosLibrary *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-708\n"
	"\tblrl";
#define IsFileSystem(name) __IsFileSystem(DOSBase, (name))

BOOL __Format(struct DosLibrary *, CONST_STRPTR filesystem, CONST_STRPTR volumename, ULONG dostype) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-714\n"
	"\tblrl";
#define Format(filesystem, volumename, dostype) __Format(DOSBase, (filesystem), (volumename), (dostype))

LONG __Relabel(struct DosLibrary *, CONST_STRPTR drive, CONST_STRPTR newname) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-720\n"
	"\tblrl";
#define Relabel(drive, newname) __Relabel(DOSBase, (drive), (newname))

LONG __Inhibit(struct DosLibrary *, CONST_STRPTR name, LONG onoff) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-726\n"
	"\tblrl";
#define Inhibit(name, onoff) __Inhibit(DOSBase, (name), (onoff))

LONG __AddBuffers(struct DosLibrary *, CONST_STRPTR name, LONG number) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-732\n"
	"\tblrl";
#define AddBuffers(name, number) __AddBuffers(DOSBase, (name), (number))

LONG __CompareDates(struct DosLibrary *, const struct DateStamp * date1, const struct DateStamp * date2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-738\n"
	"\tblrl";
#define CompareDates(date1, date2) __CompareDates(DOSBase, (date1), (date2))

LONG __DateToStr(struct DosLibrary *, struct DateTime * datetime) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-744\n"
	"\tblrl";
#define DateToStr(datetime) __DateToStr(DOSBase, (datetime))

LONG __StrToDate(struct DosLibrary *, struct DateTime * datetime) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-750\n"
	"\tblrl";
#define StrToDate(datetime) __StrToDate(DOSBase, (datetime))

BPTR __InternalLoadSeg(struct DosLibrary *, BPTR fh, BPTR table, const LONG * funcarray, LONG * stack) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,32(2)\n"
	"\tstw\t6,36(2)\n"
	"\tstw\t7,40(2)\n"
	"\tli\t3,-756\n"
	"\tblrl";
#define InternalLoadSeg(fh, table, funcarray, stack) __InternalLoadSeg(DOSBase, (fh), (table), (funcarray), (stack))

BOOL __InternalUnLoadSeg(struct DosLibrary *, BPTR seglist, VOID (*freefunc)()) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-762\n"
	"\tblrl";
#define InternalUnLoadSeg(seglist, freefunc) __InternalUnLoadSeg(DOSBase, (seglist), (freefunc))

BPTR __NewLoadSeg(struct DosLibrary *, CONST_STRPTR file, const struct TagItem * tags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-768\n"
	"\tblrl";
#define NewLoadSeg(file, tags) __NewLoadSeg(DOSBase, (file), (tags))

#define NewLoadSegTagList(file, tags) __NewLoadSeg((file), (tags), DOSBase)

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
BPTR __NewLoadSegTags(struct DosLibrary *, long, long, long, long, long, long, CONST_STRPTR file, ULONG tags, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t10,4(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,8(2)\n"
	"\tli\t3,-768\n"
	"\tblrl";
#define NewLoadSegTags(file, ...) __NewLoadSegTags(DOSBase, 0, 0, 0, 0, 0, 0, (file), __VA_ARGS__)
#endif

LONG __AddSegment(struct DosLibrary *, CONST_STRPTR name, BPTR seg, LONG system) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-774\n"
	"\tblrl";
#define AddSegment(name, seg, system) __AddSegment(DOSBase, (name), (seg), (system))

struct Segment * __FindSegment(struct DosLibrary *, CONST_STRPTR name, const struct Segment * seg, LONG system) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-780\n"
	"\tblrl";
#define FindSegment(name, seg, system) __FindSegment(DOSBase, (name), (seg), (system))

LONG __RemSegment(struct DosLibrary *, struct Segment * seg) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-786\n"
	"\tblrl";
#define RemSegment(seg) __RemSegment(DOSBase, (seg))

LONG __CheckSignal(struct DosLibrary *, LONG mask) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-792\n"
	"\tblrl";
#define CheckSignal(mask) __CheckSignal(DOSBase, (mask))

struct RDArgs * __ReadArgs(struct DosLibrary *, CONST_STRPTR arg_template, LONG * array, struct RDArgs * args) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-798\n"
	"\tblrl";
#define ReadArgs(arg_template, array, args) __ReadArgs(DOSBase, (arg_template), (array), (args))

LONG __FindArg(struct DosLibrary *, CONST_STRPTR keyword, CONST_STRPTR arg_template) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-804\n"
	"\tblrl";
#define FindArg(keyword, arg_template) __FindArg(DOSBase, (keyword), (arg_template))

LONG __ReadItem(struct DosLibrary *, CONST_STRPTR name, LONG maxchars, struct CSource * cSource) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-810\n"
	"\tblrl";
#define ReadItem(name, maxchars, cSource) __ReadItem(DOSBase, (name), (maxchars), (cSource))

LONG __StrToLong(struct DosLibrary *, CONST_STRPTR string, LONG * value) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-816\n"
	"\tblrl";
#define StrToLong(string, value) __StrToLong(DOSBase, (string), (value))

LONG __MatchFirst(struct DosLibrary *, CONST_STRPTR pat, struct AnchorPath * anchor) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-822\n"
	"\tblrl";
#define MatchFirst(pat, anchor) __MatchFirst(DOSBase, (pat), (anchor))

LONG __MatchNext(struct DosLibrary *, struct AnchorPath * anchor) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-828\n"
	"\tblrl";
#define MatchNext(anchor) __MatchNext(DOSBase, (anchor))

VOID __MatchEnd(struct DosLibrary *, struct AnchorPath * anchor) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-834\n"
	"\tblrl";
#define MatchEnd(anchor) __MatchEnd(DOSBase, (anchor))

LONG __ParsePattern(struct DosLibrary *, CONST_STRPTR pat, STRPTR buf, LONG buflen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-840\n"
	"\tblrl";
#define ParsePattern(pat, buf, buflen) __ParsePattern(DOSBase, (pat), (buf), (buflen))

BOOL __MatchPattern(struct DosLibrary *, CONST_STRPTR pat, STRPTR str) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-846\n"
	"\tblrl";
#define MatchPattern(pat, str) __MatchPattern(DOSBase, (pat), (str))

VOID __FreeArgs(struct DosLibrary *, struct RDArgs * args) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-858\n"
	"\tblrl";
#define FreeArgs(args) __FreeArgs(DOSBase, (args))

STRPTR __FilePart(struct DosLibrary *, CONST_STRPTR path) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-870\n"
	"\tblrl";
#define FilePart(path) __FilePart(DOSBase, (path))

STRPTR __PathPart(struct DosLibrary *, CONST_STRPTR path) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-876\n"
	"\tblrl";
#define PathPart(path) __PathPart(DOSBase, (path))

BOOL __AddPart(struct DosLibrary *, STRPTR dirname, CONST_STRPTR filename, ULONG size) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-882\n"
	"\tblrl";
#define AddPart(dirname, filename, size) __AddPart(DOSBase, (dirname), (filename), (size))

BOOL __StartNotify(struct DosLibrary *, struct NotifyRequest * notify) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-888\n"
	"\tblrl";
#define StartNotify(notify) __StartNotify(DOSBase, (notify))

VOID __EndNotify(struct DosLibrary *, struct NotifyRequest * notify) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-894\n"
	"\tblrl";
#define EndNotify(notify) __EndNotify(DOSBase, (notify))

BOOL __SetVar(struct DosLibrary *, CONST_STRPTR name, CONST_STRPTR buffer, LONG size, LONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tli\t3,-900\n"
	"\tblrl";
#define SetVar(name, buffer, size, flags) __SetVar(DOSBase, (name), (buffer), (size), (flags))

LONG __GetVar(struct DosLibrary *, CONST_STRPTR name, STRPTR buffer, LONG size, LONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tli\t3,-906\n"
	"\tblrl";
#define GetVar(name, buffer, size, flags) __GetVar(DOSBase, (name), (buffer), (size), (flags))

LONG __DeleteVar(struct DosLibrary *, CONST_STRPTR name, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-912\n"
	"\tblrl";
#define DeleteVar(name, flags) __DeleteVar(DOSBase, (name), (flags))

struct LocalVar * __FindVar(struct DosLibrary *, CONST_STRPTR name, ULONG type) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-918\n"
	"\tblrl";
#define FindVar(name, type) __FindVar(DOSBase, (name), (type))

LONG __CliInitNewcli(struct DosLibrary *, struct DosPacket * dp) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-930\n"
	"\tblrl";
#define CliInitNewcli(dp) __CliInitNewcli(DOSBase, (dp))

LONG __CliInitRun(struct DosLibrary *, struct DosPacket * dp) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-936\n"
	"\tblrl";
#define CliInitRun(dp) __CliInitRun(DOSBase, (dp))

LONG __WriteChars(struct DosLibrary *, CONST_STRPTR buf, ULONG buflen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-942\n"
	"\tblrl";
#define WriteChars(buf, buflen) __WriteChars(DOSBase, (buf), (buflen))

LONG __PutStr(struct DosLibrary *, CONST_STRPTR str) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-948\n"
	"\tblrl";
#define PutStr(str) __PutStr(DOSBase, (str))

LONG __VPrintf(struct DosLibrary *, CONST_STRPTR format, const APTR argarray) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-954\n"
	"\tblrl";
#define VPrintf(format, argarray) __VPrintf(DOSBase, (format), (argarray))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
LONG __Printf(struct DosLibrary *, long, long, long, long, long, long, CONST_STRPTR format, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t10,4(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,8(2)\n"
	"\tli\t3,-954\n"
	"\tblrl";
#define Printf(...) __Printf(DOSBase, 0, 0, 0, 0, 0, 0, __VA_ARGS__)
#endif

LONG __ParsePatternNoCase(struct DosLibrary *, CONST_STRPTR pat, UBYTE * buf, LONG buflen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tli\t3,-966\n"
	"\tblrl";
#define ParsePatternNoCase(pat, buf, buflen) __ParsePatternNoCase(DOSBase, (pat), (buf), (buflen))

BOOL __MatchPatternNoCase(struct DosLibrary *, CONST_STRPTR pat, STRPTR str) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-972\n"
	"\tblrl";
#define MatchPatternNoCase(pat, str) __MatchPatternNoCase(DOSBase, (pat), (str))

BOOL __SameDevice(struct DosLibrary *, BPTR lock1, BPTR lock2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-984\n"
	"\tblrl";
#define SameDevice(lock1, lock2) __SameDevice(DOSBase, (lock1), (lock2))

VOID __ExAllEnd(struct DosLibrary *, BPTR lock, struct ExAllData * buffer, LONG size, LONG data, struct ExAllControl * control) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tstw\t6,12(2)\n"
	"\tstw\t7,16(2)\n"
	"\tstw\t8,20(2)\n"
	"\tli\t3,-990\n"
	"\tblrl";
#define ExAllEnd(lock, buffer, size, data, control) __ExAllEnd(DOSBase, (lock), (buffer), (size), (data), (control))

BOOL __SetOwner(struct DosLibrary *, CONST_STRPTR name, LONG owner_info) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tstw\t5,8(2)\n"
	"\tli\t3,-996\n"
	"\tblrl";
#define SetOwner(name, owner_info) __SetOwner(DOSBase, (name), (owner_info))

#endif /*  _VBCCINLINE_DOS_H  */
