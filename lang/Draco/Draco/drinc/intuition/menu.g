type
„Menu_t=struct{
ˆ*Menu_tm_NextMenu;
ˆuintm_LeftEdge,m_TopEdge;
ˆuintm_Width,m_Height;
ˆuintm_Flags;
ˆ*charm_MenuName;
ˆ*MenuItem_tm_FirstItem;
ˆuintm_JazzX,m_JazzY,m_BeatX,m_BeatY;
„};

uint
„MENUENABLED=0x0001,

„MIDRAWN…=0x0100;

type
„MenuItem_t=struct{
ˆ*MenuItem_tmi_NextItem;
ˆuintmi_LeftEdge,mi_TopEdge;
ˆuintmi_Width,mi_Height;
ˆuintmi_Flags;
ˆ
ˆulongmi_MutualExclude;
ˆunion{*IntuiText_tmiIt;*Image_tmiIm}mi_ItemFill,mi_SelectFill;
ˆ
ˆcharmi_Command;
ˆ
ˆ*MenuItem_tmi_SubItem;
ˆ
ˆuintmi_NextSelect;
„};

uint
„CHECKIT…=0x0001,
„ITEMTEXT„=0x0002,
„COMMSEQ…=0x0004,
„MENUTOGGLE‚=0x0008,
„ITEMENABLED=0x0010,

„HIGHFLAGSƒ=0x00C0,
„HIGHIMAGEƒ=0x0000,
„HIGHCOMP„=0x0040,
„HIGHBOX…=0x0080,
„HIGHNONE„=0x00C0,

„CHECKED…=0x0100,

„ISDRAWN…=0x1000,
„HIGHITEM„=0x2000,
„MENUTOGGLED=0x4000,

„NOMENU†=0x001F,
„NOITEM†=0x003F,
„NOSUB‡=0x001F,
„MENUNULL„=0xFFFF,

„CHECKWIDTH†=19,
„COMMWIDTH‡=27,
„LOWCHECKWIDTHƒ=13,
„LOWCOMMWIDTH„=16;

extern
„ClearMenuStrip(*Window_tw)void,
„ItemAddress(*Menu_tmenu;ulongmenuNumber)*MenuItem_t,
„OffMenu(*Window_tw;ulongmenuNumber)void,
„OnMenu(*Window_tw;ulongmenuNumber)void,
„SetMenuStrip(*Window_tw;*Menu_tm)void,
„MENUNUM(uintn)uint,
„ITEMNUM(uintn)uint,
„SUBNUM(uintn)uint,
„SHIFTMENU(uintn)uint,
„SHIFTITEM(uintn)uint,
„SHIFTSUB(uintn)uint;
