#ifndef _VBCCINLINE_EXEC_H
#define _VBCCINLINE_EXEC_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

ULONG __Supervisor(struct ExecBase *, ULONG (*userFunction)()) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,52(2)\n"
	"\tli\t3,-30\n"
	"\tblrl";
#define Supervisor(userFunction) __Supervisor(SysBase, (userFunction))

VOID __InitCode(struct ExecBase *, ULONG startClass, ULONG version) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-72\n"
	"\tblrl";
#define InitCode(startClass, version) __InitCode(SysBase, (startClass), (version))

VOID __InitStruct(struct ExecBase *, const APTR initTable, APTR memory, ULONG size) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tstw\t5,40(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-78\n"
	"\tblrl";
#define InitStruct(initTable, memory, size) __InitStruct(SysBase, (initTable), (memory), (size))

struct Library * __MakeLibrary(struct ExecBase *, const APTR funcInit, const APTR structInit, ULONG (*libInit)(), ULONG dataSize, ULONG segList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,0(2)\n"
	"\tstw\t8,4(2)\n"
	"\tli\t3,-84\n"
	"\tblrl";
#define MakeLibrary(funcInit, structInit, libInit, dataSize, segList) __MakeLibrary(SysBase, (funcInit), (structInit), (libInit), (dataSize), (segList))

VOID __MakeFunctions(struct ExecBase *, APTR target, const APTR functionArray, const APTR funcDispBase) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-90\n"
	"\tblrl";
#define MakeFunctions(target, functionArray, funcDispBase) __MakeFunctions(SysBase, (target), (functionArray), (funcDispBase))

struct Resident * __FindResident(struct ExecBase *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-96\n"
	"\tblrl";
#define FindResident(name) __FindResident(SysBase, (name))

APTR __InitResident(struct ExecBase *, const struct Resident * resident, ULONG segList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-102\n"
	"\tblrl";
#define InitResident(resident, segList) __InitResident(SysBase, (resident), (segList))

VOID __Alert(struct ExecBase *, ULONG alertNum) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,28(2)\n"
	"\tli\t3,-108\n"
	"\tblrl";
#define Alert(alertNum) __Alert(SysBase, (alertNum))

VOID __Debug(struct ExecBase *, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-114\n"
	"\tblrl";
#define Debug(flags) __Debug(SysBase, (flags))

VOID __Disable(struct ExecBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-120\n"
	"\tblrl";
#define Disable() __Disable(SysBase)

VOID __Enable(struct ExecBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-126\n"
	"\tblrl";
#define Enable() __Enable(SysBase)

VOID __Forbid(struct ExecBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-132\n"
	"\tblrl";
#define Forbid() __Forbid(SysBase)

VOID __Permit(struct ExecBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-138\n"
	"\tblrl";
#define Permit() __Permit(SysBase)

ULONG __SetSR(struct ExecBase *, ULONG newSR, ULONG mask) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-144\n"
	"\tblrl";
#define SetSR(newSR, mask) __SetSR(SysBase, (newSR), (mask))

APTR __SuperState(struct ExecBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-150\n"
	"\tblrl";
#define SuperState() __SuperState(SysBase)

VOID __UserState(struct ExecBase *, APTR sysStack) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-156\n"
	"\tblrl";
#define UserState(sysStack) __UserState(SysBase, (sysStack))

struct Interrupt * __SetIntVector(struct ExecBase *, LONG intNumber, const struct Interrupt * interrupt) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-162\n"
	"\tblrl";
#define SetIntVector(intNumber, interrupt) __SetIntVector(SysBase, (intNumber), (interrupt))

VOID __AddIntServer(struct ExecBase *, LONG intNumber, struct Interrupt * interrupt) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-168\n"
	"\tblrl";
#define AddIntServer(intNumber, interrupt) __AddIntServer(SysBase, (intNumber), (interrupt))

VOID __RemIntServer(struct ExecBase *, LONG intNumber, struct Interrupt * interrupt) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-174\n"
	"\tblrl";
#define RemIntServer(intNumber, interrupt) __RemIntServer(SysBase, (intNumber), (interrupt))

VOID __Cause(struct ExecBase *, struct Interrupt * interrupt) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-180\n"
	"\tblrl";
#define Cause(interrupt) __Cause(SysBase, (interrupt))

APTR __Allocate(struct ExecBase *, struct MemHeader * freeList, ULONG byteSize) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-186\n"
	"\tblrl";
#define Allocate(freeList, byteSize) __Allocate(SysBase, (freeList), (byteSize))

VOID __Deallocate(struct ExecBase *, struct MemHeader * freeList, APTR memoryBlock, ULONG byteSize) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-192\n"
	"\tblrl";
#define Deallocate(freeList, memoryBlock, byteSize) __Deallocate(SysBase, (freeList), (memoryBlock), (byteSize))

APTR __AllocMem(struct ExecBase *, ULONG byteSize, ULONG requirements) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-198\n"
	"\tblrl";
#define AllocMem(byteSize, requirements) __AllocMem(SysBase, (byteSize), (requirements))

APTR __AllocAbs(struct ExecBase *, ULONG byteSize, APTR location) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-204\n"
	"\tblrl";
#define AllocAbs(byteSize, location) __AllocAbs(SysBase, (byteSize), (location))

VOID __FreeMem(struct ExecBase *, APTR memoryBlock, ULONG byteSize) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-210\n"
	"\tblrl";
#define FreeMem(memoryBlock, byteSize) __FreeMem(SysBase, (memoryBlock), (byteSize))

ULONG __AvailMem(struct ExecBase *, ULONG requirements) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,4(2)\n"
	"\tli\t3,-216\n"
	"\tblrl";
#define AvailMem(requirements) __AvailMem(SysBase, (requirements))

struct MemList * __AllocEntry(struct ExecBase *, struct MemList * entry) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-222\n"
	"\tblrl";
#define AllocEntry(entry) __AllocEntry(SysBase, (entry))

VOID __FreeEntry(struct ExecBase *, struct MemList * entry) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-228\n"
	"\tblrl";
#define FreeEntry(entry) __FreeEntry(SysBase, (entry))

VOID __Insert(struct ExecBase *, struct List * list, struct Node * node, struct Node * pred) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-234\n"
	"\tblrl";
#define Insert(list, node, pred) __Insert(SysBase, (list), (node), (pred))

VOID __AddHead(struct ExecBase *, struct List * list, struct Node * node) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-240\n"
	"\tblrl";
#define AddHead(list, node) __AddHead(SysBase, (list), (node))

VOID __AddTail(struct ExecBase *, struct List * list, struct Node * node) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-246\n"
	"\tblrl";
#define AddTail(list, node) __AddTail(SysBase, (list), (node))

VOID __Remove(struct ExecBase *, struct Node * node) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-252\n"
	"\tblrl";
#define Remove(node) __Remove(SysBase, (node))

struct Node * __RemHead(struct ExecBase *, struct List * list) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-258\n"
	"\tblrl";
#define RemHead(list) __RemHead(SysBase, (list))

struct Node * __RemTail(struct ExecBase *, struct List * list) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-264\n"
	"\tblrl";
#define RemTail(list) __RemTail(SysBase, (list))

VOID __Enqueue(struct ExecBase *, struct List * list, struct Node * node) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-270\n"
	"\tblrl";
#define Enqueue(list, node) __Enqueue(SysBase, (list), (node))

struct Node * __FindName(struct ExecBase *, struct List * list, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-276\n"
	"\tblrl";
#define FindName(list, name) __FindName(SysBase, (list), (name))

APTR __AddTask(struct ExecBase *, struct Task * task, const APTR initPC, const APTR finalPC) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tstw\t5,40(2)\n"
	"\tstw\t6,44(2)\n"
	"\tli\t3,-282\n"
	"\tblrl";
#define AddTask(task, initPC, finalPC) __AddTask(SysBase, (task), (initPC), (finalPC))

VOID __RemTask(struct ExecBase *, struct Task * task) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-288\n"
	"\tblrl";
#define RemTask(task) __RemTask(SysBase, (task))

struct Task * __FindTask(struct ExecBase *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-294\n"
	"\tblrl";
#define FindTask(name) __FindTask(SysBase, (name))

BYTE __SetTaskPri(struct ExecBase *, struct Task * task, LONG priority) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-300\n"
	"\tblrl";
#define SetTaskPri(task, priority) __SetTaskPri(SysBase, (task), (priority))

ULONG __SetSignal(struct ExecBase *, ULONG newSignals, ULONG signalSet) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-306\n"
	"\tblrl";
#define SetSignal(newSignals, signalSet) __SetSignal(SysBase, (newSignals), (signalSet))

ULONG __SetExcept(struct ExecBase *, ULONG newSignals, ULONG signalSet) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-312\n"
	"\tblrl";
#define SetExcept(newSignals, signalSet) __SetExcept(SysBase, (newSignals), (signalSet))

ULONG __Wait(struct ExecBase *, ULONG signalSet) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-318\n"
	"\tblrl";
#define Wait(signalSet) __Wait(SysBase, (signalSet))

VOID __Signal(struct ExecBase *, struct Task * task, ULONG signalSet) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-324\n"
	"\tblrl";
#define Signal(task, signalSet) __Signal(SysBase, (task), (signalSet))

BYTE __AllocSignal(struct ExecBase *, LONG signalNum) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-330\n"
	"\tblrl";
#define AllocSignal(signalNum) __AllocSignal(SysBase, (signalNum))

VOID __FreeSignal(struct ExecBase *, LONG signalNum) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-336\n"
	"\tblrl";
#define FreeSignal(signalNum) __FreeSignal(SysBase, (signalNum))

LONG __AllocTrap(struct ExecBase *, LONG trapNum) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-342\n"
	"\tblrl";
#define AllocTrap(trapNum) __AllocTrap(SysBase, (trapNum))

VOID __FreeTrap(struct ExecBase *, LONG trapNum) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-348\n"
	"\tblrl";
#define FreeTrap(trapNum) __FreeTrap(SysBase, (trapNum))

VOID __AddPort(struct ExecBase *, struct MsgPort * port) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-354\n"
	"\tblrl";
#define AddPort(port) __AddPort(SysBase, (port))

VOID __RemPort(struct ExecBase *, struct MsgPort * port) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-360\n"
	"\tblrl";
#define RemPort(port) __RemPort(SysBase, (port))

VOID __PutMsg(struct ExecBase *, struct MsgPort * port, struct Message * message) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-366\n"
	"\tblrl";
#define PutMsg(port, message) __PutMsg(SysBase, (port), (message))

struct Message * __GetMsg(struct ExecBase *, struct MsgPort * port) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-372\n"
	"\tblrl";
#define GetMsg(port) __GetMsg(SysBase, (port))

VOID __ReplyMsg(struct ExecBase *, struct Message * message) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-378\n"
	"\tblrl";
#define ReplyMsg(message) __ReplyMsg(SysBase, (message))

struct Message * __WaitPort(struct ExecBase *, struct MsgPort * port) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-384\n"
	"\tblrl";
#define WaitPort(port) __WaitPort(SysBase, (port))

struct MsgPort * __FindPort(struct ExecBase *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-390\n"
	"\tblrl";
#define FindPort(name) __FindPort(SysBase, (name))

VOID __AddLibrary(struct ExecBase *, struct Library * library) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-396\n"
	"\tblrl";
#define AddLibrary(library) __AddLibrary(SysBase, (library))

VOID __RemLibrary(struct ExecBase *, struct Library * library) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-402\n"
	"\tblrl";
#define RemLibrary(library) __RemLibrary(SysBase, (library))

struct Library * __OldOpenLibrary(struct ExecBase *, CONST_STRPTR libName) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-408\n"
	"\tblrl";
#define OldOpenLibrary(libName) __OldOpenLibrary(SysBase, (libName))

VOID __CloseLibrary(struct ExecBase *, struct Library * library) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-414\n"
	"\tblrl";
#define CloseLibrary(library) __CloseLibrary(SysBase, (library))

APTR __SetFunction(struct ExecBase *, struct Library * library, LONG funcOffset, ULONG (*newFunction)()) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tstw\t5,32(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-420\n"
	"\tblrl";
#define SetFunction(library, funcOffset, newFunction) __SetFunction(SysBase, (library), (funcOffset), (newFunction))

VOID __SumLibrary(struct ExecBase *, struct Library * library) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-426\n"
	"\tblrl";
#define SumLibrary(library) __SumLibrary(SysBase, (library))

VOID __AddDevice(struct ExecBase *, struct Device * device) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-432\n"
	"\tblrl";
#define AddDevice(device) __AddDevice(SysBase, (device))

VOID __RemDevice(struct ExecBase *, struct Device * device) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-438\n"
	"\tblrl";
#define RemDevice(device) __RemDevice(SysBase, (device))

BYTE __OpenDevice(struct ExecBase *, CONST_STRPTR devName, ULONG unit, struct IORequest * ioRequest, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,36(2)\n"
	"\tstw\t7,4(2)\n"
	"\tli\t3,-444\n"
	"\tblrl";
#define OpenDevice(devName, unit, ioRequest, flags) __OpenDevice(SysBase, (devName), (unit), (ioRequest), (flags))

VOID __CloseDevice(struct ExecBase *, struct IORequest * ioRequest) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-450\n"
	"\tblrl";
#define CloseDevice(ioRequest) __CloseDevice(SysBase, (ioRequest))

BYTE __DoIO(struct ExecBase *, struct IORequest * ioRequest) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-456\n"
	"\tblrl";
#define DoIO(ioRequest) __DoIO(SysBase, (ioRequest))

VOID __SendIO(struct ExecBase *, struct IORequest * ioRequest) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-462\n"
	"\tblrl";
#define SendIO(ioRequest) __SendIO(SysBase, (ioRequest))

struct IORequest * __CheckIO(struct ExecBase *, struct IORequest * ioRequest) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-468\n"
	"\tblrl";
#define CheckIO(ioRequest) __CheckIO(SysBase, (ioRequest))

BYTE __WaitIO(struct ExecBase *, struct IORequest * ioRequest) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-474\n"
	"\tblrl";
#define WaitIO(ioRequest) __WaitIO(SysBase, (ioRequest))

VOID __AbortIO(struct ExecBase *, struct IORequest * ioRequest) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-480\n"
	"\tblrl";
#define AbortIO(ioRequest) __AbortIO(SysBase, (ioRequest))

VOID __AddResource(struct ExecBase *, APTR resource) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-486\n"
	"\tblrl";
#define AddResource(resource) __AddResource(SysBase, (resource))

VOID __RemResource(struct ExecBase *, APTR resource) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-492\n"
	"\tblrl";
#define RemResource(resource) __RemResource(SysBase, (resource))

APTR __OpenResource(struct ExecBase *, CONST_STRPTR resName) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-498\n"
	"\tblrl";
#define OpenResource(resName) __OpenResource(SysBase, (resName))

APTR __RawDoFmt(struct ExecBase *, CONST_STRPTR formatString, const APTR dataStream, VOID (*putChProc)(), APTR putChData) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,44(2)\n"
	"\tli\t3,-522\n"
	"\tblrl";
#define RawDoFmt(formatString, dataStream, putChProc, putChData) __RawDoFmt(SysBase, (formatString), (dataStream), (putChProc), (putChData))

ULONG __GetCC(struct ExecBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-528\n"
	"\tblrl";
#define GetCC() __GetCC(SysBase)

ULONG __TypeOfMem(struct ExecBase *, const APTR address) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-534\n"
	"\tblrl";
#define TypeOfMem(address) __TypeOfMem(SysBase, (address))

ULONG __Procure(struct ExecBase *, struct SignalSemaphore * sigSem, struct SemaphoreMessage * bidMsg) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-540\n"
	"\tblrl";
#define Procure(sigSem, bidMsg) __Procure(SysBase, (sigSem), (bidMsg))

VOID __Vacate(struct ExecBase *, struct SignalSemaphore * sigSem, struct SemaphoreMessage * bidMsg) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-546\n"
	"\tblrl";
#define Vacate(sigSem, bidMsg) __Vacate(SysBase, (sigSem), (bidMsg))

struct Library * __OpenLibrary(struct ExecBase *, CONST_STRPTR libName, ULONG version) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-552\n"
	"\tblrl";
#define OpenLibrary(libName, version) __OpenLibrary(SysBase, (libName), (version))

VOID __InitSemaphore(struct ExecBase *, struct SignalSemaphore * sigSem) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-558\n"
	"\tblrl";
#define InitSemaphore(sigSem) __InitSemaphore(SysBase, (sigSem))

VOID __ObtainSemaphore(struct ExecBase *, struct SignalSemaphore * sigSem) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-564\n"
	"\tblrl";
#define ObtainSemaphore(sigSem) __ObtainSemaphore(SysBase, (sigSem))

VOID __ReleaseSemaphore(struct ExecBase *, struct SignalSemaphore * sigSem) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-570\n"
	"\tblrl";
#define ReleaseSemaphore(sigSem) __ReleaseSemaphore(SysBase, (sigSem))

ULONG __AttemptSemaphore(struct ExecBase *, struct SignalSemaphore * sigSem) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-576\n"
	"\tblrl";
#define AttemptSemaphore(sigSem) __AttemptSemaphore(SysBase, (sigSem))

VOID __ObtainSemaphoreList(struct ExecBase *, struct List * sigSem) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-582\n"
	"\tblrl";
#define ObtainSemaphoreList(sigSem) __ObtainSemaphoreList(SysBase, (sigSem))

VOID __ReleaseSemaphoreList(struct ExecBase *, struct List * sigSem) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-588\n"
	"\tblrl";
#define ReleaseSemaphoreList(sigSem) __ReleaseSemaphoreList(SysBase, (sigSem))

struct SignalSemaphore * __FindSemaphore(struct ExecBase *, STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-594\n"
	"\tblrl";
#define FindSemaphore(name) __FindSemaphore(SysBase, (name))

VOID __AddSemaphore(struct ExecBase *, struct SignalSemaphore * sigSem) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-600\n"
	"\tblrl";
#define AddSemaphore(sigSem) __AddSemaphore(SysBase, (sigSem))

VOID __RemSemaphore(struct ExecBase *, struct SignalSemaphore * sigSem) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-606\n"
	"\tblrl";
#define RemSemaphore(sigSem) __RemSemaphore(SysBase, (sigSem))

ULONG __SumKickData(struct ExecBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-612\n"
	"\tblrl";
#define SumKickData() __SumKickData(SysBase)

VOID __AddMemList(struct ExecBase *, ULONG size, ULONG attributes, LONG pri, APTR base, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tstw\t6,8(2)\n"
	"\tstw\t7,32(2)\n"
	"\tstw\t8,36(2)\n"
	"\tli\t3,-618\n"
	"\tblrl";
#define AddMemList(size, attributes, pri, base, name) __AddMemList(SysBase, (size), (attributes), (pri), (base), (name))

VOID __CopyMem(struct ExecBase *, const APTR source, APTR dest, ULONG size) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-624\n"
	"\tblrl";
#define CopyMem(source, dest, size) __CopyMem(SysBase, (source), (dest), (size))

VOID __CopyMemQuick(struct ExecBase *, const APTR source, APTR dest, ULONG size) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-630\n"
	"\tblrl";
#define CopyMemQuick(source, dest, size) __CopyMemQuick(SysBase, (source), (dest), (size))

VOID __CacheClearU(struct ExecBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-636\n"
	"\tblrl";
#define CacheClearU() __CacheClearU(SysBase)

VOID __CacheClearE(struct ExecBase *, APTR address, ULONG length, ULONG caches) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,4(2)\n"
	"\tli\t3,-642\n"
	"\tblrl";
#define CacheClearE(address, length, caches) __CacheClearE(SysBase, (address), (length), (caches))

ULONG __CacheControl(struct ExecBase *, ULONG cacheBits, ULONG cacheMask) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-648\n"
	"\tblrl";
#define CacheControl(cacheBits, cacheMask) __CacheControl(SysBase, (cacheBits), (cacheMask))

APTR __CreateIORequest(struct ExecBase *, const struct MsgPort * port, ULONG size) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-654\n"
	"\tblrl";
#define CreateIORequest(port, size) __CreateIORequest(SysBase, (port), (size))

VOID __DeleteIORequest(struct ExecBase *, APTR iorequest) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-660\n"
	"\tblrl";
#define DeleteIORequest(iorequest) __DeleteIORequest(SysBase, (iorequest))

struct MsgPort * __CreateMsgPort(struct ExecBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-666\n"
	"\tblrl";
#define CreateMsgPort() __CreateMsgPort(SysBase)

VOID __DeleteMsgPort(struct ExecBase *, struct MsgPort * port) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-672\n"
	"\tblrl";
#define DeleteMsgPort(port) __DeleteMsgPort(SysBase, (port))

VOID __ObtainSemaphoreShared(struct ExecBase *, struct SignalSemaphore * sigSem) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-678\n"
	"\tblrl";
#define ObtainSemaphoreShared(sigSem) __ObtainSemaphoreShared(SysBase, (sigSem))

APTR __AllocVec(struct ExecBase *, ULONG byteSize, ULONG requirements) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-684\n"
	"\tblrl";
#define AllocVec(byteSize, requirements) __AllocVec(SysBase, (byteSize), (requirements))

VOID __FreeVec(struct ExecBase *, APTR memoryBlock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-690\n"
	"\tblrl";
#define FreeVec(memoryBlock) __FreeVec(SysBase, (memoryBlock))

APTR __CreatePool(struct ExecBase *, ULONG requirements, ULONG puddleSize, ULONG threshSize) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tstw\t6,8(2)\n"
	"\tli\t3,-696\n"
	"\tblrl";
#define CreatePool(requirements, puddleSize, threshSize) __CreatePool(SysBase, (requirements), (puddleSize), (threshSize))

VOID __DeletePool(struct ExecBase *, APTR poolHeader) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-702\n"
	"\tblrl";
#define DeletePool(poolHeader) __DeletePool(SysBase, (poolHeader))

APTR __AllocPooled(struct ExecBase *, APTR poolHeader, ULONG memSize) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-708\n"
	"\tblrl";
#define AllocPooled(poolHeader, memSize) __AllocPooled(SysBase, (poolHeader), (memSize))

VOID __FreePooled(struct ExecBase *, APTR poolHeader, APTR memory, ULONG memSize) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-714\n"
	"\tblrl";
#define FreePooled(poolHeader, memory, memSize) __FreePooled(SysBase, (poolHeader), (memory), (memSize))

ULONG __AttemptSemaphoreShared(struct ExecBase *, struct SignalSemaphore * sigSem) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-720\n"
	"\tblrl";
#define AttemptSemaphoreShared(sigSem) __AttemptSemaphoreShared(SysBase, (sigSem))

VOID __ColdReboot(struct ExecBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-726\n"
	"\tblrl";
#define ColdReboot() __ColdReboot(SysBase)

VOID __StackSwap(struct ExecBase *, struct StackSwapStruct * newStack) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-732\n"
	"\tblrl";
#define StackSwap(newStack) __StackSwap(SysBase, (newStack))

APTR __CachePreDMA(struct ExecBase *, const APTR address, ULONG * length, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-762\n"
	"\tblrl";
#define CachePreDMA(address, length, flags) __CachePreDMA(SysBase, (address), (length), (flags))

VOID __CachePostDMA(struct ExecBase *, const APTR address, ULONG * length, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-768\n"
	"\tblrl";
#define CachePostDMA(address, length, flags) __CachePostDMA(SysBase, (address), (length), (flags))

VOID __AddMemHandler(struct ExecBase *, struct Interrupt * memhand) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-774\n"
	"\tblrl";
#define AddMemHandler(memhand) __AddMemHandler(SysBase, (memhand))

VOID __RemMemHandler(struct ExecBase *, struct Interrupt * memhand) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-780\n"
	"\tblrl";
#define RemMemHandler(memhand) __RemMemHandler(SysBase, (memhand))

ULONG __ObtainQuickVector(struct ExecBase *, APTR interruptCode) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-786\n"
	"\tblrl";
#define ObtainQuickVector(interruptCode) __ObtainQuickVector(SysBase, (interruptCode))

VOID __NewMinList(struct ExecBase *, struct MinList * minlist) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-828\n"
	"\tblrl";
#define NewMinList(minlist) __NewMinList(SysBase, (minlist))

struct AVLNode * __AVL_AddNode(struct ExecBase *, struct AVLNode ** root, struct AVLNode * node, APTR func) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-852\n"
	"\tblrl";
#define AVL_AddNode(root, node, func) __AVL_AddNode(SysBase, (root), (node), (func))

struct AVLNode * __AVL_RemNodeByAddress(struct ExecBase *, struct AVLNode ** root, struct AVLNode * node) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-858\n"
	"\tblrl";
#define AVL_RemNodeByAddress(root, node) __AVL_RemNodeByAddress(SysBase, (root), (node))

struct AVLNode * __AVL_RemNodeByKey(struct ExecBase *, struct AVLNode ** root, APTR key, APTR func) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-864\n"
	"\tblrl";
#define AVL_RemNodeByKey(root, key, func) __AVL_RemNodeByKey(SysBase, (root), (key), (func))

struct AVLNode * __AVL_FindNode(struct ExecBase *, CONST struct AVLNode * root, APTR key, APTR func) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-870\n"
	"\tblrl";
#define AVL_FindNode(root, key, func) __AVL_FindNode(SysBase, (root), (key), (func))

struct AVLNode * __AVL_FindPrevNodeByAddress(struct ExecBase *, CONST struct AVLNode * node) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-876\n"
	"\tblrl";
#define AVL_FindPrevNodeByAddress(node) __AVL_FindPrevNodeByAddress(SysBase, (node))

struct AVLNode * __AVL_FindPrevNodeByKey(struct ExecBase *, CONST struct AVLNode * root, APTR key, APTR func) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-882\n"
	"\tblrl";
#define AVL_FindPrevNodeByKey(root, key, func) __AVL_FindPrevNodeByKey(SysBase, (root), (key), (func))

struct AVLNode * __AVL_FindNextNodeByAddress(struct ExecBase *, CONST struct AVLNode * node) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-888\n"
	"\tblrl";
#define AVL_FindNextNodeByAddress(node) __AVL_FindNextNodeByAddress(SysBase, (node))

struct AVLNode * __AVL_FindNextNodeByKey(struct ExecBase *, CONST struct AVLNode * root, APTR key, APTR func) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-894\n"
	"\tblrl";
#define AVL_FindNextNodeByKey(root, key, func) __AVL_FindNextNodeByKey(SysBase, (root), (key), (func))

struct AVLNode * __AVL_FindFirstNode(struct ExecBase *, CONST struct AVLNode * root) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-900\n"
	"\tblrl";
#define AVL_FindFirstNode(root) __AVL_FindFirstNode(SysBase, (root))

struct AVLNode * __AVL_FindLastNode(struct ExecBase *, CONST struct AVLNode * root) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-906\n"
	"\tblrl";
#define AVL_FindLastNode(root) __AVL_FindLastNode(SysBase, (root))

#endif /*  _VBCCINLINE_EXEC_H  */
