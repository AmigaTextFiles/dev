
#ifndef _EXECLIBRARY_CPP
#define _EXECLIBRARY_CPP

#include <libclasses/ExecLibrary.h>
#include <Exception.cpp>

ExecLibrary::ExecLibrary()
{
	Base = *((struct Library **)4);
}

ExecLibrary::~ExecLibrary()
{

}

ULONG ExecLibrary::Supervisor(int userFunction)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register int a5 __asm("a5");

	a6 = Base;
	a5 = userFunction;
	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (a5)
	: "a5");
	return (ULONG) _res;
}

VOID ExecLibrary::InitCode(ULONG startClass, ULONG version)
{
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	d0 = startClass;
	d1 = version;
	__asm volatile ("jsr a6@(-72)"
	: 
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
}

VOID ExecLibrary::InitStruct(CONST APTR initTable, APTR memory, ULONG size)
{
	register void * a6 __asm("a6");
	register const void * a1 __asm("a1");
	register void * a2 __asm("a2");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a1 = initTable;
	a2 = memory;
	d0 = size;
	__asm volatile ("jsr a6@(-78)"
	: 
	: "r" (a6), "r" (a1), "r" (a2), "r" (d0)
	: "a1", "a2", "d0");
}

struct Library * ExecLibrary::MakeLibrary(CONST APTR funcInit, CONST APTR structInit, ULONG (*CONST libInit)() , ULONG dataSize, ULONG segList)
{
	register struct Library * _res __asm("d0");
	register void * a6 __asm("a6");
	register const void * a0 __asm("a0");
	register const void * a1 __asm("a1");
	register void * a2 __asm("a2");
	register unsigned int d0 __asm("d0");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	a0 = funcInit;
	a1 = structInit;
	a2 = libInit;
	d0 = dataSize;
	d1 = segList;
	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1)
	: "a0", "a1", "a2", "d0", "d1");
	return (struct Library *) _res;
}

VOID ExecLibrary::MakeFunctions(APTR target, CONST APTR functionArray, ULONG funcDispBase)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register const void * a1 __asm("a1");
	register unsigned int a2 __asm("a2");

	a6 = Base;
	a0 = target;
	a1 = functionArray;
	a2 = funcDispBase;
	__asm volatile ("jsr a6@(-90)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

struct Resident * ExecLibrary::FindResident(CONST_STRPTR name)
{
	register struct Resident * _res __asm("d0");
	register void * a6 __asm("a6");
	register const char * a1 __asm("a1");

	a6 = Base;
	a1 = name;
	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (struct Resident *) _res;
}

APTR ExecLibrary::InitResident(CONST struct Resident * resident, ULONG segList)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register const void * a1 __asm("a1");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	a1 = resident;
	d1 = segList;
	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d1)
	: "a1", "d1");
	return (APTR) _res;
}

VOID ExecLibrary::Alert(ULONG alertNum)
{
	register void * a6 __asm("a6");
	register unsigned int d7 __asm("d7");

	a6 = Base;
	d7 = alertNum;
	__asm volatile ("jsr a6@(-108)"
	: 
	: "r" (a6), "r" (d7)
	: "d7");
}

VOID ExecLibrary::Debug(ULONG flags)
{
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	d0 = flags;
	__asm volatile ("jsr a6@(-114)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

VOID ExecLibrary::Disable()
{
	register void * a6 __asm("a6");

	a6 = Base;
	__asm volatile ("jsr a6@(-120)"
	: 
	: "r" (a6)
	: "d0");
}

VOID ExecLibrary::Enable()
{
	register void * a6 __asm("a6");

	a6 = Base;
	__asm volatile ("jsr a6@(-126)"
	: 
	: "r" (a6)
	: "d0");
}

VOID ExecLibrary::Forbid()
{
	register void * a6 __asm("a6");

	a6 = Base;
	__asm volatile ("jsr a6@(-132)"
	: 
	: "r" (a6)
	: "d0");
}

VOID ExecLibrary::Permit()
{
	register void * a6 __asm("a6");

	a6 = Base;
	__asm volatile ("jsr a6@(-138)"
	: 
	: "r" (a6)
	: "d0");
}

ULONG ExecLibrary::SetSR(ULONG newSR, ULONG mask)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	d0 = newSR;
	d1 = mask;
	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (ULONG) _res;
}

APTR ExecLibrary::SuperState()
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");

	a6 = Base;
	__asm volatile ("jsr a6@(-150)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (APTR) _res;
}

VOID ExecLibrary::UserState(APTR sysStack)
{
	register void * a6 __asm("a6");
	register void * d0 __asm("d0");

	a6 = Base;
	d0 = sysStack;
	__asm volatile ("jsr a6@(-156)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

struct Interrupt * ExecLibrary::SetIntVector(LONG intNumber, CONST struct Interrupt * interrupt)
{
	register struct Interrupt * _res __asm("d0");
	register void * a6 __asm("a6");
	register int d0 __asm("d0");
	register const void * a1 __asm("a1");

	a6 = Base;
	d0 = intNumber;
	a1 = interrupt;
	__asm volatile ("jsr a6@(-162)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a1)
	: "d0", "a1");
	return (struct Interrupt *) _res;
}

VOID ExecLibrary::AddIntServer(LONG intNumber, struct Interrupt * interrupt)
{
	register void * a6 __asm("a6");
	register int d0 __asm("d0");
	register void * a1 __asm("a1");

	a6 = Base;
	d0 = intNumber;
	a1 = interrupt;
	__asm volatile ("jsr a6@(-168)"
	: 
	: "r" (a6), "r" (d0), "r" (a1)
	: "d0", "a1");
}

VOID ExecLibrary::RemIntServer(LONG intNumber, struct Interrupt * interrupt)
{
	register void * a6 __asm("a6");
	register int d0 __asm("d0");
	register void * a1 __asm("a1");

	a6 = Base;
	d0 = intNumber;
	a1 = interrupt;
	__asm volatile ("jsr a6@(-174)"
	: 
	: "r" (a6), "r" (d0), "r" (a1)
	: "d0", "a1");
}

VOID ExecLibrary::Cause(struct Interrupt * interrupt)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = interrupt;
	__asm volatile ("jsr a6@(-180)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

APTR ExecLibrary::Allocate(struct MemHeader * freeList, ULONG byteSize)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a0 = freeList;
	d0 = byteSize;
	__asm volatile ("jsr a6@(-186)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (APTR) _res;
}

VOID ExecLibrary::Deallocate(struct MemHeader * freeList, APTR memoryBlock, ULONG byteSize)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register void * a1 __asm("a1");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a0 = freeList;
	a1 = memoryBlock;
	d0 = byteSize;
	__asm volatile ("jsr a6@(-192)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
}

APTR ExecLibrary::AllocMem(ULONG byteSize, ULONG requirements)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	d0 = byteSize;
	d1 = requirements;
	__asm volatile ("jsr a6@(-198)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (APTR) _res;
}

APTR ExecLibrary::AllocAbs(ULONG byteSize, APTR location)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");
	register void * a1 __asm("a1");

	a6 = Base;
	d0 = byteSize;
	a1 = location;
	__asm volatile ("jsr a6@(-204)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a1)
	: "d0", "a1");
	return (APTR) _res;
}

VOID ExecLibrary::FreeMem(APTR memoryBlock, ULONG byteSize)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a1 = memoryBlock;
	d0 = byteSize;
	__asm volatile ("jsr a6@(-210)"
	: 
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
}

ULONG ExecLibrary::AvailMem(ULONG requirements)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	d1 = requirements;
	__asm volatile ("jsr a6@(-216)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (ULONG) _res;
}

struct MemList * ExecLibrary::AllocEntry(struct MemList * entry)
{
	register struct MemList * _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = entry;
	__asm volatile ("jsr a6@(-222)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct MemList *) _res;
}

VOID ExecLibrary::FreeEntry(struct MemList * entry)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = entry;
	__asm volatile ("jsr a6@(-228)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ExecLibrary::Insert(struct List * list, struct Node * node, struct Node * pred)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register void * a1 __asm("a1");
	register void * a2 __asm("a2");

	a6 = Base;
	a0 = list;
	a1 = node;
	a2 = pred;
	__asm volatile ("jsr a6@(-234)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID ExecLibrary::AddHead(struct List * list, struct Node * node)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register void * a1 __asm("a1");

	a6 = Base;
	a0 = list;
	a1 = node;
	__asm volatile ("jsr a6@(-240)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID ExecLibrary::AddTail(struct List * list, struct Node * node)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register void * a1 __asm("a1");

	a6 = Base;
	a0 = list;
	a1 = node;
	__asm volatile ("jsr a6@(-246)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID ExecLibrary::Remove(struct Node * node)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = node;
	__asm volatile ("jsr a6@(-252)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

struct Node * ExecLibrary::RemHead(struct List * list)
{
	register struct Node * _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = list;
	__asm volatile ("jsr a6@(-258)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Node *) _res;
}

struct Node * ExecLibrary::RemTail(struct List * list)
{
	register struct Node * _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = list;
	__asm volatile ("jsr a6@(-264)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Node *) _res;
}

VOID ExecLibrary::Enqueue(struct List * list, struct Node * node)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register void * a1 __asm("a1");

	a6 = Base;
	a0 = list;
	a1 = node;
	__asm volatile ("jsr a6@(-270)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

struct Node * ExecLibrary::FindName(struct List * list, CONST_STRPTR name)
{
	register struct Node * _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register const char * a1 __asm("a1");

	a6 = Base;
	a0 = list;
	a1 = name;
	__asm volatile ("jsr a6@(-276)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct Node *) _res;
}

APTR ExecLibrary::AddTask(struct Task * task, CONST APTR initPC, CONST APTR finalPC)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");
	register const void * a2 __asm("a2");
	register const void * a3 __asm("a3");

	a6 = Base;
	a1 = task;
	a2 = initPC;
	a3 = finalPC;
	__asm volatile ("jsr a6@(-282)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (a2), "r" (a3)
	: "a1", "a2", "a3");
	return (APTR) _res;
}

VOID ExecLibrary::RemTask(struct Task * task)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = task;
	__asm volatile ("jsr a6@(-288)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

struct Task * ExecLibrary::FindTask(CONST_STRPTR name)
{
	register struct Task * _res __asm("d0");
	register void * a6 __asm("a6");
	register const char * a1 __asm("a1");

	a6 = Base;
	a1 = name;
	__asm volatile ("jsr a6@(-294)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (struct Task *) _res;
}

BYTE ExecLibrary::SetTaskPri(struct Task * task, LONG priority)
{
	register BYTE _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");
	register int d0 __asm("d0");

	a6 = Base;
	a1 = task;
	d0 = priority;
	__asm volatile ("jsr a6@(-300)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
	return (BYTE) _res;
}

ULONG ExecLibrary::SetSignal(ULONG newSignals, ULONG signalSet)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	d0 = newSignals;
	d1 = signalSet;
	__asm volatile ("jsr a6@(-306)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (ULONG) _res;
}

ULONG ExecLibrary::SetExcept(ULONG newSignals, ULONG signalSet)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	d0 = newSignals;
	d1 = signalSet;
	__asm volatile ("jsr a6@(-312)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (ULONG) _res;
}

ULONG ExecLibrary::Wait(ULONG signalSet)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	d0 = signalSet;
	__asm volatile ("jsr a6@(-318)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (ULONG) _res;
}

VOID ExecLibrary::Signal(struct Task * task, ULONG signalSet)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a1 = task;
	d0 = signalSet;
	__asm volatile ("jsr a6@(-324)"
	: 
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
}

BYTE ExecLibrary::AllocSignal(LONG signalNum)
{
	register BYTE _res __asm("d0");
	register void * a6 __asm("a6");
	register int d0 __asm("d0");

	a6 = Base;
	d0 = signalNum;
	__asm volatile ("jsr a6@(-330)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (BYTE) _res;
}

VOID ExecLibrary::FreeSignal(LONG signalNum)
{
	register void * a6 __asm("a6");
	register int d0 __asm("d0");

	a6 = Base;
	d0 = signalNum;
	__asm volatile ("jsr a6@(-336)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

LONG ExecLibrary::AllocTrap(LONG trapNum)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6");
	register int d0 __asm("d0");

	a6 = Base;
	d0 = trapNum;
	__asm volatile ("jsr a6@(-342)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (LONG) _res;
}

VOID ExecLibrary::FreeTrap(LONG trapNum)
{
	register void * a6 __asm("a6");
	register int d0 __asm("d0");

	a6 = Base;
	d0 = trapNum;
	__asm volatile ("jsr a6@(-348)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

VOID ExecLibrary::AddPort(struct MsgPort * port)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = port;
	__asm volatile ("jsr a6@(-354)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID ExecLibrary::RemPort(struct MsgPort * port)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = port;
	__asm volatile ("jsr a6@(-360)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID ExecLibrary::PutMsg(struct MsgPort * port, struct Message * message)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register void * a1 __asm("a1");

	a6 = Base;
	a0 = port;
	a1 = message;
	__asm volatile ("jsr a6@(-366)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

struct Message * ExecLibrary::GetMsg(struct MsgPort * port)
{
	register struct Message * _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = port;
	__asm volatile ("jsr a6@(-372)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Message *) _res;
}

VOID ExecLibrary::ReplyMsg(struct Message * message)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = message;
	__asm volatile ("jsr a6@(-378)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

struct Message * ExecLibrary::WaitPort(struct MsgPort * port)
{
	register struct Message * _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = port;
	__asm volatile ("jsr a6@(-384)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Message *) _res;
}

struct MsgPort * ExecLibrary::FindPort(CONST_STRPTR name)
{
	register struct MsgPort * _res __asm("d0");
	register void * a6 __asm("a6");
	register const char * a1 __asm("a1");

	a6 = Base;
	a1 = name;
	__asm volatile ("jsr a6@(-390)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (struct MsgPort *) _res;
}

VOID ExecLibrary::AddLibrary(struct Library * library)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = library;
	__asm volatile ("jsr a6@(-396)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID ExecLibrary::RemLibrary(struct Library * library)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = library;
	__asm volatile ("jsr a6@(-402)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

struct Library * ExecLibrary::OldOpenLibrary(CONST_STRPTR libName)
{
	register struct Library * _res __asm("d0");
	register void * a6 __asm("a6");
	register const char * a1 __asm("a1");

	a6 = Base;
	a1 = libName;
	__asm volatile ("jsr a6@(-408)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (struct Library *) _res;
}

VOID ExecLibrary::CloseLibrary(struct Library * library)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = library;
	__asm volatile ("jsr a6@(-414)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

APTR ExecLibrary::SetFunction(struct Library * library, LONG funcOffset, int newFunction)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");
	register int a0 __asm("a0");
	register int d0 __asm("d0");

	a6 = Base;
	a1 = library;
	a0 = funcOffset;
	d0 = newFunction;
	__asm volatile ("jsr a6@(-420)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (a0), "r" (d0)
	: "a1", "a0", "d0");
	return (APTR) _res;
}

VOID ExecLibrary::SumLibrary(struct Library * library)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = library;
	__asm volatile ("jsr a6@(-426)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID ExecLibrary::AddDevice(struct Device * device)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = device;
	__asm volatile ("jsr a6@(-432)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID ExecLibrary::RemDevice(struct Device * device)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = device;
	__asm volatile ("jsr a6@(-438)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

BYTE ExecLibrary::OpenDevice(CONST_STRPTR devName, ULONG unit, struct IORequest * ioRequest, ULONG flags)
{
	register BYTE _res __asm("d0");
	register void * a6 __asm("a6");
	register const char * a0 __asm("a0");
	register unsigned int d0 __asm("d0");
	register void * a1 __asm("a1");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	a0 = devName;
	d0 = unit;
	a1 = ioRequest;
	d1 = flags;
	__asm volatile ("jsr a6@(-444)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (a1), "r" (d1)
	: "a0", "d0", "a1", "d1");
	return (BYTE) _res;
}

VOID ExecLibrary::CloseDevice(struct IORequest * ioRequest)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = ioRequest;
	__asm volatile ("jsr a6@(-450)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

BYTE ExecLibrary::DoIO(struct IORequest * ioRequest)
{
	register BYTE _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = ioRequest;
	__asm volatile ("jsr a6@(-456)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (BYTE) _res;
}

VOID ExecLibrary::SendIO(struct IORequest * ioRequest)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = ioRequest;
	__asm volatile ("jsr a6@(-462)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

struct IORequest * ExecLibrary::CheckIO(struct IORequest * ioRequest)
{
	register struct IORequest * _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = ioRequest;
	__asm volatile ("jsr a6@(-468)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (struct IORequest *) _res;
}

BYTE ExecLibrary::WaitIO(struct IORequest * ioRequest)
{
	register BYTE _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = ioRequest;
	__asm volatile ("jsr a6@(-474)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (BYTE) _res;
}

VOID ExecLibrary::AbortIO(struct IORequest * ioRequest)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = ioRequest;
	__asm volatile ("jsr a6@(-480)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID ExecLibrary::AddResource(APTR resource)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = resource;
	__asm volatile ("jsr a6@(-486)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID ExecLibrary::RemResource(APTR resource)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = resource;
	__asm volatile ("jsr a6@(-492)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

APTR ExecLibrary::OpenResource(CONST_STRPTR resName)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register const char * a1 __asm("a1");

	a6 = Base;
	a1 = resName;
	__asm volatile ("jsr a6@(-498)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (APTR) _res;
}

APTR ExecLibrary::RawDoFmt(CONST_STRPTR formatString, CONST APTR dataStream, VOID (*CONST putChProc)() , APTR putChData)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register const char * a0 __asm("a0");
	register const void * a1 __asm("a1");
	register void * a2 __asm("a2");
	register void * a3 __asm("a3");

	a6 = Base;
	a0 = formatString;
	a1 = dataStream;
	a2 = putChProc;
	a3 = putChData;
	__asm volatile ("jsr a6@(-522)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
	return (APTR) _res;
}

ULONG ExecLibrary::GetCC()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");

	a6 = Base;
	__asm volatile ("jsr a6@(-528)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}

ULONG ExecLibrary::TypeOfMem(CONST APTR address)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register const void * a1 __asm("a1");

	a6 = Base;
	a1 = address;
	__asm volatile ("jsr a6@(-534)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (ULONG) _res;
}

ULONG ExecLibrary::Procure(struct SignalSemaphore * sigSem, struct SemaphoreMessage * bidMsg)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register void * a1 __asm("a1");

	a6 = Base;
	a0 = sigSem;
	a1 = bidMsg;
	__asm volatile ("jsr a6@(-540)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

VOID ExecLibrary::Vacate(struct SignalSemaphore * sigSem, struct SemaphoreMessage * bidMsg)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register void * a1 __asm("a1");

	a6 = Base;
	a0 = sigSem;
	a1 = bidMsg;
	__asm volatile ("jsr a6@(-546)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

struct Library * ExecLibrary::OpenLibrary(CONST_STRPTR libName, ULONG version)
{
	register struct Library * _res __asm("d0");
	register void * a6 __asm("a6");
	register const char * a1 __asm("a1");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a1 = libName;
	d0 = version;
	__asm volatile ("jsr a6@(-552)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
	return (struct Library *) _res;
}

VOID ExecLibrary::InitSemaphore(struct SignalSemaphore * sigSem)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = sigSem;
	__asm volatile ("jsr a6@(-558)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ExecLibrary::ObtainSemaphore(struct SignalSemaphore * sigSem)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = sigSem;
	__asm volatile ("jsr a6@(-564)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ExecLibrary::ReleaseSemaphore(struct SignalSemaphore * sigSem)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = sigSem;
	__asm volatile ("jsr a6@(-570)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG ExecLibrary::AttemptSemaphore(struct SignalSemaphore * sigSem)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = sigSem;
	__asm volatile ("jsr a6@(-576)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

VOID ExecLibrary::ObtainSemaphoreList(struct List * sigSem)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = sigSem;
	__asm volatile ("jsr a6@(-582)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ExecLibrary::ReleaseSemaphoreList(struct List * sigSem)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = sigSem;
	__asm volatile ("jsr a6@(-588)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct SignalSemaphore * ExecLibrary::FindSemaphore(STRPTR name)
{
	register struct SignalSemaphore * _res __asm("d0");
	register void * a6 __asm("a6");
	register char * a1 __asm("a1");

	a6 = Base;
	a1 = name;
	__asm volatile ("jsr a6@(-594)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (struct SignalSemaphore *) _res;
}

VOID ExecLibrary::AddSemaphore(struct SignalSemaphore * sigSem)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = sigSem;
	__asm volatile ("jsr a6@(-600)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID ExecLibrary::RemSemaphore(struct SignalSemaphore * sigSem)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = sigSem;
	__asm volatile ("jsr a6@(-606)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

ULONG ExecLibrary::SumKickData()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");

	a6 = Base;
	__asm volatile ("jsr a6@(-612)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}

VOID ExecLibrary::AddMemList(ULONG size, ULONG attributes, LONG pri, APTR base, CONST_STRPTR name)
{
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");
	register unsigned int d1 __asm("d1");
	register int d2 __asm("d2");
	register void * a0 __asm("a0");
	register const char * a1 __asm("a1");

	a6 = Base;
	d0 = size;
	d1 = attributes;
	d2 = pri;
	a0 = base;
	a1 = name;
	__asm volatile ("jsr a6@(-618)"
	: 
	: "r" (a6), "r" (d0), "r" (d1), "r" (d2), "r" (a0), "r" (a1)
	: "d0", "d1", "d2", "a0", "a1");
}

VOID ExecLibrary::CopyMem(CONST APTR source, APTR dest, ULONG size)
{
	register void * a6 __asm("a6");
	register const void * a0 __asm("a0");
	register void * a1 __asm("a1");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a0 = source;
	a1 = dest;
	d0 = size;
	__asm volatile ("jsr a6@(-624)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
}

VOID ExecLibrary::CopyMemQuick(CONST APTR source, APTR dest, ULONG size)
{
	register void * a6 __asm("a6");
	register const void * a0 __asm("a0");
	register void * a1 __asm("a1");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a0 = source;
	a1 = dest;
	d0 = size;
	__asm volatile ("jsr a6@(-630)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
}

VOID ExecLibrary::CacheClearU()
{
	register void * a6 __asm("a6");

	a6 = Base;
	__asm volatile ("jsr a6@(-636)"
	: 
	: "r" (a6)
	: "d0");
}

VOID ExecLibrary::CacheClearE(APTR address, ULONG length, ULONG caches)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register unsigned int d0 __asm("d0");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	a0 = address;
	d0 = length;
	d1 = caches;
	__asm volatile ("jsr a6@(-642)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
}

ULONG ExecLibrary::CacheControl(ULONG cacheBits, ULONG cacheMask)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	d0 = cacheBits;
	d1 = cacheMask;
	__asm volatile ("jsr a6@(-648)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (ULONG) _res;
}

APTR ExecLibrary::CreateIORequest(CONST struct MsgPort * port, ULONG size)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register const void * a0 __asm("a0");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a0 = port;
	d0 = size;
	__asm volatile ("jsr a6@(-654)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (APTR) _res;
}

VOID ExecLibrary::DeleteIORequest(APTR iorequest)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = iorequest;
	__asm volatile ("jsr a6@(-660)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct MsgPort * ExecLibrary::CreateMsgPort()
{
	register struct MsgPort * _res __asm("d0");
	register void * a6 __asm("a6");

	a6 = Base;
	__asm volatile ("jsr a6@(-666)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct MsgPort *) _res;
}

VOID ExecLibrary::DeleteMsgPort(struct MsgPort * port)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = port;
	__asm volatile ("jsr a6@(-672)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ExecLibrary::ObtainSemaphoreShared(struct SignalSemaphore * sigSem)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = sigSem;
	__asm volatile ("jsr a6@(-678)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

APTR ExecLibrary::AllocVec(ULONG byteSize, ULONG requirements)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");
	register unsigned int d1 __asm("d1");

	a6 = Base;
	d0 = byteSize;
	d1 = requirements;
	__asm volatile ("jsr a6@(-684)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (APTR) _res;
}

VOID ExecLibrary::FreeVec(APTR memoryBlock)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = memoryBlock;
	__asm volatile ("jsr a6@(-690)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

APTR ExecLibrary::CreatePool(ULONG requirements, ULONG puddleSize, ULONG threshSize)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register unsigned int d0 __asm("d0");
	register unsigned int d1 __asm("d1");
	register unsigned int d2 __asm("d2");

	a6 = Base;
	d0 = requirements;
	d1 = puddleSize;
	d2 = threshSize;
	__asm volatile ("jsr a6@(-696)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (d2)
	: "d0", "d1", "d2");
	return (APTR) _res;
}

VOID ExecLibrary::DeletePool(APTR poolHeader)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = poolHeader;
	__asm volatile ("jsr a6@(-702)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

APTR ExecLibrary::AllocPooled(APTR poolHeader, ULONG memSize)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a0 = poolHeader;
	d0 = memSize;
	__asm volatile ("jsr a6@(-708)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (APTR) _res;
}

VOID ExecLibrary::FreePooled(APTR poolHeader, APTR memory, ULONG memSize)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");
	register void * a1 __asm("a1");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a0 = poolHeader;
	a1 = memory;
	d0 = memSize;
	__asm volatile ("jsr a6@(-714)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
}

ULONG ExecLibrary::AttemptSemaphoreShared(struct SignalSemaphore * sigSem)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = sigSem;
	__asm volatile ("jsr a6@(-720)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

VOID ExecLibrary::ColdReboot()
{
	register void * a6 __asm("a6");

	a6 = Base;
	__asm volatile ("jsr a6@(-726)"
	: 
	: "r" (a6)
	: "d0");
}

VOID ExecLibrary::StackSwap(struct StackSwapStruct * newStack)
{
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = newStack;
	__asm volatile ("jsr a6@(-732)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ExecLibrary::ChildFree(APTR tid)
{
	register void * a6 __asm("a6");
	register void * d0 __asm("d0");

	a6 = Base;
	d0 = tid;
	__asm volatile ("jsr a6@(-738)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

VOID ExecLibrary::ChildOrphan(APTR tid)
{
	register void * a6 __asm("a6");
	register void * d0 __asm("d0");

	a6 = Base;
	d0 = tid;
	__asm volatile ("jsr a6@(-744)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

VOID ExecLibrary::ChildStatus(APTR tid)
{
	register void * a6 __asm("a6");
	register void * d0 __asm("d0");

	a6 = Base;
	d0 = tid;
	__asm volatile ("jsr a6@(-750)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

VOID ExecLibrary::ChildWait(APTR tid)
{
	register void * a6 __asm("a6");
	register void * d0 __asm("d0");

	a6 = Base;
	d0 = tid;
	__asm volatile ("jsr a6@(-756)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

APTR ExecLibrary::CachePreDMA(CONST APTR address, ULONG * length, ULONG flags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6");
	register const void * a0 __asm("a0");
	register void * a1 __asm("a1");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a0 = address;
	a1 = length;
	d0 = flags;
	__asm volatile ("jsr a6@(-762)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (APTR) _res;
}

VOID ExecLibrary::CachePostDMA(CONST APTR address, ULONG * length, ULONG flags)
{
	register void * a6 __asm("a6");
	register const void * a0 __asm("a0");
	register void * a1 __asm("a1");
	register unsigned int d0 __asm("d0");

	a6 = Base;
	a0 = address;
	a1 = length;
	d0 = flags;
	__asm volatile ("jsr a6@(-768)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
}

VOID ExecLibrary::AddMemHandler(struct Interrupt * memhand)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = memhand;
	__asm volatile ("jsr a6@(-774)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID ExecLibrary::RemMemHandler(struct Interrupt * memhand)
{
	register void * a6 __asm("a6");
	register void * a1 __asm("a1");

	a6 = Base;
	a1 = memhand;
	__asm volatile ("jsr a6@(-780)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

ULONG ExecLibrary::ObtainQuickVector(APTR interruptCode)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6");
	register void * a0 __asm("a0");

	a6 = Base;
	a0 = interruptCode;
	__asm volatile ("jsr a6@(-786)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}


#endif

