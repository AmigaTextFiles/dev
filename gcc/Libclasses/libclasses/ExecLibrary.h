
#ifndef _EXECLIBRARY_H
#define _EXECLIBRARY_H

#include <exec/types.h>
#include <exec/tasks.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <exec/semaphores.h>

class ExecLibrary
{
public:
	~ExecLibrary();

	static class ExecLibrary Default;

	ULONG Supervisor(int userFunction);
	VOID InitCode(ULONG startClass, ULONG version);
	VOID InitStruct(CONST APTR initTable, APTR memory, ULONG size);
	struct Library * MakeLibrary(CONST APTR funcInit, CONST APTR structInit, ULONG (*CONST libInit)() , ULONG dataSize, ULONG segList);
	VOID MakeFunctions(APTR target, CONST APTR functionArray, ULONG funcDispBase);
	struct Resident * FindResident(CONST_STRPTR name);
	APTR InitResident(CONST struct Resident * resident, ULONG segList);
	VOID Alert(ULONG alertNum);
	VOID Debug(ULONG flags);
	VOID Disable();
	VOID Enable();
	VOID Forbid();
	VOID Permit();
	ULONG SetSR(ULONG newSR, ULONG mask);
	APTR SuperState();
	VOID UserState(APTR sysStack);
	struct Interrupt * SetIntVector(LONG intNumber, CONST struct Interrupt * interrupt);
	VOID AddIntServer(LONG intNumber, struct Interrupt * interrupt);
	VOID RemIntServer(LONG intNumber, struct Interrupt * interrupt);
	VOID Cause(struct Interrupt * interrupt);
	APTR Allocate(struct MemHeader * freeList, ULONG byteSize);
	VOID Deallocate(struct MemHeader * freeList, APTR memoryBlock, ULONG byteSize);
	APTR AllocMem(ULONG byteSize, ULONG requirements);
	APTR AllocAbs(ULONG byteSize, APTR location);
	VOID FreeMem(APTR memoryBlock, ULONG byteSize);
	ULONG AvailMem(ULONG requirements);
	struct MemList * AllocEntry(struct MemList * entry);
	VOID FreeEntry(struct MemList * entry);
	VOID Insert(struct List * list, struct Node * node, struct Node * pred);
	VOID AddHead(struct List * list, struct Node * node);
	VOID AddTail(struct List * list, struct Node * node);
	VOID Remove(struct Node * node);
	struct Node * RemHead(struct List * list);
	struct Node * RemTail(struct List * list);
	VOID Enqueue(struct List * list, struct Node * node);
	struct Node * FindName(struct List * list, CONST_STRPTR name);
	APTR AddTask(struct Task * task, CONST APTR initPC, CONST APTR finalPC);
	VOID RemTask(struct Task * task);
	struct Task * FindTask(CONST_STRPTR name);
	BYTE SetTaskPri(struct Task * task, LONG priority);
	ULONG SetSignal(ULONG newSignals, ULONG signalSet);
	ULONG SetExcept(ULONG newSignals, ULONG signalSet);
	ULONG Wait(ULONG signalSet);
	VOID Signal(struct Task * task, ULONG signalSet);
	BYTE AllocSignal(LONG signalNum);
	VOID FreeSignal(LONG signalNum);
	LONG AllocTrap(LONG trapNum);
	VOID FreeTrap(LONG trapNum);
	VOID AddPort(struct MsgPort * port);
	VOID RemPort(struct MsgPort * port);
	VOID PutMsg(struct MsgPort * port, struct Message * message);
	struct Message * GetMsg(struct MsgPort * port);
	VOID ReplyMsg(struct Message * message);
	struct Message * WaitPort(struct MsgPort * port);
	struct MsgPort * FindPort(CONST_STRPTR name);
	VOID AddLibrary(struct Library * library);
	VOID RemLibrary(struct Library * library);
	struct Library * OldOpenLibrary(CONST_STRPTR libName);
	VOID CloseLibrary(struct Library * library);
	APTR SetFunction(struct Library * library, LONG funcOffset, int newFunction);
	VOID SumLibrary(struct Library * library);
	VOID AddDevice(struct Device * device);
	VOID RemDevice(struct Device * device);
	BYTE OpenDevice(CONST_STRPTR devName, ULONG unit, struct IORequest * ioRequest, ULONG flags);
	VOID CloseDevice(struct IORequest * ioRequest);
	BYTE DoIO(struct IORequest * ioRequest);
	VOID SendIO(struct IORequest * ioRequest);
	struct IORequest * CheckIO(struct IORequest * ioRequest);
	BYTE WaitIO(struct IORequest * ioRequest);
	VOID AbortIO(struct IORequest * ioRequest);
	VOID AddResource(APTR resource);
	VOID RemResource(APTR resource);
	APTR OpenResource(CONST_STRPTR resName);
	APTR RawDoFmt(CONST_STRPTR formatString, CONST APTR dataStream, VOID (*CONST putChProc)() , APTR putChData);
	ULONG GetCC();
	ULONG TypeOfMem(CONST APTR address);
	ULONG Procure(struct SignalSemaphore * sigSem, struct SemaphoreMessage * bidMsg);
	VOID Vacate(struct SignalSemaphore * sigSem, struct SemaphoreMessage * bidMsg);
	struct Library * OpenLibrary(CONST_STRPTR libName, ULONG version);
	VOID InitSemaphore(struct SignalSemaphore * sigSem);
	VOID ObtainSemaphore(struct SignalSemaphore * sigSem);
	VOID ReleaseSemaphore(struct SignalSemaphore * sigSem);
	ULONG AttemptSemaphore(struct SignalSemaphore * sigSem);
	VOID ObtainSemaphoreList(struct List * sigSem);
	VOID ReleaseSemaphoreList(struct List * sigSem);
	struct SignalSemaphore * FindSemaphore(STRPTR name);
	VOID AddSemaphore(struct SignalSemaphore * sigSem);
	VOID RemSemaphore(struct SignalSemaphore * sigSem);
	ULONG SumKickData();
	VOID AddMemList(ULONG size, ULONG attributes, LONG pri, APTR base, CONST_STRPTR name);
	VOID CopyMem(CONST APTR source, APTR dest, ULONG size);
	VOID CopyMemQuick(CONST APTR source, APTR dest, ULONG size);
	VOID CacheClearU();
	VOID CacheClearE(APTR address, ULONG length, ULONG caches);
	ULONG CacheControl(ULONG cacheBits, ULONG cacheMask);
	APTR CreateIORequest(CONST struct MsgPort * port, ULONG size);
	VOID DeleteIORequest(APTR iorequest);
	struct MsgPort * CreateMsgPort();
	VOID DeleteMsgPort(struct MsgPort * port);
	VOID ObtainSemaphoreShared(struct SignalSemaphore * sigSem);
	APTR AllocVec(ULONG byteSize, ULONG requirements);
	VOID FreeVec(APTR memoryBlock);
	APTR CreatePool(ULONG requirements, ULONG puddleSize, ULONG threshSize);
	VOID DeletePool(APTR poolHeader);
	APTR AllocPooled(APTR poolHeader, ULONG memSize);
	VOID FreePooled(APTR poolHeader, APTR memory, ULONG memSize);
	ULONG AttemptSemaphoreShared(struct SignalSemaphore * sigSem);
	VOID ColdReboot();
	VOID StackSwap(struct StackSwapStruct * newStack);
	VOID ChildFree(APTR tid);
	VOID ChildOrphan(APTR tid);
	VOID ChildStatus(APTR tid);
	VOID ChildWait(APTR tid);
	APTR CachePreDMA(CONST APTR address, ULONG * length, ULONG flags);
	VOID CachePostDMA(CONST APTR address, ULONG * length, ULONG flags);
	VOID AddMemHandler(struct Interrupt * memhand);
	VOID RemMemHandler(struct Interrupt * memhand);
	ULONG ObtainQuickVector(APTR interruptCode);

private:
	ExecLibrary();
	struct Library *Base;
};

ExecLibrary ExecLibrary::Default;

#endif

