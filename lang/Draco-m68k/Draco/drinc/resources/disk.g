/*requirespriorinclusionof"exec/libraries.g"*/

type
„List_t=unknown14,
„Message_t=unknown20,
„Interrupt_t=unknown22,
„Library_t=unknown34,

„DiscResourceUnit_t=struct{
ˆMessage_tdru_Message;
ˆInterrupt_tdru_DiscBlock,dru_DiscSync,dru_Index;
„},

„DiscResource_t=struct{
ˆLibrary_tdr_Library;
ˆ*DiscResourceUnitdr_Current;
ˆushortdr_Flags,dr_pad;
ˆ*Library_tdr_SysLib,dr_CiaResource;
ˆ[4]ulongdr_UnitID;
ˆList_tdr_Waiting;
ˆInterrupt_tdr_DiscBlock,dr_DiscSync,dr_Index;
„};

ushort
„DRB_ALLOC0‚=0,
„DRB_ALLOC1‚=1,
„DRB_ALLOC2‚=2,
„DRB_ALLOC3‚=3,
„DRB_ACTIVE‚=7,

„DRF_ALLOC0‚=1<<DRB_ALLOC0,
„DRF_ALLOC1‚=1<<DRB_ALLOC1,
„DRF_ALLOC2‚=1<<DRB_ALLOC2,
„DRF_ALLOC3‚=1<<DRB_ALLOC3,
„DRF_ACTIVE‚=1<<DRB_ACTIVE;

uintDSKDMAOFF=0x4000;

*charDISKNAME="disk.resource";

int
„DR_ALLOCUNITˆ=LIB_BASE-0*LIB_VECTSIZE,
„DR_FREEUNIT‰=LIB_BASE-1*LIB_VECTSIZE,
„DR_GETUNITŠ=LIB_BASE-2*LIB_VECTSIZE,
„DR_GIVEUNIT‰=LIB_BASE-3*LIB_VECTSIZE,
„DR_GETUNITIDˆ=LIB_BASE-4*LIB_VECTSIZE,

„DR_LASTCOMŠ=DR_GIVEUNIT;

ulong
„DRT_AMIGA‹=0x00000000,
„DRT_37422D2Sˆ=0x55555555,
„DRT_EMPTY‹=0xFFFFFFFF;

extern
„AllocUnit(ulongunitNum)bool,
„FreeUnit(ulongunitNum)void,
„GetUnit(*DiskResourceUnit_tunitPointer)*DiskResourceUnit,
„GetUnitId(ulongunitNum)ulong,
„GiveUnit()void;
