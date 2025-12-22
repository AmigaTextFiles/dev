@DATABASE "gg:doc/NDK/Guide/Include/clib/exec_protos.h"
@MASTER   "gg:os-include/clib/exec_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:39
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/exec_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/exec_protos.h" LINK File}

@ENDNODE
@NODE File "clib/exec_protos.h"
#ifndef  CLIB_EXEC_PROTOS_H
#define  CLIB_EXEC_PROTOS_H

/*
**      $VER: exec_protos.h 45.2 (6.6.1998)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  EXEC_TASKS_H
#include <@{"exec/tasks.h" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File"}>
#endif
#ifndef  EXEC_MEMORY_H
#include <@{"exec/memory.h" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File"}>
#endif
#ifndef  EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif
#ifndef  EXEC_DEVICES_H
#include <@{"exec/devices.h" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File"}>
#endif
#ifndef  EXEC_IO_H
#include <@{"exec/io.h" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File"}>
#endif
#ifndef  EXEC_SEMAPHORES_H
#include <@{"exec/semaphores.h" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File"}>
#endif
#ifndef  EXEC_AVL_H
#include <@{"exec/avl.h" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File"}>
#endif
/*------ misc ---------------------------------------------------------*/
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"Supervisor" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 41}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} (*@{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} userFunction)() );
/*------ special patchable hooks to internal exec activity ------------*/
/*------ module creation ----------------------------------------------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitCode" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 45}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} startClass, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} version );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitStruct" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 49}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} initTable, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} memory, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} size );
@{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *MakeLibrary( CONST APTR funcInit, CONST APTR structInit, ULONG (*CONST libInit)(), @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} dataSize, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} segList );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"MakeFunctions" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 57}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} target, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} functionArray, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} funcDispBase );
@{"struct Resident" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 18} *FindResident( CONST_STRPTR name );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"InitResident" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 65}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct Resident" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 18} *resident, ULONG segList );
/*------ diagnostics --------------------------------------------------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Alert" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 69}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} alertNum );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Debug" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 73}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags );
/*------ interrupts ---------------------------------------------------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Disable" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 77}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Enable" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 81}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Forbid" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 85}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Permit" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 89}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetSR" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 93}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} newSR, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} mask );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"SuperState" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 97}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UserState" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 101}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} sysStack );
@{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} *SetIntVector( LONG intNumber, CONST struct Interrupt *interrupt );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddIntServer" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 109}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} intNumber, @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} *interrupt );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemIntServer" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 113}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} intNumber, @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} *interrupt );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Cause" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 117}( @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} *interrupt );
/*------ memory allocation --------------------------------------------*/
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"Allocate" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 121}( @{"struct MemHeader" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 28} *freeList, ULONG byteSize );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Deallocate" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 125}( @{"struct MemHeader" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 28} *freeList, APTR memoryBlock, ULONG byteSize );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AllocMem" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 129}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} byteSize, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} requirements );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AllocAbs" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 133}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} byteSize, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} location );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeMem" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 137}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} memoryBlock, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} byteSize );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"AvailMem" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 141}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} requirements );
@{"struct MemList" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 56} *AllocEntry( struct MemList *entry );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeEntry" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 149}( @{"struct MemList" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 56} *entry );
/*------ lists --------------------------------------------------------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Insert" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 153}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *list, struct Node *node, struct Node *pred );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddHead" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 157}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *list, struct Node *node );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddTail" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 161}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *list, struct Node *node );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Remove" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 165}( @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *node );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *RemHead( struct List *list );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *RemTail( struct List *list );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Enqueue" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 177}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *list, struct Node *node );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *FindName( struct List *list, CONST_STRPTR name );
/*------ tasks --------------------------------------------------------*/
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddTask" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 185}( @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *task, CONST APTR initPC, CONST APTR finalPC );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemTask" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 189}( @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *task );
@{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *FindTask( CONST_STRPTR name );
@{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} @{"SetTaskPri" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 197}( @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *task, LONG priority );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetSignal" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 201}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} newSignals, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} signalSet );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetExcept" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 205}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} newSignals, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} signalSet );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"Wait" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 209}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} signalSet );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Signal" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 213}( @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *task, ULONG signalSet );
@{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} @{"AllocSignal" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 217}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} signalNum );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeSignal" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 221}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} signalNum );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AllocTrap" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 225}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} trapNum );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeTrap" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 229}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} trapNum );
/*------ messages -----------------------------------------------------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddPort" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 233}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemPort" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 237}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"PutMsg" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 241}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port, struct Message *message );
@{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} *GetMsg( struct MsgPort *port );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReplyMsg" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 249}( @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} *message );
@{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} *WaitPort( struct MsgPort *port );
@{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *FindPort( CONST_STRPTR name );
/*------ libraries ----------------------------------------------------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddLibrary" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 261}( @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *library );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemLibrary" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 265}( @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *library );
@{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *OldOpenLibrary( CONST_STRPTR libName );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CloseLibrary" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 273}( @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *library );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"SetFunction" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 277}( @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *library, LONG funcOffset, ULONG (*CONST newFunction)() );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SumLibrary" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 281}( @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *library );
/*------ devices ------------------------------------------------------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddDevice" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 285}( @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} *device );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemDevice" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 289}( @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} *device );
@{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} @{"OpenDevice" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 293}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} devName, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} unit, @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *ioRequest, ULONG flags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CloseDevice" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 297}( @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *ioRequest );
@{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} @{"DoIO" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 301}( @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *ioRequest );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SendIO" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 305}( @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *ioRequest );
@{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *CheckIO( struct IORequest *ioRequest );
@{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} @{"WaitIO" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 313}( @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *ioRequest );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AbortIO" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 317}( @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *ioRequest );
/*------ resources ----------------------------------------------------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddResource" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 321}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} resource );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemResource" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 325}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} resource );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"OpenResource" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 329}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} resName );
/*------ private diagnostic support -----------------------------------*/
/*------ misc ---------------------------------------------------------*/
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"RawDoFmt" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 333}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} formatString, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dataStream, @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} (*@{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} putChProc)(), @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} putChData );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetCC" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 337}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"TypeOfMem" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 341}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} address );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"Procure" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 345}( @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *sigSem, struct SemaphoreMessage *bidMsg );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Vacate" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 349}( @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *sigSem, struct SemaphoreMessage *bidMsg );
@{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *OpenLibrary( CONST_STRPTR libName, ULONG version );
/*--- functions in V33 or higher (Release 1.2) ---*/
/*------ signal semaphores (note funny registers)----------------------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitSemaphore" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 357}( @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *sigSem );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ObtainSemaphore" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 361}( @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *sigSem );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReleaseSemaphore" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 365}( @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *sigSem );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"AttemptSemaphore" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 369}( @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *sigSem );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ObtainSemaphoreList" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 373}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *sigSem );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReleaseSemaphoreList" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 377}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *sigSem );
@{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *FindSemaphore( STRPTR name );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddSemaphore" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 385}( @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *sigSem );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemSemaphore" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 389}( @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *sigSem );
/*------ kickmem support ----------------------------------------------*/
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SumKickData" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 393}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
/*------ more memory support ------------------------------------------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddMemList" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 397}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} size, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} attributes, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} pri, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} base, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CopyMem" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 401}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} source, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dest, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} size );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CopyMemQuick" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 405}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} source, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dest, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} size );
/*------ cache --------------------------------------------------------*/
/*--- functions in V36 or higher (Release 2.0) ---*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CacheClearU" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 409}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CacheClearE" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 413}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} address, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} length, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} caches );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"CacheControl" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 417}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cacheBits, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cacheMask );
/*------ misc ---------------------------------------------------------*/
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateIORequest" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 421}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port, ULONG size );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DeleteIORequest" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 425}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} iorequest );
@{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *CreateMsgPort( VOID );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DeleteMsgPort" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 433}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ObtainSemaphoreShared" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 437}( @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *sigSem );
/*------ even more memory support -------------------------------------*/
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AllocVec" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 441}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} byteSize, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} requirements );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeVec" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 445}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} memoryBlock );
/*------ V39 Pool LVOs...*/
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreatePool" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 449}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} requirements, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} puddleSize, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} threshSize );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DeletePool" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 453}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} poolHeader );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AllocPooled" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 457}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} poolHeader, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} memSize );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreePooled" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 461}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} poolHeader, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} memory, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} memSize );
/*------ misc ---------------------------------------------------------*/
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"AttemptSemaphoreShared" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 465}( @{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40} *sigSem );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ColdReboot" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 469}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"StackSwap" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 473}( @{"struct StackSwapStruct" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 52} *newStack );
/*------ future expansion ---------------------------------------------*/
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CachePreDMA" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 477}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} address, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *length, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CachePostDMA" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 481}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} address, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *length, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags );
/*------ New, for V39*/
/*--- functions in V39 or higher (Release 3) ---*/
/*------ Low memory handler functions*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddMemHandler" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 485}( @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} *memhand );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemMemHandler" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 489}( @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} *memhand );
/*------ Function to attempt to obtain a Quick Interrupt Vector...*/
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ObtainQuickVector" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 493}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} interruptCode );
/*--- functions in V45 or higher ---*/
/*------ Finally the list functions are complete*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"NewMinList" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File" 497}( @{"struct MinList" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 31} *minlist );
/*------ New AVL tree support for V45. Yes, this is intentionally part of Exec!*/
@{"struct AVLNode" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 20} *AVL_AddNode( struct AVLNode **root, struct AVLNode *node, APTR func );
@{"struct AVLNode" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 20} *AVL_RemNodeByAddress( struct AVLNode **root, struct AVLNode *node );
@{"struct AVLNode" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 20} *AVL_RemNodeByKey( struct AVLNode **root, AVLKey key, APTR func );
@{"struct AVLNode" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 20} *AVL_FindNode( CONST struct AVLNode *root, AVLKey key, APTR func );
@{"struct AVLNode" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 20} *AVL_FindPrevNodeByAddress( CONST struct AVLNode *node );
@{"struct AVLNode" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 20} *AVL_FindPrevNodeByKey( CONST struct AVLNode *root, AVLKey key, APTR func );
@{"struct AVLNode" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 20} *AVL_FindNextNodeByAddress( CONST struct AVLNode *node );
@{"struct AVLNode" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 20} *AVL_FindNextNodeByKey( CONST struct AVLNode *root, AVLKey key, APTR func );
@{"struct AVLNode" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 20} *AVL_FindFirstNode( CONST struct AVLNode *root );
@{"struct AVLNode" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 20} *AVL_FindLastNode( CONST struct AVLNode *root );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_EXEC_PROTOS_H */
@ENDNODE
