        IFND LCR_DOS_I
LCR_DOS_I SET 1

****************************************************************************
** Librarycall-include v1.0 written by Rasmus K. Ursem, Dreamline Designs **
** For the dos.library.                                                   **
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
** <Library-Call-Name>_FH             = ALWAYS a BPTR filehandle.         **
** <Library-Call-Name>_Lock           = ALWAYS a BPTR lock.               **
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
** dos.library                                                            **
****************************************************************************
****************************************************************************

*** _LVOAbortPkt() ***
_LVOAbortPkt_Port       equr    d1
_LVOAbortPkt_MsgPort    equr    d1
_LVOAbortPkt_Packet     equr    d2
_LVOAbortPkt_Pkt        equr    d2
_LVOAbortPkt_RU         = 2

*** _LVOAllocDosObject() ***
_LVOAllocDosObject_Type         equr    d1
_LVOAllocDosObject_Tags         equr    d2
_LVOAllocDosObject_Result       equr    d0
_LVOAllocDosObject_RFail        = 0
_LVOAllocDosObject_RU           = 2

*** _LVOClose() ***
_LVOClose_File          equr    d1
_LVOClose_FH            equr    d1
_LVOClose_FileHandle    equr    d1
_LVOClose_Result        equr    d0
_LVOClose_RFail         = 0
_LVOClose_RU            = 1

*** _LVODoPkt() ***
_LVODoPkt_Port          equr    d1
_LVODoPkt_MsgPort       equr    d1
_LVODoPkt_Action        equr    d2
_LVODoPkt_Arg1          equr    d3
_LVODoPkt_Arg2          equr    d4
_LVODoPkt_Arg3          equr    d5
_LVODoPkt_Arg4          equr    d6
_LVODoPkt_Arg5          equr    d7
_LVODoPkt_Result        equr    d0
_LVODoPkt_Result2       equr    d1
_LVODoPkt_RFail         = 0
_LVODoPkt_RU            = 7

*** _LVOExamine() ***
_LVOExamine_Lock                equr d1
_LVOExamine_Block               equr d2
_LVOExamine_FIB                 equr d2
_LVOExamine_FileInfoBlock       equr d2
_LVOExamine_Result              equr d0
_LVOExamine_RFail               = 0
_LVOExamine_RU                  = 2

*** _LVOExamineFH() ***
_LVOExamineFH_FH                  equr d1
_LVOExamineFH_Block               equr d2
_LVOExamineFH_FIB                 equr d2
_LVOExamineFH_FileInfoBlock       equr d2
_LVOExamineFH_Result              equr d0
_LVOExamineFH_RFail               = 0
_LVOExamineFH_RU                  = 2

*** _LVOExNext() ***
_LVOExNext_Lock                equr d1
_LVOExNext_Block               equr d2
_LVOExNext_FIB                 equr d2
_LVOExNext_FileInfoBlock       equr d2
_LVOExNext_Result              equr d0
_LVOExNext_RFail               = 0
_LVOExNext_RU                  = 2

*** _LVOFreeDosObject() ***
_LVOFreeDosObject_Type          equr    d1
_LVOFreeDosObject_Object        equr    d2
_LVOFreeDosObject_Ptr           equr    d2
_LVOFreeDosObject_Pointer       equr    d2
_LVOFreeDosObject_RU            = 2

*** _LVOGetConsoleTask() ***
_LVOGetConsoleTask_Result       equr    d0
_LVOGetConsoleTask_RFail        = 0
_LVOGetConsoleTask_RU           = 0

*** _LVOInput() ***
_LVOInput_Result        equr d0
_LVOInput_RU            =0

*** _LVOLock() ***
_LVOLock_Name           equr d1
_LVOLock_Mode           equr d2
_LVOLock_AccessMode     equr d2
_LVOLock_Result         equr d0
_LVOLock_RFail          = 0
_LVOLock_RU             = 2

*** _LVOOutput() ***
_LVOOutput_Result       equr d0
_LVOOutput_RU           = 0

*** _LVOOpen() ***
_LVOOpen_Name           equr    d1
_LVOOpen_Mode           equr    d2
_LVOOpen_AccessMode     equr    d2
_LVOOpen_Result         equr    d0
_LVOOpen_RFail          = 0
_LVOOpen_RU             = 2

*** _LVORead() ***
_LVORead_FH     equr d1
_LVORead_Buffer equr d2
_LVORead_Size   equr d3
_LVORead_Lenght equr d3
_LVORead_Result equr d0
_LVORead_RFail = 0
_LVORead_RU       = 3

*** _LVOSeek() ***
_LVOSeek_FH             equr    d1
_LVOSeek_Position       equr    d2
_LVOSeek_Pos            equr    d2
_LVOSeek_Mode           equr    d3
_LVOSeek_Offset         equr    d3
_LVOSeek_Result         equr    d0
_LVOSeek_RU             = 3

*** _LVOSendPkt() ***
_LVOSendPkt_Packet      equr    d1
_LVOSendPkt_Pkt         equr    d1
_LVOSendPkt_Port        equr    d2
_LVOSendPkt_MsgPort     equr    d2
_LVOSendPkt_ReplyPort   equr    d3
_LVOSendPkt_RU          = 3

*** _LVOWrite() ***
_LVOWrite_FH     equr d1
_LVOWrite_Buffer equr d2
_LVOWrite_Size   equr d3
_LVOWrite_Lenght equr d3
_LVOWrite_Result equr d0
_LVOWrite_RFail = 0
_LVOWrite_RU       = 3

*** _LVOUnLock() ***
_LVOUnLock_Lock         equr d1
_LVOUnLock_RU           = 0

*** _LVOWaitPkt() ***
_LVOWaitPkt_Result      equr    d0
_LVOWaitPkt_RU          = 0

        ENDC
