type
„ViewPort_t=unknown40,
„RastPort_t=unknown100,
„BitMap_t=unknown40,
„Layer_Info_t=unknown102;

type
„Screen_t=struct{
ˆ*Screen_tsc_NextScreen;
ˆ*Window_tsc_FirstWindow;
ˆ
ˆuintsc_LeftEdge,sc_TopEdge;
ˆuintsc_Width,sc_Height;
ˆ
ˆintsc_MouseY,sc_MouseX;
ˆ
ˆuintsc_Flags;
ˆ
ˆ*charsc_Title;
ˆ*charsc_DefaultTitle;
ˆ
ˆushortsc_BarHeight,sc_BarVBorder,sc_BarHBorder,
Œsc_MenuVBorder,sc_MenuHBorder;
ˆushortsc_WBorTop,sc_WBorLeft,sc_WBorRight,sc_WBorBottom;
ˆ
ˆ*TextAttr_tsc_Font;
ˆ
ˆViewPort_tsc_ViewPort;
ˆRastPort_tsc_RastPort;
ˆBitMap_tsc_BitMap;
ˆLayer_Info_tsc_LayerInfo;
ˆ
ˆ*Gadget_tsc_FirstGadget;
ˆ
ˆushortsc_DetailPen,sc_BlockPen;
ˆ
ˆuintsc_SaveColor0;
ˆ
ˆ*Layer_tsc_BarLayer;
ˆ
ˆ*bytesc_ExtData;
ˆ
ˆ*bytesc_UserData;
„};

uint„
„SCREENTYPE†=0x000F,
„WBENCHSCREEN„=0x0001,
„CUSTOMSCREEN„=0x000F,

„SHOWTITLE‡=0x0010,

„BEEPING‰=0x0020,

„CUSTOMBITMAP„=0x0040,

„SCREENBEHIND„=0x0080,

„SCREENQUIET…=0x0100;

uint
„STDSCREENHEIGHT=65535;

type
„NewScreen_t=struct{
ˆuintns_LeftEdge,ns_TopEdge,ns_Width,ns_Height,ns_Depth;
ˆ
ˆushortns_DetailPen,ns_BlockPen;
ˆ
ˆuintns_ViewModes;
ˆ
ˆuintns_Type;
ˆ
ˆ*TextAttr_tns_Font;
ˆ
ˆ*charns_DefaultTitle;
ˆ
ˆ*Gadget_tns_Gadgets;
ˆ
ˆ*BitMap_tns_CustomBitMap;
„};

extern
„CloseScreen(*Screen_tsc)void,
„DisplayBeep(*Screen_tsc)void,
„GetScreenData(*bytebuffer;ulongsize,typ;*Screen_tsc)bool,
„MakeScreen(*Screen_tsc)void,
„MoveScreen(*Screen_tsc;longdeltaX,deltaY)void,
„OpenScreen(*NewScreen_tnewScreen)*Screen_t,
„ScreenToBack(*Screen_tsc)void,
„ScreenToFront(*Screen_tsc)void,
„ShowTitle(*Screen_tsc;ulongshowIt)void;
