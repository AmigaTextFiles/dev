OPT MODULE
OPT EXPORT
OPT NODEFMODS

-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> ------ misc ---------------------------------------------------------
MACRO Supervisor(userFunction) IS ASM ' movem.l d2-d7/a2-a5,-(a7)' BUT Stores(execbase,userFunction) BUT Loads(A6,A5) BUT ASM ' jsr -30(a6)' BUT ASM ' movem.l (a7)+, d2-d7/a2-a5'
-> ------ special patchable hooks to internal exec activity ------------
-> ------ module creation ----------------------------------------------
MACRO InitCode(startClass,version) IS Stores(execbase,startClass,version) BUT Loads(A6,D0,D1) BUT ASM ' jsr -72(a6)'
MACRO InitStruct(initTable,memory,size) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(execbase,initTable,memory,size) BUT Loads(A6,A1,A2,D0) BUT ASM ' jsr -78(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO MakeLibrary(funcInit,structInit,libInit,dataSize,segList) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(execbase,funcInit,structInit,libInit,dataSize,segList) BUT Loads(A6,A0,A1,A2,D0,D1) BUT ASM ' jsr -84(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO MakeFunctions(target,functionArray,funcDispBase) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(execbase,target,functionArray,funcDispBase) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -90(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO FindResident(name) IS (A1:=name) BUT (A6:=execbase) BUT ASM ' jsr -96(a6)'
MACRO InitResident(resident,segList) IS Stores(execbase,resident,segList) BUT Loads(A6,A1,D1) BUT ASM ' jsr -102(a6)'
-> ------ diagnostics --------------------------------------------------
MACRO Alert(alertNum) IS ASM ' movem.l d2-d7/a2-a5,-(a7)' BUT Stores(execbase,alertNum) BUT Loads(A6,D7) BUT ASM ' jsr -108(a6)' BUT ASM ' movem.l (a7)+, d2-d7/a2-a5'
MACRO Debug(flags) IS (D0:=flags) BUT (A6:=execbase) BUT ASM ' jsr -114(a6)'
-> ------ interrupts ---------------------------------------------------
MACRO Disable() IS (A6:=execbase) BUT ASM ' jsr -120(a6)'
MACRO Enable() IS (A6:=execbase) BUT ASM ' jsr -126(a6)'
MACRO Forbid() IS (A6:=execbase) BUT ASM ' jsr -132(a6)'
MACRO Permit() IS (A6:=execbase) BUT ASM ' jsr -138(a6)'
MACRO SetSR(newSR,mask) IS Stores(execbase,newSR,mask) BUT Loads(A6,D0,D1) BUT ASM ' jsr -144(a6)'
MACRO SuperState() IS (A6:=execbase) BUT ASM ' jsr -150(a6)'
MACRO UserState(sysStack) IS (D0:=sysStack) BUT (A6:=execbase) BUT ASM ' jsr -156(a6)'
MACRO SetIntVector(intNumber,interrupt) IS Stores(execbase,intNumber,interrupt) BUT Loads(A6,D0,A1) BUT ASM ' jsr -162(a6)'
MACRO AddIntServer(intNumber,interrupt) IS Stores(execbase,intNumber,interrupt) BUT Loads(A6,D0,A1) BUT ASM ' jsr -168(a6)'
MACRO RemIntServer(intNumber,interrupt) IS Stores(execbase,intNumber,interrupt) BUT Loads(A6,D0,A1) BUT ASM ' jsr -174(a6)'
MACRO Cause(interrupt) IS (A1:=interrupt) BUT (A6:=execbase) BUT ASM ' jsr -180(a6)'
-> ------ memory allocation --------------------------------------------
MACRO Allocate(freeList,byteSize) IS Stores(execbase,freeList,byteSize) BUT Loads(A6,A0,D0) BUT ASM ' jsr -186(a6)'
MACRO Deallocate(freeList,memoryBlock,byteSize) IS Stores(execbase,freeList,memoryBlock,byteSize) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -192(a6)'
MACRO AllocMem(byteSize,requirements) IS Stores(execbase,byteSize,requirements) BUT Loads(A6,D0,D1) BUT ASM ' jsr -198(a6)'
MACRO AllocAbs(byteSize,location) IS Stores(execbase,byteSize,location) BUT Loads(A6,D0,A1) BUT ASM ' jsr -204(a6)'
MACRO FreeMem(memoryBlock,byteSize) IS Stores(execbase,memoryBlock,byteSize) BUT Loads(A6,A1,D0) BUT ASM ' jsr -210(a6)'
MACRO AvailMem(requirements) IS (D1:=requirements) BUT (A6:=execbase) BUT ASM ' jsr -216(a6)'
MACRO AllocEntry(entry) IS (A0:=entry) BUT (A6:=execbase) BUT ASM ' jsr -222(a6)'
MACRO FreeEntry(entry) IS (A0:=entry) BUT (A6:=execbase) BUT ASM ' jsr -228(a6)'
-> ------ lists --------------------------------------------------------
MACRO Insert(list,node,pred) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(execbase,list,node,pred) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -234(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO AddHead(list,node) IS Stores(execbase,list,node) BUT Loads(A6,A0,A1) BUT ASM ' jsr -240(a6)'
MACRO AddTail(list,node) IS Stores(execbase,list,node) BUT Loads(A6,A0,A1) BUT ASM ' jsr -246(a6)'
MACRO Remove(node) IS (A1:=node) BUT (A6:=execbase) BUT ASM ' jsr -252(a6)'
MACRO RemHead(list) IS (A0:=list) BUT (A6:=execbase) BUT ASM ' jsr -258(a6)'
MACRO RemTail(list) IS (A0:=list) BUT (A6:=execbase) BUT ASM ' jsr -264(a6)'
MACRO Enqueue(list,node) IS Stores(execbase,list,node) BUT Loads(A6,A0,A1) BUT ASM ' jsr -270(a6)'
MACRO FindName(list,name) IS Stores(execbase,list,name) BUT Loads(A6,A0,A1) BUT ASM ' jsr -276(a6)'
-> ------ tasks --------------------------------------------------------
MACRO AddTask(task,initPC,finalPC) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(execbase,task,initPC,finalPC) BUT Loads(A6,A1,A2,A3) BUT ASM ' jsr -282(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO RemTask(task) IS (A1:=task) BUT (A6:=execbase) BUT ASM ' jsr -288(a6)'
MACRO FindTask(name) IS (A1:=name) BUT (A6:=execbase) BUT ASM ' jsr -294(a6)'
MACRO SetTaskPri(task,priority) IS Stores(execbase,task,priority) BUT Loads(A6,A1,D0) BUT ASM ' jsr -300(a6)'
MACRO SetSignal(newSignals,signalSet) IS Stores(execbase,newSignals,signalSet) BUT Loads(A6,D0,D1) BUT ASM ' jsr -306(a6)'
MACRO SetExcept(newSignals,signalSet) IS Stores(execbase,newSignals,signalSet) BUT Loads(A6,D0,D1) BUT ASM ' jsr -312(a6)'
MACRO Wait(signalSet) IS (D0:=signalSet) BUT (A6:=execbase) BUT ASM ' jsr -318(a6)'
MACRO Signal(task,signalSet) IS Stores(execbase,task,signalSet) BUT Loads(A6,A1,D0) BUT ASM ' jsr -324(a6)'
MACRO AllocSignal(signalNum) IS (D0:=signalNum) BUT (A6:=execbase) BUT ASM ' jsr -330(a6)'
MACRO FreeSignal(signalNum) IS (D0:=signalNum) BUT (A6:=execbase) BUT ASM ' jsr -336(a6)'
MACRO AllocTrap(trapNum) IS (D0:=trapNum) BUT (A6:=execbase) BUT ASM ' jsr -342(a6)'
MACRO FreeTrap(trapNum) IS (D0:=trapNum) BUT (A6:=execbase) BUT ASM ' jsr -348(a6)'
-> ------ messages -----------------------------------------------------
MACRO AddPort(port) IS (A1:=port) BUT (A6:=execbase) BUT ASM ' jsr -354(a6)'
MACRO RemPort(port) IS (A1:=port) BUT (A6:=execbase) BUT ASM ' jsr -360(a6)'
MACRO PutMsg(port,message) IS Stores(execbase,port,message) BUT Loads(A6,A0,A1) BUT ASM ' jsr -366(a6)'
MACRO GetMsg(port) IS (A0:=port) BUT (A6:=execbase) BUT ASM ' jsr -372(a6)'
MACRO ReplyMsg(message) IS (A1:=message) BUT (A6:=execbase) BUT ASM ' jsr -378(a6)'
MACRO WaitPort(port) IS (A0:=port) BUT (A6:=execbase) BUT ASM ' jsr -384(a6)'
MACRO FindPort(name) IS (A1:=name) BUT (A6:=execbase) BUT ASM ' jsr -390(a6)'
-> ------ libraries ----------------------------------------------------
MACRO AddLibrary(library) IS (A1:=library) BUT (A6:=execbase) BUT ASM ' jsr -396(a6)'
MACRO RemLibrary(library) IS (A1:=library) BUT (A6:=execbase) BUT ASM ' jsr -402(a6)'
MACRO OldOpenLibrary(libName) IS (A1:=libName) BUT (A6:=execbase) BUT ASM ' jsr -408(a6)'
MACRO CloseLibrary(library) IS (A1:=library) BUT (A6:=execbase) BUT ASM ' jsr -414(a6)'
MACRO SetFunction(library,funcOffset,newFunction) IS Stores(execbase,library,funcOffset,newFunction) BUT Loads(A6,A1,A0,D0) BUT ASM ' jsr -420(a6)'
MACRO SumLibrary(library) IS (A1:=library) BUT (A6:=execbase) BUT ASM ' jsr -426(a6)'
-> ------ devices ------------------------------------------------------
MACRO AddDevice(device) IS (A1:=device) BUT (A6:=execbase) BUT ASM ' jsr -432(a6)'
MACRO RemDevice(device) IS (A1:=device) BUT (A6:=execbase) BUT ASM ' jsr -438(a6)'
MACRO OpenDevice(devName,unit,ioRequest,flags) IS Stores(execbase,devName,unit,ioRequest,flags) BUT Loads(A6,A0,D0,A1,D1) BUT ASM ' jsr -444(a6)'
MACRO CloseDevice(ioRequest) IS (A1:=ioRequest) BUT (A6:=execbase) BUT ASM ' jsr -450(a6)'
MACRO DoIO(ioRequest) IS (A1:=ioRequest) BUT (A6:=execbase) BUT ASM ' jsr -456(a6)'
MACRO SendIO(ioRequest) IS (A1:=ioRequest) BUT (A6:=execbase) BUT ASM ' jsr -462(a6)'
MACRO CheckIO(ioRequest) IS (A1:=ioRequest) BUT (A6:=execbase) BUT ASM ' jsr -468(a6)'
MACRO WaitIO(ioRequest) IS (A1:=ioRequest) BUT (A6:=execbase) BUT ASM ' jsr -474(a6)'
MACRO AbortIO(ioRequest) IS (A1:=ioRequest) BUT (A6:=execbase) BUT ASM ' jsr -480(a6)'
-> ------ resources ----------------------------------------------------
MACRO AddResource(resource) IS (A1:=resource) BUT (A6:=execbase) BUT ASM ' jsr -486(a6)'
MACRO RemResource(resource) IS (A1:=resource) BUT (A6:=execbase) BUT ASM ' jsr -492(a6)'
MACRO OpenResource(resName) IS (A1:=resName) BUT (A6:=execbase) BUT ASM ' jsr -498(a6)'
-> ------ private diagnostic support -----------------------------------
-> ------ misc ---------------------------------------------------------
MACRO RawDoFmt(formatString,dataStream,putChProc,putChData) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(execbase,formatString,dataStream,putChProc,putChData) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -522(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO GetCC() IS (A6:=execbase) BUT ASM ' jsr -528(a6)'
MACRO TypeOfMem(address) IS (A1:=address) BUT (A6:=execbase) BUT ASM ' jsr -534(a6)'
MACRO Procure(sigSem,bidMsg) IS Stores(execbase,sigSem,bidMsg) BUT Loads(A6,A0,A1) BUT ASM ' jsr -540(a6)'
MACRO Vacate(sigSem,bidMsg) IS Stores(execbase,sigSem,bidMsg) BUT Loads(A6,A0,A1) BUT ASM ' jsr -546(a6)'
MACRO OpenLibrary(libName,version) IS Stores(execbase,libName,version) BUT Loads(A6,A1,D0) BUT ASM ' jsr -552(a6)'
-> --- functions in V33 or higher (Release 1.2) ---
-> ------ signal semaphores (note funny registers)----------------------
MACRO InitSemaphore(sigSem) IS (A0:=sigSem) BUT (A6:=execbase) BUT ASM ' jsr -558(a6)'
MACRO ObtainSemaphore(sigSem) IS (A0:=sigSem) BUT (A6:=execbase) BUT ASM ' jsr -564(a6)'
MACRO ReleaseSemaphore(sigSem) IS (A0:=sigSem) BUT (A6:=execbase) BUT ASM ' jsr -570(a6)'
MACRO AttemptSemaphore(sigSem) IS (A0:=sigSem) BUT (A6:=execbase) BUT ASM ' jsr -576(a6)'
MACRO ObtainSemaphoreList(sigSem) IS (A0:=sigSem) BUT (A6:=execbase) BUT ASM ' jsr -582(a6)'
MACRO ReleaseSemaphoreList(sigSem) IS (A0:=sigSem) BUT (A6:=execbase) BUT ASM ' jsr -588(a6)'
MACRO FindSemaphore(sigSem) IS (A1:=sigSem) BUT (A6:=execbase) BUT ASM ' jsr -594(a6)'
MACRO AddSemaphore(sigSem) IS (A1:=sigSem) BUT (A6:=execbase) BUT ASM ' jsr -600(a6)'
MACRO RemSemaphore(sigSem) IS (A1:=sigSem) BUT (A6:=execbase) BUT ASM ' jsr -606(a6)'
-> ------ kickmem support ----------------------------------------------
MACRO SumKickData() IS (A6:=execbase) BUT ASM ' jsr -612(a6)'
-> ------ more memory support ------------------------------------------
MACRO AddMemList(size,attributes,pri,base,name) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(execbase,size,attributes,pri,base,name) BUT Loads(A6,D0,D1,D2,A0,A1) BUT ASM ' jsr -618(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO CopyMem(source,dest,size) IS Stores(execbase,source,dest,size) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -624(a6)'
MACRO CopyMemQuick(source,dest,size) IS Stores(execbase,source,dest,size) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -630(a6)'
-> ------ cache --------------------------------------------------------
-> --- functions in V36 or higher (Release 2.0) ---
MACRO CacheClearU() IS (A6:=execbase) BUT ASM ' jsr -636(a6)'
MACRO CacheClearE(address,length,caches) IS Stores(execbase,address,length,caches) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -642(a6)'
MACRO CacheControl(cacheBits,cacheMask) IS Stores(execbase,cacheBits,cacheMask) BUT Loads(A6,D0,D1) BUT ASM ' jsr -648(a6)'
-> ------ misc ---------------------------------------------------------
MACRO CreateIORequest(port,size) IS Stores(execbase,port,size) BUT Loads(A6,A0,D0) BUT ASM ' jsr -654(a6)'
MACRO DeleteIORequest(iorequest) IS (A0:=iorequest) BUT (A6:=execbase) BUT ASM ' jsr -660(a6)'
MACRO CreateMsgPort() IS (A6:=execbase) BUT ASM ' jsr -666(a6)'
MACRO DeleteMsgPort(port) IS (A0:=port) BUT (A6:=execbase) BUT ASM ' jsr -672(a6)'
MACRO ObtainSemaphoreShared(sigSem) IS (A0:=sigSem) BUT (A6:=execbase) BUT ASM ' jsr -678(a6)'
-> ------ even more memory support -------------------------------------
MACRO AllocVec(byteSize,requirements) IS Stores(execbase,byteSize,requirements) BUT Loads(A6,D0,D1) BUT ASM ' jsr -684(a6)'
MACRO FreeVec(memoryBlock) IS (A1:=memoryBlock) BUT (A6:=execbase) BUT ASM ' jsr -690(a6)'
-> ------ V39 Pool LVOs...
MACRO CreatePool(requirements,puddleSize,threshSize) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(execbase,requirements,puddleSize,threshSize) BUT Loads(A6,D0,D1,D2) BUT ASM ' jsr -696(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO DeletePool(poolHeader) IS (A0:=poolHeader) BUT (A6:=execbase) BUT ASM ' jsr -702(a6)'
MACRO AllocPooled(poolHeader,memSize) IS Stores(execbase,poolHeader,memSize) BUT Loads(A6,A0,D0) BUT ASM ' jsr -708(a6)'
MACRO FreePooled(poolHeader,memory,memSize) IS Stores(execbase,poolHeader,memory,memSize) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -714(a6)'
-> ------ misc ---------------------------------------------------------
MACRO AttemptSemaphoreShared(sigSem) IS (A0:=sigSem) BUT (A6:=execbase) BUT ASM ' jsr -720(a6)'
MACRO ColdReboot() IS (A6:=execbase) BUT ASM ' jsr -726(a6)'
MACRO StackSwap(newStack) IS (A0:=newStack) BUT (A6:=execbase) BUT ASM ' jsr -732(a6)'
-> ------ task trees ---------------------------------------------------
MACRO ChildFree(tid) IS (D0:=tid) BUT (A6:=execbase) BUT ASM ' jsr -738(a6)'
MACRO ChildOrphan(tid) IS (D0:=tid) BUT (A6:=execbase) BUT ASM ' jsr -744(a6)'
MACRO ChildStatus(tid) IS (D0:=tid) BUT (A6:=execbase) BUT ASM ' jsr -750(a6)'
MACRO ChildWait(tid) IS (D0:=tid) BUT (A6:=execbase) BUT ASM ' jsr -756(a6)'
-> ------ future expansion ---------------------------------------------
MACRO CachePreDMA(address,length,flags) IS Stores(execbase,address,length,flags) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -762(a6)'
MACRO CachePostDMA(address,length,flags) IS Stores(execbase,address,length,flags) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -768(a6)'
-> ------ New, for V39
-> --- functions in V39 or higher (Release 3) ---
-> ------ Low memory handler functions
MACRO AddMemHandler(memhand) IS (A1:=memhand) BUT (A6:=execbase) BUT ASM ' jsr -774(a6)'
MACRO RemMemHandler(memhand) IS (A1:=memhand) BUT (A6:=execbase) BUT ASM ' jsr -780(a6)'
-> ------ Function to attempt to obtain a Quick Interrupt Vector...
MACRO ObtainQuickVector(interruptCode) IS (A0:=interruptCode) BUT (A6:=execbase) BUT ASM ' jsr -786(a6)'
