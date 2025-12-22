type
„Gadget_t=struct{
ˆ*Gadget_tg_NextGadget;
ˆ
ˆintg_LeftEdge,g_TopEdge;
ˆintg_Width,g_Height;
ˆ
ˆuintg_Flags;
ˆuintg_Activation;
ˆuintg_GadgetType;
ˆ
ˆunion{*Image_tgImage;*Border_tgBorder}
Œg_GadgetRender,g_SelectRender;
ˆ
ˆ*IntuiText_tg_GadgetText;
ˆ
ˆulongg_MutualExclude;
ˆ
ˆunion{*BoolInfo_tgBool;*StringInfo_tgStr;*PropInfo_tgProp}
Œg_SpecialInfo;
ˆ
ˆuintg_GadgetID;
ˆ*byteg_UserData;
„};

uint
„GADGHIGHBITS=0x0003,
„GADGHCOMPƒ=0x0000,
„GADGHBOX„=0x0001,
„GADGHIMAGE‚=0x0002,
„GADGHNONEƒ=0x0003,

„GADGIMAGEƒ=0x0004,

„GRELBOTTOM‚=0x0008,
„GRELRIGHTƒ=0x0010,
„GRELWIDTHƒ=0x0020,
„GRELHEIGHT‚=0x0040,

„SELECTED„=0x0080,

„GADGDISABLED=0x0100;

uint
„RELVERIFYƒ=0x0001,

„GADGIMMEDIATE=0x0002,

„ENDGADGETƒ=0x0004,

„FOLLOWMOUSE=0x0008,

„RIGHTBORDER=0x0010,
„LEFTBORDER‚=0x0020,
„TOPBORDERƒ=0x0040,
„BOTTOMBORDER=0x0080,

„TOGGLESELECT=0x0100,

„STRINGCENTER=0x0200,
„STRINGRIGHT=0x0400,

„LONGINT…=0x0800,

„ALTKEYMAPƒ=0x1000,

„BOOLEXTEND‚=0x2000;

uint
„GADGETTYPE‚=0xFC00,
„SYSGADGETƒ=0x8000,
„SCRGADGETƒ=0x4000,
„GZZGADGETƒ=0x2000,
„REQGADGETƒ=0x1000,

„SIZING†=0x0010,
„WDRAGGINGƒ=0x0020,
„SDRAGGINGƒ=0x0030,
„WUPFRONT„=0x0040,
„SUPFRONT„=0x0050,
„WDOWNBACKƒ=0x0060,
„SDOWNBACKƒ=0x0070,
„CLOSE‡=0x0080,

„BOOLGADGET‚=0x0001,
„GADGET002ƒ=0x0002,
„PROPGADGET‚=0x0003,
„STRGADGETƒ=0x0004;

type
„BoolInfo_t=struct{
ˆuintbi_Flags;
ˆ*uintbi_Mask;
ˆulongbi_Reserved;
„};

uint
„BOOLMASK„=0x0001;

type
„PropInfo_t=struct{
ˆuintpi_Flags;
ˆ
ˆuintpi_HorizPot;
ˆuintpi_VertPot;
ˆ
ˆuintpi_HorizBody;
ˆuintpi_VertBody;
ˆ
ˆuintpi_CWidth;
ˆuintpi_CHeight;
ˆuintpi_HPotRes,pi_VPotRes;
ˆuintpi_LeftBorder;
ˆuintpi_TopBorder;
„};

uint
„AUTOKNOB„=0x0001,
„FREEHORIZƒ=0x0002,
„FREEVERT„=0x0004,
„PROPBORDERLESS=0x0008,
„KNOBHIT…=0x0100;

uint
„KNOBHMIN„=6,
„KNOBVMIN„=4,
„MAXBODY…=65535,
„MAXBOT†=65535;

type
„StringInfo_t=struct{
ˆ*charsi_Buffer;
ˆ*charsi_UndoBuffer;
ˆuintsi_BufferPos;
ˆuintsi_MaxChars;
ˆuintsi_DispPos;
ˆ
ˆuintsi_UndoPos;
ˆuintsi_NumChars;
ˆuintsi_DispCount;
ˆintsi_CLeft,si_CTop;
ˆ*Layer_tsi_LayerPtr;
ˆ
ˆlongsi_LongInt;
ˆ
ˆ*KeyMap_tsi_AltKeyMap;
„};

extern
„ActivateGadget(*Gadget_tg;*Window_tw;*Requester_tr)bool,
„AddGadget(*Window_tw;*Gadget_tg;ulongposition)ulong,
„AddGList(*Window_tw;*Gadget_tg;ulongposition;longnumGad;
*Requester_tr)ulong,
„ModifyProp(*Gadget_tg;*Window_tw;*Requester_tr;ulongflags;
ulonghorizPot,vertPot,horizBody,vertBody)void,
„NewModifyProp(*Gadget_tg;*Window_tw;*Requester_tr;ulongflags;
’ulonghorizPot,vertPot,horizBody,vertBody;
’longnumGad)void,
„OffGadget(*Gadget_tg;*Window_tw;*Requester_tr)void,
„OnGadget(*Gadget_tg;*Window_tw;*Requester_tr)void,
„RefreshGadgets(*Gadget_tg;*Window_tw;*Requester_tr)void,
„RefreshGList(*Gadget_tg;*Window_tw;*Requester_tr;longnumGad)void,
„RemoveGadget(*Window_tw;*Gadget_tg)long,
„RemoveGList(*Window_tw;*Gadget_tg;longnumGad)long;
