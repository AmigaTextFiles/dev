uint
„BITSET=0x8000,
„BITCLR=0x0000;

type
„Rectangle_t=struct{
ˆuintr_MinX,r_MinY;
ˆuintr_MaxX,r_MaxY;
„},

„Point_t=struct{
ˆuintpt_x,pt_y;
„},

„PLANEPTR=*uint,

„BitMap_t=struct{
ˆuintbm_BytesPerRow;
ˆuintbm_Rows;
ˆushortbm_Flags;
ˆushortbm_Depth;
ˆuintbm_pad;
ˆ[8]PLANEPTRbm_Planes;
„};

extern
„AllocRaster(ulongwidth,height)PLANEPTR,
„BltBitMap(*BitMap_tsrc;ulongsrcX,srcY;
*BitMap_tdst;ulongdstX,dstY;
ulongsizX,sizY,minterm,mask;*byteTempA)ulong,
„CloseGraphicsLibrary()void,
„DisownBlitter()void,
„FreeRaster(PLANEPTRp;ulongwidth,height)void,
„InitBitMap(*BitMap_tbm;ulongdepth,width,height)void,
„OpenGraphicsLibrary(ulongversion)*GfxBase_t,
„OwnBlitter()void,
„QBlit(*BltNode_tbp)void,
„QBSBlit(*BltNode_tbp)void,
„RASSIZE(uintw,h)ulong,
„VBeamPos()ulong,
„WaitBlit()void,
„WaitTOF()void;
