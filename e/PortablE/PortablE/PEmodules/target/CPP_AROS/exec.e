/* Automatically generated from '/home/aros/ABIv0/Build/20110803/AROS/rom/exec/exec.conf' */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/exec/alerts', 'target/exec/avl', 'target/exec/devices', 'target/exec/errors', 'target/exec/execbase', 'target/exec/initializers', 'target/exec/interrupts', 'target/exec/io', 'target/exec/libraries', 'target/exec/lists', 'target/exec/memheaderext', 'target/exec/memory', 'target/exec/nodes', 'target/exec/ports', /*DISABLED FOR BACKWARDS COMPATIBILITY: 'target/exec/rawfmt',*/ 'target/exec/resident', 'target/exec/semaphores', 'target/exec/tasks', 'target/exec/types'
MODULE 'target/aros/libcall', 'target/exec/types', 'target/exec/tasks', 'target/exec/memory', 'target/exec/ports', 'target/exec/devices', 'target/exec/io', 'target/exec/semaphores', 'target/exec/interrupts', 'target/exec/avl', 'target/dos/bptr'
MODULE 'target/exec/types', 'target/aros/system', 'target/defines/exec'
MODULE 'target/utility/tagitem', 'target/dos/dos'
{
#include <proto/exec.h>
}
{
//struct ExecBase* SysBase = NULL;
}
NATIVE {CLIB_EXEC_PROTOS_H} CONST
NATIVE {PROTO_EXEC_H} CONST

NATIVE {SysBase} DEF execbase:NATIVE {struct ExecBase*} PTR TO lib


NATIVE {NewRawDoFmt} PROC
PROC NewRawDoFmt(FormatString:/*CONST_STRPTR*/ ARRAY OF CHAR, PutChProc:NATIVE {VOID_FUNC} PTR, PutChData:APTR, PutChData2=0:ULONG, ...) IS NATIVE {NewRawDoFmt(} FormatString {,} PutChProc {,} PutChData {,} PutChData2 {,} ... {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR

NATIVE {Supervisor} PROC
PROC Supervisor(userFunction:PTR) IS NATIVE {Supervisor(} userFunction {)} ENDNATIVE !!ULONG
->NATIVE {PrepareContext} PROC
->PROC PrepareContext(task:PTR TO tc, entryPoint:APTR, fallBack:APTR, tagList:ARRAY OF tagitem) IS NATIVE {-PrepareContext(} task {,} entryPoint {,} fallBack {,} tagList {)} ENDNATIVE !!INT
NATIVE {Reschedule} PROC
PROC Reschedule() IS NATIVE {Reschedule()} ENDNATIVE
->NATIVE {Switch} PROC
->PROC Switch() IS NATIVE {Switch()} ENDNATIVE
->NATIVE {Dispatch} PROC
->PROC Dispatch() IS NATIVE {Dispatch()} ENDNATIVE
->NATIVE {Exception} PROC
->#removed for backwards compatibility: PROC Exception() IS NATIVE {Exception()} ENDNATIVE
NATIVE {InitCode} PROC
PROC InitCode(startClass:ULONG, version:ULONG) IS NATIVE {InitCode(} startClass {,} version {)} ENDNATIVE
NATIVE {InitStruct} PROC
PROC InitStruct(initTable:APTR, memory:APTR, size:ULONG) IS NATIVE {InitStruct(} initTable {,} memory {,} size {)} ENDNATIVE
NATIVE {MakeLibrary} PROC
PROC MakeLibrary(funcInit:APTR, structInit:APTR, libInit:NATIVE {ULONG_FUNC} PTR, dataSize:ULONG, segList:BPTR) IS NATIVE {MakeLibrary(} funcInit {,} structInit {,} libInit {,} dataSize {,} segList {)} ENDNATIVE !!PTR TO lib
NATIVE {MakeFunctions} PROC
PROC MakeFunctions(target:APTR, functionArray:CONST_APTR, funcDispBase:CONST_APTR) IS NATIVE {MakeFunctions(} target {,} functionArray {,} funcDispBase {)} ENDNATIVE !!ULONG
NATIVE {FindResident} PROC
PROC FindResident(name:ARRAY OF UBYTE) IS NATIVE {FindResident(} name {)} ENDNATIVE !!PTR TO rt
NATIVE {InitResident} PROC
PROC InitResident(resident:PTR TO rt, segList:BPTR) IS NATIVE {InitResident(} resident {,} segList {)} ENDNATIVE !!APTR
NATIVE {Alert} PROC
PROC Alert(alertNum:ULONG) IS NATIVE {Alert(} alertNum {)} ENDNATIVE
NATIVE {Debug} PROC
PROC Debug(flags:ULONG) IS NATIVE {Debug(} flags {)} ENDNATIVE
NATIVE {Disable} PROC
PROC Disable() IS NATIVE {Disable()} ENDNATIVE
NATIVE {Enable} PROC
PROC Enable() IS NATIVE {Enable()} ENDNATIVE
NATIVE {Forbid} PROC
PROC Forbid() IS NATIVE {Forbid()} ENDNATIVE
NATIVE {Permit} PROC
PROC Permit() IS NATIVE {Permit()} ENDNATIVE
NATIVE {SetSR} PROC
PROC SetSR(newSR:ULONG, mask:ULONG) IS NATIVE {SetSR(} newSR {,} mask {)} ENDNATIVE !!ULONG
NATIVE {SuperState} PROC
PROC SuperState() IS NATIVE {SuperState()} ENDNATIVE !!APTR
NATIVE {UserState} PROC
PROC UserState(sysStack:APTR) IS NATIVE {UserState(} sysStack {)} ENDNATIVE
NATIVE {SetIntVector} PROC
PROC SetIntVector(intNumber:ULONG, interrupt:PTR TO is) IS NATIVE {SetIntVector(} intNumber {,} interrupt {)} ENDNATIVE !!PTR TO is
NATIVE {AddIntServer} PROC
PROC AddIntServer(intNumber:ULONG, interrupt:PTR TO is) IS NATIVE {AddIntServer(} intNumber {,} interrupt {)} ENDNATIVE
NATIVE {RemIntServer} PROC
PROC RemIntServer(intNumber:ULONG, interrupt:PTR TO is) IS NATIVE {RemIntServer(} intNumber {,} interrupt {)} ENDNATIVE
NATIVE {Cause} PROC
PROC Cause(softint:PTR TO is) IS NATIVE {Cause(} softint {)} ENDNATIVE
NATIVE {Allocate} PROC
PROC Allocate(freeList:PTR TO mh, byteSize:ULONG) IS NATIVE {Allocate(} freeList {,} byteSize {)} ENDNATIVE !!APTR
NATIVE {Deallocate} PROC
PROC Deallocate(freeList:PTR TO mh, memoryBlock:APTR, byteSize:ULONG) IS NATIVE {Deallocate(} freeList {,} memoryBlock {,} byteSize {)} ENDNATIVE
NATIVE {AllocMem} PROC
PROC AllocMem(byteSize:ULONG, requirements:ULONG) IS NATIVE {AllocMem(} byteSize {,} requirements {)} ENDNATIVE !!APTR
NATIVE {AllocAbs} PROC
PROC AllocAbs(byteSize:ULONG, location:APTR) IS NATIVE {AllocAbs(} byteSize {,} location {)} ENDNATIVE !!APTR
NATIVE {FreeMem} PROC
PROC FreeMem(memoryBlock:APTR, byteSize:ULONG) IS NATIVE {FreeMem(} memoryBlock {,} byteSize {)} ENDNATIVE
NATIVE {AvailMem} PROC
PROC AvailMem(attributes:ULONG) IS NATIVE {AvailMem(} attributes {)} ENDNATIVE !!ULONG
NATIVE {AllocEntry} PROC
PROC AllocEntry(entry:PTR TO ml) IS NATIVE {AllocEntry(} entry {)} ENDNATIVE !!PTR TO ml
NATIVE {FreeEntry} PROC
PROC FreeEntry(entry:PTR TO ml) IS NATIVE {FreeEntry(} entry {)} ENDNATIVE
NATIVE {Insert} PROC
PROC Insert(list:PTR TO lh, node:PTR TO ln, pred:PTR TO ln) IS NATIVE {Insert(} list {,} node {,} pred {)} ENDNATIVE
NATIVE {AddHead} PROC
PROC AddHead(list:PTR TO lh, node:PTR TO ln) IS NATIVE {AddHead(} list {,} node {)} ENDNATIVE
NATIVE {AddTail} PROC
PROC AddTail(list:PTR TO lh, node:PTR TO ln) IS NATIVE {AddTail(} list {,} node {)} ENDNATIVE
NATIVE {Remove} PROC
PROC Remove(node:PTR TO ln) IS NATIVE {Remove(} node {)} ENDNATIVE
NATIVE {RemHead} PROC
PROC RemHead(list:PTR TO lh) IS NATIVE {RemHead(} list {)} ENDNATIVE !!PTR TO ln
NATIVE {RemTail} PROC
PROC RemTail(list:PTR TO lh) IS NATIVE {RemTail(} list {)} ENDNATIVE !!PTR TO ln
NATIVE {Enqueue} PROC
PROC Enqueue(list:PTR TO lh, node:PTR TO ln) IS NATIVE {Enqueue(} list {,} node {)} ENDNATIVE
NATIVE {FindName} PROC
PROC FindName(list:PTR TO lh, name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {FindName(} list {,} name {)} ENDNATIVE !!PTR TO ln
NATIVE {AddTask} PROC
PROC AddTask(task:PTR TO tc, initialPC:APTR, finalPC:APTR) IS NATIVE {AddTask(} task {,} initialPC {,} finalPC {)} ENDNATIVE !!APTR
NATIVE {RemTask} PROC
PROC RemTask(task:PTR TO tc) IS NATIVE {RemTask(} task {)} ENDNATIVE
NATIVE {FindTask} PROC
PROC FindTask(name:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {FindTask(} name {)} ENDNATIVE !!PTR TO tc
NATIVE {SetTaskPri} PROC
PROC SetTaskPri(task:PTR TO tc, priority:VALUE) IS NATIVE {SetTaskPri(} task {,} priority {)} ENDNATIVE !!BYTE
NATIVE {SetSignal} PROC
PROC SetSignal(newSignals:ULONG, signalSet:ULONG) IS NATIVE {SetSignal(} newSignals {,} signalSet {)} ENDNATIVE !!ULONG
NATIVE {SetExcept} PROC
PROC SetExcept(newSignals:ULONG, signalSet:ULONG) IS NATIVE {SetExcept(} newSignals {,} signalSet {)} ENDNATIVE !!ULONG
NATIVE {Wait} PROC
PROC Wait(signalSet:ULONG) IS NATIVE {Wait(} signalSet {)} ENDNATIVE !!ULONG
NATIVE {Signal} PROC
PROC Signal(task:PTR TO tc, signalSet:ULONG) IS NATIVE {Signal(} task {,} signalSet {)} ENDNATIVE
NATIVE {AllocSignal} PROC
PROC AllocSignal(signalNum:VALUE) IS NATIVE {AllocSignal(} signalNum {)} ENDNATIVE !!BYTE
NATIVE {FreeSignal} PROC
PROC FreeSignal(signalNum:VALUE) IS NATIVE {FreeSignal(} signalNum {)} ENDNATIVE
NATIVE {AllocTrap} PROC
PROC AllocTrap(trapNum:VALUE) IS NATIVE {AllocTrap(} trapNum {)} ENDNATIVE !!VALUE
NATIVE {FreeTrap} PROC
PROC FreeTrap(trapNum:VALUE) IS NATIVE {FreeTrap(} trapNum {)} ENDNATIVE
NATIVE {AddPort} PROC
PROC AddPort(port:PTR TO mp) IS NATIVE {AddPort(} port {)} ENDNATIVE
NATIVE {RemPort} PROC
PROC RemPort(port:PTR TO mp) IS NATIVE {RemPort(} port {)} ENDNATIVE
NATIVE {PutMsg} PROC
PROC PutMsg(port:PTR TO mp, message:PTR TO mn) IS NATIVE {PutMsg(} port {,} message {)} ENDNATIVE
NATIVE {GetMsg} PROC
PROC GetMsg(port:PTR TO mp) IS NATIVE {GetMsg(} port {)} ENDNATIVE !!PTR TO mn
NATIVE {ReplyMsg} PROC
PROC ReplyMsg(message:PTR TO mn) IS NATIVE {ReplyMsg(} message {)} ENDNATIVE
NATIVE {WaitPort} PROC
PROC WaitPort(port:PTR TO mp) IS NATIVE {WaitPort(} port {)} ENDNATIVE !!PTR TO mn
NATIVE {FindPort} PROC
PROC FindPort(name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {FindPort(} name {)} ENDNATIVE !!PTR TO mp
NATIVE {AddLibrary} PROC
PROC AddLibrary(library:PTR TO lib) IS NATIVE {AddLibrary(} library {)} ENDNATIVE
NATIVE {RemLibrary} PROC
PROC RemLibrary(library:PTR TO lib) IS NATIVE {RemLibrary(} library {)} ENDNATIVE
NATIVE {OldOpenLibrary} PROC
PROC OldOpenLibrary(libName:ARRAY OF UBYTE) IS NATIVE {OldOpenLibrary(} libName {)} ENDNATIVE !!PTR TO lib
NATIVE {CloseLibrary} PROC
PROC CloseLibrary(library:PTR TO lib) IS NATIVE {CloseLibrary(} library {)} ENDNATIVE
NATIVE {SetFunction} PROC
PROC SetFunction(library:PTR TO lib, funcOffset:VALUE, newFunction:APTR) IS NATIVE {SetFunction(} library {,} funcOffset {,} newFunction {)} ENDNATIVE !!APTR
NATIVE {SumLibrary} PROC
PROC SumLibrary(library:PTR TO lib) IS NATIVE {SumLibrary(} library {)} ENDNATIVE
NATIVE {AddDevice} PROC
PROC AddDevice(device:PTR TO dd) IS NATIVE {AddDevice(} device {)} ENDNATIVE
NATIVE {RemDevice} PROC
PROC RemDevice(device:PTR TO dd) IS NATIVE {RemDevice(} device {)} ENDNATIVE
NATIVE {OpenDevice} PROC
PROC OpenDevice(devName:/*CONST_STRPTR*/ ARRAY OF CHAR, unitNumber:IPTR, iORequest:PTR TO io, flags:ULONG) IS NATIVE {OpenDevice(} devName {,} unitNumber {,} iORequest {,} flags {)} ENDNATIVE !!VALUE
NATIVE {CloseDevice} PROC
PROC CloseDevice(iORequest:PTR TO io) IS NATIVE {CloseDevice(} iORequest {)} ENDNATIVE
NATIVE {DoIO} PROC
PROC DoIO(iORequest:PTR TO io) IS NATIVE {DoIO(} iORequest {)} ENDNATIVE !!VALUE
NATIVE {SendIO} PROC
PROC SendIO(iORequest:PTR TO io) IS NATIVE {SendIO(} iORequest {)} ENDNATIVE
NATIVE {CheckIO} PROC
PROC CheckIO(iORequest:PTR TO io) IS NATIVE {CheckIO(} iORequest {)} ENDNATIVE !!PTR TO io
NATIVE {WaitIO} PROC
PROC WaitIO(iORequest:PTR TO io) IS NATIVE {WaitIO(} iORequest {)} ENDNATIVE !!VALUE
NATIVE {AbortIO} PROC
PROC AbortIO(iORequest:PTR TO io) IS NATIVE {AbortIO(} iORequest {)} ENDNATIVE !!VALUE
NATIVE {AddResource} PROC
PROC AddResource(resource:APTR) IS NATIVE {AddResource(} resource {)} ENDNATIVE
NATIVE {RemResource} PROC
PROC RemResource(resource:APTR) IS NATIVE {RemResource(} resource {)} ENDNATIVE
NATIVE {OpenResource} PROC
PROC OpenResource(resName:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {OpenResource(} resName {)} ENDNATIVE !!APTR
NATIVE {RawIOInit} PROC
PROC RawIOInit() IS NATIVE {RawIOInit()} ENDNATIVE
NATIVE {RawMayGetChar} PROC
PROC RawMayGetChar() IS NATIVE {RawMayGetChar()} ENDNATIVE !!VALUE
NATIVE {RawPutChar} PROC
PROC RawPutChar(chr:UBYTE) IS NATIVE {RawPutChar(} chr {)} ENDNATIVE
NATIVE {RawDoFmt} PROC
PROC RawDoFmt(FormatString:/*CONST_STRPTR*/ ARRAY OF CHAR, DataStream:RAWARG, PutChProc:NATIVE {VOID_FUNC} PTR, PutChData:APTR) IS NATIVE {RawDoFmt(} FormatString {,} DataStream {,} PutChProc {,} PutChData {)} ENDNATIVE !!APTR
NATIVE {GetCC} PROC
PROC GetCC() IS NATIVE {GetCC()} ENDNATIVE !!UINT
NATIVE {TypeOfMem} PROC
PROC TypeOfMem(address:APTR) IS NATIVE {TypeOfMem(} address {)} ENDNATIVE !!ULONG
NATIVE {Procure} PROC
PROC Procure(sigSem:PTR TO ss, bidMsg:PTR TO semaphoremessage) IS NATIVE {Procure(} sigSem {,} bidMsg {)} ENDNATIVE !!ULONG
NATIVE {Vacate} PROC
PROC Vacate(sigSem:PTR TO ss, bidMsg:PTR TO semaphoremessage) IS NATIVE {Vacate(} sigSem {,} bidMsg {)} ENDNATIVE
NATIVE {OpenLibrary} PROC
PROC OpenLibrary(libName:/*CONST_STRPTR*/ ARRAY OF CHAR, version:ULONG) IS NATIVE {OpenLibrary(} libName {,} version {)} ENDNATIVE !!PTR TO lib
NATIVE {InitSemaphore} PROC
PROC InitSemaphore(sigSem:PTR TO ss) IS NATIVE {InitSemaphore(} sigSem {)} ENDNATIVE
NATIVE {ObtainSemaphore} PROC
PROC ObtainSemaphore(sigSem:PTR TO ss) IS NATIVE {ObtainSemaphore(} sigSem {)} ENDNATIVE
NATIVE {ReleaseSemaphore} PROC
PROC ReleaseSemaphore(sigSem:PTR TO ss) IS NATIVE {ReleaseSemaphore(} sigSem {)} ENDNATIVE
NATIVE {AttemptSemaphore} PROC
PROC AttemptSemaphore(sigSem:PTR TO ss) IS NATIVE {AttemptSemaphore(} sigSem {)} ENDNATIVE !!ULONG
NATIVE {ObtainSemaphoreList} PROC
PROC ObtainSemaphoreList(sigSem:PTR TO lh) IS NATIVE {ObtainSemaphoreList(} sigSem {)} ENDNATIVE
NATIVE {ReleaseSemaphoreList} PROC
PROC ReleaseSemaphoreList(sigSem:PTR TO lh) IS NATIVE {ReleaseSemaphoreList(} sigSem {)} ENDNATIVE
NATIVE {FindSemaphore} PROC
PROC FindSemaphore(name:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {FindSemaphore(} name {)} ENDNATIVE !!PTR TO ss
NATIVE {AddSemaphore} PROC
PROC AddSemaphore(sigSem:PTR TO ss) IS NATIVE {AddSemaphore(} sigSem {)} ENDNATIVE
NATIVE {RemSemaphore} PROC
PROC RemSemaphore(sigSem:PTR TO ss) IS NATIVE {RemSemaphore(} sigSem {)} ENDNATIVE
NATIVE {SumKickData} PROC
PROC SumKickData() IS NATIVE {SumKickData()} ENDNATIVE !!ULONG
NATIVE {AddMemList} PROC
PROC AddMemList(size:ULONG, attributes:ULONG, pri:VALUE, base:APTR, name:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {AddMemList(} size {,} attributes {,} pri {,} base {,} name {)} ENDNATIVE
NATIVE {CopyMem} PROC
PROC CopyMem(source:CONST_APTR, dest:APTR, size:ULONG) IS NATIVE {CopyMem(} source {,} dest {,} size {)} ENDNATIVE
NATIVE {CopyMemQuick} PROC
PROC CopyMemQuick(source:CONST_APTR, dest:APTR, size:ULONG) IS NATIVE {CopyMemQuick(} source {,} dest {,} size {)} ENDNATIVE
NATIVE {CacheClearU} PROC
PROC CacheClearU() IS NATIVE {CacheClearU()} ENDNATIVE
NATIVE {CacheClearE} PROC
PROC CacheClearE(address:APTR, length:ULONG, caches:ULONG) IS NATIVE {CacheClearE(} address {,} length {,} caches {)} ENDNATIVE
NATIVE {CacheControl} PROC
PROC CacheControl(cacheBits:ULONG, cacheMask:ULONG) IS NATIVE {CacheControl(} cacheBits {,} cacheMask {)} ENDNATIVE !!ULONG
NATIVE {CreateIORequest} PROC
PROC CreateIORequest(ioReplyPort:PTR TO mp, size:ULONG) IS NATIVE {CreateIORequest(} ioReplyPort {,} size {)} ENDNATIVE !!APTR2
NATIVE {DeleteIORequest} PROC
PROC DeleteIORequest(iorequest:APTR2) IS NATIVE {DeleteIORequest(} iorequest {)} ENDNATIVE
NATIVE {CreateMsgPort} PROC
PROC CreateMsgPort() IS NATIVE {CreateMsgPort()} ENDNATIVE !!PTR TO mp
NATIVE {DeleteMsgPort} PROC
PROC DeleteMsgPort(port:PTR TO mp) IS NATIVE {DeleteMsgPort(} port {)} ENDNATIVE
NATIVE {ObtainSemaphoreShared} PROC
PROC ObtainSemaphoreShared(sigSem:PTR TO ss) IS NATIVE {ObtainSemaphoreShared(} sigSem {)} ENDNATIVE
NATIVE {AllocVec} PROC
PROC AllocVec(byteSize:ULONG, requirements:ULONG) IS NATIVE {AllocVec(} byteSize {,} requirements {)} ENDNATIVE !!APTR
NATIVE {FreeVec} PROC
PROC FreeVec(memoryBlock:APTR) IS NATIVE {FreeVec(} memoryBlock {)} ENDNATIVE
NATIVE {CreatePool} PROC
PROC CreatePool(requirements:ULONG, puddleSize:ULONG, threshSize:ULONG) IS NATIVE {CreatePool(} requirements {,} puddleSize {,} threshSize {)} ENDNATIVE !!APTR
NATIVE {DeletePool} PROC
PROC DeletePool(poolHeader:APTR) IS NATIVE {DeletePool(} poolHeader {)} ENDNATIVE
NATIVE {AllocPooled} PROC
PROC AllocPooled(poolHeader:APTR, memSize:ULONG) IS NATIVE {AllocPooled(} poolHeader {,} memSize {)} ENDNATIVE !!APTR
NATIVE {FreePooled} PROC
PROC FreePooled(poolHeader:APTR, memory:APTR, memSize:ULONG) IS NATIVE {FreePooled(} poolHeader {,} memory {,} memSize {)} ENDNATIVE
NATIVE {AttemptSemaphoreShared} PROC
PROC AttemptSemaphoreShared(sigSem:PTR TO ss) IS NATIVE {AttemptSemaphoreShared(} sigSem {)} ENDNATIVE !!ULONG
NATIVE {ColdReboot} PROC
PROC ColdReboot() IS NATIVE {ColdReboot()} ENDNATIVE
->NATIVE {StackSwap} PROC
->PROC StackSwap(sss:PTR TO stackswapstruct) IS NATIVE {StackSwap(} sss {)} ENDNATIVE
NATIVE {ChildFree} PROC
PROC ChildFree(tid:ULONG) IS NATIVE {ChildFree(} tid {)} ENDNATIVE
NATIVE {ChildOrphan} PROC
PROC ChildOrphan(tid:ULONG) IS NATIVE {ChildOrphan(} tid {)} ENDNATIVE !!ULONG
NATIVE {ChildStatus} PROC
PROC ChildStatus(tid:ULONG) IS NATIVE {ChildStatus(} tid {)} ENDNATIVE !!ULONG
NATIVE {ChildWait} PROC
PROC ChildWait(tid:ULONG) IS NATIVE {ChildWait(} tid {)} ENDNATIVE !!IPTR
NATIVE {CachePreDMA} PROC
PROC CachePreDMA(address:APTR, length:PTR TO ULONG, flags:ULONG) IS NATIVE {CachePreDMA(} address {,} length {,} flags {)} ENDNATIVE !!APTR
NATIVE {CachePostDMA} PROC
PROC CachePostDMA(address:APTR, length:PTR TO ULONG, flags:ULONG) IS NATIVE {CachePostDMA(} address {,} length {,} flags {)} ENDNATIVE
NATIVE {AddMemHandler} PROC
PROC AddMemHandler(memHandler:PTR TO is) IS NATIVE {AddMemHandler(} memHandler {)} ENDNATIVE
NATIVE {RemMemHandler} PROC
PROC RemMemHandler(memHandler:PTR TO is) IS NATIVE {RemMemHandler(} memHandler {)} ENDNATIVE
NATIVE {ObtainQuickVector} PROC
PROC ObtainQuickVector(interruptCode:APTR) IS NATIVE {ObtainQuickVector(} interruptCode {)} ENDNATIVE !!ULONG
NATIVE {NewStackSwap} PROC
->will not compile for some reason: PROC NewStackSwap(newStack:PTR TO stackswapstruct, function:APTR, args:PTR TO stackswapstruct) IS NATIVE {NewStackSwap(} newStack {,} function {,} args {)} ENDNATIVE !!IPTR
NATIVE {TaggedOpenLibrary} PROC
PROC TaggedOpenLibrary(tag:VALUE) IS NATIVE {TaggedOpenLibrary(} tag {)} ENDNATIVE !!APTR
NATIVE {ReadGayle} PROC
PROC ReadGayle() IS NATIVE {ReadGayle()} ENDNATIVE !!ULONG
NATIVE {VNewRawDoFmt} PROC
->va_list is not supported: PROC VnewRawDoFmt(FormatString:/*CONST_STRPTR*/ ARRAY OF CHAR, PutChProc:NATIVE {VOID_FUNC} PTR, PutChData:APTR, VaListStream:#va_list) IS NATIVE {VNewRawDoFmt(} FormatString {,} PutChProc {,} PutChData {,} VaListStream {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {AVL_AddNode} PROC
PROC AvL_AddNode(root:PTR TO PTR /*TO avlnode*/, node:PTR TO avlnode, func:AVLNODECOMP) IS NATIVE {AVL_AddNode( (AVLNode **) } root {,} node {,} func {)} ENDNATIVE !!PTR TO avlnode
NATIVE {AVL_RemNodeByAddress} PROC
PROC AvL_RemNodeByAddress(root:PTR TO PTR /*TO avlnode*/, node:PTR TO avlnode) IS NATIVE {AVL_RemNodeByAddress( (AVLNode **) } root {,} node {)} ENDNATIVE !!PTR TO avlnode
NATIVE {AVL_RemNodeByKey} PROC
PROC AvL_RemNodeByKey(root:PTR TO PTR /*TO avlnode*/, key:AVLKey, func:AVLKEYCOMP) IS NATIVE {AVL_RemNodeByKey( (AVLNode **) } root {,} key {,} func {)} ENDNATIVE !!PTR TO avlnode
NATIVE {AVL_FindNode} PROC
PROC AvL_FindNode(root:PTR TO avlnode, key:AVLKey, func:AVLKEYCOMP) IS NATIVE {AVL_FindNode(} root {,} key {,} func {)} ENDNATIVE !!PTR TO avlnode
NATIVE {AVL_FindPrevNodeByAddress} PROC
PROC AvL_FindPrevNodeByAddress(node:PTR TO avlnode) IS NATIVE {AVL_FindPrevNodeByAddress(} node {)} ENDNATIVE !!PTR TO avlnode
NATIVE {AVL_FindPrevNodeByKey} PROC
PROC AvL_FindPrevNodeByKey(root:PTR TO avlnode, key:AVLKey, func:AVLKEYCOMP) IS NATIVE {AVL_FindPrevNodeByKey(} root {,} key {,} func {)} ENDNATIVE !!PTR TO avlnode
NATIVE {AVL_FindNextNodeByAddress} PROC
PROC AvL_FindNextNodeByAddress(node:PTR TO avlnode) IS NATIVE {AVL_FindNextNodeByAddress(} node {)} ENDNATIVE !!PTR TO avlnode
NATIVE {AVL_FindNextNodeByKey} PROC
PROC AvL_FindNextNodeByKey(node:PTR TO avlnode, key:AVLKey, func:AVLKEYCOMP) IS NATIVE {AVL_FindNextNodeByKey(} node {,} key {,} func {)} ENDNATIVE !!PTR TO avlnode
NATIVE {AVL_FindFirstNode} PROC
PROC AvL_FindFirstNode(root:PTR TO avlnode) IS NATIVE {AVL_FindFirstNode(} root {)} ENDNATIVE !!PTR TO avlnode
NATIVE {AVL_FindLastNode} PROC
PROC AvL_FindLastNode(root:PTR TO avlnode) IS NATIVE {AVL_FindLastNode(} root {)} ENDNATIVE !!PTR TO avlnode
NATIVE {AllocVecPooled} PROC
PROC AllocVecPooled(pool:APTR, size:ULONG) IS NATIVE {AllocVecPooled(} pool {,} size {)} ENDNATIVE !!APTR
NATIVE {FreeVecPooled} PROC
PROC FreeVecPooled(pool:APTR, memory:APTR) IS NATIVE {FreeVecPooled(} pool {,} memory {)} ENDNATIVE
NATIVE {NewAllocEntry} PROC
PROC NewAllocEntry(entry:PTR TO ml, /*return_entry:ARRAY OF PTR TO ml,*/ return_flags:PTR TO ULONG) IS NATIVE {NewAllocEntry(} entry {,} return_flags {)} ENDNATIVE !!PTR TO ml
NATIVE {NewAddTask} PROC
PROC NewAddTask(task:PTR TO tc, initialPC:APTR, finalPC:APTR, tagList:ARRAY OF tagitem) IS NATIVE {NewAddTask(} task {,} initialPC {,} finalPC {,} tagList {)} ENDNATIVE !!APTR
NATIVE {NewCreateTaskA} PROC
PROC NewCreateTaskA(tags:ARRAY OF tagitem) IS NATIVE {NewCreateTaskA(} tags {)} ENDNATIVE !!PTR TO tc
NATIVE {AddResetCallback} PROC
PROC AddResetCallback(resetCallback:PTR TO is) IS NATIVE {-AddResetCallback(} resetCallback {)} ENDNATIVE !!INT
NATIVE {RemResetCallback} PROC
PROC RemResetCallback(resetCallback:PTR TO is) IS NATIVE {RemResetCallback(} resetCallback {)} ENDNATIVE
NATIVE {ShutdownA} PROC
PROC ShutdownA(action:ULONG) IS NATIVE {ShutdownA(} action {)} ENDNATIVE !!ULONG
