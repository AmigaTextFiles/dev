
#
# WarpOS PowerPC.library support for pasm
#
# Convertion by AlphaSND - Fantaisie Software
#

.ifndef  ALPHASND_USEFULSTUFFS_I
.set     ALPHASND_USEFULSTUFFS_I,1

.set _LVORun68K              ,       -300
.set _LVOWaitFor68K          ,       -306
.set _LVOSPrintF             ,       -312
.set _LVORun68KLowLevel      ,       -318    #PRIVATE!
.set _LVOAllocVecPPC         ,       -324
.set _LVOFreeVecPPC          ,       -330
.set _LVOCreateTaskPPC       ,       -336
.set _LVODeleteTaskPPC       ,       -342
.set _LVOFindTaskPPC         ,       -348
.set _LVOInitSemaphorePPC    ,       -354
.set _LVOFreeSemaphorePPC    ,       -360
.set _LVOAddSemaphorePPC     ,       -366
.set _LVORemSemaphorePPC     ,       -372
.set _LVOObtainSemaphorePPC  ,       -378
.set _LVOAttemptSemaphorePPC ,       -384
.set _LVOReleaseSemaphorePPC ,       -390
.set _LVOFindSemaphorePPC    ,       -396
.set _LVOInsertPPC           ,       -402
.set _LVOAddHeadPPC          ,       -408
.set _LVOAddTailPPC          ,       -414
.set _LVORemovePPC           ,       -420
.set _LVORemHeadPPC          ,       -426
.set _LVORemTailPPC          ,       -432
.set _LVOEnqueuePPC          ,       -438
.set _LVOFindNamePPC         ,       -444
.set _LVOFindTagItemPPC      ,       -450
.set _LVOGetTagDataPPC       ,       -456
.set _LVONextTagItemPPC      ,       -462
.set _LVOAllocSignalPPC      ,       -468
.set _LVOFreeSignalPPC       ,       -474
.set _LVOSetSignalPPC        ,       -480
.set _LVOSignalPPC           ,       -486
.set _LVOWaitPPC             ,       -492
.set _LVOSetTaskPriPPC       ,       -498
.set _LVOSignal68K           ,       -504
.set _LVOSetCache            ,       -510
.set _LVOSetExcHandler       ,       -516
.set _LVORemExcHandler       ,       -522
.set _LVOSuper               ,       -528
.set _LVOUser                ,       -534
.set _LVOSetHardware         ,       -540
.set _LVOModifyFPExc         ,       -546
.set _LVOWaitTime            ,       -552
.set _LVOChangeStack         ,       -558    # PRIVATE!
.set _LVOLockTaskList        ,       -564
.set _LVOUnLockTaskList      ,       -570
.set _LVOSetExcMMU           ,       -576
.set _LVOClearExcMMU         ,       -582
.set _LVOChangeMMU           ,       -588
.set _LVOGetInfo             ,       -594
.set _LVOCreateMsgPortPPC    ,       -600
.set _LVODeleteMsgPortPPC    ,       -606
.set _LVOAddPortPPC          ,       -612
.set _LVORemPortPPC          ,       -618
.set _LVOFindPortPPC         ,       -624
.set _LVOWaitPortPPC         ,       -630
.set _LVOPutMsgPPC           ,       -636
.set _LVOGetMsgPPC           ,       -642
.set _LVOReplyMsgPPC         ,       -648
.set _LVOFreeAllMem          ,       -654
.set _LVOCopyMemPPC          ,       -660
.set _LVOAllocXMsgPPC        ,       -666
.set _LVOFreeXMsgPPC         ,       -672
.set _LVOPutXMsgPPC          ,       -678
.set _LVOGetSysTimePPC       ,       -684
.set _LVOAddTimePPC          ,       -690
.set _LVOSubTimePPC          ,       -696
.set _LVOCmpTimePPC          ,       -702
.set _LVOSetReplyPortPPC     ,       -708
.set _LVOSnoopTask           ,       -714
.set _LVOEndSnoopTask        ,       -720
.set _LVOGetHALInfo          ,       -726
.set _LVOSetScheduling       ,       -732
.set _LVOFindTaskByID        ,       -738
.set _LVOSetNiceValue        ,       -744
.set _LVOTrySemaphorePPC     ,       -750
.set _LVOAllocPrivateMem     ,       -756    # PRIVATE!
.set _LVOFreePrivateMem      ,       -762    # PRIVATE!
.set _LVOResetCPU            ,       -768    # PRIVATE!
.set _LVONewListPPC          ,       -774
.set _LVOSetExceptPPC        ,       -780
.set _LVOObtainSemaphoreSharedPPC ,  -786
.set _LVOAttemptSemaphoreSharedPPC,  -792
.set _LVOProcurePPC          ,       -798
.set _LVOVacatePPC           ,       -804
.set _LVOCauseInterrupt      ,       -810
.set _LVOCreatePoolPPC       ,       -816
.set _LVODeletePoolPPC       ,       -822
.set _LVOAllocPooledPPC      ,       -828
.set _LVOFreePooledPPC       ,       -834
.set _LVORawDoFmtPPC         ,       -840


# Useful constants for PPC calls.
#


.set PP_CODE      ,  0   # Ptr to PPC code
.set PP_OFFSET    ,  4   # Offset to PP_CODE
.set PP_FLAGS     ,  8   # flags (see below)
.set PP_STACKPTR  , 12   # stack pointer
.set PP_STACKSIZE , 16   # stack size
.set PP_REGS      , 20   # 15 registers (d0-a6)  - 15*4
.set PP_FREGS     , 80   # 8 registers (fp0-fp7) - 8*8
.set PP_SIZE      ,176   # Theorically 144, but vbcc use 176 so..



# CallPowerPC - PowerPC.library automatic function call.
#
# Usage: 'CALLPOWERPC AllocMemPPC'
#

.macro CALLPOWERPC
  lwz  r3,_PowerPCBase(r2)
  lwz  r0,_LVO\1+2(r3)
  mtlr r0
  blrl
.endm


# Run68k - Allow launching of regular 68000 sub functions.
#
# Usage: 'RUN68K r5,-198'
#

.macro RUN68K
  mr  r18,\1
  li  r19,\2
  bl _Run68K_SubRoutine
.endm


.macro RUN68K_SubRoutine
_Run68K_SubRoutine:
  pushlr
  push    _a6
  subi    local,local,PP_SIZE
  stw     _d0,PP_REGS(local)
  stw     _d1,PP_REGS+1*4(local)
  stw     _d2,PP_REGS+2*4(local)
  stw     _d3,PP_REGS+3*4(local)
  stw     _d4,PP_REGS+4*4(local)
  stw     _d5,PP_REGS+5*4(local)
  stw     _d6,PP_REGS+6*4(local)
  stw     _d7,PP_REGS+7*4(local)
  stw     _a0,PP_REGS+8*4(local)
  stw     _a1,PP_REGS+9*4(local)
  stw     _a2,PP_REGS+10*4(local)
  stw     _a3,PP_REGS+11*4(local)
  stw     _a4,PP_REGS+12*4(local)
  stw     _a5,PP_REGS+13*4(local)
  stw     _a6,PP_REGS+14*4(local)
  stw      r18,PP_CODE(local)       # Set the default base...
  mr      _d0,r19                   # ... and it's offset (ie: -526(a6))
  stw     _d0,PP_OFFSET(local)
  clrw    _d0                       # We don't use them, so clear them.
  stw     _d0,PP_FLAGS(local)       #
  stw     _d0,PP_STACKPTR(local)    #
  stw     _d0,PP_STACKSIZE(local)   #
  mr      r4,local
  lw      r3,_PowerPCBase(r2)
  lwz     r0,-300+2(r3)             # Run68K(r3, r4) - BasePtr, PPArgs
  mtlr    r0
  blrl
  lwz     _d0,PP_REGS(local)        # We only need 'd0'
  addi    local,local,PP_SIZE
  pop     _a6
  poplr
  blr
.endm


.endif

