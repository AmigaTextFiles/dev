type
„Image_t=struct{
ˆinti_LeftEdge,i_TopEdge;
ˆuinti_Width,i_Height;
ˆuinti_Depth;
ˆ*uinti_ImageData;
ˆ
ˆushorti_PlanePick,i_PlaneOnOff;
ˆ
ˆ*Image_ti_NextImage;
„};

extern
„DrawImage(*RastPort_trp;*Image_ti;ulongleftOffset,topOffset)void;
