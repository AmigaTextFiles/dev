type
„SimpleSprite_t=struct{
ˆ*uintss_posctldata;
ˆuintss_height;
ˆuintss_x,ss_y;
ˆuintss_num;
„};

extern
„ChangeSprite(*ViewPort_tvp;*SimpleSprite_tss;*uintnewData)void,
„FreeSprite(ulongpick)void,
„GetSprite(*SimpleSprite_tsprite;ulongpick)ulong,
„MoveSprite(*ViewPort_tvp;*SimpleSprite_tss;ulongx,y)void;
