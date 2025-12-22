
#ifndef _DOSLIBRARY_CPP
#define _DOSLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/DOSLibrary.h>

DOSLibrary::DOSLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("dos.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open dos.library") );
	}
}

DOSLibrary::~DOSLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

BPTR DOSLibrary::Open(CONST_STRPTR name, LONG accessMode)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register int d2 __asm("d2") = accessMode;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BPTR) _res;
}

LONG DOSLibrary::Close(BPTR file)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = file;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

LONG DOSLibrary::Read(BPTR file, APTR buffer, LONG length)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = file;
	register void * d2 __asm("d2") = buffer;
	register int d3 __asm("d3") = length;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

LONG DOSLibrary::Write(BPTR file, CONST APTR buffer, LONG length)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = file;
	register const void * d2 __asm("d2") = buffer;
	register int d3 __asm("d3") = length;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

BPTR DOSLibrary::Input()
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (BPTR) _res;
}

BPTR DOSLibrary::Output()
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (BPTR) _res;
}

LONG DOSLibrary::Seek(BPTR file, LONG position, LONG offset)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = file;
	register int d2 __asm("d2") = position;
	register int d3 __asm("d3") = offset;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

LONG DOSLibrary::DeleteFile(CONST_STRPTR name)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

LONG DOSLibrary::Rename(CONST_STRPTR oldName, CONST_STRPTR newName)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = oldName;
	register const char * d2 __asm("d2") = newName;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

BPTR DOSLibrary::Lock(CONST_STRPTR name, LONG type)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register int d2 __asm("d2") = type;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BPTR) _res;
}

VOID DOSLibrary::UnLock(BPTR lock)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;

	__asm volatile ("jsr a6@(-90)"
	: 
	: "r" (a6), "r" (d1)
	: "d1");
}

BPTR DOSLibrary::DupLock(BPTR lock)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BPTR) _res;
}

LONG DOSLibrary::Examine(BPTR lock, struct FileInfoBlock * fileInfoBlock)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;
	register void * d2 __asm("d2") = fileInfoBlock;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::ExNext(BPTR lock, struct FileInfoBlock * fileInfoBlock)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;
	register void * d2 __asm("d2") = fileInfoBlock;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::Info(BPTR lock, struct InfoData * parameterBlock)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;
	register void * d2 __asm("d2") = parameterBlock;

	__asm volatile ("jsr a6@(-114)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

BPTR DOSLibrary::CreateDir(CONST_STRPTR name)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;

	__asm volatile ("jsr a6@(-120)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BPTR) _res;
}

BPTR DOSLibrary::CurrentDir(BPTR lock)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BPTR) _res;
}

LONG DOSLibrary::IoErr()
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (LONG) _res;
}

struct MsgPort * DOSLibrary::CreateProc(CONST_STRPTR name, LONG pri, BPTR segList, LONG stackSize)
{
	register struct MsgPort * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register int d2 __asm("d2") = pri;
	register unsigned int d3 __asm("d3") = segList;
	register int d4 __asm("d4") = stackSize;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "d1", "d2", "d3", "d4");
	return (struct MsgPort *) _res;
}

VOID DOSLibrary::Exit(LONG returnCode)
{
	register void * a6 __asm("a6") = Base;
	register int d1 __asm("d1") = returnCode;

	__asm volatile ("jsr a6@(-144)"
	: 
	: "r" (a6), "r" (d1)
	: "d1");
}

BPTR DOSLibrary::LoadSeg(CONST_STRPTR name)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;

	__asm volatile ("jsr a6@(-150)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BPTR) _res;
}

VOID DOSLibrary::UnLoadSeg(BPTR seglist)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = seglist;

	__asm volatile ("jsr a6@(-156)"
	: 
	: "r" (a6), "r" (d1)
	: "d1");
}

struct MsgPort * DOSLibrary::DeviceProc(CONST_STRPTR name)
{
	register struct MsgPort * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;

	__asm volatile ("jsr a6@(-174)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (struct MsgPort *) _res;
}

LONG DOSLibrary::SetComment(CONST_STRPTR name, CONST_STRPTR comment)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register const char * d2 __asm("d2") = comment;

	__asm volatile ("jsr a6@(-180)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::SetProtection(CONST_STRPTR name, LONG protect)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register int d2 __asm("d2") = protect;

	__asm volatile ("jsr a6@(-186)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

struct DateStamp * DOSLibrary::DateStamp(struct DateStamp * date)
{
	register struct DateStamp * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = date;

	__asm volatile ("jsr a6@(-192)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (struct DateStamp *) _res;
}

VOID DOSLibrary::Delay(LONG timeout)
{
	register void * a6 __asm("a6") = Base;
	register int d1 __asm("d1") = timeout;

	__asm volatile ("jsr a6@(-198)"
	: 
	: "r" (a6), "r" (d1)
	: "d1");
}

LONG DOSLibrary::WaitForChar(BPTR file, LONG timeout)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = file;
	register int d2 __asm("d2") = timeout;

	__asm volatile ("jsr a6@(-204)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

BPTR DOSLibrary::ParentDir(BPTR lock)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;

	__asm volatile ("jsr a6@(-210)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BPTR) _res;
}

LONG DOSLibrary::IsInteractive(BPTR file)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = file;

	__asm volatile ("jsr a6@(-216)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

LONG DOSLibrary::Execute(CONST_STRPTR string, BPTR file, BPTR file2)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = string;
	register unsigned int d2 __asm("d2") = file;
	register unsigned int d3 __asm("d3") = file2;

	__asm volatile ("jsr a6@(-222)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

APTR DOSLibrary::AllocDosObject(ULONG type, CONST struct TagItem * tags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = type;
	register const void * d2 __asm("d2") = tags;

	__asm volatile ("jsr a6@(-228)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (APTR) _res;
}

VOID DOSLibrary::FreeDosObject(ULONG type, APTR ptr)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = type;
	register void * d2 __asm("d2") = ptr;

	__asm volatile ("jsr a6@(-234)"
	: 
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
}

LONG DOSLibrary::DoPkt(struct MsgPort * port, LONG action, LONG arg1, LONG arg2, LONG arg3, LONG arg4, LONG arg5)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = port;
	register int d2 __asm("d2") = action;
	register int d3 __asm("d3") = arg1;
	register int d4 __asm("d4") = arg2;
	register int d5 __asm("d5") = arg3;
	register int d6 __asm("d6") = arg4;
	register int d7 __asm("d7") = arg5;

	__asm volatile ("jsr a6@(-240)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5), "r" (d6), "r" (d7)
	: "d1", "d2", "d3", "d4", "d5", "d6", "d7");
	return (LONG) _res;
}

VOID DOSLibrary::SendPkt(struct DosPacket * dp, struct MsgPort * port, struct MsgPort * replyport)
{
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = dp;
	register void * d2 __asm("d2") = port;
	register void * d3 __asm("d3") = replyport;

	__asm volatile ("jsr a6@(-246)"
	: 
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
}

struct DosPacket * DOSLibrary::WaitPkt()
{
	register struct DosPacket * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-252)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct DosPacket *) _res;
}

VOID DOSLibrary::ReplyPkt(struct DosPacket * dp, LONG res1, LONG res2)
{
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = dp;
	register int d2 __asm("d2") = res1;
	register int d3 __asm("d3") = res2;

	__asm volatile ("jsr a6@(-258)"
	: 
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
}

VOID DOSLibrary::AbortPkt(struct MsgPort * port, struct DosPacket * pkt)
{
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = port;
	register void * d2 __asm("d2") = pkt;

	__asm volatile ("jsr a6@(-264)"
	: 
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
}

BOOL DOSLibrary::LockRecord(BPTR fh, ULONG offset, ULONG length, ULONG mode, ULONG timeout)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register unsigned int d2 __asm("d2") = offset;
	register unsigned int d3 __asm("d3") = length;
	register unsigned int d4 __asm("d4") = mode;
	register unsigned int d5 __asm("d5") = timeout;

	__asm volatile ("jsr a6@(-270)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
	: "d1", "d2", "d3", "d4", "d5");
	return (BOOL) _res;
}

BOOL DOSLibrary::LockRecords(struct RecordLock * recArray, ULONG timeout)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = recArray;
	register unsigned int d2 __asm("d2") = timeout;

	__asm volatile ("jsr a6@(-276)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

BOOL DOSLibrary::UnLockRecord(BPTR fh, ULONG offset, ULONG length)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register unsigned int d2 __asm("d2") = offset;
	register unsigned int d3 __asm("d3") = length;

	__asm volatile ("jsr a6@(-282)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (BOOL) _res;
}

BOOL DOSLibrary::UnLockRecords(struct RecordLock * recArray)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = recArray;

	__asm volatile ("jsr a6@(-288)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BOOL) _res;
}

BPTR DOSLibrary::SelectInput(BPTR fh)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;

	__asm volatile ("jsr a6@(-294)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BPTR) _res;
}

BPTR DOSLibrary::SelectOutput(BPTR fh)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;

	__asm volatile ("jsr a6@(-300)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BPTR) _res;
}

LONG DOSLibrary::FGetC(BPTR fh)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;

	__asm volatile ("jsr a6@(-306)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

LONG DOSLibrary::FPutC(BPTR fh, LONG ch)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register int d2 __asm("d2") = ch;

	__asm volatile ("jsr a6@(-312)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::UnGetC(BPTR fh, LONG character)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register int d2 __asm("d2") = character;

	__asm volatile ("jsr a6@(-318)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::FRead(BPTR fh, APTR block, ULONG blocklen, ULONG number)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register void * d2 __asm("d2") = block;
	register unsigned int d3 __asm("d3") = blocklen;
	register unsigned int d4 __asm("d4") = number;

	__asm volatile ("jsr a6@(-324)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "d1", "d2", "d3", "d4");
	return (LONG) _res;
}

LONG DOSLibrary::FWrite(BPTR fh, CONST APTR block, ULONG blocklen, ULONG number)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register const void * d2 __asm("d2") = block;
	register unsigned int d3 __asm("d3") = blocklen;
	register unsigned int d4 __asm("d4") = number;

	__asm volatile ("jsr a6@(-330)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "d1", "d2", "d3", "d4");
	return (LONG) _res;
}

STRPTR DOSLibrary::FGets(BPTR fh, STRPTR buf, ULONG buflen)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register char * d2 __asm("d2") = buf;
	register unsigned int d3 __asm("d3") = buflen;

	__asm volatile ("jsr a6@(-336)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (STRPTR) _res;
}

LONG DOSLibrary::FPuts(BPTR fh, CONST_STRPTR str)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register const char * d2 __asm("d2") = str;

	__asm volatile ("jsr a6@(-342)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

VOID DOSLibrary::VFWritef(BPTR fh, CONST_STRPTR format, CONST LONG * argarray)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register const char * d2 __asm("d2") = format;
	register const void * d3 __asm("d3") = argarray;

	__asm volatile ("jsr a6@(-348)"
	: 
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
}

LONG DOSLibrary::VFPrintf(BPTR fh, CONST_STRPTR format, CONST APTR argarray)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register const char * d2 __asm("d2") = format;
	register const void * d3 __asm("d3") = argarray;

	__asm volatile ("jsr a6@(-354)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

LONG DOSLibrary::Flush(BPTR fh)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;

	__asm volatile ("jsr a6@(-360)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

LONG DOSLibrary::SetVBuf(BPTR fh, STRPTR buff, LONG type, LONG size)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register char * d2 __asm("d2") = buff;
	register int d3 __asm("d3") = type;
	register int d4 __asm("d4") = size;

	__asm volatile ("jsr a6@(-366)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "d1", "d2", "d3", "d4");
	return (LONG) _res;
}

BPTR DOSLibrary::DupLockFromFH(BPTR fh)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;

	__asm volatile ("jsr a6@(-372)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BPTR) _res;
}

BPTR DOSLibrary::OpenFromLock(BPTR lock)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;

	__asm volatile ("jsr a6@(-378)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BPTR) _res;
}

BPTR DOSLibrary::ParentOfFH(BPTR fh)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;

	__asm volatile ("jsr a6@(-384)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BPTR) _res;
}

BOOL DOSLibrary::ExamineFH(BPTR fh, struct FileInfoBlock * fib)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register void * d2 __asm("d2") = fib;

	__asm volatile ("jsr a6@(-390)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

LONG DOSLibrary::SetFileDate(CONST_STRPTR name, CONST struct DateStamp * date)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register const void * d2 __asm("d2") = date;

	__asm volatile ("jsr a6@(-396)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::NameFromLock(BPTR lock, STRPTR buffer, LONG len)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;
	register char * d2 __asm("d2") = buffer;
	register int d3 __asm("d3") = len;

	__asm volatile ("jsr a6@(-402)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

LONG DOSLibrary::NameFromFH(BPTR fh, STRPTR buffer, LONG len)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register char * d2 __asm("d2") = buffer;
	register int d3 __asm("d3") = len;

	__asm volatile ("jsr a6@(-408)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

WORD DOSLibrary::SplitName(CONST_STRPTR name, ULONG separator, STRPTR buf, LONG oldpos, LONG size)
{
	register WORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register unsigned int d2 __asm("d2") = separator;
	register char * d3 __asm("d3") = buf;
	register int d4 __asm("d4") = oldpos;
	register int d5 __asm("d5") = size;

	__asm volatile ("jsr a6@(-414)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
	: "d1", "d2", "d3", "d4", "d5");
	return (WORD) _res;
}

LONG DOSLibrary::SameLock(BPTR lock1, BPTR lock2)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock1;
	register unsigned int d2 __asm("d2") = lock2;

	__asm volatile ("jsr a6@(-420)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::SetMode(BPTR fh, LONG mode)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register int d2 __asm("d2") = mode;

	__asm volatile ("jsr a6@(-426)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::ExAll(BPTR lock, struct ExAllData * buffer, LONG size, LONG data, struct ExAllControl * control)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;
	register void * d2 __asm("d2") = buffer;
	register int d3 __asm("d3") = size;
	register int d4 __asm("d4") = data;
	register void * d5 __asm("d5") = control;

	__asm volatile ("jsr a6@(-432)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
	: "d1", "d2", "d3", "d4", "d5");
	return (LONG) _res;
}

LONG DOSLibrary::ReadLink(struct MsgPort * port, BPTR lock, CONST_STRPTR path, STRPTR buffer, ULONG size)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = port;
	register unsigned int d2 __asm("d2") = lock;
	register const char * d3 __asm("d3") = path;
	register char * d4 __asm("d4") = buffer;
	register unsigned int d5 __asm("d5") = size;

	__asm volatile ("jsr a6@(-438)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
	: "d1", "d2", "d3", "d4", "d5");
	return (LONG) _res;
}

LONG DOSLibrary::MakeLink(CONST_STRPTR name, LONG dest, LONG soft)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register int d2 __asm("d2") = dest;
	register int d3 __asm("d3") = soft;

	__asm volatile ("jsr a6@(-444)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

LONG DOSLibrary::ChangeMode(LONG type, BPTR fh, LONG newmode)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d1 __asm("d1") = type;
	register unsigned int d2 __asm("d2") = fh;
	register int d3 __asm("d3") = newmode;

	__asm volatile ("jsr a6@(-450)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

LONG DOSLibrary::SetFileSize(BPTR fh, LONG pos, LONG mode)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = fh;
	register int d2 __asm("d2") = pos;
	register int d3 __asm("d3") = mode;

	__asm volatile ("jsr a6@(-456)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

LONG DOSLibrary::SetIoErr(LONG result)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d1 __asm("d1") = result;

	__asm volatile ("jsr a6@(-462)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

BOOL DOSLibrary::Fault(LONG code, STRPTR header, STRPTR buffer, LONG len)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d1 __asm("d1") = code;
	register char * d2 __asm("d2") = header;
	register char * d3 __asm("d3") = buffer;
	register int d4 __asm("d4") = len;

	__asm volatile ("jsr a6@(-468)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "d1", "d2", "d3", "d4");
	return (BOOL) _res;
}

BOOL DOSLibrary::PrintFault(LONG code, CONST_STRPTR header)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d1 __asm("d1") = code;
	register const char * d2 __asm("d2") = header;

	__asm volatile ("jsr a6@(-474)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

LONG DOSLibrary::ErrorReport(LONG code, LONG type, ULONG arg1, struct MsgPort * device)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d1 __asm("d1") = code;
	register int d2 __asm("d2") = type;
	register unsigned int d3 __asm("d3") = arg1;
	register void * d4 __asm("d4") = device;

	__asm volatile ("jsr a6@(-480)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "d1", "d2", "d3", "d4");
	return (LONG) _res;
}

struct CommandLineInterface * DOSLibrary::Cli()
{
	register struct CommandLineInterface * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-492)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct CommandLineInterface *) _res;
}

struct Process * DOSLibrary::CreateNewProc(CONST struct TagItem * tags)
{
	register struct Process * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * d1 __asm("d1") = tags;

	__asm volatile ("jsr a6@(-498)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (struct Process *) _res;
}

LONG DOSLibrary::RunCommand(BPTR seg, LONG stack, CONST_STRPTR paramptr, LONG paramlen)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = seg;
	register int d2 __asm("d2") = stack;
	register const char * d3 __asm("d3") = paramptr;
	register int d4 __asm("d4") = paramlen;

	__asm volatile ("jsr a6@(-504)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "d1", "d2", "d3", "d4");
	return (LONG) _res;
}

struct MsgPort * DOSLibrary::GetConsoleTask()
{
	register struct MsgPort * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-510)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct MsgPort *) _res;
}

struct MsgPort * DOSLibrary::SetConsoleTask(CONST struct MsgPort * task)
{
	register struct MsgPort * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * d1 __asm("d1") = task;

	__asm volatile ("jsr a6@(-516)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (struct MsgPort *) _res;
}

struct MsgPort * DOSLibrary::GetFileSysTask()
{
	register struct MsgPort * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-522)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct MsgPort *) _res;
}

struct MsgPort * DOSLibrary::SetFileSysTask(CONST struct MsgPort * task)
{
	register struct MsgPort * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * d1 __asm("d1") = task;

	__asm volatile ("jsr a6@(-528)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (struct MsgPort *) _res;
}

STRPTR DOSLibrary::GetArgStr()
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-534)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (STRPTR) _res;
}

BOOL DOSLibrary::SetArgStr(CONST_STRPTR string)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = string;

	__asm volatile ("jsr a6@(-540)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BOOL) _res;
}

struct Process * DOSLibrary::FindCliProc(ULONG num)
{
	register struct Process * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = num;

	__asm volatile ("jsr a6@(-546)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (struct Process *) _res;
}

ULONG DOSLibrary::MaxCli()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-552)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}

BOOL DOSLibrary::SetCurrentDirName(CONST_STRPTR name)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;

	__asm volatile ("jsr a6@(-558)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BOOL) _res;
}

BOOL DOSLibrary::GetCurrentDirName(STRPTR buf, LONG len)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * d1 __asm("d1") = buf;
	register int d2 __asm("d2") = len;

	__asm volatile ("jsr a6@(-564)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

BOOL DOSLibrary::SetProgramName(CONST_STRPTR name)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;

	__asm volatile ("jsr a6@(-570)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BOOL) _res;
}

BOOL DOSLibrary::GetProgramName(STRPTR buf, LONG len)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * d1 __asm("d1") = buf;
	register int d2 __asm("d2") = len;

	__asm volatile ("jsr a6@(-576)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

BOOL DOSLibrary::SetPrompt(CONST_STRPTR name)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;

	__asm volatile ("jsr a6@(-582)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BOOL) _res;
}

BOOL DOSLibrary::GetPrompt(STRPTR buf, LONG len)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * d1 __asm("d1") = buf;
	register int d2 __asm("d2") = len;

	__asm volatile ("jsr a6@(-588)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

BPTR DOSLibrary::SetProgramDir(BPTR lock)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;

	__asm volatile ("jsr a6@(-594)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BPTR) _res;
}

BPTR DOSLibrary::GetProgramDir()
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-600)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (BPTR) _res;
}

LONG DOSLibrary::SystemTagList(CONST_STRPTR command, CONST struct TagItem * tags)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = command;
	register const void * d2 __asm("d2") = tags;

	__asm volatile ("jsr a6@(-606)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::AssignLock(CONST_STRPTR name, BPTR lock)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register unsigned int d2 __asm("d2") = lock;

	__asm volatile ("jsr a6@(-612)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

BOOL DOSLibrary::AssignLate(CONST_STRPTR name, CONST_STRPTR path)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register const char * d2 __asm("d2") = path;

	__asm volatile ("jsr a6@(-618)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

BOOL DOSLibrary::AssignPath(CONST_STRPTR name, CONST_STRPTR path)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register const char * d2 __asm("d2") = path;

	__asm volatile ("jsr a6@(-624)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

BOOL DOSLibrary::AssignAdd(CONST_STRPTR name, BPTR lock)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register unsigned int d2 __asm("d2") = lock;

	__asm volatile ("jsr a6@(-630)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

LONG DOSLibrary::RemAssignList(CONST_STRPTR name, BPTR lock)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register unsigned int d2 __asm("d2") = lock;

	__asm volatile ("jsr a6@(-636)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

struct DevProc * DOSLibrary::GetDeviceProc(CONST_STRPTR name, struct DevProc * dp)
{
	register struct DevProc * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register void * d2 __asm("d2") = dp;

	__asm volatile ("jsr a6@(-642)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (struct DevProc *) _res;
}

VOID DOSLibrary::FreeDeviceProc(struct DevProc * dp)
{
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = dp;

	__asm volatile ("jsr a6@(-648)"
	: 
	: "r" (a6), "r" (d1)
	: "d1");
}

struct DosList * DOSLibrary::LockDosList(ULONG flags)
{
	register struct DosList * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = flags;

	__asm volatile ("jsr a6@(-654)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (struct DosList *) _res;
}

VOID DOSLibrary::UnLockDosList(ULONG flags)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = flags;

	__asm volatile ("jsr a6@(-660)"
	: 
	: "r" (a6), "r" (d1)
	: "d1");
}

struct DosList * DOSLibrary::AttemptLockDosList(ULONG flags)
{
	register struct DosList * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = flags;

	__asm volatile ("jsr a6@(-666)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (struct DosList *) _res;
}

BOOL DOSLibrary::RemDosEntry(struct DosList * dlist)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = dlist;

	__asm volatile ("jsr a6@(-672)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BOOL) _res;
}

LONG DOSLibrary::AddDosEntry(struct DosList * dlist)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = dlist;

	__asm volatile ("jsr a6@(-678)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

struct DosList * DOSLibrary::FindDosEntry(CONST struct DosList * dlist, CONST_STRPTR name, ULONG flags)
{
	register struct DosList * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * d1 __asm("d1") = dlist;
	register const char * d2 __asm("d2") = name;
	register unsigned int d3 __asm("d3") = flags;

	__asm volatile ("jsr a6@(-684)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (struct DosList *) _res;
}

struct DosList * DOSLibrary::NextDosEntry(CONST struct DosList * dlist, ULONG flags)
{
	register struct DosList * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * d1 __asm("d1") = dlist;
	register unsigned int d2 __asm("d2") = flags;

	__asm volatile ("jsr a6@(-690)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (struct DosList *) _res;
}

struct DosList * DOSLibrary::MakeDosEntry(CONST_STRPTR name, LONG type)
{
	register struct DosList * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register int d2 __asm("d2") = type;

	__asm volatile ("jsr a6@(-696)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (struct DosList *) _res;
}

VOID DOSLibrary::FreeDosEntry(struct DosList * dlist)
{
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = dlist;

	__asm volatile ("jsr a6@(-702)"
	: 
	: "r" (a6), "r" (d1)
	: "d1");
}

BOOL DOSLibrary::IsFileSystem(CONST_STRPTR name)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;

	__asm volatile ("jsr a6@(-708)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BOOL) _res;
}

BOOL DOSLibrary::Format(CONST_STRPTR filesystem, CONST_STRPTR volumename, ULONG dostype)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = filesystem;
	register const char * d2 __asm("d2") = volumename;
	register unsigned int d3 __asm("d3") = dostype;

	__asm volatile ("jsr a6@(-714)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (BOOL) _res;
}

LONG DOSLibrary::Relabel(CONST_STRPTR drive, CONST_STRPTR newname)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = drive;
	register const char * d2 __asm("d2") = newname;

	__asm volatile ("jsr a6@(-720)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::Inhibit(CONST_STRPTR name, LONG onoff)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register int d2 __asm("d2") = onoff;

	__asm volatile ("jsr a6@(-726)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::AddBuffers(CONST_STRPTR name, LONG number)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register int d2 __asm("d2") = number;

	__asm volatile ("jsr a6@(-732)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::CompareDates(CONST struct DateStamp * date1, CONST struct DateStamp * date2)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * d1 __asm("d1") = date1;
	register const void * d2 __asm("d2") = date2;

	__asm volatile ("jsr a6@(-738)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::DateToStr(struct DateTime * datetime)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = datetime;

	__asm volatile ("jsr a6@(-744)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

LONG DOSLibrary::StrToDate(struct DateTime * datetime)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = datetime;

	__asm volatile ("jsr a6@(-750)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

BPTR DOSLibrary::InternalLoadSeg(BPTR fh, BPTR table, CONST LONG * funcarray, LONG * stack)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = fh;
	register unsigned int a0 __asm("a0") = table;
	register const void * a1 __asm("a1") = funcarray;
	register void * a2 __asm("a2") = stack;

	__asm volatile ("jsr a6@(-756)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (a1), "r" (a2)
	: "d0", "a0", "a1", "a2");
	return (BPTR) _res;
}

BOOL DOSLibrary::InternalUnLoadSeg(BPTR seglist, int freefunc)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = seglist;
	register int a1 __asm("a1") = freefunc;

	__asm volatile ("jsr a6@(-762)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (a1)
	: "d1", "a1");
	return (BOOL) _res;
}

BPTR DOSLibrary::NewLoadSeg(CONST_STRPTR file, CONST struct TagItem * tags)
{
	register BPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = file;
	register const void * d2 __asm("d2") = tags;

	__asm volatile ("jsr a6@(-768)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BPTR) _res;
}

LONG DOSLibrary::AddSegment(CONST_STRPTR name, BPTR seg, LONG system)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register unsigned int d2 __asm("d2") = seg;
	register int d3 __asm("d3") = system;

	__asm volatile ("jsr a6@(-774)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

struct Segment * DOSLibrary::FindSegment(CONST_STRPTR name, CONST struct Segment * seg, LONG system)
{
	register struct Segment * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register const void * d2 __asm("d2") = seg;
	register int d3 __asm("d3") = system;

	__asm volatile ("jsr a6@(-780)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (struct Segment *) _res;
}

LONG DOSLibrary::RemSegment(struct Segment * seg)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = seg;

	__asm volatile ("jsr a6@(-786)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

LONG DOSLibrary::CheckSignal(LONG mask)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d1 __asm("d1") = mask;

	__asm volatile ("jsr a6@(-792)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

struct RDArgs * DOSLibrary::ReadArgs(CONST_STRPTR arg_template, LONG * array, struct RDArgs * args)
{
	register struct RDArgs * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = arg_template;
	register void * d2 __asm("d2") = array;
	register void * d3 __asm("d3") = args;

	__asm volatile ("jsr a6@(-798)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (struct RDArgs *) _res;
}

LONG DOSLibrary::FindArg(CONST_STRPTR keyword, CONST_STRPTR arg_template)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = keyword;
	register const char * d2 __asm("d2") = arg_template;

	__asm volatile ("jsr a6@(-804)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::ReadItem(CONST_STRPTR name, LONG maxchars, struct CSource * cSource)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register int d2 __asm("d2") = maxchars;
	register void * d3 __asm("d3") = cSource;

	__asm volatile ("jsr a6@(-810)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

LONG DOSLibrary::StrToLong(CONST_STRPTR string, LONG * value)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = string;
	register void * d2 __asm("d2") = value;

	__asm volatile ("jsr a6@(-816)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::MatchFirst(CONST_STRPTR pat, struct AnchorPath * anchor)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = pat;
	register void * d2 __asm("d2") = anchor;

	__asm volatile ("jsr a6@(-822)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::MatchNext(struct AnchorPath * anchor)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = anchor;

	__asm volatile ("jsr a6@(-828)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

VOID DOSLibrary::MatchEnd(struct AnchorPath * anchor)
{
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = anchor;

	__asm volatile ("jsr a6@(-834)"
	: 
	: "r" (a6), "r" (d1)
	: "d1");
}

LONG DOSLibrary::ParsePattern(CONST_STRPTR pat, STRPTR buf, LONG buflen)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = pat;
	register char * d2 __asm("d2") = buf;
	register int d3 __asm("d3") = buflen;

	__asm volatile ("jsr a6@(-840)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

BOOL DOSLibrary::MatchPattern(CONST_STRPTR pat, STRPTR str)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = pat;
	register char * d2 __asm("d2") = str;

	__asm volatile ("jsr a6@(-846)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

VOID DOSLibrary::FreeArgs(struct RDArgs * args)
{
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = args;

	__asm volatile ("jsr a6@(-858)"
	: 
	: "r" (a6), "r" (d1)
	: "d1");
}

STRPTR DOSLibrary::FilePart(CONST_STRPTR path)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = path;

	__asm volatile ("jsr a6@(-870)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (STRPTR) _res;
}

STRPTR DOSLibrary::PathPart(CONST_STRPTR path)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = path;

	__asm volatile ("jsr a6@(-876)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (STRPTR) _res;
}

BOOL DOSLibrary::AddPart(STRPTR dirname, CONST_STRPTR filename, ULONG size)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * d1 __asm("d1") = dirname;
	register const char * d2 __asm("d2") = filename;
	register unsigned int d3 __asm("d3") = size;

	__asm volatile ("jsr a6@(-882)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (BOOL) _res;
}

BOOL DOSLibrary::StartNotify(struct NotifyRequest * notify)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = notify;

	__asm volatile ("jsr a6@(-888)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (BOOL) _res;
}

VOID DOSLibrary::EndNotify(struct NotifyRequest * notify)
{
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = notify;

	__asm volatile ("jsr a6@(-894)"
	: 
	: "r" (a6), "r" (d1)
	: "d1");
}

BOOL DOSLibrary::SetVar(CONST_STRPTR name, CONST_STRPTR buffer, LONG size, LONG flags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register const char * d2 __asm("d2") = buffer;
	register int d3 __asm("d3") = size;
	register int d4 __asm("d4") = flags;

	__asm volatile ("jsr a6@(-900)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "d1", "d2", "d3", "d4");
	return (BOOL) _res;
}

LONG DOSLibrary::GetVar(CONST_STRPTR name, STRPTR buffer, LONG size, LONG flags)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register char * d2 __asm("d2") = buffer;
	register int d3 __asm("d3") = size;
	register int d4 __asm("d4") = flags;

	__asm volatile ("jsr a6@(-906)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "d1", "d2", "d3", "d4");
	return (LONG) _res;
}

LONG DOSLibrary::DeleteVar(CONST_STRPTR name, ULONG flags)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register unsigned int d2 __asm("d2") = flags;

	__asm volatile ("jsr a6@(-912)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

struct LocalVar * DOSLibrary::FindVar(CONST_STRPTR name, ULONG type)
{
	register struct LocalVar * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register unsigned int d2 __asm("d2") = type;

	__asm volatile ("jsr a6@(-918)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (struct LocalVar *) _res;
}

LONG DOSLibrary::CliInitNewcli(struct DosPacket * dp)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dp;

	__asm volatile ("jsr a6@(-930)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

LONG DOSLibrary::CliInitRun(struct DosPacket * dp)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dp;

	__asm volatile ("jsr a6@(-936)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

LONG DOSLibrary::WriteChars(CONST_STRPTR buf, ULONG buflen)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = buf;
	register unsigned int d2 __asm("d2") = buflen;

	__asm volatile ("jsr a6@(-942)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::PutStr(CONST_STRPTR str)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = str;

	__asm volatile ("jsr a6@(-948)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

LONG DOSLibrary::VPrintf(CONST_STRPTR format, CONST APTR argarray)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = format;
	register const void * d2 __asm("d2") = argarray;

	__asm volatile ("jsr a6@(-954)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (LONG) _res;
}

LONG DOSLibrary::ParsePatternNoCase(CONST_STRPTR pat, UBYTE * buf, LONG buflen)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = pat;
	register void * d2 __asm("d2") = buf;
	register int d3 __asm("d3") = buflen;

	__asm volatile ("jsr a6@(-966)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3)
	: "d1", "d2", "d3");
	return (LONG) _res;
}

BOOL DOSLibrary::MatchPatternNoCase(CONST_STRPTR pat, STRPTR str)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = pat;
	register char * d2 __asm("d2") = str;

	__asm volatile ("jsr a6@(-972)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

BOOL DOSLibrary::SameDevice(BPTR lock1, BPTR lock2)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock1;
	register unsigned int d2 __asm("d2") = lock2;

	__asm volatile ("jsr a6@(-984)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}

VOID DOSLibrary::ExAllEnd(BPTR lock, struct ExAllData * buffer, LONG size, LONG data, struct ExAllControl * control)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d1 __asm("d1") = lock;
	register void * d2 __asm("d2") = buffer;
	register int d3 __asm("d3") = size;
	register int d4 __asm("d4") = data;
	register void * d5 __asm("d5") = control;

	__asm volatile ("jsr a6@(-990)"
	: 
	: "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
	: "d1", "d2", "d3", "d4", "d5");
}

BOOL DOSLibrary::SetOwner(CONST_STRPTR name, LONG owner_info)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * d1 __asm("d1") = name;
	register int d2 __asm("d2") = owner_info;

	__asm volatile ("jsr a6@(-996)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d2)
	: "d1", "d2");
	return (BOOL) _res;
}


#endif

