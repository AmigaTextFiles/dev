/* $VER: exec_protos.h 53.10 (31.1.2010) */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/exec/alerts', 'target/exec/avl', 'target/exec/devices', 'target/exec/emulation', 'target/exec/errors', 'target/exec/execbase', 'target/exec/exectags', 'target/exec/initializers', 'target/exec/interfaces', 'target/exec/interrupts', 'target/exec/io', 'target/exec/libraries', 'target/exec/lists', 'target/exec/memory', 'target/exec/nodes', 'target/exec/ports', 'target/exec/resident', 'target/exec/semaphores', 'target/exec/strings', 'target/exec/tasks', 'target/exec/types'
MODULE 'target/exec/types', 'target/exec/tasks', 'target/exec/memory', 'target/exec/ports', 'target/exec/devices', 'target/exec/io', 'target/exec/semaphores', 'target/exec/avl'
MODULE 'target/utility/hooks', 'target/utility/tagitem'
{#include <proto/exec.h>}
NATIVE {CLIB_EXEC_PROTOS_H} CONST
NATIVE {PROTO_EXEC_H} CONST
NATIVE {PRAGMA_EXEC_H} CONST
NATIVE {INLINE4_EXEC_H} CONST
NATIVE {EXEC_INTERFACE_DEF_H} CONST

NATIVE {SysBase} DEF execbase:PTR TO lib
NATIVE {IExec} DEF

/*------ misc ---------------------------------------------------------*/
->NATIVE {Supervisor} PROC
PROC Supervisor( userFunction:PTR /*ULONG (*CONST userFunction)()*/ ) IS NATIVE {IExec->Supervisor( /*Incorrect: (ULONG (*)())*/ } userFunction {)} ENDNATIVE !!ULONG
/*------ special patchable hooks to internal exec activity ------------*/
/*------ module creation ----------------------------------------------*/
->NATIVE {InitCode} PROC
PROC InitCode( startClass:ULONG, version:ULONG ) IS NATIVE {IExec->InitCode(} startClass {,} version {)} ENDNATIVE
->NATIVE {InitStruct} PROC
PROC InitStruct( initTable:APTR, memory:APTR, size:ULONG ) IS NATIVE {IExec->InitStruct(} initTable {,} memory {,} size {)} ENDNATIVE
->NATIVE {MakeLibrary} PROC
PROC MakeLibrary( funcInit:APTR, structInit:APTR, libInit:PTR /*ULONG (*CONST libInit)()*/, dataSize:ULONG, segList:/*Incorrect: ULONG*/PTR ) IS NATIVE {IExec->MakeLibrary(} funcInit {,} structInit {, /*Incorrect: (ULONG (*)())*/ } libInit {,} dataSize {,} segList {)} ENDNATIVE !!PTR TO lib
->NATIVE {MakeFunctions} PROC
PROC MakeFunctions( target:APTR, functionArray:APTR, funcDispBase:APTR ) IS NATIVE {IExec->MakeFunctions(} target {,} functionArray {,} funcDispBase {)} ENDNATIVE
->NATIVE {FindResident} PROC
PROC FindResident( name:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IExec->FindResident(} name {)} ENDNATIVE !!PTR TO rt
->NATIVE {InitResident} PROC
PROC InitResident( resident:PTR TO rt, segList:ULONG ) IS NATIVE {IExec->InitResident(} resident {,} segList {)} ENDNATIVE !!APTR
->NATIVE {TaggedOpenLibrary} PROC
->Not supported for some reason: PROC TaggedOpenLibrary(tag:ULONG) IS NATIVE {IExec->TaggedOpenLibrary(} tag {)} ENDNATIVE !!PTR TO lib
/*------ diagnostics --------------------------------------------------*/
->NATIVE {Alert} PROC
PROC Alert( alertNum:ULONG ) IS NATIVE {IExec->Alert(} alertNum {)} ENDNATIVE
->NATIVE {Debug} PROC
->Not supported for some reason: PROC Debug( flags:ULONG ) IS NATIVE {IExec->Debug(} flags {)} ENDNATIVE
/*------ interrupts ---------------------------------------------------*/
->NATIVE {Disable} PROC
PROC Disable( ) IS NATIVE {IExec->Disable()} ENDNATIVE
->NATIVE {Enable} PROC
PROC Enable( ) IS NATIVE {IExec->Enable()} ENDNATIVE
->NATIVE {Forbid} PROC
PROC Forbid( ) IS NATIVE {IExec->Forbid()} ENDNATIVE
->NATIVE {Permit} PROC
PROC Permit( ) IS NATIVE {IExec->Permit()} ENDNATIVE
->NATIVE {SetSR} PROC
PROC SetSR( newSR:ULONG, mask:ULONG ) IS NATIVE {IExec->SetSR(} newSR {,} mask {)} ENDNATIVE !!ULONG
->NATIVE {SuperState} PROC
PROC SuperState( ) IS NATIVE {IExec->SuperState()} ENDNATIVE !!APTR
->NATIVE {UserState} PROC
PROC UserState( sysStack:APTR ) IS NATIVE {IExec->UserState(} sysStack {)} ENDNATIVE
->NATIVE {SetIntVector} PROC
PROC SetIntVector( intNumber:VALUE, interrupt:PTR TO is ) IS NATIVE {IExec->SetIntVector(} intNumber {,} interrupt {)} ENDNATIVE !!PTR TO is
->NATIVE {AddIntServer} PROC
PROC AddIntServer( intNumber:VALUE, interrupt:PTR TO is ) IS NATIVE {IExec->AddIntServer(} intNumber {,} interrupt {)} ENDNATIVE
->NATIVE {RemIntServer} PROC
PROC RemIntServer( intNumber:VALUE, interrupt:PTR TO is ) IS NATIVE {IExec->RemIntServer(} intNumber {,} interrupt {)} ENDNATIVE
->NATIVE {Cause} PROC
PROC Cause( interrupt:PTR TO is ) IS NATIVE {IExec->Cause(} interrupt {)} ENDNATIVE
/*------ memory allocation --------------------------------------------*/
->NATIVE {Allocate} PROC
PROC Allocate( freeList:PTR TO mh, byteSize:ULONG ) IS NATIVE {IExec->Allocate(} freeList {,} byteSize {)} ENDNATIVE !!APTR
->NATIVE {Deallocate} PROC
PROC Deallocate( freeList:PTR TO mh, memoryBlock:APTR, byteSize:ULONG ) IS NATIVE {IExec->Deallocate(} freeList {,} memoryBlock {,} byteSize {)} ENDNATIVE
->NATIVE {AllocMem} PROC
PROC AllocMem( byteSize:ULONG, requirements:ULONG ) IS NATIVE {IExec->AllocMem(} byteSize {,} requirements {)} ENDNATIVE !!APTR
->NATIVE {AllocAbs} PROC
PROC AllocAbs( byteSize:ULONG, location:APTR ) IS NATIVE {IExec->AllocAbs(} byteSize {,} location {)} ENDNATIVE !!APTR
->NATIVE {FreeMem} PROC
PROC FreeMem( memoryBlock:APTR, byteSize:ULONG ) IS NATIVE {IExec->FreeMem(} memoryBlock {,} byteSize {)} ENDNATIVE
->NATIVE {AvailMem} PROC
PROC AvailMem( requirements:ULONG ) IS NATIVE {IExec->AvailMem(} requirements {)} ENDNATIVE !!ULONG
->NATIVE {AllocEntry} PROC
PROC AllocEntry( entry:PTR TO ml ) IS NATIVE {IExec->AllocEntry(} entry {)} ENDNATIVE !!PTR TO ml
->NATIVE {FreeEntry} PROC
PROC FreeEntry( entry:PTR TO ml ) IS NATIVE {IExec->FreeEntry(} entry {)} ENDNATIVE
/*------ lists --------------------------------------------------------*/
->NATIVE {Insert} PROC
PROC Insert( list:PTR TO lh, node:PTR TO ln, pred:PTR TO ln ) IS NATIVE {IExec->Insert(} list {,} node {,} pred {)} ENDNATIVE
->NATIVE {AddHead} PROC
PROC AddHead( list:PTR TO lh, node:PTR TO ln ) IS NATIVE {IExec->AddHead(} list {,} node {)} ENDNATIVE
->NATIVE {AddTail} PROC
PROC AddTail( list:PTR TO lh, node:PTR TO ln ) IS NATIVE {IExec->AddTail(} list {,} node {)} ENDNATIVE
->NATIVE {Remove} PROC
PROC Remove( node:PTR TO ln ) IS NATIVE {IExec->Remove(} node {)} ENDNATIVE
->NATIVE {RemHead} PROC
PROC RemHead( list:PTR TO lh ) IS NATIVE {IExec->RemHead(} list {)} ENDNATIVE !!PTR TO ln
->NATIVE {RemTail} PROC
PROC RemTail( list:PTR TO lh ) IS NATIVE {IExec->RemTail(} list {)} ENDNATIVE !!PTR TO ln
->NATIVE {Enqueue} PROC
PROC Enqueue( list:PTR TO lh, node:PTR TO ln ) IS NATIVE {IExec->Enqueue(} list {,} node {)} ENDNATIVE
->NATIVE {FindName} PROC
PROC FindName( list:PTR TO lh, name:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IExec->FindName(} list {,} name {)} ENDNATIVE !!PTR TO ln
/*------ tasks --------------------------------------------------------*/
->NATIVE {AddTask} PROC
->Parameter mis-match for some reason: PROC AddTask( task:PTR TO tc, initPC:APTR, finalPC:APTR ) IS NATIVE {IExec->AddTask(} task {,} initPC {,} finalPC {)} ENDNATIVE !!APTR
->NATIVE {RemTask} PROC
PROC RemTask( task:PTR TO tc ) IS NATIVE {IExec->RemTask(} task {)} ENDNATIVE
->NATIVE {FindTask} PROC
PROC FindTask( name:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IExec->FindTask(} name {)} ENDNATIVE !!PTR TO tc
->NATIVE {SetTaskPri} PROC
PROC SetTaskPri( task:PTR TO tc, priority:BYTE ) IS NATIVE {IExec->SetTaskPri(} task {,} priority {)} ENDNATIVE !!BYTE
->NATIVE {SetSignal} PROC
PROC SetSignal( newSignals:ULONG, signalSet:ULONG ) IS NATIVE {IExec->SetSignal(} newSignals {,} signalSet {)} ENDNATIVE !!ULONG
->NATIVE {SetExcept} PROC
PROC SetExcept( newSignals:ULONG, signalSet:ULONG ) IS NATIVE {IExec->SetExcept(} newSignals {,} signalSet {)} ENDNATIVE !!ULONG
->NATIVE {Wait} PROC
PROC Wait( signalSet:ULONG ) IS NATIVE {IExec->Wait(} signalSet {)} ENDNATIVE !!ULONG
->NATIVE {Signal} PROC
PROC Signal( task:PTR TO tc, signalSet:ULONG ) IS NATIVE {IExec->Signal(} task {,} signalSet {)} ENDNATIVE
->NATIVE {AllocSignal} PROC
PROC AllocSignal( signalNum:VALUE ) IS NATIVE {IExec->AllocSignal(} signalNum {)} ENDNATIVE !!BYTE
->NATIVE {FreeSignal} PROC
PROC FreeSignal( signalNum:VALUE ) IS NATIVE {IExec->FreeSignal(} signalNum {)} ENDNATIVE
->NATIVE {AllocTrap} PROC
PROC AllocTrap( trapNum:VALUE ) IS NATIVE {IExec->AllocTrap(} trapNum {)} ENDNATIVE !!VALUE
->NATIVE {FreeTrap} PROC
PROC FreeTrap( trapNum:VALUE ) IS NATIVE {IExec->FreeTrap(} trapNum {)} ENDNATIVE
/*------ messages -----------------------------------------------------*/
->NATIVE {AddPort} PROC
PROC AddPort( port:PTR TO mp ) IS NATIVE {IExec->AddPort(} port {)} ENDNATIVE
->NATIVE {RemPort} PROC
PROC RemPort( port:PTR TO mp ) IS NATIVE {IExec->RemPort(} port {)} ENDNATIVE
->NATIVE {PutMsg} PROC
PROC PutMsg( port:PTR TO mp, message:PTR TO mn ) IS NATIVE {IExec->PutMsg(} port {,} message {)} ENDNATIVE
->NATIVE {GetMsg} PROC
PROC GetMsg( port:PTR TO mp ) IS NATIVE {IExec->GetMsg(} port {)} ENDNATIVE !!PTR TO mn
->NATIVE {ReplyMsg} PROC
PROC ReplyMsg( message:PTR TO mn ) IS NATIVE {IExec->ReplyMsg(} message {)} ENDNATIVE
->NATIVE {WaitPort} PROC
PROC WaitPort( port:PTR TO mp ) IS NATIVE {IExec->WaitPort(} port {)} ENDNATIVE !!PTR TO mn
->NATIVE {FindPort} PROC
PROC FindPort( name:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IExec->FindPort(} name {)} ENDNATIVE !!PTR TO mp
/*------ libraries ----------------------------------------------------*/
->NATIVE {AddLibrary} PROC
PROC AddLibrary( library:PTR TO lib ) IS NATIVE {IExec->AddLibrary(} library {)} ENDNATIVE
->NATIVE {RemLibrary} PROC
PROC RemLibrary( library:PTR TO lib ) IS NATIVE {IExec->RemLibrary(} library {)} ENDNATIVE
->NATIVE {OldOpenLibrary} PROC
->Not supported for some reason: PROC OldOpenLibrary( libName:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IExec->OldOpenLibrary(} libName {)} ENDNATIVE !!PTR TO lib
->NATIVE {CloseLibrary} PROC
PROC CloseLibrary( library:PTR TO lib ) IS NATIVE {IExec->CloseLibrary(} library {)} ENDNATIVE
->NATIVE {SetFunction} PROC
PROC SetFunction( library:PTR TO lib, funcOffset:VALUE, newFunction:PTR /*ULONG (*CONST newFunction)()*/ ) IS NATIVE {IExec->SetFunction(} library {,} funcOffset {, /*Incorrect: (ULONG (*)())*/ } newFunction {)} ENDNATIVE !!APTR
->NATIVE {SumLibrary} PROC
PROC SumLibrary( library:PTR TO lib ) IS NATIVE {IExec->SumLibrary(} library {)} ENDNATIVE
/*------ devices ------------------------------------------------------*/
->NATIVE {AddDevice} PROC
PROC AddDevice( device:PTR TO dd ) IS NATIVE {IExec->AddDevice(} device {)} ENDNATIVE
->NATIVE {RemDevice} PROC
PROC RemDevice( device:PTR TO dd ) IS NATIVE {IExec->RemDevice(} device {)} ENDNATIVE
->NATIVE {OpenDevice} PROC
PROC OpenDevice( devName:/*CONST_STRPTR*/ ARRAY OF CHAR, unit:ULONG, ioRequest:PTR TO io, flags:ULONG ) IS NATIVE {IExec->OpenDevice(} devName {,} unit {,} ioRequest {,} flags {)} ENDNATIVE !!BYTE
->NATIVE {CloseDevice} PROC
PROC CloseDevice( ioRequest:PTR TO io ) IS NATIVE {IExec->CloseDevice(} ioRequest {)} ENDNATIVE
->NATIVE {DoIO} PROC
PROC DoIO( ioRequest:PTR TO io ) IS NATIVE {IExec->DoIO(} ioRequest {)} ENDNATIVE !!BYTE
->NATIVE {SendIO} PROC
PROC SendIO( ioRequest:PTR TO io ) IS NATIVE {IExec->SendIO(} ioRequest {)} ENDNATIVE
->NATIVE {CheckIO} PROC
PROC CheckIO( ioRequest:PTR TO io ) IS NATIVE {IExec->CheckIO(} ioRequest {)} ENDNATIVE !!PTR TO io
->NATIVE {WaitIO} PROC
PROC WaitIO( ioRequest:PTR TO io ) IS NATIVE {IExec->WaitIO(} ioRequest {)} ENDNATIVE !!BYTE
->NATIVE {AbortIO} PROC
PROC AbortIO( ioRequest:PTR TO io ) IS NATIVE {IExec->AbortIO(} ioRequest {)} ENDNATIVE
/*------ resources ----------------------------------------------------*/
->NATIVE {AddResource} PROC
PROC AddResource( resource:APTR ) IS NATIVE {IExec->AddResource(} resource {)} ENDNATIVE
->NATIVE {RemResource} PROC
PROC RemResource( resource:APTR ) IS NATIVE {IExec->RemResource(} resource {)} ENDNATIVE
->NATIVE {OpenResource} PROC
PROC OpenResource( resName:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IExec->OpenResource(} resName {)} ENDNATIVE !!APTR
/*------ private diagnostic support -----------------------------------*/
/*------ misc ---------------------------------------------------------*/
->NATIVE {RawDoFmt} PROC
PROC RawDoFmt( formatString:/*CONST_STRPTR*/ ARRAY OF CHAR, dataStream:APTR, putChProc:PTR /*VOID (*CONST putChProc)()*/, putChData:APTR ) IS NATIVE {IExec->RawDoFmt(} formatString {,} dataStream {, (VOID (*)()) } putChProc {,} putChData {)} ENDNATIVE !!APTR
->NATIVE {GetCC} PROC
PROC GetCC( ) IS NATIVE {IExec->GetCC()} ENDNATIVE !!ULONG
->NATIVE {TypeOfMem} PROC
PROC TypeOfMem( address:APTR ) IS NATIVE {IExec->TypeOfMem(} address {)} ENDNATIVE !!ULONG
->NATIVE {Procure} PROC
PROC Procure( sigSem:PTR TO ss, bidMsg:PTR TO semaphoremessage ) IS NATIVE {IExec->Procure(} sigSem {,} bidMsg {)} ENDNATIVE ->Incorrect: !!ULONG
->NATIVE {Vacate} PROC
PROC Vacate( sigSem:PTR TO ss, bidMsg:PTR TO semaphoremessage ) IS NATIVE {IExec->Vacate(} sigSem {,} bidMsg {)} ENDNATIVE
->NATIVE {OpenLibrary} PROC
PROC OpenLibrary( libName:/*CONST_STRPTR*/ ARRAY OF CHAR, version:ULONG ) IS NATIVE {IExec->OpenLibrary(} libName {,} version {)} ENDNATIVE !!PTR TO lib
/*--- functions in V33 or higher (Release 1.2) ---*/
/*------ signal semaphores (note funny registers)----------------------*/
->NATIVE {InitSemaphore} PROC
PROC InitSemaphore( sigSem:PTR TO ss ) IS NATIVE {IExec->InitSemaphore(} sigSem {)} ENDNATIVE
->NATIVE {ObtainSemaphore} PROC
PROC ObtainSemaphore( sigSem:PTR TO ss ) IS NATIVE {IExec->ObtainSemaphore(} sigSem {)} ENDNATIVE
->NATIVE {ReleaseSemaphore} PROC
PROC ReleaseSemaphore( sigSem:PTR TO ss ) IS NATIVE {IExec->ReleaseSemaphore(} sigSem {)} ENDNATIVE
->NATIVE {AttemptSemaphore} PROC
PROC AttemptSemaphore( sigSem:PTR TO ss ) IS NATIVE {IExec->AttemptSemaphore(} sigSem {)} ENDNATIVE !!ULONG
->NATIVE {ObtainSemaphoreList} PROC
PROC ObtainSemaphoreList( sigSem:PTR TO lh ) IS NATIVE {IExec->ObtainSemaphoreList(} sigSem {)} ENDNATIVE
->NATIVE {ReleaseSemaphoreList} PROC
PROC ReleaseSemaphoreList( sigSem:PTR TO lh ) IS NATIVE {IExec->ReleaseSemaphoreList(} sigSem {)} ENDNATIVE
->NATIVE {FindSemaphore} PROC
PROC FindSemaphore( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IExec->FindSemaphore(} name {)} ENDNATIVE !!PTR TO ss
->NATIVE {AddSemaphore} PROC
PROC AddSemaphore( sigSem:PTR TO ss ) IS NATIVE {IExec->AddSemaphore(} sigSem {)} ENDNATIVE
->NATIVE {RemSemaphore} PROC
PROC RemSemaphore( sigSem:PTR TO ss ) IS NATIVE {IExec->RemSemaphore(} sigSem {)} ENDNATIVE
/*------ kickmem support ----------------------------------------------*/
->NATIVE {SumKickData} PROC
PROC SumKickData( ) IS NATIVE {IExec->SumKickData()} ENDNATIVE !!ULONG
/*------ more memory support ------------------------------------------*/
->NATIVE {AddMemList} PROC
PROC AddMemList( size:ULONG, attributes:ULONG, pri:VALUE, base:APTR, name:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IExec->AddMemList(} size {,} attributes {,} pri {,} base {,} name {)} ENDNATIVE
->NATIVE {CopyMem} PROC
PROC CopyMem( source:APTR, dest:APTR, size:ULONG ) IS NATIVE {IExec->CopyMem(} source {,} dest {,} size {)} ENDNATIVE
->NATIVE {CopyMemQuick} PROC
PROC CopyMemQuick( source:APTR, dest:APTR, size:ULONG ) IS NATIVE {IExec->CopyMemQuick(} source {,} dest {,} size {)} ENDNATIVE
/*------ cache --------------------------------------------------------*/
/*--- functions in V36 or higher (Release 2.0) ---*/
->NATIVE {CacheClearU} PROC
PROC CacheClearU( ) IS NATIVE {IExec->CacheClearU()} ENDNATIVE
->NATIVE {CacheClearE} PROC
PROC CacheClearE( address:APTR, length:ULONG, caches:ULONG ) IS NATIVE {IExec->CacheClearE(} address {,} length {,} caches {)} ENDNATIVE
->NATIVE {CacheControl} PROC
PROC CacheControl( cacheBits:ULONG, cacheMask:ULONG ) IS NATIVE {IExec->CacheControl(} cacheBits {,} cacheMask {)} ENDNATIVE !!ULONG
/*------ misc ---------------------------------------------------------*/
->NATIVE {CreateIORequest} PROC
PROC CreateIORequest( port:PTR TO mp, size:ULONG ) IS NATIVE {IExec->CreateIORequest(} port {,} size {)} ENDNATIVE !!APTR2
->NATIVE {DeleteIORequest} PROC
PROC DeleteIORequest( iorequest:APTR2 ) IS NATIVE {IExec->DeleteIORequest( /*Required:*/ (IORequest*) } iorequest {)} ENDNATIVE
->NATIVE {CreateMsgPort} PROC
PROC CreateMsgPort( ) IS NATIVE {IExec->CreateMsgPort()} ENDNATIVE !!PTR TO mp
->NATIVE {DeleteMsgPort} PROC
PROC DeleteMsgPort( port:PTR TO mp ) IS NATIVE {IExec->DeleteMsgPort(} port {)} ENDNATIVE
->NATIVE {ObtainSemaphoreShared} PROC
PROC ObtainSemaphoreShared( sigSem:PTR TO ss ) IS NATIVE {IExec->ObtainSemaphoreShared(} sigSem {)} ENDNATIVE
/*------ even more memory support -------------------------------------*/
->NATIVE {AllocVec} PROC
PROC AllocVec( byteSize:ULONG, requirements:ULONG ) IS NATIVE {IExec->AllocVec(} byteSize {,} requirements {)} ENDNATIVE !!APTR
->NATIVE {FreeVec} PROC
PROC FreeVec( memoryBlock:APTR ) IS NATIVE {IExec->FreeVec(} memoryBlock {)} ENDNATIVE
/*------ V39 Pool LVOs...*/
->NATIVE {CreatePool} PROC
PROC CreatePool( requirements:ULONG, puddleSize:ULONG, threshSize:ULONG ) IS NATIVE {IExec->CreatePool(} requirements {,} puddleSize {,} threshSize {)} ENDNATIVE !!APTR
->NATIVE {DeletePool} PROC
PROC DeletePool( poolHeader:APTR ) IS NATIVE {IExec->DeletePool(} poolHeader {)} ENDNATIVE
->NATIVE {AllocPooled} PROC
PROC AllocPooled( poolHeader:APTR, memSize:ULONG ) IS NATIVE {IExec->AllocPooled(} poolHeader {,} memSize {)} ENDNATIVE !!APTR
->NATIVE {FreePooled} PROC
PROC FreePooled( poolHeader:APTR, memory:APTR, memSize:ULONG ) IS NATIVE {IExec->FreePooled(} poolHeader {,} memory {,} memSize {)} ENDNATIVE
/*------ misc ---------------------------------------------------------*/
->NATIVE {AttemptSemaphoreShared} PROC
PROC AttemptSemaphoreShared( sigSem:PTR TO ss ) IS NATIVE {IExec->AttemptSemaphoreShared(} sigSem {)} ENDNATIVE !!ULONG
->NATIVE {ColdReboot} PROC
PROC ColdReboot( ) IS NATIVE {IExec->ColdReboot()} ENDNATIVE
->NATIVE {StackSwap} PROC
PROC StackSwap( newStack:PTR TO stackswapstruct ) IS NATIVE {IExec->StackSwap(} newStack {)} ENDNATIVE
/*------ future expansion ---------------------------------------------*/
->NATIVE {CachePreDMA} PROC
PROC CachePreDMA( address:APTR, length:PTR TO ULONG, flags:ULONG ) IS NATIVE {IExec->CachePreDMA(} address {,} length {,} flags {)} ENDNATIVE !!APTR
->NATIVE {CachePostDMA} PROC
PROC CachePostDMA( address:APTR, length:PTR TO ULONG, flags:ULONG ) IS NATIVE {IExec->CachePostDMA(} address {,} length {,} flags {)} ENDNATIVE
/*------ New, for V39*/
/*--- functions in V39 or higher (Release 3) ---*/
/*------ Low memory handler functions*/
->NATIVE {AddMemHandler} PROC
PROC AddMemHandler( memhand:PTR TO is ) IS NATIVE {IExec->AddMemHandler(} memhand {)} ENDNATIVE
->NATIVE {RemMemHandler} PROC
PROC RemMemHandler( memhand:PTR TO is ) IS NATIVE {IExec->RemMemHandler(} memhand {)} ENDNATIVE
/*------ Function to attempt to obtain a Quick Interrupt Vector...*/
->NATIVE {ObtainQuickVector} PROC
PROC ObtainQuickVector( interruptCode:APTR ) IS NATIVE {IExec->ObtainQuickVector(} interruptCode {)} ENDNATIVE !!ULONG
->NATIVE {ReadGayle} PROC
->Not supported for some reason: PROC ReadGayle( ) IS NATIVE {IExec->ReadGayle()} ENDNATIVE !!ULONG
/*--- functions in V45 or higher ---*/
/*------ Finally the list functions are complete*/
->NATIVE {NewMinList} PROC
PROC NewMinList( minlist:PTR TO mlh ) IS NATIVE {IExec->NewMinList(} minlist {)} ENDNATIVE
/*------ New AVL tree support for V45. Yes, this is intentionally part of Exec!*/
->NATIVE {AVL_AddNode} PROC
PROC AvL_AddNode( root:ARRAY OF PTR TO avlnode, node:PTR TO avlnode, func:APTR ) IS NATIVE {IExec->AVL_AddNode(} root {,} node {, /*Required:*/ (int32 (*)(AVLNode*,AVLNode*)) } func {)} ENDNATIVE !!PTR TO avlnode
->NATIVE {AVL_RemNodeByAddress} PROC
PROC AvL_RemNodeByAddress( root:ARRAY OF PTR TO avlnode, node:PTR TO avlnode ) IS NATIVE {IExec->AVL_RemNodeByAddress(} root {,} node {)} ENDNATIVE !!PTR TO avlnode
->NATIVE {AVL_RemNodeByKey} PROC
PROC AvL_RemNodeByKey( root:ARRAY OF PTR TO avlnode, key:AVLKey, func:APTR ) IS NATIVE {IExec->AVL_RemNodeByKey(} root {,} key {, /*Required:*/ (int32 (*)(AVLNode*,void*)) } func {)} ENDNATIVE !!PTR TO avlnode
->NATIVE {AVL_FindNode} PROC
PROC AvL_FindNode( root:PTR TO avlnode, key:AVLKey, func:APTR ) IS NATIVE {IExec->AVL_FindNode(} root {,} key {, /*Required:*/ (int32 (*)(AVLNode*,void*)) } func {)} ENDNATIVE !!PTR TO avlnode
->NATIVE {AVL_FindPrevNodeByAddress} PROC
PROC AvL_FindPrevNodeByAddress( node:PTR TO avlnode ) IS NATIVE {IExec->AVL_FindPrevNodeByAddress(} node {)} ENDNATIVE !!PTR TO avlnode
->NATIVE {AVL_FindPrevNodeByKey} PROC
PROC AvL_FindPrevNodeByKey( root:PTR TO avlnode, key:AVLKey, func:APTR ) IS NATIVE {IExec->AVL_FindPrevNodeByKey(} root {,} key {, /*Required:*/ (int32 (*)(AVLNode*,void*)) } func {)} ENDNATIVE !!PTR TO avlnode
->NATIVE {AVL_FindNextNodeByAddress} PROC
PROC AvL_FindNextNodeByAddress( node:PTR TO avlnode ) IS NATIVE {IExec->AVL_FindNextNodeByAddress(} node {)} ENDNATIVE !!PTR TO avlnode
->NATIVE {AVL_FindNextNodeByKey} PROC
PROC AvL_FindNextNodeByKey( root:PTR TO avlnode, key:AVLKey, func:APTR ) IS NATIVE {IExec->AVL_FindNextNodeByKey(} root {,} key {, /*Required:*/ (int32 (*)(AVLNode*,void*)) } func {)} ENDNATIVE !!PTR TO avlnode
->NATIVE {AVL_FindFirstNode} PROC
PROC AvL_FindFirstNode( root:PTR TO avlnode ) IS NATIVE {IExec->AVL_FindFirstNode(} root {)} ENDNATIVE !!PTR TO avlnode
->NATIVE {AVL_FindLastNode} PROC
PROC AvL_FindLastNode( root:PTR TO avlnode ) IS NATIVE {IExec->AVL_FindLastNode(} root {)} ENDNATIVE !!PTR TO avlnode

->missing from clib:
/* v50 stuff */
->NATIVE {AddInterface} PROC
PROC AddInterface(library:PTR TO lib, interface:PTR TO interface) IS NATIVE {IExec->AddInterface(} library {,} interface {)} ENDNATIVE
->NATIVE {AddResetCallback} PROC
PROC AddResetCallback(resetCallback:PTR TO is) IS NATIVE {-IExec->AddResetCallback(} resetCallback {)} ENDNATIVE !!INT
->NATIVE {AddTaskTags} PROC
->PROC AddTaskTags(task:PTR TO tc, initialPC:CONST_APTR, finalPC:CONST_APTR, finalPC2=0:ULONG, ...) IS NATIVE {IExec->AddTaskTags(} task {,} initialPC {,} finalPC {,} finalPC2 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {AddTrackable} PROC
PROC AddTrackable(usingTask:PTR TO tc, object:APTR, destFunc:PTR TO hook) IS NATIVE {IExec->AddTrackable(} usingTask {,} object {,} destFunc {)} ENDNATIVE !!PTR TO trackable
->NATIVE {AllocSysObject} PROC
PROC AllocSysObject(type:ULONG, tags:ARRAY OF tagitem) IS NATIVE {IExec->AllocSysObject(} type {,} tags {)} ENDNATIVE !!APTR
->NATIVE {AllocSysObjectTags} PROC
->PROC AllocSysObjectTags(type:ULONG, type2=0:ULONG, ...) IS NATIVE {IExec->AllocSysObjectTags(} type {,} type2 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {AllocVecPooled} PROC
PROC AllocVecPooled(poolHeader:APTR, size:ULONG) IS NATIVE {IExec->AllocVecPooled(} poolHeader {,} size {)} ENDNATIVE !!APTR
->NATIVE {BeginIO} PROC
PROC BeginIO(ioRequest:PTR TO io) IS NATIVE {IExec->BeginIO(} ioRequest {)} ENDNATIVE
->NATIVE {CreateLibrary} PROC
PROC CreateLibrary(taglist:ARRAY OF tagitem) IS NATIVE {IExec->CreateLibrary(} taglist {)} ENDNATIVE !!PTR TO lib
->NATIVE {CreateLibraryTags} PROC
->PROC CreateLibraryTags(dataSize:ULONG, dataSize2=0:ULONG, ...) IS NATIVE {IExec->CreateLibraryTags(} dataSize {,} dataSize2 {,} ... {)} ENDNATIVE !!PTR TO lib
->NATIVE {CreatePort} PROC
PROC CreatePort(name:/*CONST_STRPTR*/ ARRAY OF CHAR, pri:BYTE) IS NATIVE {IExec->CreatePort(} name {,} pri {)} ENDNATIVE !!PTR TO mp
->NATIVE {CreateTask} PROC
PROC CreateTask(name:/*CONST_STRPTR*/ ARRAY OF CHAR, pri:VALUE, initPC:CONST_APTR, stackSize:ULONG, tagList:ARRAY OF tagitem) IS NATIVE {IExec->CreateTask(} name {,} pri {,} initPC {,} stackSize {,} tagList {)} ENDNATIVE !!PTR TO tc
->NATIVE {CreateTaskTags} PROC
->PROC CreateTaskTags(name:/*CONST_STRPTR*/ ARRAY OF CHAR, pri:VALUE, initPC:CONST_APTR, stackSize:ULONG, stackSize2=0:ULONG, ...) IS NATIVE {IExec->CreateTaskTags(} name {,} pri {,} initPC {,} stackSize {,} stackSize2 {,} ... {)} ENDNATIVE !!PTR TO tc
->NATIVE {DebugPrintF} PROC
PROC DebugPrintF(format:/*CONST_STRPTR*/ ARRAY OF CHAR, format1=0:ULONG, ...) IS NATIVE {IExec->DebugPrintF(} format {,} format1 {,} ... {)} ENDNATIVE
->NATIVE {DeleteInterface} PROC
PROC DeleteInterface(interface:PTR TO interface) IS NATIVE {IExec->DeleteInterface(} interface {)} ENDNATIVE
->NATIVE {DeleteLibrary} PROC
PROC DeleteLibrary(library:PTR TO lib) IS NATIVE {IExec->DeleteLibrary(} library {)} ENDNATIVE
->NATIVE {DeletePort} PROC
PROC DeletePort(port:PTR TO mp) IS NATIVE {IExec->DeletePort(} port {)} ENDNATIVE
->NATIVE {DeleteTask} PROC
PROC DeleteTask(task:PTR TO tc) IS NATIVE {IExec->DeleteTask(} task {)} ENDNATIVE
->NATIVE {DeleteTrackable} PROC
PROC DeleteTrackable(trackable:PTR TO trackable) IS NATIVE {IExec->DeleteTrackable(} trackable {)} ENDNATIVE
->NATIVE {DropInterface} PROC
PROC DropInterface(interface:PTR TO interface) IS NATIVE {IExec->DropInterface(} interface {)} ENDNATIVE
->NATIVE {Emulate} PROC
PROC Emulate(InitPC:CONST_APTR, tagList:ARRAY OF tagitem) IS NATIVE {IExec->Emulate(} InitPC {,} tagList {)} ENDNATIVE !!ULONG
->NATIVE {EmulateTags} PROC
->PROC EmulateTags(InitPC:CONST_APTR, InitPC2=0:ULONG, ...) IS NATIVE {IExec->EmulateTags(} InitPC {,} InitPC2 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {EndDMA} PROC
PROC EndDMA(startAddr:CONST_APTR, blockSize:ULONG, flags:ULONG) IS NATIVE {IExec->EndDMA(} startAddr {,} blockSize {,} flags {)} ENDNATIVE
->NATIVE {FindIName} PROC
PROC FindIName(start:PTR TO lh, name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IExec->FindIName(} start {,} name {)} ENDNATIVE !!PTR TO ln
->NATIVE {FindTrackable} PROC
PROC FindTrackable(usingTask:PTR TO tc, object:APTR) IS NATIVE {IExec->FindTrackable(} usingTask {,} object {)} ENDNATIVE !!PTR TO trackable
->NATIVE {FreeSysObject} PROC
PROC FreeSysObject(type:ULONG, object:APTR) IS NATIVE {IExec->FreeSysObject(} type {,} object {)} ENDNATIVE
->NATIVE {FreeVecPooled} PROC
PROC FreeVecPooled(poolHeader:APTR, memory:APTR) IS NATIVE {IExec->FreeVecPooled(} poolHeader {,} memory {)} ENDNATIVE
->NATIVE {GetCPUInfo} PROC
PROC GetCPUInfo(TagList:ARRAY OF tagitem) IS NATIVE {IExec->GetCPUInfo(} TagList {)} ENDNATIVE
->NATIVE {GetCPUInfoTags} PROC
->PROC GetCPUInfoTags(tag1:ULONG, tag12=0:ULONG, ...) IS NATIVE {IExec->GetCPUInfoTags(} tag1 {,} tag12 {,} ... {)} ENDNATIVE
->NATIVE {GetDMAList} PROC
PROC GetDMAList(startAddr:CONST_APTR, blockSize:ULONG, flags:ULONG, dmaList:PTR TO dmaentry) IS NATIVE {IExec->GetDMAList(} startAddr {,} blockSize {,} flags {,} dmaList {)} ENDNATIVE
->NATIVE {GetInterface} PROC
PROC GetInterface(library:PTR TO lib, name:/*CONST_STRPTR*/ ARRAY OF CHAR, version:ULONG, taglist:ARRAY OF tagitem) IS NATIVE {IExec->GetInterface(} library {,} name {,} version {,} taglist {)} ENDNATIVE !!PTR TO interface
->NATIVE {GetInterfaceTags} PROC
->PROC GetInterfaceTags(library:PTR TO lib, name:/*CONST_STRPTR*/ ARRAY OF CHAR, version:ULONG, version2=0:ULONG, ...) IS NATIVE {IExec->GetInterfaceTags(} library {,} name {,} version {,} version2 {,} ... {)} ENDNATIVE !!PTR TO interface
->NATIVE {InitData} PROC
PROC InitData(initTab:CONST_APTR, memory:APTR, size:ULONG) IS NATIVE {IExec->InitData(} initTab {,} memory {,} size {)} ENDNATIVE
->NATIVE {IsNative} PROC
PROC IsNative(code:CONST_APTR) IS NATIVE {-IExec->IsNative(} code {)} ENDNATIVE !!INT
->NATIVE {ItemPoolAlloc} PROC
PROC ItemPoolAlloc(itemPool:APTR) IS NATIVE {IExec->ItemPoolAlloc(} itemPool {)} ENDNATIVE !!APTR
->NATIVE {ItemPoolControl} PROC
PROC ItemPoolControl(itemPool:APTR, tagList:ARRAY OF tagitem) IS NATIVE {IExec->ItemPoolControl(} itemPool {,} tagList {)} ENDNATIVE !!ULONG
->NATIVE {ItemPoolControlTags} PROC
->PROC ItemPoolControlTags(itemPool:APTR, itemPool2=0:ULONG, ...) IS NATIVE {IExec->ItemPoolControlTags(} itemPool {,} itemPool2 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {ItemPoolFree} PROC
PROC ItemPoolFree(itemPool:APTR, item:APTR) IS NATIVE {IExec->ItemPoolFree(} itemPool {,} item {)} ENDNATIVE
->NATIVE {ItemPoolGC} PROC
PROC ItemPoolGC(itemPool:APTR) IS NATIVE {IExec->ItemPoolGC(} itemPool {)} ENDNATIVE
->NATIVE {LockMem} PROC
PROC LockMem(baseAddress:APTR, size:ULONG) IS NATIVE {-IExec->LockMem(} baseAddress {,} size {)} ENDNATIVE !!INT
->NATIVE {MakeInterface} PROC
PROC MakeInterface(library:PTR TO lib, taglist:ARRAY OF tagitem) IS NATIVE {IExec->MakeInterface(} library {,} taglist {)} ENDNATIVE !!PTR TO interface
->NATIVE {MakeInterfaceTags} PROC
->PROC MakeInterfaceTags(library:PTR TO lib, library2=0:ULONG, ...) IS NATIVE {IExec->MakeInterfaceTags(} library {,} library2 {,} ... {)} ENDNATIVE !!PTR TO interface
->NATIVE {MoveList} PROC
PROC MoveList(destinationList:PTR TO lh, sourceList:PTR TO lh) IS NATIVE {IExec->MoveList(} destinationList {,} sourceList {)} ENDNATIVE
->NATIVE {NewList} PROC
PROC NewList_exec(list:PTR TO lh) IS NATIVE {IExec->NewList(} list {)} ENDNATIVE
->NATIVE {OwnerOfMem} PROC
PROC OwnerOfMem(Address:CONST_APTR) IS NATIVE {IExec->OwnerOfMem(} Address {)} ENDNATIVE !!PTR TO tc
->NATIVE {ReallocVec} PROC
->PROC ReallocVec(memBlock:APTR, newSize:ULONG, flags:ULONG) IS NATIVE {IExec->ReallocVec(} memBlock {,} newSize {,} flags {)} ENDNATIVE !!ULONG
->NATIVE {RemInterface} PROC
PROC RemInterface(interface:PTR TO interface) IS NATIVE {IExec->RemInterface(} interface {)} ENDNATIVE
->NATIVE {RemResetCallback} PROC
PROC RemResetCallback(resetCallback:PTR TO is) IS NATIVE {IExec->RemResetCallback(} resetCallback {)} ENDNATIVE
->NATIVE {RemTrackable} PROC
PROC RemTrackable(usingTask:PTR TO tc, trackable:PTR TO trackable) IS NATIVE {IExec->RemTrackable(} usingTask {,} trackable {)} ENDNATIVE !!PTR TO trackable
->NATIVE {RestartTask} PROC
PROC RestartTask(whichTask:PTR TO tc, flags:ULONG) IS NATIVE {IExec->RestartTask(} whichTask {,} flags {)} ENDNATIVE
->NATIVE {SetMethod} PROC
PROC SetMethod(interface:PTR TO interface, funcOffset:VALUE, newFunc:CONST_APTR) IS NATIVE {IExec->SetMethod(} interface {,} funcOffset {,} newFunc {)} ENDNATIVE !!APTR
->NATIVE {SetTaskTrap} PROC
PROC SetTaskTrap(trapNum:ULONG, trapCode:CONST_APTR, trapData:CONST_APTR) IS NATIVE {-IExec->SetTaskTrap(} trapNum {,} trapCode {,} trapData {)} ENDNATIVE !!INT
->NATIVE {StartDMA} PROC
PROC StartDMA(startAddr:CONST_APTR, blockSize:ULONG, flags:ULONG) IS NATIVE {IExec->StartDMA(} startAddr {,} blockSize {,} flags {)} ENDNATIVE !!ULONG
->NATIVE {SumInterface} PROC
PROC SumInterface(interface:PTR TO interface) IS NATIVE {IExec->SumInterface(} interface {)} ENDNATIVE
->NATIVE {SuspendTask} PROC
PROC SuspendTask(whichTask:PTR TO tc, flags:ULONG) IS NATIVE {IExec->SuspendTask(} whichTask {,} flags {)} ENDNATIVE
->NATIVE {UnlockMem} PROC
PROC UnlockMem(baseAddress:APTR, size:ULONG) IS NATIVE {IExec->UnlockMem(} baseAddress {,} size {)} ENDNATIVE
/* v51 stuff */
->NATIVE {ItemPoolFlush} PROC
PROC ItemPoolFlush(itemPool:APTR) IS NATIVE {IExec->ItemPoolFlush(} itemPool {)} ENDNATIVE
->NATIVE {GetHead} PROC
PROC GetHead(list:PTR TO lh) IS NATIVE {IExec->GetHead(} list {)} ENDNATIVE !!PTR TO ln
->NATIVE {GetTail} PROC
PROC GetTail(list:PTR TO lh) IS NATIVE {IExec->GetTail(} list {)} ENDNATIVE !!PTR TO ln
->NATIVE {GetSucc} PROC
PROC GetSucc(node:PTR TO ln) IS NATIVE {IExec->GetSucc(} node {)} ENDNATIVE !!PTR TO ln
->NATIVE {GetPred} PROC
PROC GetPred(node:PTR TO ln) IS NATIVE {IExec->GetPred(} node {)} ENDNATIVE !!PTR TO ln
->NATIVE {IceColdReboot} PROC
PROC IceColdReboot() IS NATIVE {IExec->IceColdReboot()} ENDNATIVE
->NATIVE {RMapAlloc} PROC
PROC RmapAlloc(Map:APTR, size:ULONG, flags:ULONG) IS NATIVE {IExec->RMapAlloc(} Map {,} size {,} flags {)} ENDNATIVE !!APTR
->NATIVE {RMapFree} PROC
PROC RmapFree(Map:APTR, addr:APTR, size:ULONG) IS NATIVE {IExec->RMapFree(} Map {,} addr {,} size {)} ENDNATIVE
->NATIVE {AllocVecTagList} PROC
PROC AllocVecTagList(size:ULONG, tags:ARRAY OF tagitem) IS NATIVE {IExec->AllocVecTagList(} size {,} tags {)} ENDNATIVE !!APTR
->NATIVE {AllocVecTags} PROC
->PROC AllocVecTags(size:ULONG, size2=0:ULONG, ...) IS NATIVE {IExec->AllocVecTags(} size {,} size2 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {RMapExtAlloc} PROC
PROC RmapExtAlloc(Map:APTR, size:ULONG, alignment:ULONG, flags:ULONG) IS NATIVE {IExec->RMapExtAlloc(} Map {,} size {,} alignment {,} flags {)} ENDNATIVE !!APTR
->NATIVE {RMapExtFree} PROC
PROC RmapExtFree(Map:APTR, addr:APTR, size:ULONG) IS NATIVE {IExec->RMapExtFree(} Map {,} addr {,} size {)} ENDNATIVE
->NATIVE {AllocNamedMemory} PROC
PROC AllocNamedMemory(byteSize:ULONG, space:/*CONST_STRPTR*/ ARRAY OF CHAR, name:/*CONST_STRPTR*/ ARRAY OF CHAR, tagList:ARRAY OF tagitem) IS NATIVE {IExec->AllocNamedMemory(} byteSize {,} space {,} name {,} tagList {)} ENDNATIVE !!APTR
->NATIVE {AllocNamedMemoryTags} PROC
->PROC AllocNamedMemoryTags(byteSize:ULONG, space:/*CONST_STRPTR*/ ARRAY OF CHAR, name:/*CONST_STRPTR*/ ARRAY OF CHAR, name2=0:ULONG, ...) IS NATIVE {IExec->AllocNamedMemoryTags(} byteSize {,} space {,} name {,} name2 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {FreeNamedMemory} PROC
PROC FreeNamedMemory(space:/*CONST_STRPTR*/ ARRAY OF CHAR, name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-IExec->FreeNamedMemory(} space {,} name {)} ENDNATIVE !!INT
->NATIVE {FindNamedMemory} PROC
PROC FindNamedMemory(space:/*CONST_STRPTR*/ ARRAY OF CHAR, name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IExec->FindNamedMemory(} space {,} name {)} ENDNATIVE !!PTR
->NATIVE {UpdateNamedMemory} PROC
PROC UpdateNamedMemory(space:/*CONST_STRPTR*/ ARRAY OF CHAR, name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IExec->UpdateNamedMemory(} space {,} name {)} ENDNATIVE
->NATIVE {LockNamedMemory} PROC
PROC LockNamedMemory(space:/*CONST_STRPTR*/ ARRAY OF CHAR, name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IExec->LockNamedMemory(} space {,} name {)} ENDNATIVE !!PTR
->NATIVE {AttemptNamedMemory} PROC
PROC AttemptNamedMemory(space:/*CONST_STRPTR*/ ARRAY OF CHAR, name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IExec->AttemptNamedMemory(} space {,} name {)} ENDNATIVE !!PTR
->NATIVE {UnlockNamedMemory} PROC
PROC UnlockNamedMemory(space:/*CONST_STRPTR*/ ARRAY OF CHAR, name:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {IExec->UnlockNamedMemory(} space {,} name {)} ENDNATIVE
->NATIVE {ScanNamedMemory} PROC
PROC ScanNamedMemory(scHook:PTR TO hook, flags:ULONG, user:APTR) IS NATIVE {IExec->ScanNamedMemory(} scHook {,} flags {,} user {)} ENDNATIVE !!ULONG
->NATIVE {AllocTaskMemEntry} PROC
PROC AllocTaskMemEntry(memList:PTR TO ml) IS NATIVE {IExec->AllocTaskMemEntry(} memList {)} ENDNATIVE !!PTR TO ml
->NATIVE {MutexObtain} PROC
PROC MutexObtain(Mutex:APTR) IS NATIVE {IExec->MutexObtain(} Mutex {)} ENDNATIVE
->NATIVE {MutexAttempt} PROC
PROC MutexAttempt(Mutex:APTR) IS NATIVE {-IExec->MutexAttempt(} Mutex {)} ENDNATIVE !!INT
->NATIVE {MutexRelease} PROC
PROC MutexRelease(Mutex:APTR) IS NATIVE {IExec->MutexRelease(} Mutex {)} ENDNATIVE
->NATIVE {MutexAttemptWithSignal} PROC
PROC MutexAttemptWithSignal(Mutex:APTR, SigSet:ULONG) IS NATIVE {IExec->MutexAttemptWithSignal(} Mutex {,} SigSet {)} ENDNATIVE !!ULONG
->NATIVE {NewStackRun} PROC
PROC NewStackRun(initPC:APTR, TagList:ARRAY OF tagitem) IS NATIVE {IExec->NewStackRun(} initPC {,} TagList {)} ENDNATIVE !!VALUE
->NATIVE {NewStackRunTags} PROC
->PROC NewStackRunTags(initPC:APTR, initPC2=0:ULONG, ...) IS NATIVE {IExec->NewStackRunTags(} initPC {,} initPC2 {,} ... {)} ENDNATIVE !!VALUE

