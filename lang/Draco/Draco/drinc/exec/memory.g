type
„Node_t=unknown14,

„MemChunk_t=struct{
ˆ*MemChunk_tmc_Next;
ˆulongmc_Bytes;
„},

„MemHeader_t=struct{
ˆNode_tmh_Node;
ˆuintmh_Attributes;
ˆ*MemChunk_tmh_First;
ˆ*bytemh_Lower;
ˆ*bytemh_Upper;
ˆulongmh_Free;
„},

„MemEntry_t=struct{
ˆunion{
Œulongmeu_Reqs;
Œ*bytemeu_Addr;
ˆ}me_Un;
ˆulongme_Length;
„},

„MemList_t=struct{
ˆNode_tml_Node;
ˆuintml_NumEntries;
ˆ[1]MemEntry_tml_ME;
„};

uint
„MEMF_PUBLIC…=1<<0,
„MEMF_CHIP‡=1<<1,
„MEMF_FAST‡=1<<2;

ulong
„MEMF_CLEAR†=1<<16,
„MEMF_LARGEST„=1<<17;

uint
„MEM_BLOCKSIZEƒ=8,
„MEM_BLOCKMASKƒ=7;

extern
„AddMemList(ulongsize,attributes;longpri;arbptrbase;*charname)bool,
„AllocAbs(ulongbyteSize,location)arbptr,
„Allocate(*MemHeader_tfreeList;ulongbyteSize)arbptr,
„AllocEntry(*MemList_tneeded)*MemList_t,
„AllocMem(ulongbyteSize,requirements)arbptr,
„AvailMem(ulongrequirements)ulong,
„CopyMem(arbptrsource,dest;ulongsize)void,
„CopyMemQuick(*ulongsource,dest;ulongbyteSize)void,
„Deallocate(*MemHeader_tfreeList;arbptrmemoryBlock;ulongbyteSize)void,
„FreeEntry(*MemList_tmemList)void,
„FreeMem(arbptrmemoryBlock;ulongbyteSize)void,
„InitStruct(*byteinitTable,memory;ulongsize)void,
„TypeOfMem(arbptraddress)uint;
