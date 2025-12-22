type
„IntuiText_t=struct{
ˆushortit_FrontPen,it_BackPen;
ˆushortit_DrawMode;
ˆintit_LeftEdge,it_TopEdge;
ˆ*TextAttr_tit_ITextFont;
ˆ*charit_IText;
ˆ*IntuiText_tit_NextText;
„};

extern
„IntuiTextLength(*IntuiText_tit)ulong,
„PrintIText(*RastPort_trp;*IntuiText_tit;
ulongleftOffset,topOffset)void;
