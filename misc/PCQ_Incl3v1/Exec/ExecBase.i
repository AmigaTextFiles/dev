

{
        exec/execbase.i
}


{$I "Include:exec/lists.i" }
{$I "Include:exec/interrupts.i" }
{$I "Include:exec/libraries.i" }
{$I "Include:exec/tasks.i" }


{  Definition of the Exec library base structure (pointed to by location 4).
** Most fields are not to be viewed or modified by user programs.  Use
** extreme caution.
 }

Type

ExecBase = Record
        LibNode    : Library;   {  Standard library node  }

{ ******* Static System Variables ******* }

        SoftVer,                {  kickstart release number (obs.)  }
        LowMemChkSum : Short;   {  checksum of 68000 trap vectors  }
        ChkBase      : Integer; {  system base pointer complement  }
        ColdCapture,            {  coldstart soft capture vector  }
        CoolCapture,            {  coolstart soft capture vector  }
        WarmCapture,            {  warmstart soft capture vector  }
        SysStkUpper,            {  system stack base   (upper bound)  }
        SysStkLower  : Address; {  top of system stack (lower bound)  }
        MaxLocMem    : Integer; {  top of chip memory  }
        DebugEntry,             {  global debugger entry point  }
        DebugData,              {  global debugger data segment  }
        AlertData,              {  alert data segment  }
        MaxExtMem    : Address; {  top of extended mem, or null if none  }

        ChkSum       : Short;   {  for all of the above (minus 2)  }

{ ***** Interrupt Related ************************************** }

        IntVects     : Array[0..15] of IntVector;

{ ***** Dynamic System Variables ************************************ }

        ThisTask     : TaskPtr; {  pointer to current task (readable)  }

        IdleCount,              {  idle counter  }
        DispCount    : Integer; {  dispatch counter  }
        Quantum,                {  time slice quantum  }
        Elapsed,                {  current quantum ticks  }
        SysFlags     : Short;   {  misc internal system flags  }
        IDNestCnt,              {  interrupt disable nesting count  }
        TDNestCnt    : Byte;    {  task disable nesting count  }

        AttnFlags,              {  special attention flags (readable)  }
        AttnResched  : Short;   {  rescheduling attention  }
        ResModules,             {  resident module array pointer  }
        TaskTrapCode,
        TaskExceptCode,
        TaskExitCode : Address;
        TaskSigAlloc : Integer;
        TaskTrapAlloc: Short;


{ ***** System Lists (private!) ******************************* }

        MemList,
        ResourceList,
        DeviceList,
        IntrList,
        LibList,
        PortList,
        TaskReady,
        TaskWait     : List;

        SoftInts     : Array[0..4] of SoftIntList;

{ ***** Other Globals ****************************************** }

        LastAlert    : Array[0..3] of Integer;

        {  these next two variables are provided to allow
        ** system developers to have a rough idea of the
        ** period of two externally controlled signals --
        ** the time between vertical blank interrupts and the
        ** external line rate (which is counted by CIA A's
        ** "time of day" clock).  In general these values
        ** will be 50 or 60, and may or may not track each
        ** other.  These values replace the obsolete AFB_PAL
        ** and AFB_50HZ flags.
         }

        VBlankFrequency,                {  (readable)  }
        PowerSupplyFrequency : Byte;    {  (readable)  }

        SemaphoreList    : List;

        {  these next two are to be able to kickstart into user ram.
        ** KickMemPtr holds a singly linked list of MemLists which
        ** will be removed from the memory list via AllocAbs.  If
        ** all the AllocAbs's succeeded, then the KickTagPtr will
        ** be added to the rom tag list.
         }

        KickMemPtr,             {  ptr to queue of mem lists  }
        KickTagPtr,             {  ptr to rom tag queue  }
        KickCheckSum : Address; {  checksum for mem and tags  }

{ ***** V36 Exec additions start here ************************************* }

        ex_Pad0           : Short;
        ex_Reserved0      : Integer;
        ex_RamLibPrivate  : Address;

        {  The next ULONG contains the system "E" clock frequency,
        ** expressed in Hertz.  The E clock is used as a timebase for
        ** the Amiga's 8520 I/O chips. (E is connected to "02").
        ** Typical values are 715909 for NTSC, or 709379 for PAL.
         }

        ex_EClockFrequency,     {  (readable)  }
        ex_CacheControl,        {  Private to CacheControl calls  }
        ex_TaskID,              {  Next available task ID  }

        ex_Reserved1      : Array[0..4] of Integer;

        ex_MMULock        : Address;    {  private  }

        ex_Reserved2      : Array[0..2] of Integer;
{***** V39 Exec additions start here *************************************}

        { The following list and data element are used
         * for V39 exec's low memory handler...
         }
        ex_MemHandlers    : MinList; { The handler list }
        ex_MemHandler     : Address;          { Private! handler pointer }
        ex_Reserved       : Array[0..1] of Byte;
end;
ExecBasePtr = ^ExecBase;


{ ***** Bit defines for AttnFlags (see above) ***************************** }

{   Processors and Co-processors:  }

CONST

  AFB_68010     = 0;    {  also set for 68020  }
  AFB_68020     = 1;    {  also set for 68030  }
  AFB_68030     = 2;    {  also set for 68040  }
  AFB_68040     = 3;
  AFB_68881     = 4;    {  also set for 68882  }
  AFB_68882     = 5;
  AFB_FPU40     = 6;    {  Set if 68040 FPU }

  AFF_68010     = %00000001;
  AFF_68020     = %00000010;
  AFF_68030     = %00000100;
  AFF_68040     = %00001000;
  AFF_68881     = %00010000;
  AFF_68882     = %00100000;
  AFF_FPU40     = %01000000;

{    AFB_RESERVED8 = %000100000000;  }
{    AFB_RESERVED9 = %001000000000;  }


{ ***** Selected flag definitions for Cache manipulation calls ********* }

  CACRF_EnableI       = %0000000000000001;  { Enable instruction cache  }
  CACRF_FreezeI       = %0000000000000010;  { Freeze instruction cache  }
  CACRF_ClearI        = %0000000000001000;  { Clear instruction cache   }
  CACRF_IBE           = %0000000000010000;  { Instruction burst enable  }
  CACRF_EnableD       = %0000000100000000;  { 68030 Enable data cache   }
  CACRF_FreezeD       = %0000001000000000;  { 68030 Freeze data cache   }
  CACRF_ClearD        = %0000100000000000;  { 68030 Clear data cache    }
  CACRF_DBE           = %0001000000000000;  { 68030 Data burst enable   }
  CACRF_WriteAllocate = %0010000000000000;  { 68030 Write-Allocate mode
                                              (must always be set!)     }
  CACRF_EnableE       = 1073741824;  { Master enable for external caches }
                                     { External caches should track the }
                                     { state of the internal caches }
                                     { such that they do not cache anything }
                                     { that the internal cache turned off }
                                     { for. }

  CACRF_CopyBack      = $80000000;  { Master enable for copyback caches }

  DMA_Continue        = 2;      { Continuation flag for CachePreDMA }
  DMA_NoModify        = 4;      { Set if DMA does not update memory }
  DMA_ReadFromRAM     = 8;      { Set if DMA goes *FROM* RAM to device }


