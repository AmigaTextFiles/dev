type
„Border_t=struct{
ˆintb_LeftEdge,b_TopEdge;
ˆushortb_FrontPen,b_BackPen;
ˆushortb_DrawMode;
ˆushortb_Count;
ˆ*intb_XY;
ˆ*Border_tb_NextBorder;
„};

extern
„DrawBorder(*RastPort_trp;*Border_tb;ulongleftOffset,topOffset)void;
