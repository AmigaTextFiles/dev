/****h* AmigaTalk/Exec.c [3.0] *************************************
*
* NAME 
*   Exec.c
*
* DESCRIPTION
*   Functions that handle Exec to AmigaTalk primitives.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleExec( int numargs, OBJECT **args );
*                  <209 4 xx>
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    26-Feb-2002 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/Exec.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <exec/tasks.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <exec/semaphores.h>

#include <AmigaDOSErrs.h>

#ifdef __SASC

# include <clib/exec_protos.h>

#else

# include <amiga_compiler.h>

# define __USE_INLINE__

# include <proto/exec.h>

IMPORT struct ExecIFace *IExec;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// See Global.c for these: --------------------------------------------

IMPORT UBYTE *SystemProblem;

IMPORT UBYTE *ErrMsg;

// --------------------------------------------------------------------

/* The following is a list of Exec functions that are implemented in
** other AmigaTalk sections/primitives:
**
**  In Library.c
**     VOID CloseLibrary( struct Library *library );
**     struct Library *OpenLibrary( CONST_STRPTR libName, ULONG libVersion );
**
**  In GrabMem.c:
**     APTR AllocVec( ULONG byteSize, ULONG requirements );
**     VOID FreeVec( APTR memoryBlock );
**
**  In MsgPort.c:
**     struct MsgPort *CreateMsgPort( VOID );
**     VOID            DeleteMsgPort( struct MsgPort *port );
**     VOID            AddPort( struct MsgPort *port );
**
**  BYTE OpenDevice( CONST_STRPTR      devName,
**                   ULONG             unit, 
**                   struct IORequest *ioRequest, 
**                   ULONG             flags 
**                 );
**
**  VOID CloseDevice( struct IORequest *ioRequest );
*/

/* The following is a list of Exec functions that are no longer needed:
**
**  struct Library *OldOpenLibrary( CONST_STRPTR libName );
*/

/* The following is a list of Dangerous functions that will have
** primitive numbers assigned, but will NOT appear in AmigaTalk .st
** source files:
**
**  ULONG Supervisor( ULONG (* CONST userFunction)() );
**  VOID  Disable( VOID );
**  VOID  Enable( VOID );
**  VOID  Forbid( VOID ); // Task switching, NOT interrupts!
**  VOID  Permit( VOID );
**  ULONG SetSR( ULONG newSR, ULONG mask );
**  APTR  SuperState( VOID );
**  VOID  UserState( APTR sysStack );
**
**  struct Interrupt *SetIntVector( LONG intNumber, 
**                                  CONST struct Interrupt *interrupt
**                                );
**
**  VOID  AddIntServer( LONG intNumber, struct Interrupt *interrupt );
**  VOID  RemIntServer( LONG intNumber, struct Interrupt *interrupt );
**  VOID  Cause( struct Interrupt *interrupt );
**  APTR  CachePreDMA( CONST APTR address, ULONG *length, ULONG flags );
**  VOID  CachePostDMA( CONST APTR address, ULONG *length, ULONG flags );
**  ULONG ObtainQuickVector( APTR interruptCode );
**  LONG  AllocTrap( LONG trapNum );
**  VOID  FreeTrap( LONG trapNum );
**  VOID  ColdReboot( VOID );
**  VOID  StackSwap( struct StackSwapStruct *newStack );
**  VOID  AddMemHandler( struct Interrupt *memhand );
**  VOID  RemMemHandler( struct Interrupt *memhand );
**  VOID  Debug( ULONG flags );
*/

/****i* copyMemory() [3.0] ********************************************
*
* NAME
*    copyMemory()
*
* DESCRIPTION
*    <primitive 209 4 0 srcObj destObj size>
***********************************************************************
*
*/

METHODFUNC void copyMemory( OBJECT *srcObj, OBJECT *destObj, ULONG size )
{
   const APTR src = (const APTR) CheckObject( srcObj  );
         APTR dst =       (APTR) CheckObject( destObj );
   
   if (!src || !dst || (size < 1))
      return;
            
   CopyMem( src, dst, size );
   
   return;
}

/****i* copyMemoryQuick() [3.0] ***************************************
*
* NAME
*    copyMemoryQuick()
*
* DESCRIPTION
*    <primitive 209 4 1 srcObj destObj size>
***********************************************************************
*
*/

METHODFUNC void copyMemoryQuick( OBJECT *srcObj, OBJECT *destObj, ULONG size )
{
   const APTR src = (const APTR) CheckObject( srcObj  );
         APTR dst =       (APTR) CheckObject( destObj );
   
   if (!src || !dst || (size < 1))
      return;
            
   CopyMemQuick( src, dst, size );
   
   return;
}

/****i* waitForSignal() [3.0] *****************************************
*
* NAME
*    waitForSignal()
*
* DESCRIPTION
*    ^ <primitive 209 4 2 signals>
***********************************************************************
*
*/

METHODFUNC OBJECT *waitForSignal( ULONG signalSet )
{
   ULONG rval = Wait( signalSet );
   
   return( AssignObj( new_int( (int) rval ) ) );
}

/****i* signalTask() [3.0] ********************************************
*
* NAME
*    signalTask()
*
* DESCRIPTION
*    <primitive 209 4 3 taskObj signals>
***********************************************************************
*
*/

METHODFUNC void signalTask( OBJECT *taskObj, ULONG signalSet )
{
   struct Task *task = (struct Task *) CheckObject( taskObj );
   
   if (!task) // == NULL)
      return;
      
   Signal( task, signalSet );
   
   return;
}

/****i* allocSignal() [3.0] *******************************************
*
* NAME
*    allocSignal()
*
* DESCRIPTION
*    ^ <primitive 209 4 4 signalNumber>
***********************************************************************
*
*/

METHODFUNC OBJECT *allocSignal( LONG signalNum )
{
    return( AssignObj( new_int( (int) AllocSignal( signalNum ))));
}

/****i* freeSignal() [3.0] ********************************************
*
* NAME
*    freeSignal()
*
* DESCRIPTION
*    <primitive 209 4 5 signalNumber>
***********************************************************************
*
*/

METHODFUNC void freeSignal( LONG signalNum )
{
   FreeSignal( signalNum );

   return;
}

/****i* setSignal() [3.0] *********************************************
*
* NAME
*    setSignal()
*
* DESCRIPTION
*    ^ <primitive 209 4 6 newSignals signals>
***********************************************************************
*
*/

METHODFUNC OBJECT *setSignal( ULONG newSignals, ULONG signalSet )
{
   return( AssignObj( new_int( (int) SetSignal( newSignals, signalSet ))));
}

/****i* setException() [3.0] ******************************************
*
* NAME
*    setException()
*
* DESCRIPTION
*    ^ <primitive 209 4 7 newSignals signals>
***********************************************************************
*
*/

METHODFUNC OBJECT *setException( ULONG newSignals, ULONG signalSet )
{
   return( AssignObj( new_address( (ULONG) SetExcept( newSignals, signalSet ))));
}

/****i* addTask() [3.0] ***********************************************
*
* NAME
*    addTask()
*
* DESCRIPTION
*    ^ <primitive 209 4 8 taskObj initPCObj finalPCObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *addTask( OBJECT *taskObj, OBJECT *inpcObj, OBJECT *fnpcObj )
{
   struct Task *task   = (struct Task *) CheckObject( taskObj );
   const  APTR  initPC =    (const APTR) CheckObject( inpcObj );
   const  APTR  finlPC =    (const APTR) CheckObject( fnpcObj );
   
   if (!task) // == NULL)
      return( o_nil );
       
   return( AssignObj( new_address( (ULONG) AddTask( task, initPC, finlPC, 0 ))));
}

/****i* removeTask() [3.0] ********************************************
*
* NAME
*    removeTask()
*
* DESCRIPTION
*    <primitive 209 4 9 taskObj>
***********************************************************************
*
*/

METHODFUNC void removeTask( OBJECT *taskObj )
{
   struct Task *task = (struct Task *) CheckObject( taskObj );

   if (!task) // == NULL)
      return;
      
   RemTask( task );
   
   return;
}

/****i* setTaskPri() [3.0] ********************************************
*
* NAME
*    setTaskPri()
*
* DESCRIPTION
*    ^ <primitive 209 4 10 taskObj priorityNum>
***********************************************************************
*
*/

METHODFUNC OBJECT *setTaskPri( OBJECT *taskObj, LONG priority )
{
   struct Task *task = (struct Task *) CheckObject( taskObj );

   if (!task) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_int( (int) SetTaskPri( task, priority ))));
}

// 11 through 14 were for Child() functions (OBSOLETE!)

/****i* removePort() [3.0] ********************************************
*
* NAME
*    removePort()
*
* DESCRIPTION
*    <primitive 209 4 15 msgPortObj>
***********************************************************************
*
*/

METHODFUNC void removePort( OBJECT *portObj )
{
   struct MsgPort *port = (struct MsgPort *) CheckObject( portObj );
   
   if (!port) // == NULL)
      return;
      
   RemPort( port );
   
   return;
}

/****i* putMsg() [3.0] ************************************************
*
* NAME
*    putMsg()
*
* DESCRIPTION
*    <primitive 209 4 16 msgPortObj msgObj>
***********************************************************************
*
*/

METHODFUNC void putMsg( OBJECT *portObj, OBJECT *msgObj )
{
   struct MsgPort *port = (struct MsgPort *) CheckObject( portObj );
   struct Message *msg  = (struct Message *) CheckObject( msgObj  );
      
   if (!port || !msg) // == NULL)
      return;
      
   PutMsg( port, msg );
   
   return;
}

/****i* getMsg() [3.0] ************************************************
*
* NAME
*    getMsg()
*
* DESCRIPTION
*    ^ msgObj <- <primitive 209 4 17 msgPortObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *getMsg( OBJECT *portObj )
{
   struct MsgPort *port = (struct MsgPort *) CheckObject( portObj );
      
   if (!port) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) GetMsg( port ))));
}

/****i* replyMsg() [3.0] **********************************************
*
* NAME
*    replyMsg()
*
* DESCRIPTION
*    <primitive 209 4 18 msgObj>
***********************************************************************
*
*/

METHODFUNC void replyMsg( OBJECT *msgObj )
{
   struct Message *msg = (struct Message *) CheckObject( msgObj  );
      
   if (!msg) // == NULL)
      return;
      
   ReplyMsg( msg );
   
   return;
}

/****i* waitPort() [3.0] **********************************************
*
* NAME
*    waitPort()
*
* DESCRIPTION
*    ^ <primitive 209 4 19 msgPortObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *waitPort( OBJECT *portObj )
{
   struct MsgPort *port = (struct MsgPort *) CheckObject( portObj );
   
   if (!port) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_int( (int) WaitPort( port ))));
}

/****i* findPort() [3.0] **********************************************
*
* NAME
*    findPort()
*
* DESCRIPTION
*    ^ msgPortObj <- <primitive 209 4 20 portName>
***********************************************************************
*
*/

METHODFUNC OBJECT *findPort( char *name )
{
   return( AssignObj( new_address( (ULONG) FindPort( name ) ) ) );
}

/****i* addLibrary() [3.0] ********************************************
*
* NAME
*    addLibrary()
*
* DESCRIPTION
*    <primitive 209 4 21 libraryObj>
***********************************************************************
*
*/

METHODFUNC void addLibrary( OBJECT *libObj )
{
   struct Library *library = (struct Library *) CheckObject( libObj );
   
   if (!library) // == NULL)
      return;

   AddLibrary( library );
   
   return;
}

/****i* removeLibrary() [3.0] *****************************************
*
* NAME
*    removeLibrary()
*
* DESCRIPTION
*    <primitive 209 4 22 libraryObj>
***********************************************************************
*
*/

METHODFUNC void removeLibrary( OBJECT *libObj )
{
   struct Library *library = (struct Library *) CheckObject( libObj );
   
   if (!library) // == NULL)
      return;

   RemLibrary( library );
   
   return;
}

/****i* setFunction() [3.0] *******************************************
*
* NAME
*    setFunction()
*
* DESCRIPTION
*    ^ oldFuncPtrObj <- <primitive 209 4 23 libraryObj funcOffset newFuncPtrObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *setFunction( OBJECT *libObj, LONG funcOffset, 
                                ULONG (* const newFunction)()
                              )
{
   struct Library *library = (struct Library *) CheckObject( libObj );
   
   if (!library || !newFunction) // == NULL)
      return( o_nil );
   
   return( AssignObj( new_address( (ULONG) 
                                   SetFunction( library, 
                                                funcOffset, 
                                                newFunction ))));
}

/****i* sumLibrary() [3.0] ********************************************
*
* NAME
*    sumLibrary()
*
* DESCRIPTION
*    <primitive 209 4 24 libraryObj>
***********************************************************************
*
*/

METHODFUNC void sumLibrary( OBJECT *libObj )
{
   struct Library *library = (struct Library *) CheckObject( libObj );
   
   if (!library) // == NULL)
      return;
      
   SumLibrary( library );
   
   return;
}

/*------ special patchable hooks to internal exec activity ------------*/

/****i* initCode() [3.0] **********************************************
*
* NAME
*    initCode()
*
* DESCRIPTION
*    <primitive 209 4 25 startClass versionNum>
***********************************************************************
*
*/

METHODFUNC void initCode( ULONG startClass, ULONG version )
{
   InitCode( startClass, version );
   
   return;
}

/****i* initStruct() [3.0] ********************************************
*
* NAME
*    initStruct()
*
* DESCRIPTION
*    <primitive 209 4 26 initTableObj memoryObj size>
***********************************************************************
*
*/

METHODFUNC void initStruct( OBJECT *tabObj, OBJECT *memObj, ULONG size )
{
   const APTR initTable = (const APTR) CheckObject( tabObj );
         APTR memory    =       (APTR) CheckObject( memObj );
   
   if (!memory || !initTable) // == NULL)
      return;
            
   InitStruct( initTable, memory, size );
   
   return;
}

/****i* makeLibrary() [3.0] *******************************************
*
* NAME
*    makeLibrary()
*
* DESCRIPTION
*    ^ <primitive 209 4 27 funcInitObj structInitObj libInitObj dataSize segList>
***********************************************************************
*
*/

METHODFUNC OBJECT *makeLibrary( OBJECT *finitObj,
                                OBJECT *sinitObj,
                                ULONG  (* const libInit)(),
                                ULONG   dataSize,
                                ULONG   segList
                              )
{
   const APTR funcInit   = (const APTR) CheckObject( finitObj );
   const APTR structInit = (const APTR) CheckObject( sinitObj );
   ULONG      addr       = 0L;
      
   if (!segList) // == NULL)
      return( o_nil );
   
   addr = (ULONG) MakeLibrary( funcInit, structInit, (APTR) libInit, dataSize, (APTR) segList );

   return( AssignObj( new_address( addr ) ) );
}

/****i* makeFunctions() [3.0] *****************************************
*
* NAME
*    makeFunctions()
*
* DESCRIPTION
*    <primitive 209 4 28 targetObj funcArrayObj funcDispBase>
***********************************************************************
*
*/

METHODFUNC void makeFunctions( OBJECT *targetObj, 
                               OBJECT *funcArrayObj, 
                               OBJECT *funcDispBase
                             )
{
         APTR target        =       (APTR) CheckObject( targetObj    );
   const APTR functionArray = (const APTR) CheckObject( funcArrayObj );
   const APTR funcBase      = (const APTR) CheckObject( funcDispBase );

   if (!target || !functionArray) // == NULL)
      return;
      
   MakeFunctions( target, functionArray, funcBase );
   
   return;
}

/****i* findResident() [3.0] ******************************************
*
* NAME
*    findResident()
*
* DESCRIPTION
*    ^ residentObj <- <primitive 209 4 29 residentName>
***********************************************************************
*
*/

METHODFUNC OBJECT *findResident( char *name )
{
   return( AssignObj( new_address( (ULONG) FindResident( name ) ) ) );
}

/****i* initResident() [3.0] ******************************************
*
* NAME
*    initResident()
*
* DESCRIPTION
*    ^ <primitive 209 4 30 residentObj segList>
***********************************************************************
*
*/

METHODFUNC OBJECT *initResident( OBJECT *resObj, ULONG segList )
{
#  ifdef __SASC
   const struct Resident *res = (const struct Resident *) CheckObject( resObj );
#  else
   struct Resident *res = (struct Resident *) CheckObject( resObj );
#  endif

   APTR          newRes = (APTR) NULL;
   
   if (!res || !segList) // == NULL)
      return( o_nil );
   
   newRes = InitResident( res, segList );

   return( AssignObj( new_int( (int)  newRes ) ) );
}

/****i* alertDisplay() [3.0] ******************************************
*
* NAME
*    alertDisplay()
*
* DESCRIPTION
*    <primitive 209 4 31 alertNumber>
***********************************************************************
*
*/

METHODFUNC void alertDisplay( ULONG alertNum )
{
   Alert( alertNum );

   return;
}

/****i* callDebug() [3.0] *********************************************
*
* NAME
*    callDebug()
*
* DESCRIPTION
*    <primitive 209 4 32 dbgFlags>
***********************************************************************
*
*/

#ifdef  __SASC
METHODFUNC void callDebug( ULONG flags )
{
   Debug( flags );

   return;
}
#endif

/****i* allocate() [3.0] **********************************************
*
* NAME
*    allocate()
*
* DESCRIPTION
*    ^ <primitive 209 4 33 memHeaderObj byteSize>
***********************************************************************
*
*/

METHODFUNC OBJECT *allocate( OBJECT *mhObj, ULONG byteSize )
{
   struct MemHeader *freeList = (struct MemHeader *) CheckObject( mhObj );
 
   if (byteSize < 1)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) Allocate( freeList, byteSize ) ) ) );
}

/****i* deallocate() [3.0] ********************************************
*
* NAME
*    deallocate()
*
* DESCRIPTION
*    <primitive 209 4 34 memHeaderObj memoryObj byteSize>
***********************************************************************
*
*/

METHODFUNC void deallocate( OBJECT *mhObj, OBJECT *memObj, ULONG byteSize )
{
   struct MemHeader *freeList = (struct MemHeader *) CheckObject( mhObj );
   APTR              memBlok  =               (APTR) CheckObject( memObj );  

   if (!freeList || !memBlok) // == NULL)
      return;
      
   Deallocate( freeList, memBlok, byteSize );
   
   return;
}

/****i* allocAbs() [3.0] **********************************************
*
* NAME
*    allocAbs()
*
* DESCRIPTION
*    ^ <primitive 209 4 35 byteSize locationObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *allocAbs( ULONG byteSize, OBJECT *locObj )
{
   APTR location = (APTR) CheckObject( locObj );
   
   if (byteSize < 1)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) AllocAbs( byteSize, location ) ) ) );
}

/****i* allocMemory() [3.0] *******************************************
*
* NAME
*    allocMemory()
*
* DESCRIPTION
*    ^ <primitive 209 4 36 byteSize memTypeFlags>
***********************************************************************
*
*/

METHODFUNC OBJECT *allocMemory( ULONG byteSize, ULONG requirements )
{
   if (byteSize < 1)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) AllocMem( byteSize, requirements ) ) ) );
}

/****i* freeMemory() [3.0] ********************************************
*
* NAME
*    freeMemory()
*
* DESCRIPTION
*    <primitive 209 4 37 memoryObj byteSize>
***********************************************************************
*
*/

METHODFUNC void freeMemory( OBJECT *memObj, ULONG byteSize )
{
   APTR memoryBlock = (APTR) CheckObject( memObj );
   
   if (!memoryBlock) // == NULL)
      return;
      
   FreeMem( memoryBlock, byteSize );
   
   return;
}

/****i* availMemory() [3.0] *******************************************
*
* NAME
*    availMemory()
*
* DESCRIPTION
*    ^ <primitive 209 4 38 memTypeFlags>
***********************************************************************
*
*/

METHODFUNC OBJECT *availMemory( ULONG requirements )
{
   return( AssignObj( new_int( (int) AvailMem( requirements ) ) ) );
}

/****i* allocEntry() [3.0] ********************************************
*
* NAME
*    allocEntry()
*
* DESCRIPTION
*    ^ <primitive 209 4 39 memListObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *allocEntry( OBJECT *memObj )
{
   struct MemList *entry = (struct MemList *) CheckObject( memObj );
   
   if (!entry) // == NULL)  // ????
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) AllocEntry( entry ) ) ) );
}

/****i* freeEntry() [3.0] *********************************************
*
* NAME
*    freeEntry()
*
* DESCRIPTION
*    <primitive 209 4 40 memListObj>
***********************************************************************
*
*/

METHODFUNC void freeEntry( OBJECT *memObj )
{
   struct MemList *entry = (struct MemList *) CheckObject( memObj );
   
   if (!entry) // == NULL)
      return;
      
   FreeEntry( entry );
   
   return;
}

/****i* insertNode() [3.0] ********************************************
*
* NAME
*    insertNode()
*
* DESCRIPTION
*    <primitive 209 4 41 listObj nodeObj predObj>
***********************************************************************
*
*/

METHODFUNC void insertNode( OBJECT *listObj, OBJECT *nodeObj, OBJECT *predObj )
{
   struct List *list = (struct List *) CheckObject( listObj );
   struct Node *node = (struct Node *) CheckObject( nodeObj );
   struct Node *pred = (struct Node *) CheckObject( predObj );
   
   if (!list || !node || !pred) // == NULL)
      return;

   Insert( list, node, pred );
   
   return;
}

/****i* addHead() [3.0] ***********************************************
*
* NAME
*    addHead()
*
* DESCRIPTION
*    <primitive 209 4 42 listObj nodeObj>
***********************************************************************
*
*/

METHODFUNC void addHead( OBJECT *listObj, OBJECT *nodeObj )
{
   struct List *list = (struct List *) CheckObject( listObj );
   struct Node *node = (struct Node *) CheckObject( nodeObj );
   
   if (!list || !node) // == NULL)
      return;

   AddHead( list, node );
   
   return;
}

/****i* addTail() [3.0] ***********************************************
*
* NAME
*    addTail()
*
* DESCRIPTION
*    <primitive 209 4 43 listObj nodeObj>
***********************************************************************
*
*/

METHODFUNC void addTail( OBJECT *listObj, OBJECT *nodeObj )
{
   struct List *list = (struct List *) CheckObject( listObj );
   struct Node *node = (struct Node *) CheckObject( nodeObj );
   
   if (!list || !node) // == NULL)
      return;

   AddTail( list, node );
   
   return;
}

/****i* removeNode() [3.0] ********************************************
*
* NAME
*    removeNode()
*
* DESCRIPTION
*    <primitive 209 4 44 nodeObj>
***********************************************************************
*
*/

METHODFUNC void removeNode( OBJECT *nodeObj )
{
   struct Node *node = (struct Node *) CheckObject( nodeObj );
   
   if (!node) // == NULL)
      return;

   Remove( node );
   
   return;
}

/****i* removeHead() [3.0] ********************************************
*
* NAME
*    removeHead()
*
* DESCRIPTION
*    ^ nodeObj <- <primitive 209 4 45 listObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *removeHead( OBJECT *listObj )
{
   struct List *list = (struct List *) CheckObject( listObj );

   if (!list) // == NULL)
      return( o_nil );

   return( AssignObj( new_address( (ULONG) RemHead( list ) ) ) );
}

/****i* removeTail() [3.0] ********************************************
*
* NAME
*    removeTail()
*
* DESCRIPTION
*    ^ nodeObj <- <primitive 209 4 46 listObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *removeTail( OBJECT *listObj )
{
   struct List *list = (struct List *) CheckObject( listObj );

   if (!list) // == NULL)
      return( o_nil );

   return( AssignObj( new_address( (ULONG) RemTail( list ) ) ) );
}

/****i* enqueueToList() [3.0] *****************************************
*
* NAME
*    enqueueToList()
*
* DESCRIPTION
*    <primitive 209 4 47 listObj nodeObj>
***********************************************************************
*
*/

METHODFUNC void enqueueToList( OBJECT *listObj, OBJECT *nodeObj )
{
   struct List *list = (struct List *) CheckObject( listObj );
   struct Node *node = (struct Node *) CheckObject( nodeObj );
   
   if (!list || !node) // == NULL)
      return;
      
   Enqueue( list, node );
   
   return;
}

/****i* findNamedNode() [3.0] *****************************************
*
* NAME
*    findNamedNode()
*
* DESCRIPTION
*    ^ nodeObj <- <primitive 209 4 48 listObj nodeName>
***********************************************************************
*
*/

METHODFUNC OBJECT *findNamedNode( OBJECT *listObj, char *name )
{
   struct List *list = (struct List *) CheckObject( listObj );
   
   if (!list) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) FindName( list, name ) ) ) );
}

/****i* createIORequest() [3.0] ***************************************
*
* NAME
*    createIORequest()
*
* DESCRIPTION
*    ^ ioRequestObj <- <primitive 209 4 49 msgPortObj size>
***********************************************************************
*
*/

METHODFUNC OBJECT *createIORequest( OBJECT *mportObj, ULONG size )
{
#  ifdef __SASC
   const struct MsgPort *port = (const struct MsgPort *) CheckObject( mportObj );
#  else
   struct MsgPort   *port = (struct MsgPort *) CheckObject( mportObj );
#  endif

   struct IORequest *ior  = (struct IORequest *) NULL;
      
   if (!port) // == NULL)
      return( o_nil );

   ior = CreateIORequest( port, size );
   
   return( AssignObj( new_address( (ULONG) ior ) ) );
}

/****i* deleteIORequest() [3.0] ***************************************
*
* NAME
*    deleteIORequest()
*
* DESCRIPTION
*    <primitive 209 4 50 ioRequestObj>
***********************************************************************
*
*/

METHODFUNC void deleteIORequest( OBJECT *ioreqObj )
{
   APTR iorequest = (APTR) CheckObject( ioreqObj );
   
   if (!iorequest) // == NULL)
      return;
      
   DeleteIORequest( iorequest );
   
   return;
}

/****i* addDevice() [3.0] *********************************************
*
* NAME
*    addDevice()
*
* DESCRIPTION
*    <primitive 209 4 51 deviceObj>
***********************************************************************
*
*/

METHODFUNC void addDevice( OBJECT *devObj )
{
   struct Device *device = (struct Device *) CheckObject( devObj );
   
   if (!device) // == NULL)
      return;
      
   AddDevice( device );
   
   return;
}

/****i* removeDevice() [3.0] ******************************************
*
* NAME
*    removeDevice()
*
* DESCRIPTION
*    <primitive 209 4 52 deviceObj>
***********************************************************************
*
*/

METHODFUNC void removeDevice( OBJECT *devObj )
{
   struct Device *device = (struct Device *) CheckObject( devObj );
   
   if (!device) // == NULL)
      return;
      
   RemDevice( device );
   
   return;
}

/****i* doIO() [3.0] **************************************************
*
* NAME
*    doIO()
*
* DESCRIPTION
*    ^ <primitive 209 4 53 ioRequestObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *doIO( OBJECT *iorObj )
{
   struct IORequest *ioRequest = (struct IORequest *) CheckObject( iorObj );
   
   if (!ioRequest) // == NULL)
      return( o_nil );

   return( AssignObj( new_int( (int) DoIO( ioRequest ) ) ) );
}

/****i* sendIO() [3.0] ************************************************
*
* NAME
*    sendIO()
*
* DESCRIPTION
*    <primitive 209 4 54 ioRequestObj>
***********************************************************************
*
*/

METHODFUNC void sendIO( OBJECT *iorObj )
{
   struct IORequest *ioRequest = (struct IORequest *) CheckObject( iorObj );
   
   if (!ioRequest) // == NULL)
      return;

   SendIO( ioRequest );
   
   return;
}

/****i* checkIO() [3.0] ***********************************************
*
* NAME
*    checkIO()
*
* DESCRIPTION
*    ^ <primitive 209 4 55 ioRequestObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *checkIO( OBJECT *iorObj )
{
   struct IORequest *ioRequest = (struct IORequest *) CheckObject( iorObj );
   
   if (!ioRequest) // == NULL)
      return( o_nil );

   return( AssignObj( new_int( (int) CheckIO( ioRequest ) ) ) );
}

/****i* waitIO() [3.0] ************************************************
*
* NAME
*    waitIO()
*
* DESCRIPTION
*    ^ <primitive 209 4 56 ioRequestObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *waitIO( OBJECT *iorObj )
{
   struct IORequest *ioRequest = (struct IORequest *) CheckObject( iorObj );
   
   if (!ioRequest) // == NULL))
      return( o_nil );

   return( AssignObj( new_int( (int) WaitIO( ioRequest ) ) ) );
}

/****i* abortIO() [3.0] ***********************************************
*
* NAME
*    abortIO()
*
* DESCRIPTION
*    <primitive 209 4 57 ioRequestObj>
***********************************************************************
*
*/

METHODFUNC void abortIO( OBJECT *iorObj )
{
   struct IORequest *ioRequest = (struct IORequest *) CheckObject( iorObj );
   
   if (!ioRequest) // == NULL))
      return;
      
   AbortIO( ioRequest );
   
   return;
}

/****i* addResource() [3.0] *******************************************
*
* NAME
*    addResource()
*
* DESCRIPTION
*    <primitive 209 4 58 resourceObj>
***********************************************************************
*
*/

METHODFUNC void addResource( OBJECT *resObj )
{
   APTR resource = (APTR) CheckObject( resObj );
   
   if (!resource) // == NULL)
      return;

   AddResource( resource );
   
   return;
}

/****i* removeResource() [3.0] ****************************************
*
* NAME
*    removeResource()
*
* DESCRIPTION
*    <primitive 209 4 59 resourceObj>
***********************************************************************
*
*/

METHODFUNC void removeResource( OBJECT *resObj )
{
   APTR resource = (APTR) CheckObject( resObj );
   
   if (!resource) // == NULL)
      return;
      
   RemResource( resource );
   
   return;
}

/****i* openResource() [3.0] ******************************************
*
* NAME
*    openResource()
*
* DESCRIPTION
*    ^ <primitive 209 4 60 resourceName>
***********************************************************************
*
*/

METHODFUNC OBJECT *openResource( char *resName )
{
   return( AssignObj( new_address( (ULONG) OpenResource( resName ) ) ) );
}

/****i* getConditionCodes() [3.0] *************************************
*
* NAME
*    getConditionCodes()
*
* DESCRIPTION
*    ^ <primitive 209 4 61>
***********************************************************************
*
*/

METHODFUNC OBJECT *getConditionCodes( void )
{
   return( AssignObj( new_int( (int) GetCC( ) ) ) );
}

/****i* typeOfMem() [3.0] *********************************************
*
* NAME
*    typeOfMem()
*
* DESCRIPTION
*    ^ <primitive 209 4 62 addressObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *typeOfMem( OBJECT *addrObj )
{
   const APTR address = (const APTR) CheckObject( addrObj );
   
   return( AssignObj( new_int( (int) TypeOfMem( address ) ) ) );
}

/****i* procure() [3.0] ***********************************************
*
* NAME
*    procure()
*
* DESCRIPTION
*    <primitive 209 4 63 sigSemaphoreObj semaphoreMsgObj>
***********************************************************************
*
*/

METHODFUNC void procure( OBJECT *ssObj, OBJECT *smsgObj )
{
   struct SignalSemaphore  *ss  = (struct SignalSemaphore  *) CheckObject( ssObj );
   struct SemaphoreMessage *msg = (struct SemaphoreMessage *) CheckObject( smsgObj );
   ULONG                    sig = 0L;
   
   if (!ss || !msg) // == NULL)
      return; // ( (OBJECT *) o_nil );
   
   Procure( ss, msg ); 

   return; // ( AssignObj( new_address( sig ) ) );
}

/****i* vacate() [3.0] ************************************************
*
* NAME
*    vacate()
*
* DESCRIPTION
*    <primitive 209 4 64 sigSemaphoreObj semaphoreMsgObj>
***********************************************************************
*
*/

METHODFUNC void vacate( OBJECT *ssObj, OBJECT *smsgObj )
{
   struct SignalSemaphore  *ss  = (struct SignalSemaphore  *) CheckObject( ssObj );
   struct SemaphoreMessage *msg = (struct SemaphoreMessage *) CheckObject( smsgObj );

   if (!ss || !msg) // == NULL)
      return;
      
   Vacate( ss, msg );
   
   return;
}

/****i* initSemaphore() [3.0] *****************************************
*
* NAME
*    initSemaphore()
*
* DESCRIPTION
*    <primitive 209 4 65 sigSemaphoreObj>
***********************************************************************
*
*/

METHODFUNC void initSemaphore( OBJECT *ssObj )
{
   struct SignalSemaphore *ss = (struct SignalSemaphore *) CheckObject( ssObj );
   
   if (!ss) // == NULL)
      return;

   InitSemaphore( ss );
   
   return;
}

/****i* obtainSemaphore() [3.0] ***************************************
*
* NAME
*    obtainSemaphore()
*
* DESCRIPTION
*    <primitive 209 4 66 sigSemaphoreObj>
***********************************************************************
*
*/

METHODFUNC void obtainSemaphore( OBJECT *ssObj )
{
   struct SignalSemaphore *ss = (struct SignalSemaphore *) CheckObject( ssObj );
   
   if (!ss) // == NULL)
      return;

   ObtainSemaphore( ss );
   
   return;
}

/****i* releaseSemaphore() [3.0] **************************************
*
* NAME
*    releaseSemaphore()
*
* DESCRIPTION
*    <primitive 209 4 67 sigSemaphoreObj>
***********************************************************************
*
*/

METHODFUNC void releaseSemaphore( OBJECT *ssObj )
{
   struct SignalSemaphore *ss = (struct SignalSemaphore *) CheckObject( ssObj );
   
   if (!ss) // == NULL)
      return;

   ReleaseSemaphore( ss );
   
   return;
}

/****i* attemptSemaphore() [3.0] **************************************
*
* NAME
*    attemptemaphore()
*
* DESCRIPTION
*    ^ <primitive 209 4 68 sigSemaphoreObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *attemptSemaphore( OBJECT *ssObj )
{
   struct SignalSemaphore *ss = (struct SignalSemaphore *) CheckObject( ssObj );
   
   if (!ss) // == NULL)
      return( o_nil );

   return( AssignObj( new_int( (int) AttemptSemaphore( ss ) ) ) );
}

/****i* obtainSemaphoreList() [3.0] ***********************************
*
* NAME
*    obtainSemaphoreList()
*
* DESCRIPTION
*    <primitive 209 4 69 listObj>
***********************************************************************
*
*/

METHODFUNC void obtainSemaphoreList( OBJECT *listObj )
{
   struct List *sigSem = (struct List *) CheckObject( listObj );
   
   if (!sigSem) // == NULL)
      return;
      
   ObtainSemaphoreList( sigSem );
   
   return;
}

/****i* releaseSemaphoreList() [3.0] **********************************
*
* NAME
*    releaseSemaphoreList()
*
* DESCRIPTION
*    <primitive 209 4 70 listObj>
***********************************************************************
*
*/

METHODFUNC void releaseSemaphoreList( OBJECT *listObj )
{
   struct List *sigSem = (struct List *) CheckObject( listObj );
   
   if (!sigSem) // == NULL)
      return;
      
   ReleaseSemaphoreList( sigSem );
   
   return;
}

/****i* findSemaphore() [3.0] *****************************************
*
* NAME
*    findSemaphore()
*
* DESCRIPTION
*    ^ semaphoreObj <- <primitive 209 4 71 semaphoreName>
***********************************************************************
*
*/

METHODFUNC OBJECT *findSemaphore( char *semName )
{
   return( AssignObj( new_address( (ULONG) FindSemaphore( semName ) ) ) );
}

/****i* addSemaphore() [3.0] ******************************************
*
* NAME
*    addSemaphore()
*
* DESCRIPTION
*    <primitive 209 4 72 semaphoreName>
***********************************************************************
*
*/

METHODFUNC void addSemaphore( OBJECT *ssObj )
{
   struct SignalSemaphore *ss = (struct SignalSemaphore *) CheckObject( ssObj );
   
   if (!ss) // == NULL)
      return;
      
   AddSemaphore( ss );
   
   return;
}

/****i* removeSemaphore() [3.0] ***************************************
*
* NAME
*    removeSemaphore()
*
* DESCRIPTION
*    <primitive 209 4 73 sigSemaphoreObj>
***********************************************************************
*
*/

METHODFUNC void removeSemaphore( OBJECT *ssObj )
{
   struct SignalSemaphore *ss = (struct SignalSemaphore *) CheckObject( ssObj );
   
   if (!ss) // == NULL)
      return;

   RemSemaphore( ss );
   
   return;
}

/****i* attemptSemaphoreShared() [3.0] ********************************
*
* NAME
*    attemptSemaphoreShared()
*
* DESCRIPTION
*    ^ <primitive 209 4 74 sigSemaphoreObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *attemptSemaphoreShared( OBJECT *ssObj )
{
   struct SignalSemaphore *ss = (struct SignalSemaphore *) CheckObject( ssObj );
   
   if (!ss) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_int( (int) AttemptSemaphoreShared( ss ) ) ) );
}

/****i* sumKickData() [3.0] *******************************************
*
* NAME
*    sumKickData()
*
* DESCRIPTION
*    ^ <primitive 209 4 75>
***********************************************************************
*
*/

METHODFUNC OBJECT *sumKickData( void )
{
   return( AssignObj( new_int( (int) SumKickData() ) ) );
}

/****i* addMemList() [3.0] ********************************************
*
* NAME
*    addMemList()
*
* DESCRIPTION
*    <primitive 209 4 76 size attributes priority baseObj name>
***********************************************************************
*
*/

METHODFUNC void addMemList( ULONG size, ULONG attrs, LONG pri, 
                            OBJECT *baseObj, char *name 
                          )
{
   APTR base = (APTR) CheckObject( baseObj );
   
   if (!base) // == NULL)
      return;
      
   AddMemList( size, attrs, pri, base, name );
   
   return;
}

/****i* cacheClearU() [3.0] *******************************************
*
* NAME
*    cacheClearU()
*
* DESCRIPTION
*    <primitive 209 4 77>
***********************************************************************
*
*/

METHODFUNC void cacheClearU( void )
{
   CacheClearU();
   
   return;
}

/****i* cacheClearE() [3.0] *******************************************
*
* NAME
*    cacheClearE()
*
* DESCRIPTION
*    <primitive 209 4 78 addressObj length caches>
***********************************************************************
*
*/

METHODFUNC void cacheClearE( OBJECT *addrObj, ULONG length, ULONG caches )
{
   APTR address = (APTR) CheckObject( addrObj );
   
   if (!address) // == NULL)
      return;
      
   CacheClearE( address, length, caches );
   
   return;
}

/****i* cacheControl() [3.0] ******************************************
*
* NAME
*    cacheControl()
*
* DESCRIPTION
*    ^ <primitive 209 4 79 cacheBits cacheMask>
***********************************************************************
*
*/

METHODFUNC OBJECT *cacheControl( ULONG cacheBits, ULONG cacheMask )
{
   return( AssignObj( new_int( (int) CacheControl( cacheBits, cacheMask ))));
}

/****i* obtainSharedSemaphore() [3.0] *********************************
*
* NAME
*    obtainSharedSemaphore()
*
* DESCRIPTION
*    <primitive 209 4 80 sigSemaphoreObj>
***********************************************************************
*
*/

METHODFUNC void obtainSharedSemaphore( OBJECT *semObj )
{
   struct SignalSemaphore *sigSem = (struct SignalSemaphore *) CheckObject( semObj );
   
   if (!sigSem) // == NULL)
      return;
      
   ObtainSemaphoreShared( sigSem );
   
   return;
}

/****i* createPool() [3.0] ********************************************
*
* NAME
*    createPool()
*
* DESCRIPTION
*    ^ memoryPoolObj <primitive 209 4 81 memTypeFlags puddleSize threshSize>
***********************************************************************
*
*/

METHODFUNC OBJECT *createPool( ULONG reqs, ULONG puddleSize, ULONG threshSize )
{
   return( AssignObj( new_address( (ULONG) CreatePool( reqs, puddleSize, threshSize ))));
}

/****i* deletePool() [3.0] ********************************************
*
* NAME
*    deletePool()
*
* DESCRIPTION
*    <primitive 209 4 82 memoryPoolObj>
***********************************************************************
*
*/

METHODFUNC void deletePool( OBJECT *pObj )
{
   APTR poolHeader = (APTR) CheckObject( pObj );

   if (!poolHeader) // == NULL)
      return;

   DeletePool( poolHeader );
   
   return;
}

/****i* allocPooled() [3.0] *******************************************
*
* NAME
*    allocPooled()
*
* DESCRIPTION
*    ^ puddleObj <- <primitive 209 4 83 memoryPoolObj memSize>
***********************************************************************
*
*/

METHODFUNC OBJECT *allocPooled( OBJECT *pObj, ULONG memSize )
{
   APTR poolHeader = (APTR) CheckObject( pObj );

   if ((memSize < 1) || !poolHeader) // == NULL)
      return( o_nil );

   return( AssignObj( new_address( (ULONG) AllocPooled( poolHeader, memSize ))));
}

/****i* freePooled() [3.0] ********************************************
*
* NAME
*    freePooled()
*
* DESCRIPTION
*    <primitive 209 4 84 memoryPoolObj puddleObj memSize>
***********************************************************************
*
*/

METHODFUNC void freePooled( OBJECT *pObj, OBJECT *memObj, ULONG memSize )
{
   APTR poolHeader = (APTR) CheckObject( pObj   );
   APTR memory     = (APTR) CheckObject( memObj );
   
   if ((memSize < 1) || !poolHeader || !memory) // == NULL)
      return;

   FreePooled( poolHeader, memory, memSize );
   
   return;
}

/****i* coldReboot() [3.0] ********************************************
*
* NAME
*    coldReboot()
*
* DESCRIPTION
*    <primitive 209 4 85>
***********************************************************************
*
*/

METHODFUNC void coldReboot( void )
{
   ColdReboot();

   return; // Never reached(?)
}

/****i* stackSwap() [3.0] *********************************************
*
* NAME
*    stackSwap()
*
* DESCRIPTION
*    <primitive 209 4 86 stackSwapStructObj>
***********************************************************************
*
*/

METHODFUNC void stackSwap( OBJECT *sssObj )
{
   struct StackSwapStruct *sss = (struct StackSwapStruct *) CheckObject( sssObj );
   
   if (!sss) // == NULL)
      return;
      
   StackSwap( sss );
   
   return;
}

/****i* rawDoFmt() [3.0] **********************************************
*
* NAME
*    rawDoFmt()
*
* DESCRIPTION
*    ^ <primitive 209 4 87 fmtString dataStreamObj putChFuncObj putChData>
***********************************************************************
*
*/

METHODFUNC OBJECT *rawDoFormat( char *fmtStr, OBJECT *strmObj,
                                OBJECT *funcObj, OBJECT *dataObj
                              )
{
   const APTR dataStream = (const APTR) CheckObject( strmObj );
   void (* putChProc)()  = (void (*)()) CheckObject( funcObj );
   APTR  putChData       = (APTR)       CheckObject( dataObj );
   
   // Do some error checking here!
      
   return( AssignObj( new_int( (int) RawDoFmt( fmtStr, dataStream,
                                               putChProc, putChData 
                                             ) 
                             ) 
                    )
         );
}

/****i* addMemHandler() [3.0] *****************************************
*
* NAME
*    addMemHandler()
*
* DESCRIPTION
*    <primitive 209 4 88 interruptObj>
***********************************************************************
*
*/

METHODFUNC void addMemHandler( OBJECT *intObj )
{
   struct Interrupt *memhand = (struct Interrupt *) CheckObject( intObj );
   
   if (!memhand) // == NULL)
      return;

   AddMemHandler( memhand );
   
   return;
}

/****i* removeMemHandler() [3.0] **************************************
*
* NAME
*    removeMemHandler()
*
* DESCRIPTION
*    <primitive 209 4 89 interruptObj>
***********************************************************************
*
*/

METHODFUNC void removeMemHandler( OBJECT *intObj )
{
   struct Interrupt *memhand = (struct Interrupt *) CheckObject( intObj );
   
   if (!memhand) // == NULL)
      return;
      
   RemMemHandler( memhand );
   
   return;
}

/****i* findTask() [3.0] **********************************************
*
* NAME
*    findTask()
*
* DESCRIPTION
*    ^ <primitive 209 4 90 taskName>
***********************************************************************
*
*/

METHODFUNC OBJECT *findTask( char *taskName )
{
   return( AssignObj( new_address( (ULONG) FindTask( taskName ) ) ) );
}

/****i* addAVLNode() [3.0] ********************************************
*
* NAME
*    addAVLNode()
*
* DESCRIPTION
       Note that the compare function works like strcmp() by returning
       <0, 0, >0 results to define a less/equal/greater relationship.
       Note that there is no arbitration for access to the tree. You
       should use a SignalSemaphore if arbitration is required.

*    ^ <primitive 209 4 91 avlRootNode avlNode funcObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *addAVLNode( OBJECT *rootObj, OBJECT *avlNodeObj, OBJECT *funcObj )
{
   struct AVLNode *root = (struct AVLNode *) CheckObject( rootObj );
   struct AVLNode *node = (struct AVLNode *) CheckObject( avlNodeObj );
   struct AVLNode *retn = (struct AVLNode *) NULL;
   APTR            func =             (APTR) CheckObject( funcObj    );
   OBJECT         *rval = o_nil;
   
   if (!node || !func) // == NULL) // root can be NULL.
      return( rval );
      
   retn = AVL_AddNode( &root, node, func );
   
   if (!retn) // == NULL)
      return( o_true );
   
   rval = AssignObj( new_address( (ULONG) retn ) );
   
   return( rval );
}

/****i* removeAVLNodeAddr() [3.0] *************************************
*
* NAME
*    removeAVLNodeAddr()
*
* DESCRIPTION
*    ^ <primitive 209 4 92 avlRootNode avlNode>
***********************************************************************
*
*/

METHODFUNC OBJECT *removeAVLNodeAddr( OBJECT *rootObj, OBJECT *avlNodeObj )
{
   struct AVLNode *root = (struct AVLNode *) CheckObject( rootObj );
   struct AVLNode *node = (struct AVLNode *) CheckObject( avlNodeObj );
   struct AVLNode *retn = (struct AVLNode *) NULL;
   OBJECT         *rval = o_nil;

   if (!root || !node) // == NULL)
      return( rval );
      
   retn = AVL_RemNodeByAddress( &root, node );
   rval = AssignObj( new_int( (int) retn ) );
   
   return( rval );
}

/****i* removeAVLNodeKey() [3.0] **************************************
*
* NAME
*    removeAVLNodeKey()
*
* DESCRIPTION
*    ^ <primitive 209 4 93 avlRootNode avlKeyObj funcObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *removeAVLNodeKey( OBJECT *rootObj, 
                                     OBJECT *avlKeyObj, 
                                     OBJECT *funcObj 
                                   )
{
   struct AVLNode *root = (struct AVLNode *) CheckObject( rootObj );
   struct AVLNode *retn = (struct AVLNode *) NULL;
   AVLKey         *key  =           (AVLKey) CheckObject( avlKeyObj );
   APTR            func =             (APTR) CheckObject( funcObj    );
   OBJECT         *rval = o_nil;

   if (!root || !func) // == NULL)
      return( rval );
      
   if (!(retn = AVL_RemNodeByKey( &root, key, func ))) // == NULL)
      return( rval );
      
   rval = AssignObj( new_int( (int) retn ) );
   
   return( rval );
}

/****i* findAVLNode() [3.0] *******************************************
*
* NAME
*    findAVLNode()
*
* DESCRIPTION
       The function will search for the node with the given key and
       return a pointer to it.
       Note that the compare function works like strcmp() by returning
       <0, 0, >0 results to define a less/equal/greater relationship.

*    ^ <primitive 209 4 94 avlRootNode avlKeyObj funcObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *findAVLNode( OBJECT *rootObj, 
                                OBJECT *avlKeyObj, 
                                OBJECT *funcObj 
                              )
{
   struct AVLNode *root = (struct AVLNode *) CheckObject( rootObj );
   struct AVLNode *retn = (struct AVLNode *) NULL;
   AVLKey         *key  =           (AVLKey) CheckObject( avlKeyObj );
   APTR            func =             (APTR) CheckObject( funcObj    );
   OBJECT         *rval = o_nil;

   if (!root || !func) // == NULL)
      return( rval );
   
   if (!(retn = AVL_FindNode( root, key, func ))) // == NULL)
      return( rval );
      
   rval = AssignObj( new_address( (ULONG) retn ) );
   
   return( rval );
}

/****i* findPrevAVLNodeAddr() [3.0] ***********************************
*
* NAME
*    findPrevAVLNodeAddr()
*
* DESCRIPTION
*    ^ <primitive 209 4 95 avlNodeObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *findPrevAVLNodeAddr( OBJECT *avlNodeObj )
{
   struct AVLNode *node = (struct AVLNode *) CheckObject( avlNodeObj );
   struct AVLNode *retn = (struct AVLNode *) NULL;
   OBJECT         *rval = o_nil;

   if (!node) // == NULL)
      return( rval );
      
   if (!(retn = AVL_FindPrevNodeByAddress( node ))) // == NULL)
      return( rval );
      
   rval = AssignObj( new_address( (ULONG) retn ) );
   
   return( rval );
}

/****i* findPrevAVLNodeKey() [3.0] ************************************
*
* NAME
*    findPrevAVLNodeKey()
*
* DESCRIPTION
       The function will search for a node or the next lower node
       based on the key given and return a pointer to it.
       Note that the compare function works like strcmp() by returning
       <0, 0, >0 results to define a less/equal/greater relationship.

*    ^ <primitive 209 4 96 avlRootNode avlKeyObj funcObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *findPrevAVLNodeKey( OBJECT *rootObj, 
                                       OBJECT *avlKeyObj, 
                                       OBJECT *funcObj
                                     )
{
   struct AVLNode *root = (struct AVLNode *) CheckObject( rootObj );
   struct AVLNode *retn = (struct AVLNode *) NULL;
   AVLKey         *key  =           (AVLKey) CheckObject( avlKeyObj );
   APTR            func =             (APTR) CheckObject( funcObj    );
   OBJECT         *rval = o_nil;

   if (!root || !func) // == NULL)
      return( rval );
      
   if (!(retn = AVL_FindPrevNodeByKey( root, key, func ))) // == NULL)
      return( rval );
      
   rval = AssignObj( new_address( (ULONG) retn ) );
   
   return( rval );
}

/****i* findNextAVLNodeAddr() [3.0] ***********************************
*
* NAME
*    findNextAVLNodeAddr()
*
* DESCRIPTION
*    ^ <primitive 209 4 97 avlNodeObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *findNextAVLNodeAddr( OBJECT *avlNodeObj )
{
   struct AVLNode *node = (struct AVLNode *) CheckObject( avlNodeObj );
   struct AVLNode *retn = (struct AVLNode *) NULL;
   OBJECT         *rval = o_nil;

   if (!node) // == NULL)
      return( rval );
      
   if (!(retn = AVL_FindNextNodeByAddress( node ))) // == NULL)
      return( rval );
      
   rval = AssignObj( new_address( (ULONG) retn ) );
   
   return( rval );   
}

/****i* findNextAVLNodeKey() [3.0] ************************************
*
* NAME
*    findNextAVLNodeKey()
*
* DESCRIPTION
       The function will search for a node or the next higher node
       based on the key given and return a pointer to it.
       Note that the compare function works like strcmp() by returning
       <0, 0, >0 results to define a less/equal/greater relationship.

*    ^ <primitive 209 4 98 avlRootNode avlKeyObj funcObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *findNextAVLNodeKey( OBJECT *rootObj, 
                                       OBJECT *avlKeyObj, 
                                       OBJECT *funcObj
                                     )
{
   struct AVLNode *root = (struct AVLNode *) CheckObject( rootObj );
   struct AVLNode *retn = (struct AVLNode *) NULL;
   AVLKey          key  =           (AVLKey) CheckObject( avlKeyObj );
   APTR            func =             (APTR) CheckObject( funcObj    );
   OBJECT         *rval = o_nil;

   if (!root || !func) // == NULL)
      return( rval );
      
   retn = AVL_FindNextNodeByKey( root, key, func );
   rval = AssignObj( new_address( (ULONG) retn ) );
   
   return( rval );
}

/****i* findFirstAVLNode() [3.0] **************************************
*
* NAME
*    findFirstAVLNode()
*
* DESCRIPTION
*    ^ <primitive 209 4 99 avlRootNode>
***********************************************************************
*
*/

METHODFUNC OBJECT *findFirstAVLNode( OBJECT *rootObj )
{
   struct AVLNode *root = (struct AVLNode *) CheckObject( rootObj );
   struct AVLNode *retn = (struct AVLNode *) NULL;
   OBJECT         *rval = o_nil;

   if (!root) // == NULL)
      return( rval );
      
   if (!(retn = AVL_FindFirstNode( root ))) // == NULL)
      return( rval );
      
   rval = AssignObj( new_address( (ULONG) retn ) );
   
   return( rval );
}

/****i* findLastAVLNode() [3.0] ***************************************
*
* NAME
*    findLastAVLNode()
*
* DESCRIPTION
*    ^ <primitive 209 4 100 avlRootNode>
***********************************************************************
*
*/

METHODFUNC OBJECT *findLastAVLNode( OBJECT *rootObj )
{
   struct AVLNode *root = (struct AVLNode *) CheckObject( rootObj );
   struct AVLNode *retn = (struct AVLNode *) NULL;
   OBJECT         *rval = o_nil;

   if (!root) // == NULL)
      return( rval );
      
   if (!(retn = AVL_FindLastNode( root ))) // == NULL)
      return( rval );

   rval = AssignObj( new_address( (ULONG) retn ) );
   
   return( rval );
}

#ifdef  __SASC
SUBFUNC LONG __asm AVLNodeComp( register __a0 struct AVLNode *node1,
                                register __a1 struct AVLNode *node2 
                              )
#else
SUBFUNC LONG ASM AVLNodeComp( REG( a0, struct AVLNode *node1 ),
                              REG( a1, struct AVLNode *node2 ) 
                            )
#endif
{
   return( (LONG) ((ULONG) node1 - (ULONG) node2) );
}

/****i* avlNodeAddrCompare() [3.0] ************************************
*
* NAME
*    avlNodeAddrCompare()
*
* DESCRIPTION
*    Note that the compare function works like strcmp() by returning
*    < 0, 0, > 0 results to define a less/equal/greater relationship.
*
*    ^ <primitive 209 4 101 avlNode1 avlNode2>
***********************************************************************
*
*/

METHODFUNC OBJECT *avlNodeAddrCompare( OBJECT *avlNode1Obj, OBJECT *avlNode2Obj )
{
   register struct AVLNode *node1 = (struct AVLNode *) CheckObject( avlNode1Obj );
   register struct AVLNode *node2 = (struct AVLNode *) CheckObject( avlNode2Obj );

   OBJECT *rval = o_nil;
   LONG    comp = 0L;

   if (!node1 || !node2) // == NULL)
      return( rval );

   comp = AVLNodeComp( node1, node2 );      

   return( AssignObj( new_int( (int) comp ) ) );
}

#ifdef  __SASC
SUBFUNC LONG __asm AVLNodeKeyComp( register __a0 AVLKey key1,
                                   register __a1 AVLKey key2 
                                 )
#else
SUBFUNC LONG ASM AVLNodeKeyComp( REG( a0, AVLKey key1 ),
                                 REG( a1, AVLKey key2 )
                               )
#endif
{
   return( (LONG) ((ULONG) key1 - (ULONG) key2) );
}

/****i* avlNodeKeyCompare() [3.0] *************************************
*
* NAME
*    avlNodeKeyCompare()
*
* DESCRIPTION
*    Note that the compare function works like strcmp() by returning
*    < 0, 0, > 0 results to define a less/equal/greater relationship.
*
*    ^ <primitive 209 4 102 avlKey1 avlKey2>
***********************************************************************
*
*/

METHODFUNC OBJECT *avlNodeKeyCompare( OBJECT *avlKey1Obj, OBJECT *avlKey2Obj )
{
   register AVLKey key1 = (AVLKey) CheckObject( avlKey1Obj );
   register AVLKey key2 = (AVLKey) CheckObject( avlKey2Obj );

   LONG                 comp = AVLNodeKeyComp( key1, key2 );      

   return( AssignObj( new_int( (int) comp ) ) );
}

/****i* listToStrArray() [2.5] ****************************************
*
* NAME
*    listToStrArray()
*
* DESCRIPTION
*    Convert all valid List node.ln_Name fields to elements of an 
*    Array of Strings.
*
*    ^ <primitive 209 4 105 listObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *listToStrArray( OBJECT *listObj )
{
   struct List *list  = (struct List *) CheckObject( listObj );
   struct Node *node  = (struct Node *) NULL;
   OBJECT      *rval  = o_nil;
   int          count = 0;

   if (NullChk( (OBJECT *) list ) == TRUE)
      return( rval );   

   node = (struct Node *) list->lh_Head;
   
   while (node) // != NULL)
      {
      if (StringLength( node->ln_Name) > 0)
         count++;
      
      node = node->ln_Succ;
      }

   if (count == 0)
      return( rval );
      
   rval = new_array( count, FALSE );
   
   node  = (struct Node *) list->lh_Head;
   count = 0;

   while (node) // != NULL)
      {
      if (StringLength( node->ln_Name ) > 0)
         {
         rval->inst_var[ count ] = new_str( node->ln_Name );
      
         count++;
         }
         
      node = node->ln_Succ;
      }

   return( rval );
}

/*  Add later:
**
**  ULONG Supervisor( ULONG (* CONST userFunction)() );
**  VOID  Disable( VOID );
**  VOID  Enable( VOID );
**  VOID  Forbid( VOID ); // Task switching, NOT interrupts!
**  VOID  Permit( VOID );
**  ULONG SetSR( ULONG newSR, ULONG mask );
**  APTR  SuperState( VOID );
**  VOID  UserState( APTR sysStack );
**
**  struct Interrupt *SetIntVector( LONG intNumber, 
**                                  CONST struct Interrupt *interrupt
**                                );
**
**  VOID  AddIntServer( LONG intNumber, struct Interrupt *interrupt );
**  VOID  RemIntServer( LONG intNumber, struct Interrupt *interrupt );
**  VOID  Cause( struct Interrupt *interrupt );
**  APTR  CachePreDMA( CONST APTR address, ULONG *length, ULONG flags );
**  VOID  CachePostDMA( CONST APTR address, ULONG *length, ULONG flags );
**  ULONG ObtainQuickVector( APTR interruptCode );
**  LONG  AllocTrap( LONG trapNum );
**  VOID  FreeTrap( LONG trapNum );
*/

/****h* HandleExec() [3.0] ******************************************
*
* NAME
*    HandleExec() {Primitive 209 4 xx parms}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    Exec interfacing methods.
************************************************************************
*
*/

PUBLIC OBJECT *HandleExec( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );

      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // copyMemoryFrom: srcObj to: destObj size: size
              // <primitive 209 4 0 srcObj destObj size>
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            copyMemory( args[1], args[2], (ULONG) int_value( args[3] ) );     

         break;

      case 1: // copyMemoryQuickFrom: srcObj to: destObj size: size
              // <primitive 209 4 1 srcObj destObj size> 
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            copyMemoryQuick( args[1], args[2], (ULONG) int_value( args[3] ) );     

         break;
      
      case 2: // waitForSignal: signals
              //   ^ ulongObj <- <primitive 209 4 2 signals>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = waitForSignal( (ULONG) int_value( args[1] ) );

         break;

      case 3: // signalTask: taskObj with: signals
              // <primitive 209 4 3 taskObj signals>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            signalTask( args[1], (ULONG) int_value( args[2] ) );

         break;
          
      case 4: // makeSignal: signalNumber
              // ^ byteObj <- <primitive 209 4 4 signalNumber>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = allocSignal( (LONG) int_value( args[1] ) );

         break;
          
      case 5: // disposeSignal: signalNumber
              // <primitive 209 4 5 signalNumber>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            freeSignal( (LONG) int_value( args[1] ) );

         break;
          
      case 6: // setSignals: newSignals and: signalSet
              // ^ ulongObj <- <primitive 209 4 6 newSignals signalSet>
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = setSignal( (LONG) int_value( args[1] ),
                              (LONG) int_value( args[2] )
                            );
         break;
          
      case 7: // setException: newSignals and: signalSet
              // ^ ulongObj <- <primitive 209 4 7 newSignals signalSet>
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = setException( (LONG) int_value( args[1] ),
                                 (LONG) int_value( args[2] )
                               );
         break;
          
      case 8: // addTask: taskObj initialPC: inpcObj finalPC: fnpcObj
              // ^ aptrObj <- <primitive 209 4 8 taskObj inpcObj fnpcObj>
         rval = addTask( args[1], args[2], args[3] );
         break;
          
      case 9: // removeTask: taskObj
              // <primitive 209 4 9 taskObj>
         removeTask( args[1] );
         
         break;
          
      case 10: // setTaskPriority: taskObj to: priority
               // ^ byteObj <- <primitive 209 4 10 taskObj priority>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = setTaskPri( args[1], (LONG) int_value( args[2] ) );

         break;
/*
      case 11: // childFree: taskIDObj
               // <primitive 209 4 11 taskIDObj>
         childFree( args[1] );
         break;
          
      case 12: // childOrphan: taskIDObj
               // <primitive 209 4 12 taskIDObj>
         childOrphan( args[1] );
         break;
          
      case 13: // childStatus: taskIDObj
               // <primitive 209 4 13 taskIDObj>
         childStatus( args[1] );
         break;

      case 14: // childWait: taskIDObj
               // <primitive 209 4 14 taskIDObj>
         childWait( args[1] );
         break;    
*/          
      case 15: // removePort: msgPortObj
               // <primitive 209 4 15 msgPortObj>
         removePort( args[1] );
         break;
          
      case 16: // putMsg: msgObj to: msgPortObj
               // <primitive 209 4 16 msgPortObj msgObj>
         putMsg( args[1], args[2] );
         break;
          
      case 17: // getMsg: msgPortObj
               // ^ msgObj <- <primitive 209 4 17 msgPortObj>
         rval = getMsg( args[1] );
         break;
          
      case 18: // replyMsg: msgObj
               // <primitive 209 4 18 msgObj>
         replyMsg( args[1] );
         break;
          
      case 19: // waitPort: msgPortObj
               // ^ msgObj <- <primitive 209 4 19 msgPortObj>
         rval = waitPort( args[1] );
         break;
          
      case 20: // findPortNamed: portName
               // ^ msgPortObj <- <primitive 209 4 20 portName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = findPort( string_value( (STRING *) args[1] ) );

         break;
          
      case 21: // addLibrary: libraryObj
               // <primitive 209 4 21 libraryObj>
         addLibrary( args[1] ); 
         break;
          
      case 22: // removeLibrary: libraryObj
               // <primitive 209 4 22 libraryObj>
         removeLibrary( args[1] ); 
         break;
          
      case 23: // setFunctionIn: libraryObj at: funcOffset to: newFuncPtrObj
               // ^ oldFuncPtrObj <- <primitive 209 4 23 libraryObj funcOffset newFuncPtrObj>
         if (!is_integer( args[2] ) || !is_address( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = setFunction( args[1], (LONG) int_value( args[2] ),
                                (ULONG (* const)( )) addr_value( args[3] )
                              ); 
         break;
          
      case 24: // sumLibrary: libraryObj
               // <primitive 209 4 24 libraryObj>
         sumLibrary( args[1] ); 
         break;
          
      case 25: // initCode: startClass version: versionNum
               // <primitive 209 4 25 startClass versionNum>
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            initCode( (ULONG) int_value( args[1] ),
                      (ULONG) int_value( args[2] )
                    );
         break;
          
      case 26: // initStruct: initTableObj with: memoryObj size: size
               // <primitive 209 4 26 initTableObj memoryObj size>
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            initStruct( args[1], args[2], (ULONG) int_value( args[3] ) );

         break; 
          
      case 27: // makeLibrary: funcInitObj struct: structInitObj init: libInitFuncObj
               //                            size: dataSize  segments: segList
               // ^ libObj <- <primitive 209 4 27 funcInitObj structInitObj libInitObj dataSize segList>
         if (!is_address( args[3] ) || !is_address( args[4] )
                                    || !is_integer( args[5] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = makeLibrary( args[1], args[2],
                                (ULONG (* const )()) addr_value( args[3] ),
                                (ULONG) addr_value( args[4] ),
                                (ULONG) int_value( args[5] )
                              );
         break;
          
      case 28: // makeFunctionsIn: targetObj with: funcArrayObj displacement: funcDispBase
               // <primitive 209 4 28 targetObj funcArrayObj funcDispBase>
         makeFunctions( args[1], args[2], args[3] );

         break;
          
      case 29: // findResidentNamed: nameString
               // ^ residentObj <- <primitive 209 4 29 residentName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = findResident( string_value( (STRING *) args[1] ) );
            
         break;
          
      case 30: // initResident: residentObj segments: segList
               // ^ aptrObj <- <primitive 209 4 30 residentObj segList>
         if (is_address( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = initResident( args[1], (ULONG) addr_value( args[2] ) );

         break;
          
      case 31: // alertDisplay: alertNumber
               // <primitive 209 4 31 alertNumber>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            alertDisplay( (ULONG) int_value( args[1] ) );

         break;

#     ifdef    __SASC
      case 32: // callDebug: dbgFlags
               // <primitive 209 4 32 dbgFlags>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            callDebug( (ULONG) int_value( args[1] ) );

         break;
#     endif
          
      case 33: // allocate: memHeaderObj size: byteSize
               // ^ aptrObj <- <primitive 209 4 33 memHeaderObj byteSize>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = allocate( args[1],  (ULONG) int_value( args[2] ) ); 

         break;
          
      case 34: // deallocate: memHeaderObj memory: memoryObj size: byteSize
               // <primitive 209 4 34 memHeaderObj memoryObj byteSize>
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            deallocate( args[1], args[2], (ULONG) int_value( args[3] ) );

         break;
          
      case 35: // allocAbs: byteSize at: locationObj
               // ^ aptrObj <- <primitive 209 4 35 byteSize locationObj>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = allocAbs(  (ULONG) int_value( args[1] ), args[2] );

         break;
          
      case 36: // allocMemory: byteSize flags: memTypeFlags
               // ^ memoryObj <- <primitive 209 4 36 byteSize memTypeFlags>
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = allocMemory( (ULONG) int_value( args[1] ),
                                (ULONG) int_value( args[2] )  
                              );
         break;
          
      case 37: // freeMemory: memoryObj size: byteSize
               // <primitive 209 4 37 memoryObj byteSize>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            freeMemory( args[1],  (ULONG) int_value( args[2] ) );

         break;
          
      case 38: // availMemory: memTypeFlags
               // ^ ulongObj <- <primitive 209 4 38 memTypeFlags>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = availMemory( (ULONG) int_value( args[1] ) );

         break;
          
      case 39: // allocEntry: memListObj
               // ^ memListObj <- <primitive 209 4 39 memListObj>
         rval = allocEntry( args[1] );  
         break;
          
      case 40: // freeEntry: memListObj
               // <primitive 209 4 40 memListObj>
         freeEntry( args[1] );
         break;
          
      case 41: // insertNode: nodeObj into: listObj after: predObj
               // <primitive 209 4 41 listObj nodeObj predObj>
         insertNode( args[1], args[2], args[3] );
         break;
          
      case 42: // addHead: nodeObj to: listObj
               // <primitive 209 4 42 listObj nodeObj>
         addHead( args[1], args[2] );
         break;
          
      case 43: // addTail: nodeObj to: listObj
               // <primitive 209 4 43 listObj nodeObj>
         addTail( args[1], args[2] );
         break;
          
      case 44: // removeNode: nodeObj
               // <primitive 209 4 44 nodeObj>
         removeNode( args[1] ); 
         break;
          
      case 45: // removeHeadFrom: listObj
               // ^ nodeObj <- <primitive 209 4 45 listObj>
         removeHead( args[1] );
         break;
          
      case 46: // removeTailFrom: listObj
               // ^ nodeObj <- <primitive 209 4 46 listObj>
         removeTail( args[1] );
         break;
          
      case 47: // enqueue: nodeObj toList: listObj
               // <primitive 209 4 47 listObj nodeObj>
         enqueueToList( args[1], args[2] );
         break;
          
      case 48: // findNamedNode: nodeName in: listObj
               // ^ nodeObj <- <primitive 209 4 48 listObj nodeName>
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = findNamedNode( args[1], string_value( (STRING *) args[2] ) );

         break;
          
      case 49: // createIORequest: msgPortObj size: size
               // ^ ioRequestObj <- <primitive 209 4 49 msgPortObj size>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = createIORequest( args[1],  (ULONG) int_value( args[2] ) );

         break;
          
      case 50: // deleteIORequest: ioRequestObj
               // <primitive 209 4 50 ioRequestObj>
         deleteIORequest( args[1] );
         break;
          
      case 51: // addDevice: deviceObj
               // <primitive 209 4 51 deviceObj>
         addDevice( args[1] );
         break;
          
      case 52: // removeDevice: deviceObj
               // <primitive 209 4 52 deviceObj>
         removeDevice( args[1] );
         break;
          
      case 53: // doIO: ioRequestObj
               // ^ byteObj <- <primitive 209 4 53 ioRequestObj>
         rval = doIO( args[1] );
         break;
          
      case 54: // sendIO: ioRequestObj
               // <primitive 209 4 54 ioRequestObj>
         sendIO( args[1] );
         break;
          
      case 55: // checkIO: ioRequestObj
               // ^ ioRequestObj <- <primitive 209 4 55 ioRequestObj>
         rval = checkIO( args[1] );
         break;
          
      case 56: // waitIO: ioRequestObj
               // ^ byteObj <- <primitive 209 4 56 ioRequestObj>
         rval = waitIO( args[1] );
         break;
          
      case 57: // abortIO: ioRequestObj
               // <primitive 209 4 57 ioRequestObj>
         abortIO( args[1] );
         break;
          
      case 58: // addResource: resourceObj
               // <primitive 209 4 58 resourceObj>
         addResource( args[1] );
         break;
          
      case 59: // removeResource: resourceObj
               // <primitive 209 4 59 resourceObj>
         removeResource( args[1] );
         break;
          
      case 60: // openResource: resourceName
               // ^ aptrObj <- <primitive 209 4 60 resourceName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = openResource( string_value( (STRING *) args[1] ) );

         break;
          
      case 61: // getConditionCodes
               // ^ ulongObj <- <primitive 209 4 61>
         rval = getConditionCodes();
         break;
          
      case 62: // typeOfMem: memoryObj
               // ^ ulongObj <- <primitive 209 4 62 memoryObj>
         rval = typeOfMem( args[1] );
         break;
          
      case 63: // procure: signalSemaphoreObj msg: semaphoreMsgObj
               // <primitive 209 4 63 signalSemaphoreObj semaphoreMsgObj>
         procure( args[1], args[2] );
         break;
          
      case 64: // vacate: signalSemaphoreObj msg: semaphoreMsgObj
               // <primitive 209 4 64 signalSemaphoreObj semaphoreMsgObj>
         vacate( args[1], args[2] );
         break;
          
      case 65: // initSemaphore: signalSemaphoreObj
               // <primitive 209 4 65 signalSemaphoreObj>
         initSemaphore( args[1] );
         break;
          
      case 66: // obtainSemaphore: signalSemaphoreObj
               // <primitive 209 4 66 sigSemaphoreObj>
         obtainSemaphore( args[1] );
         break;
          
      case 67: // releaseSemaphore: signalSemaphoreObj
               // <primitive 209 4 67 signalSemaphoreObj>
         releaseSemaphore( args[1] );
         break;
          
      case 68: // attemptSemaphore: signalSemaphoreObj
               // ^ ulongObj <- <primitive 209 4 68 signalSemaphoreObj>
         rval = attemptSemaphore( args[1] );
         break;
          
      case 69: // obtainSemaphoreList: listObj
               // <primitive 209 4 69 listObj>
         obtainSemaphoreList( args[1] );
         break;
          
      case 70: // releaseSemaphoreList: listObj
               // <primitive 209 4 70 listObj>
         releaseSemaphoreList( args[1] );
         break;
          
      case 71: // findSemaphore: semaphoreName
               // ^ semaphoreObj <- <primitive 209 4 71 semaphoreName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = findSemaphore( string_value( (STRING *) args[1] ) );

         break;
          
      case 72: // addSemaphore: signalSemaphoreObj
               // <primitive 209 4 72 signalSemaphoreObj>
         addSemaphore( args[1] );
         break;
          
      case 73: // removeSemaphore: signalSemaphoreObj
               // <primitive 209 4 73 signalSemaphoreObj>
         removeSemaphore( args[1] );
         break;
          
      case 74: // attemptSemaphoreShared: signalSemaphoreObj
               // ^ ulongObj <- <primitive 209 4 74 signalSemaphoreObj>
         rval = attemptSemaphoreShared( args[1] );
         break;
          
      case 75: // sumKickData
               // ^ ulongObj <- <primitive 209 4 75>
         rval = sumKickData();
         break;
          
      case 76: // addMemList: size attrs: attributes priority: pri base: baseObj named: name 
               // <primitive 209 4 76 size attributes pri baseObj name>
         if (!is_integer( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] )
                                    || !is_string(  args[5] ))
            (void) PrintArgTypeError( 209 );
         else
            addMemList( (ULONG) int_value( args[1] ),
                        (ULONG) int_value( args[2] ),
                         (LONG) int_value( args[3] ),
                         args[4], string_value( (STRING *) args[5] )
                      );
         break;
          
      case 77: // cacheClearU
               // <primitive 209 4 77>
         cacheClearU();
         break;
          
      case 78: // cacheClearE: addressObj length: length caches: caches
               // <primitive 209 4 78 addressObj length caches>
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            cacheClearE( args[1], (ULONG) int_value( args[2] ),
                                  (ULONG) int_value( args[3] )
                       );   
         break;
          
      case 79: // cacheControl: cacheBits with: cacheMask
               // ^ ulongObj <- <primitive 209 4 79 cacheBits cacheMask>
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = cacheControl( (ULONG) int_value( args[1] ),
                                 (ULONG) int_value( args[2] )  
                               );
         break;
          
      case 80: // obtainSharedSemaphore: signalSemaphoreObj
               // <primitive 209 4 80 signalSemaphoreObj>
         obtainSharedSemaphore( args[1] );
         break;
          
      case 81: // createPool: memTpyeFlags puddle: puddleSize threshold: threshSize
               // ^ memoryPoolObj <primitive 209 4 81 memTypeFlags puddleSize threshSize>
         if (!is_integer( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = createPool( (ULONG) int_value( args[1] ),
                               (ULONG) int_value( args[2] ),
                               (ULONG) int_value( args[3] )
                             );
         break;
          
      case 82: // deletePool: memoryPoolObj
               // <primitive 209 4 82 memoryPoolObj>
         deletePool( args[1] ); 
         break;
          
      case 83: // allocPooled: memoryPoolObj size: memSize
               // ^ puddleObj <- <primitive 209 4 83 memoryPoolObj memSize>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = allocPooled( args[1],  (ULONG) int_value( args[2] ) );

         break;
          
      case 84: // freePooled: memoryPoolObj puddle: puddleObj size: memSize
               // <primitive 209 4 84 memoryPoolObj puddleObj memSize>
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            freePooled( args[1], args[2],  (ULONG) int_value( args[3] ) );

         break;
          
      case 85: // coldReboot
               // <primitive 209 4 85>
         coldReboot(); 
         break;
          
      case 86: // stackSwap: stackSwapStructObj
               // <primitive 209 4 86 stackSwapStructObj>
         stackSwap( args[1] ); 
         break;
          
      case 87: // rawDoFormat: fmtStr to: dataStreamObj renderFunction: funcObj data: dataObj
               // ^ aptrObj <- <primitive 209 4 87 fmtStr dataStreamObj funcObj dataObj>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = rawDoFormat( string_value( (STRING *) args[1] ),
                                args[2], args[3], args[4]
                              );
         break;
          
      case 88: // addMemHandler: interruptObj
               // <primitive 209 4 88 interruptObj>
         addMemHandler( args[1] );
         break;
          
      case 89: // removeMemHandler: interruptObj
               // <primitive 209 4 89 interruptObj>
         removeMemHandler( args[1] );
         break;

      case 90: // findTaskNamed: taskName
               // ^ taskObj <- <primitive 209 4 90 taskName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = findTask( string_value( (STRING *) args[1] ) ); 
   
         break;

      case 91: // addAVLNode: avlNodeObj to: avlRootNode function: funcObj 
               // ^ <primitive 209 4 91 avlRootNode avlNodeObj funcObj>
         rval = addAVLNode( args[1], args[2], args[3] );
         break;         

      case 92: // removeAVLNode: avlNodeObj from: avlRootNode
               // ^ <primitive 209 4 92 avlRootNode avlNodeObj>
         rval = removeAVLNodeAddr( args[1], args[2] );
         break;

      case 93: // removeAVLNode: avlKeyObj from: avlRootNode function: funcObj
               // ^ <primitive 209 4 93 avlRootNode avlKeyObj funcObj>
         rval = removeAVLNodeKey( args[1], args[2], args[3] );
         break;

      case 94: // findAVLNode: avlKeyObj in: avlRootNode function: funcObj
               // ^ <primitive 209 4 94 avlRootNode avlKeyObj funcObj>
         rval = findAVLNode( args[1], args[2], args[3] );
         break;

      case 95: // findPrevAVLNode: avlNodeObj
               // ^ <primitive 209 4 95 avlNodeObj>
         rval = findPrevAVLNodeAddr( args[1] );
         break;

      case 96: // findPrevAVLNode: avlKeyObj in: avlRootNode function: funcObj
               // ^ <primitive 209 4 96 avlRootNode avlKeyObj funcObj>
         rval = findPrevAVLNodeKey( args[1], args[2], args[3] );
         break;

      case 97: // findNextAVLNode: avlNodeObj
               // ^ <primitive 209 4 97 avlNodeObj>
         rval = findNextAVLNodeAddr( args[1] );
         break;

      case 98: // findNextAVLNode: avlKeyObj in: avlRootNode function: funcObj
               // ^ <primitive 209 4 98 avlRootNode avlKeyObj funcObj>
         rval = findNextAVLNodeKey( args[1], args[2], args[3] );
         break;

      case 99: // findFirstAVLNode: avlRootNode
               // ^ <primitive 209 4 99 avlRootNode>
         rval = findFirstAVLNode( args[1] );
         break;

      case 100: // findLastAVLNode: avlRootNode
                // ^ <primitive 209 4 100 avlRootNode>
         rval = findLastAVLNode( args[1] );
         break;

      case 101: // avlNodeCompare: avlNode1 with: avlNode2
                // ^ <primitive 209 4 101 avlNode1 avlNode2>
         rval = avlNodeAddrCompare( args[1], args[2] );
         break;

      case 102: // avlKeyCompare: avlKey1 with: avlKey2
                // ^ <primitive 209 4 102 avlKey1 avlKey2>
         rval = avlNodeKeyCompare( args[1], args[2] );
         break;

      case 103: // getDefaultCompareFunction
                // ^ <primitive 209 4 103>
         rval = new_int( (int) AVLNodeComp );
         break;

      case 104: // getDefaultKeyCompareFunction
                // ^ <primitive 209 4 104>
         rval = new_int( (int) AVLNodeKeyComp ); // This might be broken!!
         break;

      case 105: // ^ <primitive 209 4 105 listObj>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = listToStrArray( args[1] );
         
         break;
          
      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   return( rval );
}

/* ---------------------- END of Exec.c file! ----------------------- */

