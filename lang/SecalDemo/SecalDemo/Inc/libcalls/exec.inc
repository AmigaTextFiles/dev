pattern Supervisor(_userFunction) is
	push a5\a6;
	a5:=_userFunction;
	a6:=SysBase; jsr [a6-30];
	pop a5\a6;
endp;															# SUPERVISOR

pattern execPrivate1 is
	push a6;
	a6:=SysBase; jsr [a6-36];
	pop a6;
endp;															# EXECPRIVATE1

pattern execPrivate2 is
	push a6;
	a6:=SysBase; jsr [a6-42];
	pop a6;
endp;															# EXECPRIVATE2

pattern execPrivate3 is
	push a6;
	a6:=SysBase; jsr [a6-48];
	pop a6;
endp;															# EXECPRIVATE3

pattern execPrivate4 is
	push a6;
	a6:=SysBase; jsr [a6-54];
	pop a6;
endp;															# EXECPRIVATE4

pattern execPrivate5 is
	push a6;
	a6:=SysBase; jsr [a6-60];
	pop a6;
endp;															# EXECPRIVATE5

pattern execPrivate6 is
	push a6;
	a6:=SysBase; jsr [a6-66];
	pop a6;
endp;															# EXECPRIVATE6

pattern InitCode(_startClass,_version) is
	push a6;
	safe d0.l:=_startClass; d1.l:=_version;;
	a6:=SysBase; jsr [a6-72];
	pop a6;
endp;															# INITCODE

pattern InitStruct(_initTable,_memory,_size) is
	push a2\a6;
	safe a1:=_initTable; a2:=_memory; d0.l:=_size;;
	a6:=SysBase; jsr [a6-78];
	pop a2\a6;
endp;															# INITSTRUCT

pattern MakeLibrary(_funcInit,_structInit,_libInit,_dataSize,_segList) is
	push a2\a6;
	safe a0:=_funcInit; a1:=_structInit; a2:=_libInit; d0.l:=_dataSize; d1.l:=_segList;;
	a6:=SysBase; jsr [a6-84];
	pop a2\a6;
endp;															# MAKELIBRARY

pattern MakeFunctions(_target,_functionArray,_funcDispBase) is
	push a2\a6;
	safe a0:=_target; a1:=_functionArray; a2:=_funcDispBase;;
	a6:=SysBase; jsr [a6-90];
	pop a2\a6;
endp;															# MAKEFUNCTIONS

pattern FindResident(_name) is
	push a6;
	a1:=_name;
	a6:=SysBase; jsr [a6-96];
	pop a6;
endp;															# FINDRESIDENT

pattern InitResident(_resident,_segList) is
	push a6;
	safe a1:=_resident; d1.l:=_segList;;
	a6:=SysBase; jsr [a6-102];
	pop a6;
endp;															# INITRESIDENT

pattern Alert(_alertNum) is
	push d7\a6;
	d7.l:=_alertNum;
	a6:=SysBase; jsr [a6-108];
	pop d7\a6;
endp;															# ALERT

pattern Debug(_flags) is
	push a6;
	d0.l:=_flags;
	a6:=SysBase; jsr [a6-114];
	pop a6;
endp;															# DEBUG

pattern Disable is
	push a6;
	a6:=SysBase; jsr [a6-120];
	pop a6;
endp;															# DISABLE

pattern Enable is
	push a6;
	a6:=SysBase; jsr [a6-126];
	pop a6;
endp;															# ENABLE

pattern Forbid is
	push a6;
	a6:=SysBase; jsr [a6-132];
	pop a6;
endp;															# FORBID

pattern Permit is
	push a6;
	a6:=SysBase; jsr [a6-138];
	pop a6;
endp;															# PERMIT

pattern SetSR(_newSR,_mask) is
	push a6;
	safe d0.l:=_newSR; d1.l:=_mask;;
	a6:=SysBase; jsr [a6-144];
	pop a6;
endp;															# SETSR

pattern SuperState is
	push a6;
	a6:=SysBase; jsr [a6-150];
	pop a6;
endp;															# SUPERSTATE

pattern UserState(_sysStack) is
	push a6;
	d0.l:=_sysStack;
	a6:=SysBase; jsr [a6-156];
	pop a6;
endp;															# USERSTATE

pattern SetIntVector(_intNumber,_interrupt) is
	push a6;
	safe d0.l:=_intNumber; a1:=_interrupt;;
	a6:=SysBase; jsr [a6-162];
	pop a6;
endp;															# SETINTVECTOR

pattern AddIntServer(_intNumber,_interrupt) is
	push a6;
	safe d0.l:=_intNumber; a1:=_interrupt;;
	a6:=SysBase; jsr [a6-168];
	pop a6;
endp;															# ADDINTSERVER

pattern RemIntServer(_intNumber,_interrupt) is
	push a6;
	safe d0.l:=_intNumber; a1:=_interrupt;;
	a6:=SysBase; jsr [a6-174];
	pop a6;
endp;															# REMINTSERVER

pattern Cause(_interrupt) is
	push a6;
	a1:=_interrupt;
	a6:=SysBase; jsr [a6-180];
	pop a6;
endp;															# CAUSE

pattern Allocate(_freeList,_byteSize) is
	push a6;
	safe a0:=_freeList; d0.l:=_byteSize;;
	a6:=SysBase; jsr [a6-186];
	pop a6;
endp;															# ALLOCATE

pattern Deallocate(_freeList,_memoryBlock,_byteSize) is
	push a6;
	safe a0:=_freeList; a1:=_memoryBlock; d0.l:=_byteSize;;
	a6:=SysBase; jsr [a6-192];
	pop a6;
endp;															# DEALLOCATE

pattern AllocMem(_byteSize,_requirements) is
	push a6;
	safe d0.l:=_byteSize; d1.l:=_requirements;;
	a6:=SysBase; jsr [a6-198];
	pop a6;
endp;															# ALLOCMEM

pattern AllocAbs(_byteSize,_location) is
	push a6;
	safe d0.l:=_byteSize; a1:=_location;;
	a6:=SysBase; jsr [a6-204];
	pop a6;
endp;															# ALLOCABS

pattern FreeMem(_memoryBlock,_byteSize) is
	push a6;
	safe a1:=_memoryBlock; d0.l:=_byteSize;;
	a6:=SysBase; jsr [a6-210];
	pop a6;
endp;															# FREEMEM

pattern AvailMem(_requirements) is
	push a6;
	d1.l:=_requirements;
	a6:=SysBase; jsr [a6-216];
	pop a6;
endp;															# AVAILMEM

pattern AllocEntry(_entry) is
	push a6;
	a0:=_entry;
	a6:=SysBase; jsr [a6-222];
	pop a6;
endp;															# ALLOCENTRY

pattern FreeEntry(_entry) is
	push a6;
	a0:=_entry;
	a6:=SysBase; jsr [a6-228];
	pop a6;
endp;															# FREEENTRY

pattern Insert(_list,_node,_pred) is
	push a2\a6;
	safe a0:=_list; a1:=_node; a2:=_pred;;
	a6:=SysBase; jsr [a6-234];
	pop a2\a6;
endp;															# INSERT

pattern AddHead(_list,_node) is
	push a6;
	safe a0:=_list; a1:=_node;;
	a6:=SysBase; jsr [a6-240];
	pop a6;
endp;															# ADDHEAD

pattern AddTail(_list,_node) is
	push a6;
	safe a0:=_list; a1:=_node;;
	a6:=SysBase; jsr [a6-246];
	pop a6;
endp;															# ADDTAIL

pattern Remove(_node) is
	push a6;
	a1:=_node;
	a6:=SysBase; jsr [a6-252];
	pop a6;
endp;															# REMOVE

pattern RemHead(_list) is
	push a6;
	a0:=_list;
	a6:=SysBase; jsr [a6-258];
	pop a6;
endp;															# REMHEAD

pattern RemTail(_list) is
	push a6;
	a0:=_list;
	a6:=SysBase; jsr [a6-264];
	pop a6;
endp;															# REMTAIL

pattern Enqueue(_list,_node) is
	push a6;
	safe a0:=_list; a1:=_node;;
	a6:=SysBase; jsr [a6-270];
	pop a6;
endp;															# ENQUEUE

pattern FindName(_list,_name) is
	push a6;
	safe a0:=_list; a1:=_name;;
	a6:=SysBase; jsr [a6-276];
	pop a6;
endp;															# FINDNAME

pattern AddTask(_task,_initPC,_finalPC) is
	push a2\a3\a6;
	safe a1:=_task; a2:=_initPC; a3:=_finalPC;;
	a6:=SysBase; jsr [a6-282];
	pop a2\a3\a6;
endp;															# ADDTASK

pattern RemTask(_task) is
	push a6;
	a1:=_task;
	a6:=SysBase; jsr [a6-288];
	pop a6;
endp;															# REMTASK

pattern FindTask(_name) is
	push a6;
	a1:=_name;
	a6:=SysBase; jsr [a6-294];
	pop a6;
endp;															# FINDTASK

pattern SetTaskPri(_task,_priority) is
	push a6;
	safe a1:=_task; d0.l:=_priority;;
	a6:=SysBase; jsr [a6-300];
	pop a6;
endp;															# SETTASKPRI

pattern SetSignal(_newSignals,_signalSet) is
	push a6;
	safe d0.l:=_newSignals; d1.l:=_signalSet;;
	a6:=SysBase; jsr [a6-306];
	pop a6;
endp;															# SETSIGNAL

pattern SetExcept(_newSignals,_signalSet) is
	push a6;
	safe d0.l:=_newSignals; d1.l:=_signalSet;;
	a6:=SysBase; jsr [a6-312];
	pop a6;
endp;															# SETEXCEPT

pattern Wait(_signalSet) is
	push a6;
	d0.l:=_signalSet;
	a6:=SysBase; jsr [a6-318];
	pop a6;
endp;															# WAIT

pattern Signal(_task,_signalSet) is
	push a6;
	safe a1:=_task; d0.l:=_signalSet;;
	a6:=SysBase; jsr [a6-324];
	pop a6;
endp;															# SIGNAL

pattern AllocSignal(_signalNum) is
	push a6;
	d0.l:=_signalNum;
	a6:=SysBase; jsr [a6-330];
	pop a6;
endp;															# ALLOCSIGNAL

pattern FreeSignal(_signalNum) is
	push a6;
	d0.l:=_signalNum;
	a6:=SysBase; jsr [a6-336];
	pop a6;
endp;															# FREESIGNAL

pattern AllocTrap(_trapNum) is
	push a6;
	d0.l:=_trapNum;
	a6:=SysBase; jsr [a6-342];
	pop a6;
endp;															# ALLOCTRAP

pattern FreeTrap(_trapNum) is
	push a6;
	d0.l:=_trapNum;
	a6:=SysBase; jsr [a6-348];
	pop a6;
endp;															# FREETRAP

pattern AddPort(_port) is
	push a6;
	a1:=_port;
	a6:=SysBase; jsr [a6-354];
	pop a6;
endp;															# ADDPORT

pattern RemPort(_port) is
	push a6;
	a1:=_port;
	a6:=SysBase; jsr [a6-360];
	pop a6;
endp;															# REMPORT

pattern PutMsg(_port,_message) is
	push a6;
	safe a0:=_port; a1:=_message;;
	a6:=SysBase; jsr [a6-366];
	pop a6;
endp;															# PUTMSG

pattern GetMsg(_port) is
	push a6;
	a0:=_port;
	a6:=SysBase; jsr [a6-372];
	pop a6;
endp;															# GETMSG

pattern ReplyMsg(_message) is
	push a6;
	a1:=_message;
	a6:=SysBase; jsr [a6-378];
	pop a6;
endp;															# REPLYMSG

pattern WaitPort(_port) is
	push a6;
	a0:=_port;
	a6:=SysBase; jsr [a6-384];
	pop a6;
endp;															# WAITPORT

pattern FindPort(_name) is
	push a6;
	a1:=_name;
	a6:=SysBase; jsr [a6-390];
	pop a6;
endp;															# FINDPORT

pattern AddLibrary(_library) is
	push a6;
	a1:=_library;
	a6:=SysBase; jsr [a6-396];
	pop a6;
endp;															# ADDLIBRARY

pattern RemLibrary(_library) is
	push a6;
	a1:=_library;
	a6:=SysBase; jsr [a6-402];
	pop a6;
endp;															# REMLIBRARY

pattern OldOpenLibrary(_libName) is
	push a6;
	a1:=_libName;
	a6:=SysBase; jsr [a6-408];
	pop a6;
endp;															# OLDOPENLIBRARY

pattern CloseLibrary(_library) is
	push a6;
	a1:=_library;
	a6:=SysBase; jsr [a6-414];
	pop a6;
endp;															# CLOSELIBRARY

pattern SetFunction(_library,_funcOffset,_newFunction) is
	push a6;
	safe a1:=_library; a0:=_funcOffset; d0.l:=_newFunction;;
	a6:=SysBase; jsr [a6-420];
	pop a6;
endp;															# SETFUNCTION

pattern SumLibrary(_library) is
	push a6;
	a1:=_library;
	a6:=SysBase; jsr [a6-426];
	pop a6;
endp;															# SUMLIBRARY

pattern AddDevice(_device) is
	push a6;
	a1:=_device;
	a6:=SysBase; jsr [a6-432];
	pop a6;
endp;															# ADDDEVICE

pattern RemDevice(_device) is
	push a6;
	a1:=_device;
	a6:=SysBase; jsr [a6-438];
	pop a6;
endp;															# REMDEVICE

pattern OpenDevice(_devName,_unit,_ioRequest,_flags) is
	push a6;
	safe a0:=_devName; d0.l:=_unit; a1:=_ioRequest; d1.l:=_flags;;
	a6:=SysBase; jsr [a6-444];
	pop a6;
endp;															# OPENDEVICE

pattern CloseDevice(_ioRequest) is
	push a6;
	a1:=_ioRequest;
	a6:=SysBase; jsr [a6-450];
	pop a6;
endp;															# CLOSEDEVICE

pattern DoIO(_ioRequest) is
	push a6;
	a1:=_ioRequest;
	a6:=SysBase; jsr [a6-456];
	pop a6;
endp;															# DOIO

pattern SendIO(_ioRequest) is
	push a6;
	a1:=_ioRequest;
	a6:=SysBase; jsr [a6-462];
	pop a6;
endp;															# SENDIO

pattern CheckIO(_ioRequest) is
	push a6;
	a1:=_ioRequest;
	a6:=SysBase; jsr [a6-468];
	pop a6;
endp;															# CHECKIO

pattern WaitIO(_ioRequest) is
	push a6;
	a1:=_ioRequest;
	a6:=SysBase; jsr [a6-474];
	pop a6;
endp;															# WAITIO

pattern AbortIO(_ioRequest) is
	push a6;
	a1:=_ioRequest;
	a6:=SysBase; jsr [a6-480];
	pop a6;
endp;															# ABORTIO

pattern AddResource(_resource) is
	push a6;
	a1:=_resource;
	a6:=SysBase; jsr [a6-486];
	pop a6;
endp;															# ADDRESOURCE

pattern RemResource(_resource) is
	push a6;
	a1:=_resource;
	a6:=SysBase; jsr [a6-492];
	pop a6;
endp;															# REMRESOURCE

pattern OpenResource(_resName) is
	push a6;
	a1:=_resName;
	a6:=SysBase; jsr [a6-498];
	pop a6;
endp;															# OPENRESOURCE

pattern execPrivate7 is
	push a6;
	a6:=SysBase; jsr [a6-504];
	pop a6;
endp;															# EXECPRIVATE7

pattern execPrivate8 is
	push a6;
	a6:=SysBase; jsr [a6-510];
	pop a6;
endp;															# EXECPRIVATE8

pattern execPrivate9 is
	push a6;
	a6:=SysBase; jsr [a6-516];
	pop a6;
endp;															# EXECPRIVATE9

pattern RawDoFmt(_formatString,_dataStream,_putChProc,_putChData) is
	push a2\a3\a6;
	safe a0:=_formatString; a1:=_dataStream; a2:=_putChProc; a3:=_putChData;;
	a6:=SysBase; jsr [a6-522];
	pop a2\a3\a6;
endp;															# RAWDOFMT

pattern GetCC is
	push a6;
	a6:=SysBase; jsr [a6-528];
	pop a6;
endp;															# GETCC

pattern TypeOfMem(_address) is
	push a6;
	a1:=_address;
	a6:=SysBase; jsr [a6-534];
	pop a6;
endp;															# TYPEOFMEM

pattern Procure(_sigSem,_bidMsg) is
	push a6;
	safe a0:=_sigSem; a1:=_bidMsg;;
	a6:=SysBase; jsr [a6-540];
	pop a6;
endp;															# PROCURE

pattern Vacate(_sigSem,_bidMsg) is
	push a6;
	safe a0:=_sigSem; a1:=_bidMsg;;
	a6:=SysBase; jsr [a6-546];
	pop a6;
endp;															# VACATE

pattern OpenLibrary(_libName,_version) is
	push a6;
	safe a1:=_libName; d0.l:=_version;;
	a6:=SysBase; jsr [a6-552];
	pop a6;
endp;															# OPENLIBRARY

pattern InitSemaphore(_sigSem) is
	push a6;
	a0:=_sigSem;
	a6:=SysBase; jsr [a6-558];
	pop a6;
endp;															# INITSEMAPHORE

pattern ObtainSemaphore(_sigSem) is
	push a6;
	a0:=_sigSem;
	a6:=SysBase; jsr [a6-564];
	pop a6;
endp;															# OBTAINSEMAPHORE

pattern ReleaseSemaphore(_sigSem) is
	push a6;
	a0:=_sigSem;
	a6:=SysBase; jsr [a6-570];
	pop a6;
endp;															# RELEASESEMAPHORE

pattern AttemptSemaphore(_sigSem) is
	push a6;
	a0:=_sigSem;
	a6:=SysBase; jsr [a6-576];
	pop a6;
endp;															# ATTEMPTSEMAPHORE

pattern ObtainSemaphoreList(_sigSem) is
	push a6;
	a0:=_sigSem;
	a6:=SysBase; jsr [a6-582];
	pop a6;
endp;															# OBTAINSEMAPHORELIST

pattern ReleaseSemaphoreList(_sigSem) is
	push a6;
	a0:=_sigSem;
	a6:=SysBase; jsr [a6-588];
	pop a6;
endp;															# RELEASESEMAPHORELIST

pattern FindSemaphore(_sigSem) is
	push a6;
	a1:=_sigSem;
	a6:=SysBase; jsr [a6-594];
	pop a6;
endp;															# FINDSEMAPHORE

pattern AddSemaphore(_sigSem) is
	push a6;
	a1:=_sigSem;
	a6:=SysBase; jsr [a6-600];
	pop a6;
endp;															# ADDSEMAPHORE

pattern RemSemaphore(_sigSem) is
	push a6;
	a1:=_sigSem;
	a6:=SysBase; jsr [a6-606];
	pop a6;
endp;															# REMSEMAPHORE

pattern SumKickData is
	push a6;
	a6:=SysBase; jsr [a6-612];
	pop a6;
endp;															# SUMKICKDATA

pattern AddMemList(_size,_attributes,_pri,_base,_name) is
	push d2\a6;
	safe d0.l:=_size; d1.l:=_attributes; d2.l:=_pri; a0:=_base; a1:=_name;;
	a6:=SysBase; jsr [a6-618];
	pop d2\a6;
endp;															# ADDMEMLIST

pattern CopyMem(_source,_dest,_size) is
	push a6;
	safe a0:=_source; a1:=_dest; d0.l:=_size;;
	a6:=SysBase; jsr [a6-624];
	pop a6;
endp;															# COPYMEM

pattern CopyMemQuick(_source,_dest,_size) is
	push a6;
	safe a0:=_source; a1:=_dest; d0.l:=_size;;
	a6:=SysBase; jsr [a6-630];
	pop a6;
endp;															# COPYMEMQUICK

pattern CacheClearU is
	push a6;
	a6:=SysBase; jsr [a6-636];
	pop a6;
endp;															# CACHECLEARU

pattern CacheClearE(_address,_length,_caches) is
	push a6;
	safe a0:=_address; d0.l:=_length; d1.l:=_caches;;
	a6:=SysBase; jsr [a6-642];
	pop a6;
endp;															# CACHECLEARE

pattern CacheControl(_cacheBits,_cacheMask) is
	push a6;
	safe d0.l:=_cacheBits; d1.l:=_cacheMask;;
	a6:=SysBase; jsr [a6-648];
	pop a6;
endp;															# CACHECONTROL

pattern CreateIORequest(_port,_size) is
	push a6;
	safe a0:=_port; d0.l:=_size;;
	a6:=SysBase; jsr [a6-654];
	pop a6;
endp;															# CREATEIOREQUEST

pattern DeleteIORequest(_iorequest) is
	push a6;
	a0:=_iorequest;
	a6:=SysBase; jsr [a6-660];
	pop a6;
endp;															# DELETEIOREQUEST

pattern CreateMsgPort is
	push a6;
	a6:=SysBase; jsr [a6-666];
	pop a6;
endp;															# CREATEMSGPORT

pattern DeleteMsgPort(_port) is
	push a6;
	a0:=_port;
	a6:=SysBase; jsr [a6-672];
	pop a6;
endp;															# DELETEMSGPORT

pattern ObtainSemaphoreShared(_sigSem) is
	push a6;
	a0:=_sigSem;
	a6:=SysBase; jsr [a6-678];
	pop a6;
endp;															# OBTAINSEMAPHORESHARED

pattern AllocVec(_byteSize,_requirements) is
	push a6;
	safe d0.l:=_byteSize; d1.l:=_requirements;;
	a6:=SysBase; jsr [a6-684];
	pop a6;
endp;															# ALLOCVEC

pattern FreeVec(_memoryBlock) is
	push a6;
	a1:=_memoryBlock;
	a6:=SysBase; jsr [a6-690];
	pop a6;
endp;															# FREEVEC

pattern CreatePool(_requirements,_puddleSize,_threshSize) is
	push d2\a6;
	safe d0.l:=_requirements; d1.l:=_puddleSize; d2.l:=_threshSize;;
	a6:=SysBase; jsr [a6-696];
	pop d2\a6;
endp;															# CREATEPOOL

pattern DeletePool(_poolHeader) is
	push a6;
	a0:=_poolHeader;
	a6:=SysBase; jsr [a6-702];
	pop a6;
endp;															# DELETEPOOL

pattern AllocPooled(_poolHeader,_memSize) is
	push a6;
	safe a0:=_poolHeader; d0.l:=_memSize;;
	a6:=SysBase; jsr [a6-708];
	pop a6;
endp;															# ALLOCPOOLED

pattern FreePooled(_poolHeader,_memory,_memSize) is
	push a6;
	safe a0:=_poolHeader; a1:=_memory; d0.l:=_memSize;;
	a6:=SysBase; jsr [a6-714];
	pop a6;
endp;															# FREEPOOLED

pattern AttemptSemaphoreShared(_sigSem) is
	push a6;
	a0:=_sigSem;
	a6:=SysBase; jsr [a6-720];
	pop a6;
endp;															# ATTEMPTSEMAPHORESHARED

pattern ColdReboot is
	push a6;
	a6:=SysBase; jsr [a6-726];
	pop a6;
endp;															# COLDREBOOT

pattern StackSwap(_newStack) is
	push a6;
	a0:=_newStack;
	a6:=SysBase; jsr [a6-732];
	pop a6;
endp;															# STACKSWAP

pattern ChildFree(_tid) is
	push a6;
	d0.l:=_tid;
	a6:=SysBase; jsr [a6-738];
	pop a6;
endp;															# CHILDFREE

pattern ChildOrphan(_tid) is
	push a6;
	d0.l:=_tid;
	a6:=SysBase; jsr [a6-744];
	pop a6;
endp;															# CHILDORPHAN

pattern ChildStatus(_tid) is
	push a6;
	d0.l:=_tid;
	a6:=SysBase; jsr [a6-750];
	pop a6;
endp;															# CHILDSTATUS

pattern ChildWait(_tid) is
	push a6;
	d0.l:=_tid;
	a6:=SysBase; jsr [a6-756];
	pop a6;
endp;															# CHILDWAIT

pattern CachePreDMA(_address,_length,_flags) is
	push a6;
	safe a0:=_address; a1:=_length; d0.l:=_flags;;
	a6:=SysBase; jsr [a6-762];
	pop a6;
endp;															# CACHEPREDMA

pattern CachePostDMA(_address,_length,_flags) is
	push a6;
	safe a0:=_address; a1:=_length; d0.l:=_flags;;
	a6:=SysBase; jsr [a6-768];
	pop a6;
endp;															# CACHEPOSTDMA

pattern AddMemHandler(_memhand) is
	push a6;
	a1:=_memhand;
	a6:=SysBase; jsr [a6-774];
	pop a6;
endp;															# ADDMEMHANDLER

pattern RemMemHandler(_memhand) is
	push a6;
	a1:=_memhand;
	a6:=SysBase; jsr [a6-780];
	pop a6;
endp;															# REMMEMHANDLER

pattern ObtainQuickVector(_interruptCode) is
	push a6;
	a0:=_interruptCode;
	a6:=SysBase; jsr [a6-786];
	pop a6;
endp;															# OBTAINQUICKVECTOR

pattern execPrivate10 is
	push a6;
	a6:=SysBase; jsr [a6-792];
	pop a6;
endp;															# EXECPRIVATE10

pattern execPrivate11 is
	push a6;
	a6:=SysBase; jsr [a6-798];
	pop a6;
endp;															# EXECPRIVATE11

pattern execPrivate12 is
	push a6;
	a6:=SysBase; jsr [a6-804];
	pop a6;
endp;															# EXECPRIVATE12

pattern execPrivate13 is
	push a6;
	a6:=SysBase; jsr [a6-810];
	pop a6;
endp;															# EXECPRIVATE13

pattern execPrivate14 is
	push a6;
	a6:=SysBase; jsr [a6-816];
	pop a6;
endp;															# EXECPRIVATE14

pattern execPrivate15 is
	push a6;
	a6:=SysBase; jsr [a6-822];
	pop a6;
endp;															# EXECPRIVATE15

