#ifndef _INLINE_EXEC_H
#define _INLINE_EXEC_H

#ifndef CLIB_EXEC_PROTOS_H
#define CLIB_EXEC_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  EXEC_TASKS_H
#include <exec/tasks.h>
#endif
#ifndef  EXEC_MEMORY_H
#include <exec/memory.h>
#endif
#ifndef  EXEC_PORTS_H
#include <exec/ports.h>
#endif
#ifndef  EXEC_DEVICES_H
#include <exec/devices.h>
#endif
#ifndef  EXEC_IO_H
#include <exec/io.h>
#endif
#ifndef  EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif
#ifndef  EXEC_AVL_H
#include <exec/avl.h>
#endif

#ifndef EXEC_BASE_NAME
#define EXEC_BASE_NAME SysBase
#endif

#define Supervisor(userFunction) \
	LP1A5FP(0x1e, ULONG, Supervisor, __fpt, userFunction, d7, \
	, EXEC_BASE_NAME, ULONG (*__fpt)())

#define InitCode(startClass, version) \
	LP2NR(0x48, InitCode, ULONG, startClass, d0, ULONG, version, d1, \
	, EXEC_BASE_NAME)

#define InitStruct(initTable, memory, size) \
	LP3NR(0x4e, InitStruct, const APTR, initTable, a1, APTR, memory, a2, ULONG, size, d0, \
	, EXEC_BASE_NAME)

#define MakeLibrary(funcInit, structInit, libInit, dataSize, segList) \
	LP5FP(0x54, struct Library *, MakeLibrary, const APTR, funcInit, a0, const APTR, structInit, a1, __fpt, libInit, a2, ULONG, dataSize, d0, ULONG, segList, d1, \
	, EXEC_BASE_NAME, ULONG (*__fpt)())

#define MakeFunctions(target, functionArray, funcDispBase) \
	LP3NR(0x5a, MakeFunctions, APTR, target, a0, const APTR, functionArray, a1, const APTR, funcDispBase, a2, \
	, EXEC_BASE_NAME)

#define FindResident(name) \
	LP1(0x60, struct Resident *, FindResident, CONST_STRPTR, name, a1, \
	, EXEC_BASE_NAME)

#define InitResident(resident, segList) \
	LP2(0x66, APTR, InitResident, const struct Resident *, resident, a1, ULONG, segList, d1, \
	, EXEC_BASE_NAME)

#define Alert(alertNum) \
	LP1NR(0x6c, Alert, ULONG, alertNum, d7, \
	, EXEC_BASE_NAME)

#define Debug(flags) \
	LP1NR(0x72, Debug, ULONG, flags, d0, \
	, EXEC_BASE_NAME)

#define Disable() \
	LP0NR(0x78, Disable, \
	, EXEC_BASE_NAME)

#define Enable() \
	LP0NR(0x7e, Enable, \
	, EXEC_BASE_NAME)

#define Forbid() \
	LP0NR(0x84, Forbid, \
	, EXEC_BASE_NAME)

#define Permit() \
	LP0NR(0x8a, Permit, \
	, EXEC_BASE_NAME)

#define SetSR(newSR, mask) \
	LP2(0x90, ULONG, SetSR, ULONG, newSR, d0, ULONG, mask, d1, \
	, EXEC_BASE_NAME)

#define SuperState() \
	LP0(0x96, APTR, SuperState, \
	, EXEC_BASE_NAME)

#define UserState(sysStack) \
	LP1NR(0x9c, UserState, APTR, sysStack, d0, \
	, EXEC_BASE_NAME)

#define SetIntVector(intNumber, interrupt) \
	LP2(0xa2, struct Interrupt *, SetIntVector, LONG, intNumber, d0, const struct Interrupt *, interrupt, a1, \
	, EXEC_BASE_NAME)

#define AddIntServer(intNumber, interrupt) \
	LP2NR(0xa8, AddIntServer, LONG, intNumber, d0, struct Interrupt *, interrupt, a1, \
	, EXEC_BASE_NAME)

#define RemIntServer(intNumber, interrupt) \
	LP2NR(0xae, RemIntServer, LONG, intNumber, d0, struct Interrupt *, interrupt, a1, \
	, EXEC_BASE_NAME)

#define Cause(interrupt) \
	LP1NR(0xb4, Cause, struct Interrupt *, interrupt, a1, \
	, EXEC_BASE_NAME)

#define Allocate(freeList, byteSize) \
	LP2(0xba, APTR, Allocate, struct MemHeader *, freeList, a0, ULONG, byteSize, d0, \
	, EXEC_BASE_NAME)

#define Deallocate(freeList, memoryBlock, byteSize) \
	LP3NR(0xc0, Deallocate, struct MemHeader *, freeList, a0, APTR, memoryBlock, a1, ULONG, byteSize, d0, \
	, EXEC_BASE_NAME)

#define AllocMem(byteSize, requirements) \
	LP2(0xc6, APTR, AllocMem, ULONG, byteSize, d0, ULONG, requirements, d1, \
	, EXEC_BASE_NAME)

#define AllocAbs(byteSize, location) \
	LP2(0xcc, APTR, AllocAbs, ULONG, byteSize, d0, APTR, location, a1, \
	, EXEC_BASE_NAME)

#define FreeMem(memoryBlock, byteSize) \
	LP2NR(0xd2, FreeMem, APTR, memoryBlock, a1, ULONG, byteSize, d0, \
	, EXEC_BASE_NAME)

#define AvailMem(requirements) \
	LP1(0xd8, ULONG, AvailMem, ULONG, requirements, d1, \
	, EXEC_BASE_NAME)

#define AllocEntry(entry) \
	LP1(0xde, struct MemList *, AllocEntry, struct MemList *, entry, a0, \
	, EXEC_BASE_NAME)

#define FreeEntry(entry) \
	LP1NR(0xe4, FreeEntry, struct MemList *, entry, a0, \
	, EXEC_BASE_NAME)

#define Insert(list, node, pred) \
	LP3NR(0xea, Insert, struct List *, list, a0, struct Node *, node, a1, struct Node *, pred, a2, \
	, EXEC_BASE_NAME)

#define AddHead(list, node) \
	LP2NR(0xf0, AddHead, struct List *, list, a0, struct Node *, node, a1, \
	, EXEC_BASE_NAME)

#define AddTail(list, node) \
	LP2NR(0xf6, AddTail, struct List *, list, a0, struct Node *, node, a1, \
	, EXEC_BASE_NAME)

#define Remove(node) \
	LP1NR(0xfc, Remove, struct Node *, node, a1, \
	, EXEC_BASE_NAME)

#define RemHead(list) \
	LP1(0x102, struct Node *, RemHead, struct List *, list, a0, \
	, EXEC_BASE_NAME)

#define RemTail(list) \
	LP1(0x108, struct Node *, RemTail, struct List *, list, a0, \
	, EXEC_BASE_NAME)

#define Enqueue(list, node) \
	LP2NR(0x10e, Enqueue, struct List *, list, a0, struct Node *, node, a1, \
	, EXEC_BASE_NAME)

#define FindName(list, name) \
	LP2(0x114, struct Node *, FindName, struct List *, list, a0, CONST_STRPTR, name, a1, \
	, EXEC_BASE_NAME)

#define AddTask(task, initPC, finalPC) \
	LP3(0x11a, APTR, AddTask, struct Task *, task, a1, const APTR, initPC, a2, const APTR, finalPC, a3, \
	, EXEC_BASE_NAME)

#define RemTask(task) \
	LP1NR(0x120, RemTask, struct Task *, task, a1, \
	, EXEC_BASE_NAME)

#define FindTask(name) \
	LP1(0x126, struct Task *, FindTask, CONST_STRPTR, name, a1, \
	, EXEC_BASE_NAME)

#define SetTaskPri(task, priority) \
	LP2(0x12c, BYTE, SetTaskPri, struct Task *, task, a1, LONG, priority, d0, \
	, EXEC_BASE_NAME)

#define SetSignal(newSignals, signalSet) \
	LP2(0x132, ULONG, SetSignal, ULONG, newSignals, d0, ULONG, signalSet, d1, \
	, EXEC_BASE_NAME)

#define SetExcept(newSignals, signalSet) \
	LP2(0x138, ULONG, SetExcept, ULONG, newSignals, d0, ULONG, signalSet, d1, \
	, EXEC_BASE_NAME)

#define Wait(signalSet) \
	LP1(0x13e, ULONG, Wait, ULONG, signalSet, d0, \
	, EXEC_BASE_NAME)

#define Signal(task, signalSet) \
	LP2NR(0x144, Signal, struct Task *, task, a1, ULONG, signalSet, d0, \
	, EXEC_BASE_NAME)

#define AllocSignal(signalNum) \
	LP1(0x14a, BYTE, AllocSignal, LONG, signalNum, d0, \
	, EXEC_BASE_NAME)

#define FreeSignal(signalNum) \
	LP1NR(0x150, FreeSignal, LONG, signalNum, d0, \
	, EXEC_BASE_NAME)

#define AllocTrap(trapNum) \
	LP1(0x156, LONG, AllocTrap, LONG, trapNum, d0, \
	, EXEC_BASE_NAME)

#define FreeTrap(trapNum) \
	LP1NR(0x15c, FreeTrap, LONG, trapNum, d0, \
	, EXEC_BASE_NAME)

#define AddPort(port) \
	LP1NR(0x162, AddPort, struct MsgPort *, port, a1, \
	, EXEC_BASE_NAME)

#define RemPort(port) \
	LP1NR(0x168, RemPort, struct MsgPort *, port, a1, \
	, EXEC_BASE_NAME)

#define PutMsg(port, message) \
	LP2NR(0x16e, PutMsg, struct MsgPort *, port, a0, struct Message *, message, a1, \
	, EXEC_BASE_NAME)

#define GetMsg(port) \
	LP1(0x174, struct Message *, GetMsg, struct MsgPort *, port, a0, \
	, EXEC_BASE_NAME)

#define ReplyMsg(message) \
	LP1NR(0x17a, ReplyMsg, struct Message *, message, a1, \
	, EXEC_BASE_NAME)

#define WaitPort(port) \
	LP1(0x180, struct Message *, WaitPort, struct MsgPort *, port, a0, \
	, EXEC_BASE_NAME)

#define FindPort(name) \
	LP1(0x186, struct MsgPort *, FindPort, CONST_STRPTR, name, a1, \
	, EXEC_BASE_NAME)

#define AddLibrary(library) \
	LP1NR(0x18c, AddLibrary, struct Library *, library, a1, \
	, EXEC_BASE_NAME)

#define RemLibrary(library) \
	LP1NR(0x192, RemLibrary, struct Library *, library, a1, \
	, EXEC_BASE_NAME)

#define OldOpenLibrary(libName) \
	LP1(0x198, struct Library *, OldOpenLibrary, CONST_STRPTR, libName, a1, \
	, EXEC_BASE_NAME)

#define CloseLibrary(library) \
	LP1NR(0x19e, CloseLibrary, struct Library *, library, a1, \
	, EXEC_BASE_NAME)

#define SetFunction(library, funcOffset, newFunction) \
	LP3FP(0x1a4, APTR, SetFunction, struct Library *, library, a1, LONG, funcOffset, a0, __fpt, newFunction, d0, \
	, EXEC_BASE_NAME, ULONG (*__fpt)())

#define SumLibrary(library) \
	LP1NR(0x1aa, SumLibrary, struct Library *, library, a1, \
	, EXEC_BASE_NAME)

#define AddDevice(device) \
	LP1NR(0x1b0, AddDevice, struct Device *, device, a1, \
	, EXEC_BASE_NAME)

#define RemDevice(device) \
	LP1NR(0x1b6, RemDevice, struct Device *, device, a1, \
	, EXEC_BASE_NAME)

#define OpenDevice(devName, unit, ioRequest, flags) \
	LP4(0x1bc, BYTE, OpenDevice, CONST_STRPTR, devName, a0, ULONG, unit, d0, struct IORequest *, ioRequest, a1, ULONG, flags, d1, \
	, EXEC_BASE_NAME)

#define CloseDevice(ioRequest) \
	LP1NR(0x1c2, CloseDevice, struct IORequest *, ioRequest, a1, \
	, EXEC_BASE_NAME)

#define DoIO(ioRequest) \
	LP1(0x1c8, BYTE, DoIO, struct IORequest *, ioRequest, a1, \
	, EXEC_BASE_NAME)

#define SendIO(ioRequest) \
	LP1NR(0x1ce, SendIO, struct IORequest *, ioRequest, a1, \
	, EXEC_BASE_NAME)

#define CheckIO(ioRequest) \
	LP1(0x1d4, struct IORequest *, CheckIO, struct IORequest *, ioRequest, a1, \
	, EXEC_BASE_NAME)

#define WaitIO(ioRequest) \
	LP1(0x1da, BYTE, WaitIO, struct IORequest *, ioRequest, a1, \
	, EXEC_BASE_NAME)

#define AbortIO(ioRequest) \
	LP1NR(0x1e0, AbortIO, struct IORequest *, ioRequest, a1, \
	, EXEC_BASE_NAME)

#define AddResource(resource) \
	LP1NR(0x1e6, AddResource, APTR, resource, a1, \
	, EXEC_BASE_NAME)

#define RemResource(resource) \
	LP1NR(0x1ec, RemResource, APTR, resource, a1, \
	, EXEC_BASE_NAME)

#define OpenResource(resName) \
	LP1(0x1f2, APTR, OpenResource, CONST_STRPTR, resName, a1, \
	, EXEC_BASE_NAME)

#define RawDoFmt(formatString, dataStream, putChProc, putChData) \
	LP4FP(0x20a, APTR, RawDoFmt, CONST_STRPTR, formatString, a0, const APTR, dataStream, a1, __fpt, putChProc, a2, APTR, putChData, a3, \
	, EXEC_BASE_NAME, VOID (*__fpt)())

#define GetCC() \
	LP0(0x210, ULONG, GetCC, \
	, EXEC_BASE_NAME)

#define TypeOfMem(address) \
	LP1(0x216, ULONG, TypeOfMem, const APTR, address, a1, \
	, EXEC_BASE_NAME)

#define Procure(sigSem, bidMsg) \
	LP2(0x21c, ULONG, Procure, struct SignalSemaphore *, sigSem, a0, struct SemaphoreMessage *, bidMsg, a1, \
	, EXEC_BASE_NAME)

#define Vacate(sigSem, bidMsg) \
	LP2NR(0x222, Vacate, struct SignalSemaphore *, sigSem, a0, struct SemaphoreMessage *, bidMsg, a1, \
	, EXEC_BASE_NAME)

#define OpenLibrary(libName, version) \
	LP2(0x228, struct Library *, OpenLibrary, CONST_STRPTR, libName, a1, ULONG, version, d0, \
	, EXEC_BASE_NAME)

#define InitSemaphore(sigSem) \
	LP1NR(0x22e, InitSemaphore, struct SignalSemaphore *, sigSem, a0, \
	, EXEC_BASE_NAME)

#define ObtainSemaphore(sigSem) \
	LP1NR(0x234, ObtainSemaphore, struct SignalSemaphore *, sigSem, a0, \
	, EXEC_BASE_NAME)

#define ReleaseSemaphore(sigSem) \
	LP1NR(0x23a, ReleaseSemaphore, struct SignalSemaphore *, sigSem, a0, \
	, EXEC_BASE_NAME)

#define AttemptSemaphore(sigSem) \
	LP1(0x240, ULONG, AttemptSemaphore, struct SignalSemaphore *, sigSem, a0, \
	, EXEC_BASE_NAME)

#define ObtainSemaphoreList(sigSem) \
	LP1NR(0x246, ObtainSemaphoreList, struct List *, sigSem, a0, \
	, EXEC_BASE_NAME)

#define ReleaseSemaphoreList(sigSem) \
	LP1NR(0x24c, ReleaseSemaphoreList, struct List *, sigSem, a0, \
	, EXEC_BASE_NAME)

#define FindSemaphore(name) \
	LP1(0x252, struct SignalSemaphore *, FindSemaphore, STRPTR, name, a1, \
	, EXEC_BASE_NAME)

#define AddSemaphore(sigSem) \
	LP1NR(0x258, AddSemaphore, struct SignalSemaphore *, sigSem, a1, \
	, EXEC_BASE_NAME)

#define RemSemaphore(sigSem) \
	LP1NR(0x25e, RemSemaphore, struct SignalSemaphore *, sigSem, a1, \
	, EXEC_BASE_NAME)

#define SumKickData() \
	LP0(0x264, ULONG, SumKickData, \
	, EXEC_BASE_NAME)

#define AddMemList(size, attributes, pri, base, name) \
	LP5NR(0x26a, AddMemList, ULONG, size, d0, ULONG, attributes, d1, LONG, pri, d2, APTR, base, a0, CONST_STRPTR, name, a1, \
	, EXEC_BASE_NAME)

#define CopyMem(source, dest, size) \
	LP3NR(0x270, CopyMem, const APTR, source, a0, APTR, dest, a1, ULONG, size, d0, \
	, EXEC_BASE_NAME)

#define CopyMemQuick(source, dest, size) \
	LP3NR(0x276, CopyMemQuick, const APTR, source, a0, APTR, dest, a1, ULONG, size, d0, \
	, EXEC_BASE_NAME)

#define CacheClearU() \
	LP0NR(0x27c, CacheClearU, \
	, EXEC_BASE_NAME)

#define CacheClearE(address, length, caches) \
	LP3NR(0x282, CacheClearE, APTR, address, a0, ULONG, length, d0, ULONG, caches, d1, \
	, EXEC_BASE_NAME)

#define CacheControl(cacheBits, cacheMask) \
	LP2(0x288, ULONG, CacheControl, ULONG, cacheBits, d0, ULONG, cacheMask, d1, \
	, EXEC_BASE_NAME)

#define CreateIORequest(port, size) \
	LP2(0x28e, APTR, CreateIORequest, const struct MsgPort *, port, a0, ULONG, size, d0, \
	, EXEC_BASE_NAME)

#define DeleteIORequest(iorequest) \
	LP1NR(0x294, DeleteIORequest, APTR, iorequest, a0, \
	, EXEC_BASE_NAME)

#define CreateMsgPort() \
	LP0(0x29a, struct MsgPort *, CreateMsgPort, \
	, EXEC_BASE_NAME)

#define DeleteMsgPort(port) \
	LP1NR(0x2a0, DeleteMsgPort, struct MsgPort *, port, a0, \
	, EXEC_BASE_NAME)

#define ObtainSemaphoreShared(sigSem) \
	LP1NR(0x2a6, ObtainSemaphoreShared, struct SignalSemaphore *, sigSem, a0, \
	, EXEC_BASE_NAME)

#define AllocVec(byteSize, requirements) \
	LP2(0x2ac, APTR, AllocVec, ULONG, byteSize, d0, ULONG, requirements, d1, \
	, EXEC_BASE_NAME)

#define FreeVec(memoryBlock) \
	LP1NR(0x2b2, FreeVec, APTR, memoryBlock, a1, \
	, EXEC_BASE_NAME)

#define CreatePool(requirements, puddleSize, threshSize) \
	LP3(0x2b8, APTR, CreatePool, ULONG, requirements, d0, ULONG, puddleSize, d1, ULONG, threshSize, d2, \
	, EXEC_BASE_NAME)

#define DeletePool(poolHeader) \
	LP1NR(0x2be, DeletePool, APTR, poolHeader, a0, \
	, EXEC_BASE_NAME)

#define AllocPooled(poolHeader, memSize) \
	LP2(0x2c4, APTR, AllocPooled, APTR, poolHeader, a0, ULONG, memSize, d0, \
	, EXEC_BASE_NAME)

#define FreePooled(poolHeader, memory, memSize) \
	LP3NR(0x2ca, FreePooled, APTR, poolHeader, a0, APTR, memory, a1, ULONG, memSize, d0, \
	, EXEC_BASE_NAME)

#define AttemptSemaphoreShared(sigSem) \
	LP1(0x2d0, ULONG, AttemptSemaphoreShared, struct SignalSemaphore *, sigSem, a0, \
	, EXEC_BASE_NAME)

#define ColdReboot() \
	LP0NR(0x2d6, ColdReboot, \
	, EXEC_BASE_NAME)

#define StackSwap(newStack) \
	LP1NR(0x2dc, StackSwap, struct StackSwapStruct *, newStack, a0, \
	, EXEC_BASE_NAME)

#define CachePreDMA(address, length, flags) \
	LP3(0x2fa, APTR, CachePreDMA, const APTR, address, a0, ULONG *, length, a1, ULONG, flags, d0, \
	, EXEC_BASE_NAME)

#define CachePostDMA(address, length, flags) \
	LP3NR(0x300, CachePostDMA, const APTR, address, a0, ULONG *, length, a1, ULONG, flags, d0, \
	, EXEC_BASE_NAME)

#define AddMemHandler(memhand) \
	LP1NR(0x306, AddMemHandler, struct Interrupt *, memhand, a1, \
	, EXEC_BASE_NAME)

#define RemMemHandler(memhand) \
	LP1NR(0x30c, RemMemHandler, struct Interrupt *, memhand, a1, \
	, EXEC_BASE_NAME)

#define ObtainQuickVector(interruptCode) \
	LP1(0x312, ULONG, ObtainQuickVector, APTR, interruptCode, a0, \
	, EXEC_BASE_NAME)

#define NewMinList(minlist) \
	LP1NR(0x33c, NewMinList, struct MinList *, minlist, a0, \
	, EXEC_BASE_NAME)

#define AVL_AddNode(root, node, func) \
	LP3(0x354, struct AVLNode *, AVL_AddNode, struct AVLNode **, root, a0, struct AVLNode *, node, a1, APTR, func, a2, \
	, EXEC_BASE_NAME)

#define AVL_RemNodeByAddress(root, node) \
	LP2(0x35a, struct AVLNode *, AVL_RemNodeByAddress, struct AVLNode **, root, a0, struct AVLNode *, node, a1, \
	, EXEC_BASE_NAME)

#define AVL_RemNodeByKey(root, key, func) \
	LP3(0x360, struct AVLNode *, AVL_RemNodeByKey, struct AVLNode **, root, a0, APTR, key, a1, APTR, func, a2, \
	, EXEC_BASE_NAME)

#define AVL_FindNode(root, key, func) \
	LP3(0x366, struct AVLNode *, AVL_FindNode, CONST struct AVLNode *, root, a0, APTR, key, a1, APTR, func, a2, \
	, EXEC_BASE_NAME)

#define AVL_FindPrevNodeByAddress(node) \
	LP1(0x36c, struct AVLNode *, AVL_FindPrevNodeByAddress, CONST struct AVLNode *, node, a0, \
	, EXEC_BASE_NAME)

#define AVL_FindPrevNodeByKey(root, key, func) \
	LP3(0x372, struct AVLNode *, AVL_FindPrevNodeByKey, CONST struct AVLNode *, root, a0, APTR, key, a1, APTR, func, a2, \
	, EXEC_BASE_NAME)

#define AVL_FindNextNodeByAddress(node) \
	LP1(0x378, struct AVLNode *, AVL_FindNextNodeByAddress, CONST struct AVLNode *, node, a0, \
	, EXEC_BASE_NAME)

#define AVL_FindNextNodeByKey(root, key, func) \
	LP3(0x37e, struct AVLNode *, AVL_FindNextNodeByKey, CONST struct AVLNode *, root, a0, APTR, key, a1, APTR, func, a2, \
	, EXEC_BASE_NAME)

#define AVL_FindFirstNode(root) \
	LP1(0x384, struct AVLNode *, AVL_FindFirstNode, CONST struct AVLNode *, root, a0, \
	, EXEC_BASE_NAME)

#define AVL_FindLastNode(root) \
	LP1(0x38a, struct AVLNode *, AVL_FindLastNode, CONST struct AVLNode *, root, a0, \
	, EXEC_BASE_NAME)

#endif /*  _INLINE_EXEC_H  */
