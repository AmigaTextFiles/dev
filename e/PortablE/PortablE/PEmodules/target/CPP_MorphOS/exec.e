/* C++ module, for $VER: exec_protos.h 45.2 (6.6.1998) */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/exec/types', 'target/exec/nodes', 'target/exec/lists', 'target/exec/alerts', 'target/exec/errors', 'target/exec/initializers', 'target/exec/resident', 'target/exec/memory', 'target/exec/tasks', 'target/exec/ports', 'target/exec/interrupts', 'target/exec/semaphores', 'target/exec/strings', 'target/exec/libraries', 'target/exec/io', 'target/exec/devices', 'target/exec/execbase'
MODULE 'target/exec/types', 'target/exec/tasks', 'target/exec/memory', 'target/exec/ports', 'target/exec/devices', 'target/exec/io', 'target/exec/semaphores'
{
#include <proto/exec.h>
}
{
struct ExecBase* SysBase = NULL;
}
NATIVE {CLIB_EXEC_PROTOS_H} CONST
NATIVE {_PROTO_EXEC_H} CONST
NATIVE {PRAGMA_EXEC_H} CONST
NATIVE {PRAGMAS_EXEC_PRAGMAS_H} CONST

NATIVE {SysBase} DEF execbase:NATIVE {struct ExecBase*} PTR TO lib


/*------ misc ---------------------------------------------------------*/
NATIVE {Supervisor} PROC
PROC Supervisor( userFunction:PTR /*ULONG (*CONST userFunction)()*/ ) IS NATIVE {Supervisor( (ULONG (*)()) } userFunction {)} ENDNATIVE !!ULONG
/*------ special patchable hooks to internal exec activity ------------*/
/*------ module creation ----------------------------------------------*/
NATIVE {InitCode} PROC
PROC InitCode( startClass:ULONG, version:ULONG ) IS NATIVE {InitCode(} startClass {,} version {)} ENDNATIVE
NATIVE {InitStruct} PROC
PROC InitStruct( initTable:APTR, memory:APTR, size:ULONG ) IS NATIVE {InitStruct(} initTable {,} memory {,} size {)} ENDNATIVE
NATIVE {MakeLibrary} PROC
PROC MakeLibrary( funcInit:APTR, structInit:APTR, libInit:PTR /*ULONG (*CONST libInit)()*/, dataSize:ULONG, segList:ULONG ) IS NATIVE {MakeLibrary(} funcInit {,} structInit {, (ULONG (*)()) } libInit {,} dataSize {,} segList {)} ENDNATIVE !!PTR TO lib
NATIVE {MakeFunctions} PROC
PROC MakeFunctions( target:APTR, functionArray:APTR, funcDispBase:APTR ) IS NATIVE {MakeFunctions(} target {,} functionArray {,} funcDispBase {)} ENDNATIVE
NATIVE {FindResident} PROC
PROC FindResident( name:ARRAY OF CHAR ) IS NATIVE {FindResident(} name {)} ENDNATIVE !!PTR TO rt
NATIVE {InitResident} PROC
PROC InitResident( resident:PTR TO rt, segList:ULONG ) IS NATIVE {InitResident(} resident {,} segList {)} ENDNATIVE !!APTR
/*------ diagnostics --------------------------------------------------*/
NATIVE {Alert} PROC
PROC Alert( alertNum:ULONG ) IS NATIVE {Alert(} alertNum {)} ENDNATIVE
NATIVE {Debug} PROC
PROC Debug( flags:ULONG ) IS NATIVE {Debug(} flags {)} ENDNATIVE
/*------ interrupts ---------------------------------------------------*/
NATIVE {Disable} PROC
PROC Disable( ) IS NATIVE {Disable()} ENDNATIVE
NATIVE {Enable} PROC
PROC Enable( ) IS NATIVE {Enable()} ENDNATIVE
NATIVE {Forbid} PROC
PROC Forbid( ) IS NATIVE {Forbid()} ENDNATIVE
NATIVE {Permit} PROC
PROC Permit( ) IS NATIVE {Permit()} ENDNATIVE
NATIVE {SetSR} PROC
PROC SetSR( newSR:ULONG, mask:ULONG ) IS NATIVE {SetSR(} newSR {,} mask {)} ENDNATIVE !!ULONG
NATIVE {SuperState} PROC
PROC SuperState( ) IS NATIVE {SuperState()} ENDNATIVE !!APTR
NATIVE {UserState} PROC
PROC UserState( sysStack:APTR ) IS NATIVE {UserState(} sysStack {)} ENDNATIVE
NATIVE {SetIntVector} PROC
PROC SetIntVector( intNumber:VALUE, interrupt:PTR TO is ) IS NATIVE {SetIntVector(} intNumber {,} interrupt {)} ENDNATIVE !!PTR TO is
NATIVE {AddIntServer} PROC
PROC AddIntServer( intNumber:VALUE, interrupt:PTR TO is ) IS NATIVE {AddIntServer(} intNumber {,} interrupt {)} ENDNATIVE
NATIVE {RemIntServer} PROC
PROC RemIntServer( intNumber:VALUE, interrupt:PTR TO is ) IS NATIVE {RemIntServer(} intNumber {,} interrupt {)} ENDNATIVE
NATIVE {Cause} PROC
PROC Cause( interrupt:PTR TO is ) IS NATIVE {Cause(} interrupt {)} ENDNATIVE
/*------ memory allocation --------------------------------------------*/
NATIVE {Allocate} PROC
PROC Allocate( freeList:PTR TO mh, byteSize:ULONG ) IS NATIVE {Allocate(} freeList {,} byteSize {)} ENDNATIVE !!APTR
NATIVE {Deallocate} PROC
PROC Deallocate( freeList:PTR TO mh, memoryBlock:APTR, byteSize:ULONG ) IS NATIVE {Deallocate(} freeList {,} memoryBlock {,} byteSize {)} ENDNATIVE
NATIVE {AllocMem} PROC
PROC AllocMem( byteSize:ULONG, requirements:ULONG ) IS NATIVE {AllocMem(} byteSize {,} requirements {)} ENDNATIVE !!APTR
NATIVE {AllocAbs} PROC
PROC AllocAbs( byteSize:ULONG, location:APTR ) IS NATIVE {AllocAbs(} byteSize {,} location {)} ENDNATIVE !!APTR
NATIVE {FreeMem} PROC
PROC FreeMem( memoryBlock:APTR, byteSize:ULONG ) IS NATIVE {FreeMem(} memoryBlock {,} byteSize {)} ENDNATIVE
NATIVE {AvailMem} PROC
PROC AvailMem( requirements:ULONG ) IS NATIVE {AvailMem(} requirements {)} ENDNATIVE !!ULONG
NATIVE {AllocEntry} PROC
PROC AllocEntry( entry:PTR TO ml ) IS NATIVE {AllocEntry(} entry {)} ENDNATIVE !!PTR TO ml
NATIVE {FreeEntry} PROC
PROC FreeEntry( entry:PTR TO ml ) IS NATIVE {FreeEntry(} entry {)} ENDNATIVE
/*------ lists --------------------------------------------------------*/
NATIVE {Insert} PROC
PROC Insert( list:PTR TO lh, node:PTR TO ln, pred:PTR TO ln ) IS NATIVE {Insert(} list {,} node {,} pred {)} ENDNATIVE
NATIVE {AddHead} PROC
PROC AddHead( list:PTR TO lh, node:PTR TO ln ) IS NATIVE {AddHead(} list {,} node {)} ENDNATIVE
NATIVE {AddTail} PROC
PROC AddTail( list:PTR TO lh, node:PTR TO ln ) IS NATIVE {AddTail(} list {,} node {)} ENDNATIVE
NATIVE {Remove} PROC
PROC Remove( node:PTR TO ln ) IS NATIVE {Remove(} node {)} ENDNATIVE
NATIVE {RemHead} PROC
PROC RemHead( list:PTR TO lh ) IS NATIVE {RemHead(} list {)} ENDNATIVE !!PTR TO ln
NATIVE {RemTail} PROC
PROC RemTail( list:PTR TO lh ) IS NATIVE {RemTail(} list {)} ENDNATIVE !!PTR TO ln
NATIVE {Enqueue} PROC
PROC Enqueue( list:PTR TO lh, node:PTR TO ln ) IS NATIVE {Enqueue(} list {,} node {)} ENDNATIVE
NATIVE {FindName} PROC
PROC FindName( list:PTR TO lh, name:ARRAY OF CHAR ) IS NATIVE {FindName(} list {,} name {)} ENDNATIVE !!PTR TO ln
/*------ tasks --------------------------------------------------------*/
NATIVE {AddTask} PROC
PROC AddTask( task:PTR TO tc, initPC:APTR, finalPC:APTR ) IS NATIVE {AddTask(} task {,} initPC {,} finalPC {)} ENDNATIVE !!APTR
NATIVE {RemTask} PROC
PROC RemTask( task:PTR TO tc ) IS NATIVE {RemTask(} task {)} ENDNATIVE
NATIVE {FindTask} PROC
PROC FindTask( name:ARRAY OF CHAR ) IS NATIVE {FindTask(} name {)} ENDNATIVE !!PTR TO tc
NATIVE {SetTaskPri} PROC
PROC SetTaskPri( task:PTR TO tc, priority:VALUE ) IS NATIVE {SetTaskPri(} task {,} priority {)} ENDNATIVE !!BYTE
NATIVE {SetSignal} PROC
PROC SetSignal( newSignals:ULONG, signalSet:ULONG ) IS NATIVE {SetSignal(} newSignals {,} signalSet {)} ENDNATIVE !!ULONG
NATIVE {SetExcept} PROC
PROC SetExcept( newSignals:ULONG, signalSet:ULONG ) IS NATIVE {SetExcept(} newSignals {,} signalSet {)} ENDNATIVE !!ULONG
NATIVE {Wait} PROC
PROC Wait( signalSet:ULONG ) IS NATIVE {Wait(} signalSet {)} ENDNATIVE !!ULONG
NATIVE {Signal} PROC
PROC Signal( task:PTR TO tc, signalSet:ULONG ) IS NATIVE {Signal(} task {,} signalSet {)} ENDNATIVE
NATIVE {AllocSignal} PROC
PROC AllocSignal( signalNum:VALUE ) IS NATIVE {AllocSignal(} signalNum {)} ENDNATIVE !!BYTE
NATIVE {FreeSignal} PROC
PROC FreeSignal( signalNum:VALUE ) IS NATIVE {FreeSignal(} signalNum {)} ENDNATIVE
NATIVE {AllocTrap} PROC
PROC AllocTrap( trapNum:VALUE ) IS NATIVE {AllocTrap(} trapNum {)} ENDNATIVE !!VALUE
NATIVE {FreeTrap} PROC
PROC FreeTrap( trapNum:VALUE ) IS NATIVE {FreeTrap(} trapNum {)} ENDNATIVE
/*------ messages -----------------------------------------------------*/
NATIVE {AddPort} PROC
PROC AddPort( port:PTR TO mp ) IS NATIVE {AddPort(} port {)} ENDNATIVE
NATIVE {RemPort} PROC
PROC RemPort( port:PTR TO mp ) IS NATIVE {RemPort(} port {)} ENDNATIVE
NATIVE {PutMsg} PROC
PROC PutMsg( port:PTR TO mp, message:PTR TO mn ) IS NATIVE {PutMsg(} port {,} message {)} ENDNATIVE
NATIVE {GetMsg} PROC
PROC GetMsg( port:PTR TO mp ) IS NATIVE {GetMsg(} port {)} ENDNATIVE !!PTR TO mn
NATIVE {ReplyMsg} PROC
PROC ReplyMsg( message:PTR TO mn ) IS NATIVE {ReplyMsg(} message {)} ENDNATIVE
NATIVE {WaitPort} PROC
PROC WaitPort( port:PTR TO mp ) IS NATIVE {WaitPort(} port {)} ENDNATIVE !!PTR TO mn
NATIVE {FindPort} PROC
PROC FindPort( name:ARRAY OF CHAR ) IS NATIVE {FindPort(} name {)} ENDNATIVE !!PTR TO mp
/*------ libraries ----------------------------------------------------*/
NATIVE {AddLibrary} PROC
PROC AddLibrary( library:PTR TO lib ) IS NATIVE {AddLibrary(} library {)} ENDNATIVE
NATIVE {RemLibrary} PROC
PROC RemLibrary( library:PTR TO lib ) IS NATIVE {RemLibrary(} library {)} ENDNATIVE
NATIVE {OldOpenLibrary} PROC
PROC OldOpenLibrary( libName:ARRAY OF CHAR ) IS NATIVE {OldOpenLibrary(} libName {)} ENDNATIVE !!PTR TO lib
NATIVE {CloseLibrary} PROC
PROC CloseLibrary( library:PTR TO lib ) IS NATIVE {CloseLibrary(} library {)} ENDNATIVE
NATIVE {SetFunction} PROC
PROC SetFunction( library:PTR TO lib, funcOffset:VALUE, newFunction:PTR /*ULONG (*CONST newFunction)()*/ ) IS NATIVE {SetFunction(} library {,} funcOffset {, (ULONG (*)()) } newFunction {)} ENDNATIVE !!APTR
NATIVE {SumLibrary} PROC
PROC SumLibrary( library:PTR TO lib ) IS NATIVE {SumLibrary(} library {)} ENDNATIVE
/*------ devices ------------------------------------------------------*/
NATIVE {AddDevice} PROC
PROC AddDevice( device:PTR TO dd ) IS NATIVE {AddDevice(} device {)} ENDNATIVE
NATIVE {RemDevice} PROC
PROC RemDevice( device:PTR TO dd ) IS NATIVE {RemDevice(} device {)} ENDNATIVE
NATIVE {OpenDevice} PROC
PROC OpenDevice( devName:ARRAY OF CHAR, unit:ULONG, ioRequest:PTR TO io, flags:ULONG ) IS NATIVE {OpenDevice(} devName {,} unit {,} ioRequest {,} flags {)} ENDNATIVE !!BYTE
NATIVE {CloseDevice} PROC
PROC CloseDevice( ioRequest:PTR TO io ) IS NATIVE {CloseDevice(} ioRequest {)} ENDNATIVE
NATIVE {DoIO} PROC
PROC DoIO( ioRequest:PTR TO io ) IS NATIVE {DoIO(} ioRequest {)} ENDNATIVE !!BYTE
NATIVE {SendIO} PROC
PROC SendIO( ioRequest:PTR TO io ) IS NATIVE {SendIO(} ioRequest {)} ENDNATIVE
NATIVE {CheckIO} PROC
PROC CheckIO( ioRequest:PTR TO io ) IS NATIVE {CheckIO(} ioRequest {)} ENDNATIVE !!PTR TO io
NATIVE {WaitIO} PROC
PROC WaitIO( ioRequest:PTR TO io ) IS NATIVE {WaitIO(} ioRequest {)} ENDNATIVE !!BYTE
NATIVE {AbortIO} PROC
PROC AbortIO( ioRequest:PTR TO io ) IS NATIVE {AbortIO(} ioRequest {)} ENDNATIVE
/*------ resources ----------------------------------------------------*/
NATIVE {AddResource} PROC
PROC AddResource( resource:APTR ) IS NATIVE {AddResource(} resource {)} ENDNATIVE
NATIVE {RemResource} PROC
PROC RemResource( resource:APTR ) IS NATIVE {RemResource(} resource {)} ENDNATIVE
NATIVE {OpenResource} PROC
PROC OpenResource( resName:ARRAY OF CHAR ) IS NATIVE {OpenResource(} resName {)} ENDNATIVE !!APTR
/*------ private diagnostic support -----------------------------------*/
/*------ misc ---------------------------------------------------------*/
NATIVE {RawDoFmt} PROC
PROC RawDoFmt( formatString:ARRAY OF CHAR, dataStream:APTR, putChProc:PTR /*VOID (*CONST putChProc)()*/, putChData:APTR ) IS NATIVE {RawDoFmt(} formatString {,} dataStream {, (VOID (*)()) } putChProc {,} putChData {)} ENDNATIVE !!APTR
NATIVE {GetCC} PROC
PROC GetCC( ) IS NATIVE {GetCC()} ENDNATIVE !!ULONG
NATIVE {TypeOfMem} PROC
PROC TypeOfMem( address:APTR ) IS NATIVE {TypeOfMem(} address {)} ENDNATIVE !!ULONG
NATIVE {Procure} PROC
PROC Procure( sigSem:PTR TO ss, bidMsg:PTR TO semaphoremessage ) IS NATIVE {Procure(} sigSem {,} bidMsg {)} ENDNATIVE !!ULONG
NATIVE {Vacate} PROC
PROC Vacate( sigSem:PTR TO ss, bidMsg:PTR TO semaphoremessage ) IS NATIVE {Vacate(} sigSem {,} bidMsg {)} ENDNATIVE
NATIVE {OpenLibrary} PROC
PROC OpenLibrary( libName:ARRAY OF CHAR, version:ULONG ) IS NATIVE {OpenLibrary(} libName {,} version {)} ENDNATIVE !!PTR TO lib
/*--- functions in V33 or higher (Release 1.2) ---*/
/*------ signal semaphores (note funny registers)----------------------*/
NATIVE {InitSemaphore} PROC
PROC InitSemaphore( sigSem:PTR TO ss ) IS NATIVE {InitSemaphore(} sigSem {)} ENDNATIVE
NATIVE {ObtainSemaphore} PROC
PROC ObtainSemaphore( sigSem:PTR TO ss ) IS NATIVE {ObtainSemaphore(} sigSem {)} ENDNATIVE
NATIVE {ReleaseSemaphore} PROC
PROC ReleaseSemaphore( sigSem:PTR TO ss ) IS NATIVE {ReleaseSemaphore(} sigSem {)} ENDNATIVE
NATIVE {AttemptSemaphore} PROC
PROC AttemptSemaphore( sigSem:PTR TO ss ) IS NATIVE {AttemptSemaphore(} sigSem {)} ENDNATIVE !!ULONG
NATIVE {ObtainSemaphoreList} PROC
PROC ObtainSemaphoreList( sigSem:PTR TO lh ) IS NATIVE {ObtainSemaphoreList(} sigSem {)} ENDNATIVE
NATIVE {ReleaseSemaphoreList} PROC
PROC ReleaseSemaphoreList( sigSem:PTR TO lh ) IS NATIVE {ReleaseSemaphoreList(} sigSem {)} ENDNATIVE
NATIVE {FindSemaphore} PROC
PROC FindSemaphore( name:ARRAY OF CHAR ) IS NATIVE {FindSemaphore(} name {)} ENDNATIVE !!PTR TO ss
NATIVE {AddSemaphore} PROC
PROC AddSemaphore( sigSem:PTR TO ss ) IS NATIVE {AddSemaphore(} sigSem {)} ENDNATIVE
NATIVE {RemSemaphore} PROC
PROC RemSemaphore( sigSem:PTR TO ss ) IS NATIVE {RemSemaphore(} sigSem {)} ENDNATIVE
/*------ kickmem support ----------------------------------------------*/
NATIVE {SumKickData} PROC
PROC SumKickData( ) IS NATIVE {SumKickData()} ENDNATIVE !!ULONG
/*------ more memory support ------------------------------------------*/
NATIVE {AddMemList} PROC
PROC AddMemList( size:ULONG, attributes:ULONG, pri:VALUE, base:APTR, name:ARRAY OF CHAR ) IS NATIVE {AddMemList(} size {,} attributes {,} pri {,} base {,} name {)} ENDNATIVE
NATIVE {CopyMem} PROC
PROC CopyMem( source:APTR, dest:APTR, size:ULONG ) IS NATIVE {CopyMem(} source {,} dest {,} size {)} ENDNATIVE
NATIVE {CopyMemQuick} PROC
PROC CopyMemQuick( source:APTR, dest:APTR, size:ULONG ) IS NATIVE {CopyMemQuick(} source {,} dest {,} size {)} ENDNATIVE
/*------ cache --------------------------------------------------------*/
/*--- functions in V36 or higher (Release 2.0) ---*/
NATIVE {CacheClearU} PROC
PROC CacheClearU( ) IS NATIVE {CacheClearU()} ENDNATIVE
NATIVE {CacheClearE} PROC
PROC CacheClearE( address:APTR, length:ULONG, caches:ULONG ) IS NATIVE {CacheClearE(} address {,} length {,} caches {)} ENDNATIVE
NATIVE {CacheControl} PROC
PROC CacheControl( cacheBits:ULONG, cacheMask:ULONG ) IS NATIVE {CacheControl(} cacheBits {,} cacheMask {)} ENDNATIVE !!ULONG
/*------ misc ---------------------------------------------------------*/
NATIVE {CreateIORequest} PROC
PROC CreateIORequest( port:PTR TO mp, size:ULONG ) IS NATIVE {CreateIORequest(} port {,} size {)} ENDNATIVE !!APTR2
NATIVE {DeleteIORequest} PROC
PROC DeleteIORequest( iorequest:APTR2 ) IS NATIVE {DeleteIORequest(} iorequest {)} ENDNATIVE
NATIVE {CreateMsgPort} PROC
PROC CreateMsgPort( ) IS NATIVE {CreateMsgPort()} ENDNATIVE !!PTR TO mp
NATIVE {DeleteMsgPort} PROC
PROC DeleteMsgPort( port:PTR TO mp ) IS NATIVE {DeleteMsgPort(} port {)} ENDNATIVE
NATIVE {ObtainSemaphoreShared} PROC
PROC ObtainSemaphoreShared( sigSem:PTR TO ss ) IS NATIVE {ObtainSemaphoreShared(} sigSem {)} ENDNATIVE
/*------ even more memory support -------------------------------------*/
NATIVE {AllocVec} PROC
PROC AllocVec( byteSize:ULONG, requirements:ULONG ) IS NATIVE {AllocVec(} byteSize {,} requirements {)} ENDNATIVE !!APTR
NATIVE {FreeVec} PROC
PROC FreeVec( memoryBlock:APTR ) IS NATIVE {FreeVec(} memoryBlock {)} ENDNATIVE
/*------ V39 Pool LVOs...*/
NATIVE {CreatePool} PROC
PROC CreatePool( requirements:ULONG, puddleSize:ULONG, threshSize:ULONG ) IS NATIVE {CreatePool(} requirements {,} puddleSize {,} threshSize {)} ENDNATIVE !!APTR
NATIVE {DeletePool} PROC
PROC DeletePool( poolHeader:APTR ) IS NATIVE {DeletePool(} poolHeader {)} ENDNATIVE
NATIVE {AllocPooled} PROC
PROC AllocPooled( poolHeader:APTR, memSize:ULONG ) IS NATIVE {AllocPooled(} poolHeader {,} memSize {)} ENDNATIVE !!APTR
NATIVE {FreePooled} PROC
PROC FreePooled( poolHeader:APTR, memory:APTR, memSize:ULONG ) IS NATIVE {FreePooled(} poolHeader {,} memory {,} memSize {)} ENDNATIVE
/*------ misc ---------------------------------------------------------*/
NATIVE {AttemptSemaphoreShared} PROC
PROC AttemptSemaphoreShared( sigSem:PTR TO ss ) IS NATIVE {AttemptSemaphoreShared(} sigSem {)} ENDNATIVE !!ULONG
NATIVE {ColdReboot} PROC
PROC ColdReboot( ) IS NATIVE {ColdReboot()} ENDNATIVE
NATIVE {StackSwap} PROC
PROC StackSwap( newStack:PTR TO stackswapstruct ) IS NATIVE {StackSwap(} newStack {)} ENDNATIVE
/*------ future expansion ---------------------------------------------*/
NATIVE {CachePreDMA} PROC
PROC CachePreDMA( address:APTR, length:PTR TO ULONG, flags:ULONG ) IS NATIVE {CachePreDMA(} address {,} length {,} flags {)} ENDNATIVE !!APTR
NATIVE {CachePostDMA} PROC
PROC CachePostDMA( address:APTR, length:PTR TO ULONG, flags:ULONG ) IS NATIVE {CachePostDMA(} address {,} length {,} flags {)} ENDNATIVE
/*------ New, for V39*/
/*--- functions in V39 or higher (Release 3) ---*/
/*------ Low memory handler functions*/
NATIVE {AddMemHandler} PROC
PROC AddMemHandler( memhand:PTR TO is ) IS NATIVE {AddMemHandler(} memhand {)} ENDNATIVE
NATIVE {RemMemHandler} PROC
PROC RemMemHandler( memhand:PTR TO is ) IS NATIVE {RemMemHandler(} memhand {)} ENDNATIVE
/*------ Function to attempt to obtain a Quick Interrupt Vector...*/
NATIVE {ObtainQuickVector} PROC
PROC ObtainQuickVector( interruptCode:APTR ) IS NATIVE {ObtainQuickVector(} interruptCode {)} ENDNATIVE !!ULONG

