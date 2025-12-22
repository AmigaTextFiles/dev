
{
                exec/memory.i
}

{$I "Include:exec/nodes.i" }
{$I "Include:Exec/Interrupts.i"}

TYPE

{ ****** MemChunk **************************************************** }

  MemChunk = Record
    mc_Next  : ^MemChunk;       { * pointer to next chunk * }
    mc_Bytes : Integer;         { * chunk byte size     * }
  End;
  MemChunkPtr = ^MemChunk;


{ ****** MemHeader *************************************************** }

  MemHeader = Record
    mh_Node       : Node;
    mh_Attributes : Short;       { * characteristics of this region * }
    mh_First      : MemChunkPtr; { * first free region          * }
    mh_Lower,                    { * lower memory bound         * }
    mh_Upper      : Address;     { * upper memory bound+1       * }
    mh_Free       : Integer;     { * total number of free bytes * }
  End;
  MemHeaderPtr = ^MemHeader;


{ ****** MemEntry **************************************************** }

  MemUnit = Record
      meu_Reqs  : Integer;      { * the AllocMem requirements * }
      meu_Addr  : Address;      { * the address of this memory region * }
  End;
  MemUnitPtr = ^MemUnit;

  MemEntry = Record
    me_Un       : MemUnit;
    me_Length   : Integer;      { * the length of this memory region * }
  End;
  MemEntryPtr = ^MemEntry;


{ ****** MemList ***************************************************** }

{ * Note: sizeof(struct MemList) includes the size of the first MemEntry! * }

  MemList = Record
    ml_Node       : Node;
    ml_NumEntries : Short;      { * number of entries in this struct * }
    ml_ME         : Array [0..0] of MemEntry;    { * the first entry * }
  End;
  MemListPtr = ^MemList;

{ *----- Memory Requirement Types ---------------------------* }
{ *----- See the AllocMem() documentation for details--------* }

Const

   MEMF_ANY      = %000000000000000000000000;   { * Any type of memory will do * }
   MEMF_PUBLIC   = %000000000000000000000001;
   MEMF_CHIP     = %000000000000000000000010;
   MEMF_FAST     = %000000000000000000000100;
   MEMF_LOCAL    = %000000000000000100000000;
   MEMF_24BITDMA = %000000000000001000000000;   { * DMAable memory within 24 bits of address * }
   MEMF_KICK     = %000000000000010000000000;   { Memory that can be used for KickTags }

   MEMF_CLEAR    = %000000010000000000000000;
   MEMF_LARGEST  = %000000100000000000000000;
   MEMF_REVERSE  = %000001000000000000000000;
   MEMF_TOTAL    = %000010000000000000000000;   { * AvailMem: return total size of memory * }
   MEMF_NO_EXPUNGE = $80000000;   {AllocMem: Do not cause expunge on failure }

   MEM_BLOCKSIZE = 8;
   MEM_BLOCKMASK = MEM_BLOCKSIZE-1;

Type
{***** MemHandlerData *********************************************}
{ Note:  This structure is *READ ONLY* and only EXEC can create it!}
 MemHandlerData = Record
        memh_RequestSize,      { Requested allocation size }
        memh_RequestFlags,      { Requested allocation flags }
        memh_Flags  : Integer;             { Flags (see below) }
 end;
 MemHandlerDataPtr = ^MemHandlerData;

const
    MEMHF_RECYCLE  = 1; { 0==First time, 1==recycle }

{***** Low Memory handler return values **************************}
    MEM_DID_NOTHING = 0;     { Nothing we could do... }
    MEM_ALL_DONE    = -1;    { We did all we could do }
    MEM_TRY_AGAIN   = 1;     { We did some, try the allocation again }


Procedure AddMemList(size, attr, pri : Integer; base : Address; name : String);
    External;

Function AllocAbs(bytesize : Integer; location : Address) : Address;
    External;

Function Allocate(mem : MemHeaderPtr; bytesize : Integer) : Address;
    External;

Function AllocEntry(mem : MemListPtr) : MemListPtr;
    External;

Function AllocMem(bytesize : Integer; reqs : Integer) : Address;
    External;

Function AvailMem(attr : Integer) : Integer;
    External;

Procedure CopyMem(source, dest : Address; size : Integer);
    External;

Procedure CopyMemQuick(source, dest : Address; size : Integer);
    External;

Procedure Deallocate(header : MemHeaderPtr; block : Address; size : Integer);
    External;

Procedure FreeEntry(memList : MemListPtr);
    External;

Procedure FreeMem(memBlock : Address; size : Integer);
    External;

Procedure InitStruct(table, memory : Address; size : Integer);
    External;

Function TypeOfMem(mem : Address) : Integer;
    External;


{ -- 2.0 functions -- }

Function AllocPooled( memsize : Integer; poolheader : Address ): Address;
    External;

Function AllocVec( size, reqm : Integer ): Address;
    External;

Function CreatePrivatePool( requrements,
                             puddlesize,
                             puddletresh : Integer ): Address;
    External;

Procedure DeletePrivatePool( poolheader : Address );
    External;

Procedure FreePooled( memory, poolheader : Address );
    External;

Procedure FreeVec( memory : Address );
    External;


{--- functions in V39 or higher (Release 3) ---}
{------ Low memory handler functions }
PROCEDURE AddMemHandler(memhand : InterruptPtr;);
    External;

PROCEDURE RemMemHandler(memhand : InterruptPtr);
    External;




