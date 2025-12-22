" -------------------------------------------------------------------------- "
" Executive Class allows the User access to the functions from exec.library. "
" If you do not know what they do, expect your System to freeze up solid!!   "
""
" Primitive methods pertaining to MsgPorts have been moved to MsgPort.st     "
" -------------------------------------------------------------------------- "

Class Executive :Object
[
   initCode: startClass version: versionNum
      <primitive 209 4 25 startClass versionNum>
|
   initStruct: initTableObj with: memoryObj size: size
      <primitive 209 4 26 initTableObj memoryObj size>
|
   makeFunctionsIn: targetObj with: funcArrayObj displacement: funcDispBase
      <primitive 209 4 28 targetObj funcArrayObj funcDispBase>
|
   findResidentNamed: nameString
      ^ <primitive 209 4 29 nameString>
|
   initResident: residentObj segments: segList
      ^ <primitive 209 4 30 residentObj segList>
|
   alertDisplay: alertNumber
      " Use the Alert Class instead!! "
      <primitive 209 4 31 alertNumber>
|
   callDebug: dbgFlags
      <primitive 209 4 32 dbgFlags>
|
   createIORequest: msgPortObj size: size
      ^ <primitive 209 4 49 msgPortObj size>
|
   deleteIORequest: ioRequestObj
      <primitive 209 4 50 ioRequestObj>
|
   addDevice: deviceObj
      <primitive 209 4 51 deviceObj>
|
   removeDevice: deviceObj
      <primitive 209 4 52 deviceObj>
|
   doIO: ioRequestObj
      ^ <primitive 209 4 53 ioRequestObj>
|
   sendIO: ioRequestObj
      <primitive 209 4 54 ioRequestObj>
|
   checkIO: ioRequestObj
      ^ <primitive 209 4 55 ioRequestObj>
|
   waitIO: ioRequestObj
      ^ <primitive 209 4 56 ioRequestObj>
|
   abortIO: ioRequestObj
      <primitive 209 4 57 ioRequestObj>
|
   addResource: resourceObj
      <primitive 209 4 58 resourceObj>
|
   removeResource: resourceObj
      <primitive 209 4 59 resourceObj>
|
   openResource: resourceName
      ^ <primitive 209 4 60 resourceName>
|
   getConditionCodes
      ^ <primitive 209 4 61>
|
   sumKickData
      ^ <primitive 209 4 75>
|
   addMemList: size attrs: attributes priority: pri base: baseObj named: name
      <primitive 209 4 76 size attributes pri baseObj name>
|
   cacheClearU
      <primitive 209 4 77>
|
   cacheClearE: addressObj length: length caches: caches
      <primitive 209 4 78 addressObj length caches>
|
   cacheControl: cacheBits with: cacheMask
      ^ <primitive 209 4 79 cacheBits cacheMask>
|
   coldReboot
      <primitive 209 4 85>
|
   stackSwap: stackSwapStructObj
      <primitive 209 4 86 stackSwapStructObj>
|
   rawDoFormat: fmtStr to: dataStreamObj renderFunction: putChFuncObj data: putChData
      ^ <primitive 209 4 87 fmtStr dataStreamObj putChFuncObj putChData>
|
   addMemHandler: interruptObj
      <primitive 209 4 88 interruptObj>
|
   removeMemHandler: interruptObj
      <primitive 209 4 89 interruptObj>
]


" to be added later:
**  ULONG Supervisor( ULONG (* CONST userFunction)() );

**  These are just asking for trouble!!:
**  VOID  Disable( VOID ); // Disables interrupts & task-switching!
**  VOID  Enable( VOID );
**  VOID  Forbid( VOID );  // Task switching only, NOT interrupts!
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
"

" ----------------------------------------------------------------------- "
" AVLTree Class implements some new Exec functions in OS3.9.              "
""
" WARNING "
"   The compareKeyFuncObj might be broken, since the AutoDocs are as clear"
"   as mud. "
" ----------------------------------------------------------------------- "

Class AVLTree :Object ! compareFuncObj compareKeyFuncObj !
[
   addAVLNode: avlNodeObj to: avlRootNode function: funcObj 
      ^ <primitive 209 4 91 avlRootNode avlNodeObj funcObj>
|
   removeAVLNode: avlNodeObj from: avlRootNode
      ^ <primitive 209 4 92 avlRootNode avlNodeObj>
|
   removeAVLNode: avlKeyObj from: avlRootNode function: funcObj
      ^ <primitive 209 4 93 avlRootNode avlKeyObj funcObj>
|
   findAVLNode: avlKeyObj in: avlRootNode function: funcObj
      ^ <primitive 209 4 94 avlRootNode avlKeyObj funcObj>
|
   findPrevAVLNode: avlNodeObj
      ^ <primitive 209 4 95 avlNodeObj>
|
   findPrevAVLNode: avlKeyObj in: avlRootNode function: funcObj
      ^ <primitive 209 4 96 avlRootNode avlKeyObj funcObj>
|
   findNextAVLNode: avlNodeObj
      ^ <primitive 209 4 97 avlNodeObj>
|
   findNextAVLNode: avlKeyObj in: avlRootNode function: funcObj
      ^ <primitive 209 4 98 avlRootNode avlKeyObj funcObj>
|
   findFirstAVLNode: avlRootNode
      ^ <primitive 209 4 99 avlRootNode>
|
   findLastAVLNode: avlRootNode
      ^ <primitive 209 4 100 avlRootNode>
|
   getDefaultCompareFunction
      " Use the return from this method for funcObj in 
      * addAVLNode:to:function: method.
      "
      ^ compareFuncObj <- <primitive 209 4 103>
|
   getDefaultKeyCompareFunction
      " See WARNING above "
      ^ compareKeyFuncObj <- <primitive 209 4 104>
|
   avlNodeCompare: avlNode1 with: avlNode2
      " Note that the compare function works like strcmp() by returning
      * < 0, 0, > 0 results to define a less/equal/greater relationship.
      * However, this method can also return nil if either argument is nil.
      "
      ^ <primitive 209 4 101 avlNode1 avlNode2>
|
   avlKeyCompare: avlKey1 with: avlKey2
      " Note that the compare function works like strcmp() by returning
      * < 0, 0, > 0 results to define a less/equal/greater relationship.
      "
      ^ <primitive 209 4 102 avlKey1 avlKey2>
]

