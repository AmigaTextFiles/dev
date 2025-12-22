        IFND LCR_EXEC_I
LCR_EXEC_I SET 1

****************************************************************************
** Librarycall-include v1.0 written by Rasmus K. Ursem, Dreamline Designs **
** For the exec.library                                                   **
**                                                                        **
** This is an include to help assembler-programmers when accessing        **
** libraries. You probably know the situation where you just can't        **
** remember which registers a library call is using. This will aid you    **
** by the use of some logic. This include-file is build like this:        **
** All entries starts with the same as the library-calls name, e.g for    **
** dos/_LVORead() is the entries _LVORead_FH, _LVORead_Buffer and         **
** _LVORead_Size, and the result register is _LVORead_Result.             **
** An Example: Say You want to call dos/_LVORead() but cannot remember    **
** which registers is used for the input, but with some logic you guess   **
** that _LVORead() needs a Filehandle, a buffer and a size. And then it   **
** should be pretty easy to guess the names in the include.               **
****************************************************************************
** Some general names:                                                    **
** <Library-Call-Name>_Result         = the result register.              **
** <Library-Call-Name>_Result2        = the 2nd result register.          **
** <Library-Call-Name>_RFail          = the fail-value.                   **
**                                      NOTE: This is a value NOT a reg.  **
** <Library-Call-Name>_RSuccess       = the success-value.                **
**                                      NOTE: This is a value NOT a reg.  **
**                                      a call will NEVER have both fail  **
**                                      and success-values.               **      
** <Library-Call-Name>_Name           = ALWAYS a STRPTR to a name.        **
**                                      E.g. a library-name.              **
** <Library-Call-Name>_Size           = ALWAYS an ULONG size.             **
** <Library-Call-Name>_Length         = ALWAYS an ULONG size.             **
** <Library-Call-Name>_Buffer         = ALWAYS an APTR.                   **
** <Library-Call-Name>_Port           = A pointer to a msgport.           **
** <Library-Call-Name>_MsgPort        = A pointer to a msgport. Same as   **
**                                      above. If a call needs 2 ports    **
**                                      the other port will have a name   **
**                                      like <LCN>_ReplyPort. In other    **
**                                      words <LCN>_Port and              **
**                                      <LCN>_MsgPort ALWAYS refer to the **
**                                      same register.                    **
**                                                                        **
** Furthermore you can use the following to check the amount of registers **
** used in a call. (If you cannot remember how many regs a call needs.)   **
**                                                                        **
** <Library-Call-Name>_RU             = a number indicating how many regs **
**                                      this call uses for INPUT.         **
****************************************************************************
** Example of use:                                                        **
**                                                                        **
**      ...                                                               **
**      move.l  MyFileHandle,   _LVORead_FH                               **
**      move.l  MyBufferPtr,    _LVORead_Buffer                           **
**      move.l  #1000,          _LVORead_Size                             **
**      move.l  DosBase,        a6                                        **
**      jsr     _LVORead(a6)                                              **
**                                                                        **
**      cmpi.l  #_LVORead_RFail,_LVORead_Result                           **
**      beq     CouldNotRead                                              **
**      ...                                                               **
**                                                                        **
****************************************************************************

****************************************************************************
****************************************************************************
** exec.library                                                           **
****************************************************************************
****************************************************************************

*** _LVOAbortIO() ***
_LVOAbortIO_IORequest   equr    a1
_LVOAbortIO_IO          equr    a1
_LVOAbortIO_RU          = 1

*** _LVOAddDevice () ***
_LVOAddDevice_Device    equr    a1
_LVOAddDevice_RU        = 1

*** _LVOAddHead() ***
_LVOAddHead_List        equr    a0
_LVOAddHead_Node        equr    a1
_LVOAddHead_RU          = 2

*** _LVOAddIntServer() ***
_LVOAddIntServer_Number         equr    d0
_LVOAddIntServer_IntNum         equr    d0
_LVOAddIntServer_Interrupt      equr    a1
_LVOAddIntServer_RU             = 2

*** _LVOAddLibrary() ***
_LVOAddLibrary_Library  equr    a1
_LVOAddLibrary_RU       = 1

*** _LVOAddMemHandler() ***
_LVOAddMemHandler_MemHandler    equr    a1
_LVOAddMemHandler_RU            = 2

*** _LVOAddMemList() ***
_LVOLVOAddMemList_Size          equr    d0
_LVOLVOAddMemList_Attributes    equr    d1
_LVOLVOAddMemList_Att           equr    d1
_LVOLVOAddMemList_Pri           equr    d2
_LVOLVOAddMemList_Priority      equr    d2
_LVOLVOAddMemList_Base          equr    a0
_LVOLVOAddMemList_Name          equr    a1
_LVOLVOAddMemList_RU            = 5

*** _LVOAddPort() ***
_LVOAddPort_Port        equr a1
_LVOAddPort_MsgPort     equr a1
_LVOAddPort_RU          = 1

*** _LVOAddResource() ***
_LVOAddResource_Resource        equr    a1
_LVOAddResource_RU              = 1

*** _LVOAddSemaphore() ***
_LVOAddSemaphore_SignalSemaphore        equr    a1
_LVOAddSemaphore_Semaphore              equr    a1
_LVOAddSemaphore_RU                     = 1

*** _LVOAddTail() ***
_LVOAddTail_List                equr    a0
_LVOAddTail_Node                equr    a1
_LVOAddTail_RU                  = 2

*** _LVOAddTask() ***
_LVOAddTask_Task        equr a1
_LVOAddTask_InitialPC   equr a2
_LVOAddTask_initialPC   equr a2
_LVOAddTask_FinalPC     equr a3
_LVOAddTask_finalPC     equr a3
_LVOAddTask_Result      equr d0
_LVOAddTask_RU          = 3

*** _LVOAlert() ***
_LVOAlert_AlertNumber   equr    d7
_LVOAlert_AlertNum      equr    d7
_LVOAlert_Number        equr    d7
_LVOAlert_RU            = 1

*** _LVOAllocAbs() ***
_LVOAllocAbs_ByteSize   equr    d0
_LVOAllocAbs_Size       equr    d0
_LVOAllocAbs_Location   equr    a1
_LVOAllocAbs_Address    equr    a1
_LVOAllocAbs_Result     equr    d0
_LVOAllocAbs_RFail      = 0
_LVOAllocAbs_RU         = 2

*** _LVOAllocate() ***
_LVOAllocate_MemHeader  equr    a0
_LVOAllocate_ByteSize   equr    d0
_LVOAllocate_Size       equr    d0
_LVOAllocate_Result     equr    d0
_LVOAllocate_RFail      = 0
_LVOAllocate_RU         = 2

*** _LVOAllocEntry() ***
_LVOAllocEntry_MemList  equr    a0
_LVOAllocEntry_List     equr    a0
_LVOAllocEntry_Result   equr    d0
_LVOAllocEntry_RFail    = 0
_LVOAllocEntry_RU       = 1

*** _LVOAllocMem() ***
_LVOAllocMem_Size       equr d0
_LVOAllocMem_ByteSize   equr d0
_LVOAllocMem_Attributes equr d1
_LVOAllocMem_Att        equr d1
_LVOAllocMem_Requirements equr d1
_LVOAllocMem_Result     equr d0
_LVOAllocMem_RFail      = 0
_LVOAllocMem_RU         = 2

*** _LVOAllocPooled() ***
_LVOAllocPooled_PoolHeader      equr    a0
_LVOAllocPooled_Size            equr    d0
_LVOAllocPooled_MemSize         equr    d0
_LVOAllocPooled_Result          equr    d0
_LVOAllocPooled_RFail           = 0
_LVOAllocPooled_RU              = 2

*** _LVOAllocSignal() ***
_LVOAllocSignal_SignalNum       equr    d0
_LVOAllocSignal_Number          equr    d0
_LVOAllocSignal_Result          equr    d0
_LVOAllocSignal_RFail           = -1
_LVOAllocSignal_RU              = 1

*** _LVOAllocTrap() ***
_LVOAllocTrap_TrapNum           equr    d0
_LVOAllocTrap_Number            equr    d0
_LVOAllocTrap_Result            equr    d0
_LVOAllocTrap_RFail             = -1
_LVOAllocTrap_RU                = 1

***_LVOAllocVec() ***
_LVOAllocVec_Size               equr    d0
_LVOAllocVec_ByteSize           equr    d0
_LVOAllocVec_Attributes         equr    d1
_LVOAllocVec_Att                equr    d1
_LVOAllocVec_Result             equr    d0
_LVOAllocVec_RFail              = 0
_LVOAllocVec_RU                 = 2

*** _LVOAttemptSemaphore() ***
_LVOAttemptSemaphore_SignalSemaphore    equr    a0
_LVOAttemptSemaphore_Semaphore          equr    a0
_LVOAttemptSemaphore_Result             equr    d0
_LVOAttemptSemaphore_RFail              = 0
_LVOAttemptSemaphore_RU                 = 1

*** _LVOAttemptSemaphoreShared() ***
_LVOAttemptSemaphoreShared_SignalSemaphore      equr    a0
_LVOAttemptSemaphoreShared_Semaphore            equr    a0
_LVOAttemptSemaphoreShared_Result               equr    d0
_LVOAttemptSemaphoreShared_RFail                = 0
_LVOAttemptSemaphoreShared_RU                   = 1

*** _LVOAvailMem() ***
_LVOAvailMem_Attributes         equr    d1
_LVOAvailMem_Att                equr    d1
_LVOAvailMem_Result             equr    d0
_LVOAvailMem_RU                 = 1

*** _LVOCacheClearE() ***
_LVOCacheClearE_Address equr    a0
_LVOCacheClearE_Length  equr    d0
_LVOCacheClearE_Size    equr    d0
_LVOCacheClearE_Caches  equr    d1
_LVOCacheClearE_RU      = 3

*** _LVOCacheClearU() ***
_LVOCacheClearU_RU      = 0

*** _LVOCacheControl() ***
_LVOCacheControl_CacheBits      equr    d0
_LVOCacheControl_Bits           equr    d0
_LVOCacheControl_CacheMask      equr    d1
_LVOCacheControl_Mask           equr    d1
_LVOCacheControl_Result         equr    d0
_LVOCacheControl_RU             = 2

*** _LVOCachePostDMA() ***
_LVOCachePostDMA_VAddress       equr    a0
_LVOCachePostDMA_Address        equr    a0
_LVOCachePostDMA_Length         equr    a1
_LVOCachePostDMA_Size           equr    a1
_LVOCachePostDMA_Flags          equr    d0
_LVOCachePostDMA_RU             = 3

*** _LVOCachePreDMA() ***
_LVOCachePreDMA_VAddress        equr    a0
_LVOCachePreDMA_Address         equr    a0
_LVOCachePreDMA_Length          equr    a1
_LVOCachePreDMA_Size            equr    a1
_LVOCachePreDMA_Flags           equr    d0
_LVOCachePreDMA_Result          equr    d0
_LVOCachePreDMA_RU              = 3

*** _LVOCause() ***
_LVOCause_Interrupt             equr       a1
_LVOCause_RU                    = 1

*** _LVOCheckIO() ***
_LVOCheckIO_IORequest      equr a1
_LVOCheckIO_IO             equr a1
_LVOCheckIO_Result         equr d0
_LVOCheckIO_RNotFinish     = 0
_LVOCheckIO_RU             = 1

*** _LVOCloseDevice() ***
_LVOCloseDevice_IORequest       equr    a1
_LVOCloseDevice_IO              equr    a1
_LVOCloseDevice_RU              = 1

*** _LVOCloseLibrary() ***
_LVOCloseLibrary_Library        equr    a1
_LVOCloseLibrary_LibBase        equr    a1
_LVOCloseLibrary_LibraryBase    equr    a1
_LVOCloseLibrary_Base           equr    a1
_LVOCloseLibrary_RU             = 1

*** _LVOColdReboot() ***
_LVOColdReboot_RU       = 0

*** _LVOCopyMem() ***
_LVOCopyMem_Source      equr    a0
_LVOCopyMem_Dest        equr    a1
_LVOCopyMem_Destination equr    a1
_LVOCopyMem_Size        equr    d0
_LVOCopyMem_Length      equr    d0
_LVOCopyMem_RU          = 3

*** _LVOCopyMemQuick() ***
_LVOCopyMemQuick_Source         equr    a0
_LVOCopyMemQuick_Dest           equr    a1
_LVOCopyMemQuick_Destination    equr    a1
_LVOCopyMemQuick_Size           equr    d0
_LVOCopyMemQuick_Length         equr    d0
_LVOCopyMemQuick_RU             = 3

*** _LVOCreateIORequest() ***
_LVOCreateIORequest_ioReplyPort equr    a0
_LVOCreateIORequest_IOReplyPort equr    a0
_LVOCreateIORequest_Port        equr    a0
_LVOCreateIORequest_Size        equr    d0
_LVOCreateIORequest_Result      equr    d0
_LVOCreateIORequest_RFail       = 0
_LVOCreateIORequest_RU          = 2

*** _LVOCreateMsgPort() ***
_LVOCreateMsgPort_Result equr d0
_LVOCreateMsgPort_RFail = 0
_LVOCreateMsgPort_RU       = 0

*** _LVOCreatePool() ***
_LVOCreatePool_MemFlags         equr    d0
_LVOCreatePool_Flags            equr    d0
_LVOCreatePool_PuddleSize       equr    d1
_LVOCreatePool_ThreshSize       equr    d2
_LVOCreatePool_Result           equr    a0
_LVOCreatePool_RFail            = 0
_LVOCreatePool_RU               = 3

*** _LVODeallocate() ***
_LVODeallocate_MemHeader        equr    a0
_LVODeallocate_Block            equr    a1
_LVODeallocate_MemoryBlock      equr    a1
_LVODeallocate_MemBlock         equr    a1
_LVODeallocate_ByteSize         equr    d0
_LVODeallocate_Size             equr    d0
_LVODeallocate_RU               = 3

*** _LVODebug() ***
_LVODebug_Flags         equr    d0
_LVODebug_RU            = 1

*** _LVODeleteIORequest() ***
_LVODeleteIORequest_IORequest   equr    a0
_LVODeleteIORequest_IO          equr    a0
_LVODeleteIORequest_RU          = 1

*** _LVODeleteMsgPort() ***
_LVODeleteMsgPort_Port          equr a0
_LVODeleteMsgPort_MsgPort       equr a0
_LVODeleteMsgPort_RU            = 1

*** _LVODeletePool() ***
_LVODeletePool_PoolHeader       equr    a0
_LVODeletePool_Header           equr    a0
_LVODeletePool_RU               = 1

*** _LVODisable() ***
_LVODisable_RU   = 0

*** _LVODoIO() ***
_LVODoIO_IORequest      equr a1
_LVODoIO_IO             equr a1
_LVODoIO_Result         equr d0
_LVODoIO_RSuccess       = 0
_LVODoIO_RU             = 1

*** _LVOEnable() ***
_LVOEnable_RU   = 0

*** _LVOEnqueue() ***
_LVOEnqueue_List        equr    a0
_LVOEnqueue_Node        equr    a1
_LVOEnqueue_RU          = 2

*** _LVOFindName() ***
_LVOFindName_Start      equr    a0
_LVOFindName_Name       equr    a1
_LVOFindName_Result     equr    d0
_LVOFindName_RFail      = 0
_LVOFindName_RU         = 2

*** _LVOFindPort() ***
_LVOFindPort_Name       equr    a1
_LVOFindPort_Result     equr    d0
_LVOFindPort_RFail      = 0
_LVOFindPort_RU         = 1

*** _LVOFindResident() ***
_LVOFindResident_Name   equr    a1
_LVOFindResident_Result equr    d0
_LVOFindResident_RFail  = 0
_LVOFindResident_RU     = 1

*** _LVOFindSemaphore() ***
_LVOFindSemaphore_Name          equr    a1
_LVOFindSemaphore_Result        equr    d0
_LVOFindSemaphore_RFail         = 0
_LVOFindSemaphore_RU            = 1

*** _LVOFindTask() ***
_LVOFindTask_Name       equr a1
_LVOFindTask_Result     equr d0
_LVOFindTask_RFail      = 0
_LVOFindTask_ThisTask   = 0       ;Used when finding callers task-structure
_LVOFindTask_RU         = 2

*** _LVOForbid() ***
_LVOForbid_RU   = 0

*** _LVOFreeEntry() ***
_LVOFreeEntry_MemList   equr    a0
_LVOFreeEntry_List      equr    a0
_LVOFreeEntry_RU        = 1

*** _LVOFreeMem() ***
_LVOFreeMem_Size        equr d0
_LVOFreeMem_ByteSize    equr d0
_LVOFreeMem_MemoryBLock equr a1
_LVOFreeMem_Block       equr a1
_LVOFreeMem_Address     equr a1
_LVOFreeMem_RU          = 2

*** _LVOFreePooled() ***
_LVOFreePooled_PoolHeader       equr    a0
_LVOFreePooled_Header           equr    a0
_LVOFreePooled_Memory           equr    a1
_LVOFreePooled_MemSize          equr    d0
_LVOFreePooled_Size             equr    d0
_LVOFreePooled_RU               = 3

*** _LVOFreeSignal() ***
_LVOFreeSignal_SignalNum        equr    d0
_LVOFreeSignal_Signal           equr    d0
_LVOFreeSignal_Num              equr    d0
_LVOFreeSignal_RU               = 1

*** _LVOFreeTrap() ***
_LVOFreeTrap_TrapNum            equr    d0
_LVOFreeTrap_Trap               equr    d0
_LVOFreeTrap_Num                equr    d0
_LVOFreeTrap_RU                 = 2

*** _LVOFreeVec() ***
_LVOFreeVec_MemoryBlock         equr    a1
_LVOFreeVec_Memory              equr    a1
_LVOFreeVec_RU                  = 1

*** _LVOGetCC() ***
_LVOGetCC_Result        equr    d0
_LVOGetCC_RU            = 0

*** _LVOGetMsg() ***
_LVOGetMsg_Port         equr    a0
_LVOGetMsg_MsgPort      equr    a0
_LVOGetMsg_Return       equr    d0
_LVOGetMsg_RFail        = 0
_LVOGetMsg_RU           = 1

*** _LVOInitCode() ***
_LVOInitCode_StartClass equr    d0
_LVOInitCode_Class      equr    d0
_LVOInitCode_Version    equr    d1
_LVOInitCode_RU         = 2


*** _LVOInitResident() ***
_LVOInitResident_Resident       equr    a1
_LVOInitResident_SegList        equr    d1
_LVOInitResident_Result         equr    d0
_LVOInitResident_RFail          = 0
_LVOInitResident_RU             = 2

*** _LVOInitSemaphore() ***
_LVOInitSemaphore_SignalSemaphore       equr    a0
_LVOInitSemaphore_Semaphore             equr    a0
_LVOInitSemaphore_RU                    = 1

*** _LVOInitStruct() ***
_LVOInitStruct_InitTable        equr    a1
_LVOInitStruct_Table            equr    a1
_LVOInitStruct_Memory           equr    a2
_LVOInitStruct_Size             equr    d0
_LVOInitStruct_RU               = 3

*** _LVOInsert() ***
_LVOInsert_List         equr    a0
_LVOInsert_Node         equr    a1
_LVOInsert_ListNode     equr    a2
_LVOInsert_RU           = 3

*** _LVOMakeFunctions() ***
_LVOMakeFunctions_Target        equr    a0
_LVOMakeFunctions_FunctionArray equr    a1
_LVOMakeFunctions_Array         equr    a1
_LVOMakeFunctions_FuncDispBase  equr    a2
_LVOMakeFunctions_Base          equr    a2
_LVOMakeFunctions_Result        equr    d0
_LVOMakeFunctions_RU            = 3

*** _LVOMakeLibrary() ***
_LVOMakeLibrary_Vectors         equr    a0
_LVOMakeLibrary_Structure       equr    a1
_LVOMakeLibrary_Init            equr    a2
_LVOMakeLibrary_DSize           equr    d0
_LVOMakeLibrary_SegList         equr    d1
_LVOMakeLibrary_Result          equr    d0
_LVOMakeLibrary_RFail           = 0
_LVOMakeLibrary_RU              = 5

*** _LVOObtainQuickVector() ***
_LVOObtainQuickVector_InterruptCode     equr    a0
_LVOObtainQuickVector_Code              equr    a0
_LVOObtainQuickVector_Result            equr    d0
_LVOObtainQuickVector_RFail             = 0
_LVOObtainQuickVector_RU                = 1

*** _LVOObtainSemaphore() ***
_LVOObtainSemaphore_SignalSemaphore     equr    a0
_LVOObtainSemaphore_Semaphore           equr    a0
_LVOObtainSemaphore_RU = 1

*** _LVOObtainSemaphoreList() ***
_LVOObtainSemaphoreList_List            equr    a0
_LVOObtainSemaphoreList_RU              = 1

*** _LVOObtainSemaphoreShared() ***
_LVOObtainSemaphoreShared_SignalSemaphore       equr    a0
_LVOObtainSemaphoreShared_Semaphore             equr    a0
_LVOObtainSemaphoreShared_RU                    = 1

*** _LVOOldOpenLibrary() ***
_LVOOldOpenLibrary_Name         equr    a1
_LVOOldOpenLibrary_LibName      equr    a1
_LVOOldOpenLibrary_Result       equr    d0
_LVOOldOpenLibrary_RFail        = 0
_LVOOldOpenLibrary_RU           = 1

*** _LVOOpenDevice() ***
_LVOOpenDevice_Name             equr a0
_LVOOpenDevice_DevName          equr a0
_LVOOpenDevice_DeviceName       equr a0
_LVOOpenDevice_Unit             equr d0
_LVOOpenDevice_UnitNumber       equr d0
_LVOOpenDevice_IORequest        equr a1
_LVOOpenDevice_IO               equr a1
_LVOOpenDevice_Flags            equr d1
_LVOOpenDevice_Result           equr d0
_LVOOpenDevice_RSuccess         = 0
_LVOOpenDevice_RU               = 4

*** _LVOOpenLibrary() ***
_LVOOpenLibrary_Name            equr    a1
_LVOOpenLibrary_LibName         equr    a1
_LVOOpenLibrary_Version         equr    d0
_LVOOpenLibrary_Result          equr    d0
_LVOOpenLibrary_RFail           = 0
_LVOOpenLibrary_RU              = 2

*** _LVOOpenResource() ***
_LVOOpenResource_ResName        equr    a1
_LVOOpenResource_Name           equr    a1
_LVOOpenResource_Result         equr    d0
_LVOOpenResource_RFail          = 0
_LVOOpenResource_RU             = 1

*** _LVOPermit() ***
_LVOPermit_RU   = 0

*** _LVOProcure() ***
_LVOProcure_Semaphore           equr    a0
_LVOProcure_BidMessage          equr    a1
_LVOProcure_Message             equr    a1
_LVOProcure_RU                  = 2

*** _LVOPutMsg() ***
_LVOPutMsg_Port         equr    a0
_LVOPutMsg_MsgPort      equr    a0
_LVOPutMsg_Message      equr    a1
_LVOPutMsg_Msg          equr    a1
_LVOPutMsg_RU           = 2

*** _LVORawDoFmt() ***
_LVORawDoFmt_String             equr    a0
_LVORawDoFmt_Source             equr    a0
_LVORawDoFmt_DataStream         equr    a1
_LVORawDoFmt_Stream             equr    a1
_LVORawDoFmt_Data               equr    a1
_LVORawDoFmt_PutChProc          equr    a2
_LVORawDoFmt_Procedure          equr    a2
_LVORawDoFmt_PutChData          equr    a3
_LVORawDoFmt_Destination        equr    a3
_LVORawDoFmt_RU                 = 4

*** _LVOReleaseSemaphore() ***
_LVOReleaseSemaphore_SignalSemaphore    equr    a0
_LVOReleaseSemaphore_Semaphore          equr    a0
_LVOReleaseSemaphore_RU                 = 1

*** _LVOReleaseSemaphoreList() ***
_LVOReleaseSemaphoreList_List           equr    a0
_LVOReleaseSemaphoreList_RU             = 1

*** _LVORemDevice() ***
_LVORemDevice_Device    equr    a1
_LVORemDevice_RU        = 1

*** _LVORemHead() ***
_LVORemHead_List        equr    a0
_LVORemHead_Result      equr    d0
_LVORemHead_RFail       = 0
_LVORemHead_RU          = 1

*** _LVORemIntServer() ***
_LVORemIntServer_IntNum         equr    d0
_LVORemIntServer_Num            equr    d0
_LVORemIntServer_Interrupt      equr    a1
_LVORemIntServer_RU             = 2

*** _LVORemLibrary() ***
_LVORemLibrary_Library          equr    a1
_LVORemLibrary_RU               = 1

*** _LVORemMemHandler() ***
_LVORemMemHandler_MemHandler    equr    a1
_LVORemMemHandler_Handler       equr    a1
_LVORemMemHandler_RU            = 1

*** _LVORemove() ***
_LVORemove_Node         equr    a1
_LVORemove_RU           = 1

*** _LVORemPort() ***
_LVORemPort_Port        Equr a1
_LVORemPort_MsgPort     Equr a1
_LVORemPort_RU          = 1

*** _LVORemResource() ***
_LVORemResource_Resource        equr    a1
_LVORemResource_RU              = 1

*** _LVORemSemaphore() ***
_LVORemSemaphore_SignalSemaphore        equr    a1
_LVORemSemaphore_Semaphore              equr    a1
_LVORemSemaphore_RU                     = 1

*** _LVORemTail() ***
_LVORemTail_List        equr    a0
_LVORemTail_Result      equr    d0
_LVORemTail_RFail       = 0
_LVORemTail_RU          = 1

*** _LVORemTask() ***
_LVORemTask_Task        equr a1
_LVORemTask_RU          = 1

*** _LVOReplyMsg() ***
_LVOReplyMsg_Message    equr    a1
_LVOReplyMsg_Msg        equr    a1
_LVOReplyMsg_RU         = 1

*** _LVOSendIO() ***
_LVOSendIO_IORequest      equr a1
_LVOSendIO_IO             equr a1
_LVOSendIO_Result         equr d0
_LVOSendIO_RSuccess       = 0
_LVOSendIO_RU             = 1

*** _LVOSetExcept() ***
_LVOSetExcept_Signals           equr    d0
_LVOSetExcept_NewSignals        equr    d0
_LVOSetExcept_SignalMask        equr    d1
_LVOSetExcept_Mask              equr    d1
_LVOSetExcept_Result            equr    d0
_LVOSetExcept_RU                = 2

*** _LVOSetFunction() ***
_LVOSetFunction_Library         equr    a1
_LVOSetFunction_FuncOffset      equr    a0
_LVOSetFunction_Offset          equr    a0
_LVOSetFunction_FuncEntry       equr    d0
_LVOSetFunction_Entry           equr    d0
_LVOSetFunction_Result          equr    d0
_LVOSetFunction_RU              = 3

*** _LVOSetIntVector() ***
_LVOSetIntVector_IntNumber      equr    d0
_LVOSetIntVector_Num            equr    d0
_LVOSetIntVector_Number         equr    d0
_LVOSetIntVector_Interrupt      equr    a1
_LVOSetIntVector_Result         equr    d0
_LVOSetIntVector_RU             = 2

*** _LVOSetSignal() ***
_LVOSetSignal_NewSignals        equr    d0
_LVOSetSignal_Signals           equr    d0
_LVOSetSignal_SignalMask        equr    d1
_LVOSetSignal_Mask              equr    d1
_LVOSetSignal_Result            equr    d0
_LVOSetSignal_RU                = 2

*** _LVOSetSR() ***
_LVOSetSR_NewSR         equr    d0
_LVOSetSR_Mask          equr    d1
_LVOSetSR_Result        equr    d0
_LVOSetSR_RU            = 2

*** _LVOSetTaskPri() ***
_LVOSetTaskPri_Task     equr    a1
_LVOSetTaskPri_Priority equr    d0
_LVOSetTaskPri_Pri      equr    d0
_LVOSetTaskPri_Result   equr    d0
_LVOSetTaskPri_RU       = 2

*** _LVOSignal() ***
_LVOSignal_Task         equr    a1
_LVOSignal_Signals      equr    d0
_LVOSignal_RU           = 2

*** _LVOStackSwap() ***
_LVOStackSwap_NewStack  equr    a0
_LVOStackSwap_RU        = 1

*** _LVOSumKickData() ***
_LVOSumKickData_Result  equr    d0
_LVOSumKickData_RU      = 0

*** _LVOSumLibrary() ***
_LVOSumLibrary_Library  equr    a1
_LVOSumLibrary_RU       = 1

*** _LVOSuperState() ***
_LVOSuperState_Result   equr    d0
_LVOSuperState_RU       = 0

*** _LVOSupervisor() ***
_LVOSupervisor_UserFunc         equr    a5
_LVOSupervisor_RU               = 1

*** _LVOTypeOfMem() ***
_LVOTypeOfMem_Address   equr    a1
_LVOTypeOfMem_Result    equr    d0
_LVOTypeOfMem_RFail     = 0
_LVOTypeOfMem_RU        = 1

*** _LVOUserState() ***
_LVOUserState_SysStack  equr    d0
_LVOUserState_RU        = 1

*** _LVOVacate() ***
_LVOVacate_Semaphore    equr    a0
_LVOVacate_BidMessage   equr    a1
_LVOVacate_Message      equr    a1
_LVOVacate_RU           = 2

*** _LVOWait() ***
_LVOWait_SignalSet      equr    d0
_LVOWait_Set            equr    d0
_LVOWait_Signals        equr    d0
_LVOWait_Result         equr    d0
_LVOWait_RU             = 1

*** _LVOWaitIO() ***
_LVOWaitIO_IORequest      equr a1
_LVOWaitIO_IO             equr a1
_LVOWaitIO_Result         equr d0
_LVOWaitIO_RSuccess       = 0
_LVOWaitIO_RU             = 1

*** _LVOWaitPort() ***
_LVOWaitPort_Port       equr    a0
_LVOWaitPort_MsgPort    equr    a0
_LVOWaitPort_Return     equr    d0
_LVOWaitPort_RU         = 1

        ENDC
