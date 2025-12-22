with System; use System;
with Interfaces; use Interfaces;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with Unchecked_Conversion;

with Incomplete_Type; use Incomplete_Type;

with exec_Ports; use exec_Ports;
with exec_Nodes; use exec_Nodes;
with exec_Lists; use exec_Lists;
with devices_InputEvent; use devices_InputEvent;
with graphics_Graphics; use graphics_Graphics;
with graphics_Gfx; use graphics_Gfx;
with graphics_View; use graphics_View;
with graphics_Layers; use graphics_Layers;
with graphics_Rastport; use graphics_Rastport;
with utility_TagItem; use utility_TagItem;
with utility_Hooks; use utility_Hooks;
with intuition_Classes; use intuition_Classes;
with intuition_Classusr; use intuition_Classusr;

package intuition_Intuition is

--#ifndef INTUITION_PREFERENCES_H
--#include <intuition/preferences.h>
--#endif
--#ifndef EXEC_TYPES_H
--#include <exec/types.h>
--#endif
--
--#ifndef GRAPHICS_CLIP_H
--#include <graphics/clip.h>
--#endif
--
--#ifndef GRAPHICS_VIEW_H
--#include <graphics/view.h>
--#endif
--
--#ifndef GRAPHICS_TEXT_H
--#include <graphics/text.h>
--#endif
--

type Window;
type Window_Ptr is access Window;
NullWindow_Ptr : Window_Ptr := NULL;

type Gadget;
type Gadget_Ptr is access Gadget;
NullGadget_Ptr : Gadget_Ptr := NULL;

type Image;
type Image_Ptr is access Image;
NullImage_Ptr : Image_Ptr := NULL;

--package intuition_screens is


--#ifndef EXEC_TYPES_H
--#include <exec/types.h>
--#endif
--
--#ifndef GRAPHICS_GFX_H
--#include <graphics/gfx.h>
--#endif
--
--#ifndef GRAPHICS_CLIP_H
--#include <graphics/clip.h>
--#endif
--
--#ifndef GRAPHICS_VIEW_H
--#include <graphics/view.h>
--#endif
--
--#ifndef GRAPHICS_RASTPORT_H
--#include <graphics/rastport.h>
--#endif
--
--#ifndef GRAPHICS_LAYERS_H
--#include <graphics/layers.h>
--#endif
--
--
--#ifndef UTILITY_TAGITEM_H
--#include <utility/tagitem.h>
--#endif

type dri_Resolution_Type;
type dri_Resolution_Type_Ptr is access dri_Resolution_Type;
Nulldri_Resolution_Type_Ptr : dri_Resolution_Type_Ptr := Null;
type dri_Resolution_Type is record
   X : Integer_16;
   Y : Integer_16;
end record;
type DrawInfo;
type DrawInfo_Ptr is access DrawInfo;
NullDrawInfo_Ptr : DrawInfo_Ptr := Null;
type DrawInfo is record
   dri_Version : Integer_16;
   dri_NumPens : Integer_16;
   dri_Pens : Integer_16_Ptr;
   dri_Font : TextFont_Ptr;
   dri_Resolution : dri_Resolution_Type;
   driFlags : Integer;
   driReserved : Integer_Array(0..6);
end record;
   DRIF_NEWLOOK : constant Unsigned_32 := 16#00000001#;
   DETAILPEN : constant Unsigned_32 := 16#0000#;
   BLOCKPEN : constant Unsigned_32 := 16#0001#;
   TEXTPEN : constant Unsigned_32 := 16#0002#;
   SHINEPEN : constant Unsigned_32 := 16#0003#;
   SHADOWPEN : constant Unsigned_32 := 16#0004#;
   FILLPEN : constant Unsigned_32 := 16#0005#;
   FILLTEXTPEN : constant Unsigned_32 := 16#0006#;
   BACKGROUNDPEN : constant Unsigned_32 := 16#0007#;
   HIGHLIGHTTEXTPEN : constant Unsigned_32 := 16#0008#;
   NUMDRIPENS : constant Unsigned_32 := 16#0009#;
type Screen;
type Screen_Ptr is access Screen;
NullScreen_Ptr : Screen_Ptr := Null;

function to_Unsigned_32 is new Unchecked_Conversion(Screen_Ptr, Unsigned_32);
procedure AddTag is new NewAddTag(Screen_Ptr,to_Unsigned_32);

type Screen is record
   NextScreen : Screen_Ptr;
   FirstWindow : Window_Ptr;
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
   MouseY : Integer_16;
   MouseX : Integer_16;
   Flags : Unsigned_16;
   Title : Chars_Ptr;
   DefaultTitle : Integer_8_Ptr;
   BarHeight : Integer_8;
   BarVBorder : Integer_8;
   BarHBorder : Integer_8;
   MenuVBorder : Integer_8;
   MenuHBorder : Integer_8;
   WBorTop : Integer_8;
   WBorLeft : Integer_8;
   WBorRight : Integer_8;
   WBorBottom : Integer_8;
   Font : TextAttr_Ptr;
   Screen_ViewPort : ViewPort;
   Screen_RastPort : RastPort;
   Screen_BitMap : BitMap;
   LayerInfo : Layer_Info;
   FirstGadget : Gadget_Ptr;
   DetailPen : Integer_8;
   BlockPen : Integer_8;
   SaveColor0 : Integer_16;
   BarLayer : Layer_Ptr;
   ExtData : Integer_8_Ptr;
   UserData : Integer_8_Ptr;
end record;

SCREENTYPE : constant Unsigned_16 := 16#000F#;
WBENCHSCREEN : constant Unsigned_16 := 16#0001#;
PUBLICSCREEN : constant Unsigned_16 := 16#0002#;
CUSTOMSCREEN : constant Unsigned_16 := 16#000F#;
Screen_SHOWTITLE : constant Integer_16 := 16#0010#;
BEEPING : constant Integer_16 := 16#0020#;
CUSTOMBITMAP : constant Integer_16 := 16#0040#;
SCREENHIRES : constant Integer_16 := 16#0200#;
NS_EXTENDED : constant Integer_16 := 16#1000# ;
AUTOSCROLL : constant Integer_16 := 16#4000#;
STDSCREENHEIGHT : constant Integer_16 := -1;
STDSCREENWIDTH : constant Integer_16 := -1;

SA_Dummy : constant Unsigned_32 := (TAG_USER + 32);
SA_Left : constant Unsigned_32 := (SA_Dummy + 16#0001#);
SA_Top : constant Unsigned_32 := (SA_Dummy + 16#0002#);
SA_Width : constant Unsigned_32 := (SA_Dummy + 16#0003#);
SA_Height : constant Unsigned_32 := (SA_Dummy + 16#0004#);
SA_Depth : constant Unsigned_32 := (SA_Dummy + 16#0005#);
SA_DetailPen : constant Unsigned_32 := (SA_Dummy + 16#0006#);
SA_BlockPen : constant Unsigned_32 := (SA_Dummy + 16#0007#);
SA_Title : constant Unsigned_32 := (SA_Dummy + 16#0008#);
SA_Colors : constant Unsigned_32 := (SA_Dummy + 16#0009#);
SA_ErrorCode : constant Unsigned_32 := (SA_Dummy + 16#000A#);
SA_Font : constant Unsigned_32 := (SA_Dummy + 16#000B#);
SA_SysFont : constant Unsigned_32 := (SA_Dummy + 16#000C#);
SA_Type : constant Unsigned_32 := (SA_Dummy + 16#000D#);
SA_BitMap : constant Unsigned_32 := (SA_Dummy + 16#000E#);
SA_PubName : constant Unsigned_32 := (SA_Dummy + 16#000F#);
SA_PubSig : constant Unsigned_32 := (SA_Dummy + 16#0010#);
SA_PubTask : constant Unsigned_32 := (SA_Dummy + 16#0011#);
SA_DisplayID : constant Unsigned_32 := (SA_Dummy + 16#0012#);
SA_DClip : constant Unsigned_32 := (SA_Dummy + 16#0013#);
SA_Overscan : constant Unsigned_32 := (SA_Dummy + 16#0014#);
SA_Obsolete1 : constant Unsigned_32 := (SA_Dummy + 16#0015#);
SA_ShowTitle : constant Unsigned_32 := (SA_Dummy + 16#0016#);
SA_Behind : constant Unsigned_32 := (SA_Dummy + 16#0017#);
SA_Quiet : constant Unsigned_32 := (SA_Dummy + 16#0018#);
SA_AutoScroll : constant Unsigned_32 := (SA_Dummy + 16#0019#);
SA_Pens : constant Unsigned_32 := (SA_Dummy + 16#001A#);
SA_FullPalette : constant Unsigned_32 := (SA_Dummy + 16#001B#);
   
OSERR_NOMONITOR : constant Unsigned_32 := 1;
OSERR_NOCHIPS : constant Unsigned_32 := 2;
OSERR_NOMEM : constant Unsigned_32 := 3;
OSERR_NOCHIPMEM : constant Unsigned_32 := 4;
OSERR_PUBNOTUNIQUE : constant Unsigned_32 := 5;
OSERR_UNKNOWNMODE : constant Unsigned_32 := 6;

type NewScreen;
type NewScreen_Ptr is access NewScreen;
NullNewScreen_Ptr : NewScreen_Ptr := Null;
type NewScreen is record
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
   Depth : Integer_16;
   DetailPen : Integer_8;
   BlockPen : Integer_8;
   ViewModes : Unsigned_16;
   Screen_Type : Unsigned_16;
   Font : TextAttr_Ptr;
   DefaultTitle : Chars_Ptr;
   Gadgets : Gadget_Ptr;
   CustomBitMap : BitMap_Ptr;
end record;

type ExtNewScreen;
type ExtNewScreen_Ptr is access ExtNewScreen;
NullExtNewScreen_Ptr : ExtNewScreen_Ptr := Null;
type ExtNewScreen is record
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
   Depth : Integer_16;
   DetailPen : Integer_8;
   BlockPen : Integer_8;
   ViewModes : Integer_16;
   Screen_Type : Integer_16;
   Font : TextAttr_Ptr;
   DefaultTitle : Integer_8_Ptr;
   Gadgets : Gadget_Ptr;
   CustomBitMap : BitMap_Ptr;
   Extension : TagItem_Ptr;
end record;

OSCAN_TEXT : constant Unsigned_32 := 1;
OSCAN_STANDARD : constant Unsigned_32 := 2;
OSCAN_MAX : constant Unsigned_32 := 3;
OSCAN_VIDEO : constant Unsigned_32 := 4;

type PubScreenNode;
type PubScreenNode_Ptr is access PubScreenNode;
NullPubScreenNode_Ptr : PubScreenNode_Ptr := Null;
type PubScreenNode is record
   psn_Node : Node;
   psn_Screen : Screen_Ptr;
   psn_Flags : Integer_16;
   psn_Size : Integer_16;
   psn_VisitorCount : Integer_16;
   psn_SigTask : AmigaTask_Ptr;
   psn_SigBit : Integer_8;
end record;

PSNF_PRIVATE : constant Unsigned_32 := 16#0001#;
MAXPUBSCREENNAME : constant Unsigned_32 := 139;
SHANGHAI : constant Unsigned_32 := 16#0001#;
POPPUBSCREEN : constant Unsigned_32 := 16#0002#;

--end intuition_screens;

type Menu;
type Menu_Ptr is access Menu;
type Menu is record
   NextMenu :  Menu_Ptr;
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
   Flags : Unsigned_16;
   MenuName : Integer_8_Ptr;
   FirstItem : MenuItem_Ptr;
   JazzX : Integer_16;
   JazzY : Integer_16;
   BeatX : Integer_16;
   BeatY : Integer_16;
end record;

type MenuItem;
type MenuItem_Ptr is access MenuItem;
type MenuItem is record
   NextItem : MenuItem_Ptr;
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
   Flags : Integer_16;
   MutualExclude : Integer;
   ItemFill : Integer_Ptr;
   SelectFill : Integer_Ptr;
   Command : Integer_8;
   SubItem : MenuItem_Ptr;
   NextSelect : Unsigned_16;
end record;

type Requester;
type Requester_Ptr is access Requester;
type Requester is record
   OlderRequest : Requester_Ptr;
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
   RelLeft : Integer_16;
   RelTop : Integer_16;
   ReqGadget : Gadget_Ptr;
   ReqBorder : Border_Ptr;
   ReqText : IntuiText_Ptr;
   Flags : Unsigned_16;
   BackFill : Unsigned_8;
   ReqLayer : Layer_Ptr;
   ReqPad1 : Unsigned_8_Array(0..31);
   ImageBMap : BitMap_Ptr;
   RWindow : Window_Ptr;
   ReqImage : Image_Ptr;
   ReqPad2 : Unsigned_8_Array(0..31);
end record;

type Gadget is record
   NextGadget : Gadget_Ptr;
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
   Flags : Unsigned_16;
   Activation : Unsigned_16;
   GadgetType : Unsigned_16;
   GadgetRender : Integer_Ptr;
   SelectRender : Integer_Ptr;
   GadgetText : IntuiText_Ptr;
   MutualExclude : Integer;
   SpecialInfo : Integer_Ptr;
   GadgetID : Unsigned_16;
   UserData : Integer_Ptr;
end record;

type BoolInfo;
type BoolInfo_Ptr is access BoolInfo;
type BoolInfo is record
   Flags  : Unsigned_16;
   Mask   : Unsigned_16_Ptr;
   Reserved  : Unsigned_32;
end record;

type PropInfo;
type PropInfo_Ptr is access PropInfo;
type PropInfo is record
   Flags : Unsigned_16;
   HorizPot : Unsigned_16;
   VertPot : Unsigned_16;
   HorizBody : Unsigned_16;
   VertBody : Unsigned_16;
   CWidth : Unsigned_16;
   CHeight : Unsigned_16;
   HPotRes : Unsigned_16;
   VPotRes : Unsigned_16;
   LeftBorder : Unsigned_16;
   TopBorder : Unsigned_16;
end record;

type StringInfo;
type StringInfo_Ptr is access StringInfo;
type StringInfo is record
   Buffer : Unsigned_8_Ptr;
   UndoBuffer : Unsigned_8_Ptr;
   BufferPos : Integer_16;
   MaxChars : Integer_16;
   DispPos : Integer_16;
   UndoPos : Integer_16;
   NumChars : Integer_16;
   DispCount : Integer_16;
   CLeft : Integer_16;
   CTop : Integer_16;
   Extension : StringExtend_Ptr;
   IntegerInt : Integer;
   AltKeyMap : KeyMap_Ptr;
end record;

type IntuiText;
type IntuiText_Ptr is access IntuiText;
type IntuiText is record
   FrontPen : Unsigned_8;
   BackPen : Unsigned_8;
   DrawMode : Unsigned_8;
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   ITextFont : TextAttr_Ptr;
   IText : Chars_Ptr;
   NextText : IntuiText_Ptr;
end record;

type Border;
type Border_Ptr is access Border;
type Border is record
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   FrontPen : Unsigned_8;
   BackPen : Unsigned_8;
   DrawMode : Unsigned_8;
   Count : Integer_8;
   XY : Integer_16_Ptr;
   NextBorder : Border_Ptr;
end record;

type Image is record
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
   Depth : Integer_16;
   ImageData : Unsigned_16_Ptr;
   PlanePick : Unsigned_8;
   PlaneOnOff : Unsigned_8;
   NextImage : Image_Ptr;
end record;

type IntuiMessage;
type IntuiMessage_Ptr is access IntuiMessage;
NullIntuiMessage_Ptr : IntuiMessage_Ptr := NULL;

type IntuiMessage is record
   ExecMessage : Message;
   Class : Unsigned_32;
   Code : Unsigned_16;
   Qualifier : Unsigned_16;
   IAddress : Integer_Ptr;
   MouseX : Integer_16;
   MouseY : Integer_16;
   Seconds : Unsigned_32;
   Micros : Unsigned_32;
   IDCMPWindow : Window_Ptr;
   SpecialLink : IntuiMessage_Ptr;
end record;

type IBox;
type IBox_Ptr is access IBox;
type IBox is record
   Left : Integer_16;
   Top : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
end record;

type Window is record
   NextWindow : Window_Ptr;
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
   MouseY : Integer_16;
   MouseX : Integer_16;
   MinWidth : Integer_16;
   MinHeight : Integer_16;
   MaxWidth : Unsigned_16;
   MaxHeight : Unsigned_16;
   Flags : Unsigned_32;
   MenuStrip : Menu_Ptr;
   Title : Integer_8_Ptr;
   FirstRequest : Requester_Ptr;
   DMRequest : Requester_Ptr;
   ReqCount : Integer_16;
   WScreen : Screen_Ptr;
   RPort : RastPort_Ptr;
   BorderLeft : Integer_8;
   BorderTop : Integer_8;
   BorderRight : Integer_8;
   BorderBottom : Integer_8;
   BorderRPort : RastPort_Ptr;
   FirstGadget : Gadget_Ptr;
   Parent : Window_Ptr;
   Descendant : Window_Ptr;
   Pointer : Unsigned_16_Ptr;
   PtrHeight : Integer_8;
   PtrWidth : Integer_8;
   XOffset : Integer_8;
   YOffset : Integer_8;
   IDCMPFlags : Unsigned_32;
   UserPort : MsgPort_Ptr;
   WindowPort : MsgPort_Ptr;
   MessageKey : IntuiMessage_Ptr;
   DetailPen : Unsigned_8;
   BlockPen : Unsigned_8;
   CheckMark : Image_Ptr;
   ScreenTitle : Chars_Ptr;
   GZZMouseX : Integer_16;
   GZZMouseY : Integer_16;
   GZZWidth : Integer_16;
   GZZHeight : Integer_16;
   ExtData : Unsigned_8_Ptr;
   UserData : Integer_8_Ptr;
   WLayer : Layer_Ptr;
   IFont : TextFont_Ptr;
   MoreFlags : Unsigned_32;
end record;

type NewWindow;
type NewWindow_Ptr is access NewWindow;
type NewWindow is record
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
   DetailPen : Unsigned_8;
   BlockPen : Unsigned_8;
   IDCMPFlags : Unsigned_32;
   Flags : Unsigned_32;
   FirstGadget : Gadget_Ptr;
   CheckMark : Image_Ptr;
   Title : Chars_Ptr;
   Owner_Screen : Screen_Ptr;
   Window_BitMap : BitMap_Ptr;
   MinWidth : Integer_16;
   MinHeight : Integer_16;
   MaxWidth : Unsigned_16;
   MaxHeight : Unsigned_16;
   Screen_Type : Unsigned_16;
end record;

type ExtNewWindow;
type ExtNewWindow_Ptr is access ExtNewWindow;
type ExtNewWindow is record
   LeftEdge : Integer_16;
   TopEdge : Integer_16;
   Width : Integer_16;
   Height : Integer_16;
   DetailPen : Unsigned_8;
   BlockPen : Unsigned_8;
   IDCMPFlags : Unsigned_32;
   Flags : Unsigned_32;
   FirstGadget : Gadget_Ptr;
   CheckMark : Image_Ptr;
   Title : Chars_Ptr;
   Screen : Screen_Ptr;
   BitMap : BitMap_Ptr;
   MinWidth : Integer_16;
   MinHeight : Integer_16;
   MaxWidth : Unsigned_16;
   MaxHeight : Unsigned_16;
   Window_Type : Unsigned_16;
   Extension : TagItem_Ptr;
end record;

WA_Dummy : constant Unsigned_32 := (TAG_USER + 99) ;
WA_Left : constant Unsigned_32 := (WA_Dummy + 16#01#);
WA_Top : constant Unsigned_32 := (WA_Dummy + 16#02#);
WA_Width : constant Unsigned_32 := (WA_Dummy + 16#03#);
WA_Height : constant Unsigned_32 := (WA_Dummy + 16#04#);
WA_DetailPen : constant Unsigned_32 := (WA_Dummy + 16#05#);
WA_BlockPen : constant Unsigned_32 := (WA_Dummy + 16#06#);
WA_IDCMP : constant Unsigned_32 := (WA_Dummy + 16#07#);
WA_Flags : constant Unsigned_32 := (WA_Dummy + 16#08#);
WA_Gadgets : constant Unsigned_32 := (WA_Dummy + 16#09#);
WA_Checkmark : constant Unsigned_32 := (WA_Dummy + 16#0A#);
WA_Title : constant Unsigned_32 := (WA_Dummy + 16#0B#);
WA_ScreenTitle : constant Unsigned_32 := (WA_Dummy + 16#0C#);
WA_CustomScreen : constant Unsigned_32 := (WA_Dummy + 16#0D#);
WA_SuperBitMap : constant Unsigned_32 := (WA_Dummy + 16#0E#);
WA_MinWidth : constant Unsigned_32 := (WA_Dummy + 16#0F#);
WA_MinHeight : constant Unsigned_32 := (WA_Dummy + 16#10#);
WA_MaxWidth : constant Unsigned_32 := (WA_Dummy + 16#11#);
WA_MaxHeight : constant Unsigned_32 := (WA_Dummy + 16#12#);
WA_InnerWidth : constant Unsigned_32 := (WA_Dummy + 16#13#);
WA_InnerHeight : constant Unsigned_32 := (WA_Dummy + 16#14#);
WA_PubScreenName : constant Unsigned_32 := (WA_Dummy + 16#15#);
WA_PubScreen : constant Unsigned_32 := (WA_Dummy + 16#16#);
WA_PubScreenFallBack : constant Unsigned_32 := (WA_Dummy + 16#17#);
WA_WindowName : constant Unsigned_32 := (WA_Dummy + 16#18#);
WA_Colors : constant Unsigned_32 := (WA_Dummy + 16#19#);
WA_Zoom : constant Unsigned_32 := (WA_Dummy + 16#1A#);
WA_MouseQueue : constant Unsigned_32 := (WA_Dummy + 16#1B#);
WA_BackFill : constant Unsigned_32 := (WA_Dummy + 16#1C#);
WA_RptQueue : constant Unsigned_32 := (WA_Dummy + 16#1D#);
WA_SizeGadget : constant Unsigned_32 := (WA_Dummy + 16#1E#);
WA_DragBar : constant Unsigned_32 := (WA_Dummy + 16#1F#);
WA_DepthGadget : constant Unsigned_32 := (WA_Dummy + 16#20#);
WA_CloseGadget : constant Unsigned_32 := (WA_Dummy + 16#21#);
WA_Backdrop : constant Unsigned_32 := (WA_Dummy + 16#22#);
WA_ReportMouse : constant Unsigned_32 := (WA_Dummy + 16#23#);
WA_NoCareRefresh : constant Unsigned_32 := (WA_Dummy + 16#24#);
WA_Borderless : constant Unsigned_32 := (WA_Dummy + 16#25#);
WA_Activate : constant Unsigned_32 := (WA_Dummy + 16#26#);
WA_RMBTrap : constant Unsigned_32 := (WA_Dummy + 16#27#);
WA_WBenchWindow : constant Unsigned_32 := (WA_Dummy + 16#28#) ;
WA_SimpleRefresh : constant Unsigned_32 := (WA_Dummy + 16#29#);
WA_SmartRefresh : constant Unsigned_32 := (WA_Dummy + 16#2A#);
WA_SizeBRight : constant Unsigned_32 := (WA_Dummy + 16#2B#);
WA_SizeBBottom : constant Unsigned_32 := (WA_Dummy + 16#2C#);
WA_AutoAdjust : constant Unsigned_32 := (WA_Dummy + 16#2D#);
WA_GimmeZeroZero : constant Unsigned_32 := (WA_Dummy + 16#2E#);
WA_MenuHelp : constant Unsigned_32 := (WA_Dummy + 16#2F#);

type Remember;
type Remember_Ptr is access Remember;
type Remember is record
   NextRemember : Remember_Ptr;
   RememberSize : Unsigned_32;
   Memory : Unsigned_8_Ptr;
end record;

type ColorSpec;
type ColorSpec_Ptr is access ColorSpec;
type ColorSpec  is record
   ColorIndex : Unsigned_16;
   Red : Unsigned_16;
   Green : Unsigned_16;
   Blue : Unsigned_16;
end record;

type Easy;
type Easy_Ptr is access Easy;
type Easy is record
   es_StructSize : Unsigned_32;
   es_Flags : Unsigned_32;
   es_Title : Unsigned_8_Ptr;
   es_TextFormat : Unsigned_8_Ptr;
   es_GadgetFormat : Unsigned_8_Ptr;
end record;

MENUENABLED : constant Unsigned_32 := 16#0001#;
MIDRAWN : constant Unsigned_32 := 16#0100#;
CHECKIT : constant Unsigned_32		:= 16#0001#;
ITEMTEXT : constant Unsigned_32	:= 16#0002#;
COMMSEQ : constant Unsigned_32		:= 16#0004#;
MENUTOGGLE : constant Unsigned_32	:= 16#0008#;
ITEMENABLED : constant Unsigned_32	:= 16#0010#;
HIGHFLAGS : constant Unsigned_32	:= 16#00C0#;
HIGHIMAGE : constant Unsigned_32	:= 16#0000#;
HIGHCOMP : constant Unsigned_32	:= 16#0040#;
HIGHBOX : constant Unsigned_32		:= 16#0080#;
HIGHNONE : constant Unsigned_32	:= 16#00C0#;
CHECKED : constant Unsigned_32	:= 16#0100#;
ISDRAWN : constant Unsigned_32		:= 16#1000#;
HIGHITEM : constant Unsigned_32	:= 16#2000#;
MENUTOGGLED : constant Unsigned_32	:= 16#4000#;
POINTREL : constant Unsigned_32	:= 16#0001#;
PREDRAWN : constant Unsigned_32	:= 16#0002#;
NOISYREQ : constant Unsigned_32	:= 16#0004#;
SIMPLEREQ : constant Unsigned_32	:= 16#0010#;
USEREQIMAGE : constant Unsigned_32	:= 16#0020#;
NOREQBACKFILL : constant Unsigned_32	:= 16#0040#;
REQOFFWINDOW : constant Unsigned_32	:= 16#1000#;
REQACTIVE : constant Unsigned_32	:= 16#2000#;
SYSREQUEST : constant Unsigned_32	:= 16#4000#;
DEFERREFRESH : constant Unsigned_32	:= 16#8000#;
GFLG_GADGHIGHBITS : constant Unsigned_32 := 16#0003#;
GFLG_GADGHCOMP : constant Unsigned_32	  := 16#0000#;
GFLG_GADGHB16 : constant Unsigned_32 := 16#0001#;
GFLG_GADGHIMAGE : constant Unsigned_32	  := 16#0002#;
GFLG_GADGHNONE : constant Unsigned_32	  := 16#0003#;
GFLG_RELBOTTOM : constant Unsigned_32	  := 16#0008#;
GFLG_RELRIGHT : constant Unsigned_32	  := 16#0010#;
GFLG_RELWIDTH : constant Unsigned_32	  := 16#0020#;
GFLG_RELHEIGHT : constant Unsigned_32	  := 16#0040#;
GFLG_SELECTED : constant Unsigned_32	  := 16#0080#;
GFLG_DISABLED : constant Unsigned_32	  := 16#0100#;
GFLG_LABELMASK : constant Unsigned_32	  := 16#3000#;
GFLG_LABELITEXT : constant Unsigned_32         := 16#0000#;
GFLG_LABELSTRING : constant Unsigned_32  := 16#1000#;
GFLG_LABELIMAGE : constant Unsigned_32	  := 16#2000#;
GFLG_STRINGEXTEND : constant Unsigned_32  := 16#0400#;
GACT_RELVERIFY : constant Unsigned_32 	  := 16#0001#;
GACT_IMMEDIATE : constant Unsigned_32	  := 16#0002#;
GACT_ENDGADGET : constant Unsigned_32	  := 16#0004#;
GACT_FOLLOWMOUSE : constant Unsigned_32  := 16#0008#;
GACT_RIGHTBORDER : constant Unsigned_32  := 16#0010#;
GACT_LEFTBORDER : constant Unsigned_32 	  := 16#0020#;
GACT_TOPBORDER : constant Unsigned_32 	  := 16#0040#;
GACT_BOTTOMBORDER : constant Unsigned_32 := 16#0080#;
GACT_BORDERSNIFF  : constant Unsigned_32 := 16#8000#;
GACT_TOGGLESELECT : constant Unsigned_32 := 16#0100#;
GACT_BOOLEXTEND	  : constant Unsigned_32:= 16#2000#;
GACT_STRINGLEFT	  : constant Unsigned_32:= 16#0000#;
GACT_STRINGCENTER : constant Unsigned_32:= 16#0200#;
GACT_STRINGRIGHT  : constant Unsigned_32:= 16#0400#;
GACT_LONGINT	  : constant Unsigned_32:= 16#0800#;
GACT_ALTKEYMAP	  : constant Unsigned_32:= 16#1000#;
GACT_STRINGEXTEND : constant Unsigned_32:= 16#2000#;
GTYP_GADGETTYPE : constant Unsigned_32:=	16#FC00#;
GTYP_SYSGADGET : constant Unsigned_32:=	16#8000#;
GTYP_SCRGADGET : constant Unsigned_32:=	16#4000#;
GTYP_GZZGADGET : constant Unsigned_32:=	16#2000#;
GTYP_REQGADGET : constant Unsigned_32:=	16#1000#;
GTYP_SIZING : constant Unsigned_32:=	16#0010#;
GTYP_WDRAGGING : constant Unsigned_32:=	16#0020#;
GTYP_SDRAGGING : constant Unsigned_32:=	16#0030#;
GTYP_WUPFRONT : constant Unsigned_32:=	16#0040#;
GTYP_SUPFRONT : constant Unsigned_32:=	16#0050#;
GTYP_WDOWNBACK : constant Unsigned_32:=	16#0060#;
GTYP_SDOWNBACK : constant Unsigned_32:=	16#0070#;
GTYP_CLOSE : constant Unsigned_32:=	16#0080#;
GTYP_BOOLGADGET : constant Unsigned_32:=	16#0001#;
GTYP_GADGET0002 : constant Unsigned_32:=	16#0002#;
GTYP_PROPGADGET : constant Unsigned_32:=	16#0003#;
GTYP_STRGADGET : constant Unsigned_32:=	16#0004#;
GTYP_CUSTOMGADGET : constant Unsigned_32:=	16#0005#;
GTYP_GTYPEMASK : constant Unsigned_32:=	16#0007#;
BOOLMASK : constant Unsigned_32:=	16#0001#;
AUTOKNOB : constant Unsigned_32:=	16#0001#;
FREEHORIZ : constant Unsigned_32:=	16#0002#;
FREEVERT : constant Unsigned_32:=	16#0004#;
PROPBORDERLESS : constant Unsigned_32:=	16#0008#;
KNOBHIT	 : constant Unsigned_32:=	16#0100#;
MAXBODY	 : constant Unsigned_32:=	16#FFFF#;
MAXPOT		 : constant Unsigned_32:=	16#FFFF#;
IDCMP_SIZEVERIFY : constant Unsigned_32:=	16#00000001#;
IDCMP_NEWSIZE	 : constant Unsigned_32:=	16#00000002#;
IDCMP_REFRESHWINDOW : constant Unsigned_32:=	16#00000004#;
IDCMP_MOUSEBUTTONS : constant Unsigned_32:=	16#00000008#;
IDCMP_MOUSEMOVE	 : constant Unsigned_32:=	16#00000010#;
IDCMP_GADGETDOWN : constant Unsigned_32:=	16#00000020#;
IDCMP_GADGETUP	 : constant Unsigned_32:=	16#00000040#;
IDCMP_REQSET	 : constant Unsigned_32:=	16#00000080#;
IDCMP_MENUPICK	 : constant Unsigned_32:=	16#00000100#;
IDCMP_CLOSEWINDOW : constant Unsigned_32:=	16#00000200#;
IDCMP_RAWKEY	 : constant Unsigned_32:=	16#00000400#;
IDCMP_REQVERIFY	 : constant Unsigned_32:=	16#00000800#;
IDCMP_REQCLEAR	 : constant Unsigned_32:=	16#00001000#;
IDCMP_MENUVERIFY : constant Unsigned_32:=	16#00002000#;
IDCMP_NEWPREFS	 : constant Unsigned_32:=	16#00004000#;
IDCMP_DISKINSERTED : constant Unsigned_32:=	16#00008000#;
IDCMP_DISKREMOVED : constant Unsigned_32:=	16#00010000#;
IDCMP_WBENCHMESSAGE : constant Unsigned_32:=	16#00020000#;
IDCMP_ACTIVEWINDOW : constant Unsigned_32:=	16#00040000#;
IDCMP_INACTIVEWINDOW : constant Unsigned_32:=	16#00080000#;
IDCMP_DELTAMOVE	 : constant Unsigned_32:=	16#00100000#;
IDCMP_VANILLAKEY : constant Unsigned_32:=	16#00200000#;
IDCMP_INTUITICKS : constant Unsigned_32:=	16#00400000#;
IDCMP_IDCMPUPDATE : constant Unsigned_32:=	16#00800000#;
IDCMP_MENUHELP	 : constant Unsigned_32:=	16#01000000#;
IDCMP_CHANGEWINDOW : constant Unsigned_32:=	16#02000000#;
IDCMP_LONELYMESSAGE : constant Unsigned_32:= 16#80000000#;
MENUHOT	 : constant Unsigned_32:=	16#0001#;
MENUCANCEL : constant Unsigned_32:=	16#0002#;
MENUWAITING : constant Unsigned_32:=	16#0003#;
OKABORT	 : constant Unsigned_32:=	16#0004#;
WBENCHOPEN : constant Unsigned_32:=	16#0001#;
WBENCHCLOSE : constant Unsigned_32:=	16#0002#;
WFLG_SIZEGADGET	    : constant Unsigned_32:= 16#00000001#;
WFLG_DRAGBAR	    : constant Unsigned_32:= 16#00000002#;
WFLG_DEPTHGADGET    : constant Unsigned_32:= 16#00000004#;
WFLG_CLOSEGADGET    : constant Unsigned_32:= 16#00000008#;
WFLG_SIZEBRIGHT	    : constant Unsigned_32:= 16#00000010#;
WFLG_SIZEBBOTTOM    : constant Unsigned_32:= 16#00000020#;
WFLG_REFRESHBITS    : constant Unsigned_32:= 16#000000C0#;
WFLG_SMART_REFRESH  : constant Unsigned_32:= 16#00000000#;
WFLG_SIMPLE_REFRESH : constant Unsigned_32:= 16#00000040#;
WFLG_SUPER_BITMAP   : constant Unsigned_32:= 16#00000080#;
WFLG_OTHER_REFRESH  : constant Unsigned_32:= 16#000000C0#;
WFLG_BACKDROP	    : constant Unsigned_32:= 16#00000100#;
WFLG_REPORTMOUSE    : constant Unsigned_32:= 16#00000200#;
WFLG_GIMMEZEROZERO  : constant Unsigned_32:= 16#00000400#;
WFLG_BORDERLESS	    : constant Unsigned_32:= 16#00000800#;
WFLG_ACTIVATE	    : constant Unsigned_32:= 16#00001000#;
WFLG_WINDOWACTIVE   : constant Unsigned_32:= 16#00002000#;
WFLG_INREQUEST	    : constant Unsigned_32:= 16#00004000#;
WFLG_MENUSTATE	    : constant Unsigned_32:= 16#00008000#;
WFLG_RMBTRAP	    : constant Unsigned_32:= 16#00010000#;
WFLG_NOCAREREFRESH  : constant Unsigned_32:= 16#00020000#;
WFLG_WINDOWREFRESH  : constant Unsigned_32:= 16#01000000#;
WFLG_WBENCHWINDOW   : constant Unsigned_32:= 16#02000000#;
WFLG_WINDOWTICKED   : constant Unsigned_32:= 16#04000000#;
WFLG_NW_EXTENDED    : constant Unsigned_32:= 16#00040000#;
WFLG_VISITOR	    : constant Unsigned_32:= 16#08000000#;
WFLG_ZOOMED	    : constant Unsigned_32:= 16#10000000#;
WFLG_HASZOOM	    : constant Unsigned_32:= 16#20000000#;
NOMENU : constant Unsigned_32:= 16#001F#;
NOITEM : constant Unsigned_32:= 16#003F#;
NOSUB  : constant Unsigned_32:= 16#001F#;
MENUNULL : constant Unsigned_32:= 16#FFFF#;
CHECKWIDTH : constant Unsigned_32 :=	19;
COMMWIDTH : constant Unsigned_32 :=	27;
LOWCHECKWIDTH : constant Unsigned_32 := 13;
LOWCOMMWIDTH : constant Unsigned_32 := 16;
ALERT_TYPE : constant Unsigned_32:=	16#80000000#;
RECOVERY_ALERT : constant Unsigned_32:=	16#00000000#;
DEADEND_ALERT : constant Unsigned_32:=	16#80000000#;
AUTOFRONTPEN : constant Unsigned_32 :=	0;
AUTOBACKPEN : constant Unsigned_32 :=	1;

JAM2 : constant Unsigned_32 := 1; -- should be in graphics_RastPort

AUTODRAWMODE : constant Unsigned_32 :=	JAM2;
AUTOLEFTEDGE : constant Unsigned_32 :=	6;
AUTOTOPEDGE : constant Unsigned_32 :=	3;
AUTOITEXTFONT : constant Unsigned_32 :=	0;
AUTONEXTTEXT : constant Unsigned_32 :=	0;
SELECTUP : constant Unsigned_32 :=	(IECODE_LBUTTON + IECODE_UP_PREFIX);
SELECTDOWN : constant Unsigned_32 :=	(IECODE_LBUTTON);
MENUUP : constant Unsigned_32 :=		(IECODE_RBUTTON + IECODE_UP_PREFIX);
MENUDOWN : constant Unsigned_32 :=	(IECODE_RBUTTON);
MIDDLEDOWN : constant Unsigned_32 :=	(IECODE_MBUTTON);
MIDDLEUP : constant Unsigned_32 :=	(IECODE_MBUTTON + IECODE_UP_PREFIX);
ALTLEFT : constant Unsigned_32 :=		(IEQUALIFIER_LALT);
ALTRIGHT : constant Unsigned_32 :=	(IEQUALIFIER_RALT);
AMIGALEFT : constant Unsigned_32 :=	(IEQUALIFIER_LCOMMAND);
AMIGARIGHT : constant Unsigned_32 :=	(IEQUALIFIER_RCOMMAND);
AMIGAKEYS : constant Unsigned_32 :=	(AMIGALEFT + AMIGARIGHT);

CURSORUP : constant Unsigned_32:=	16#4C#;
CURSORLEFT : constant Unsigned_32:=	16#4F#;
CURSORRIGHT : constant Unsigned_32:=	16#4E#;
CURSORDOWN : constant Unsigned_32:=	16#4D#;
KEYCODE_Q : constant Unsigned_32:=	16#10#;
KEYCODE_Z : constant Unsigned_32:=	16#31#;
KEYCODE_X : constant Unsigned_32:=	16#32#;
KEYCODE_V : constant Unsigned_32:=	16#34#;
KEYCODE_B : constant Unsigned_32:=	16#35#;
KEYCODE_N : constant Unsigned_32:=	16#36#;
KEYCODE_M : constant Unsigned_32:=	16#37#;
KEYCODE_LESS : constant Unsigned_32:=	16#38#;
KEYCODE_GREATER : constant Unsigned_32:= 16#39#;

function ActivateGadget (  gadgets : Gadget_Ptr; window : Window_Ptr; requester : Requester_Ptr) return Boolean;
pragma IMPORT (C, ActivateGadget, "ActivateGadget");
procedure ActivateWindow (  window : Window_Ptr);
pragma IMPORT (C, ActivateWindow, "ActivateWindow");
procedure AddClass (  class_Ptr : IClass_Ptr);
pragma IMPORT (C, AddClass, "AddClass");
function AddGList (  window : Window_Ptr; gadget : Gadget_Ptr; position : Integer;numGad : Integer; requester : Requester_Ptr) return Integer_16;
pragma IMPORT (C, AddGList, "AddGList");
function AddGadget (  window : Window_Ptr; gadget : Gadget_Ptr; position : Integer) return Integer_16;
pragma IMPORT (C, AddGadget, "AddGadget");
function AllocRemember (  rememberKey : Remember_Ptr_Ptr; size : Integer; flags : Integer) return Integer_Ptr;
pragma IMPORT (C, AllocRemember, "AllocRemember");
function AllocScreenBuffer (  sc : Screen_Ptr; bm : BitMap_Ptr; flags : Integer) return  ScreenBuffer_Ptr;
pragma IMPORT (C, AllocScreenBuffer, "AllocScreenBuffer");
procedure AlohaWorkbench ( wbport : Integer);
pragma IMPORT (C, AlohaWorkbench, "AlohaWorkbench");
function AutoRequest (  window : Window_Ptr; TextBody : IntuiText_Ptr; posText : IntuiText_Ptr; negText : IntuiText_Ptr; pFlag : Integer; nFlag : Integer; width : Integer; height : Integer) return Boolean;
pragma IMPORT (C, AutoRequest, "AutoRequest");
procedure BeginRefresh (  window : Window_Ptr);
pragma IMPORT (C, BeginRefresh, "BeginRefresh");
function BuildEasyRequestArgs (  window : Window_Ptr; easy : Easy_Ptr; idcmp : Integer;args : Integer_Ptr) return  Window_Ptr;
pragma IMPORT (C, BuildEasyRequestArgs, "BuildEasyRequestArgs");
function BuildSysRequest (  window : Window_Ptr; TextBody : IntuiText_Ptr; posText : IntuiText_Ptr; negText : IntuiText_Ptr; flags : Integer; width : Integer; height : Integer) return  Window_Ptr;
pragma IMPORT (C, BuildSysRequest, "BuildSysRequest");
function ChangeScreenBuffer (  sc : Screen_Ptr; sb : ScreenBuffer_Ptr) return Integer;
pragma IMPORT (C, ChangeScreenBuffer, "ChangeScreenBuffer");
procedure ChangeWindowBox (  window : Window_Ptr;left : Integer;top : Integer;width : Integer;height : Integer);
pragma IMPORT (C, ChangeWindowBox, "ChangeWindowBox");
function ClearDMRequest (  window : Window_Ptr) return Boolean;
pragma IMPORT (C, ClearDMRequest, "ClearDMRequest");
procedure ClearMenuStrip (  window : Window_Ptr);
pragma IMPORT (C, ClearMenuStrip, "ClearMenuStrip");
procedure ClearPointer (  window : Window_Ptr);
pragma IMPORT (C, ClearPointer, "ClearPointer");
function CloseScreen (  screen : Screen_Ptr) return Boolean;
pragma IMPORT (C, CloseScreen, "CloseScreen");
procedure CloseWindow (  window : Window_Ptr);
pragma IMPORT (C, CloseWindow, "CloseWindow");
function CloseWorkBench  return INTEGER;
pragma IMPORT (C, CloseWorkBench, "CloseWorkBench");
procedure CurrentTime ( seconds : Integer_Ptr;micros : Integer_Ptr);
pragma IMPORT (C, CurrentTime, "CurrentTime");
function DisplayAlert (  alertNumber : Integer;string : Chars_Ptr; height : Integer) return Boolean;
pragma IMPORT (C, DisplayAlert, "DisplayAlert");
procedure DisplayBeep (  screen : Screen_Ptr);
pragma IMPORT (C, DisplayBeep, "DisplayBeep");
procedure DisposeObject ( object : Integer_Ptr);
pragma IMPORT (C, DisposeObject, "DisposeObject");
function DoubleClick (  sSeconds : Integer; sMicros : Integer; cSeconds : Integer; cMicros : Integer) return Boolean;
pragma IMPORT (C, DoubleClick, "DoubleClick");
procedure DrawBorder (  rp : RastPort_Ptr; border : Border_Ptr;leftOffset : Integer;topOffset : Integer);
pragma IMPORT (C, DrawBorder, "DrawBorder");
procedure DrawImage (  rp : RastPort_Ptr; image : Image_Ptr;leftOffset : Integer;topOffset : Integer);
pragma IMPORT (C, DrawImage, "DrawImage");
procedure DrawImageState (  rp : RastPort_Ptr; image : Image_Ptr;leftOffset : Integer;topOffset : Integer; state : Integer; drawInfo : DrawInfo_Ptr);
pragma IMPORT (C, DrawImageState, "DrawImageState");
function EasyRequestArgs (  window : Window_Ptr; easy : Easy_Ptr;idcmp_Ptr : Integer_Ptr;args : Integer_Ptr) return INTEGER;
pragma IMPORT (C, EasyRequestArgs, "EasyRequestArgs");
procedure EndRefresh (  window : Window_Ptr;complete : Integer);
pragma IMPORT (C, EndRefresh, "EndRefresh");
procedure EndRequest (  requester : Requester_Ptr; window : Window_Ptr);
pragma IMPORT (C, EndRequest, "EndRequest");
procedure EraseImage (  rp : RastPort_Ptr; image : Image_Ptr;leftOffset : Integer;topOffset : Integer);
pragma IMPORT (C, EraseImage, "EraseImage");
function FreeClass (  class_Ptr : IClass_Ptr) return Boolean;
pragma IMPORT (C, FreeClass, "FreeClass");
procedure FreeRemember (  rememberKey : Remember_Ptr_Ptr;reallyForget : Integer);
pragma IMPORT (C, FreeRemember, "FreeRemember");
procedure FreeScreenBuffer (  sc : Screen_Ptr; sb : ScreenBuffer_Ptr);
pragma IMPORT (C, FreeScreenBuffer, "FreeScreenBuffer");
procedure FreeScreenDrawInfo (  screen : Screen_Ptr; drawInfo : DrawInfo_Ptr);
pragma IMPORT (C, FreeScreenDrawInfo, "FreeScreenDrawInfo");
procedure FreeSysRequest (  window : Window_Ptr);
pragma IMPORT (C, FreeSysRequest, "FreeSysRequest");
procedure GadgetMouse (  gadget : Gadget_Ptr; gInfo : GadgetInfo_Ptr;mousePoint : Integer_16_Ptr);
pragma IMPORT (C, GadgetMouse, "GadgetMouse");
function GetAttr ( attrID : Unsigned_32; object : Object_Ptr; Storage_Ptr : System.Address) return Integer;
pragma IMPORT (C, GetAttr, "GetAttr");
function GetDefPrefs (  preferences : Preferences_Ptr;size : Integer) return  Preferences_Ptr;
pragma IMPORT (C, GetDefPrefs, "GetDefPrefs");
procedure GetDefaultPubScreen ( nameBuffer : Chars_Ptr);
pragma IMPORT (C, GetDefaultPubScreen, "GetDefaultPubScreen");
function GetPrefs (  preferences : Preferences_Ptr;size : Integer) return  Preferences_Ptr;
pragma IMPORT (C, GetPrefs, "GetPrefs");
function GetScreenData ( buffer : Integer_Ptr; size : Integer; ScreenType : Integer; screen : Screen_Ptr) return INTEGER;
pragma IMPORT (C, GetScreenData, "GetScreenData");
function GetScreenDrawInfo (  screen : Screen_Ptr) return  DrawInfo_Ptr;
pragma IMPORT (C, GetScreenDrawInfo, "GetScreenDrawInfo");
procedure HelpControl (  win : Window_Ptr; flags : Integer);
pragma IMPORT (C, HelpControl, "HelpControl");
procedure InitRequester (  requester : Requester_Ptr);
pragma IMPORT (C, InitRequester, "InitRequester");
function IntuiTextLength (  iText : IntuiText_Ptr) return INTEGER;
pragma IMPORT (C, IntuiTextLength, "IntuiTextLength");
function ItemAddress (  menuStrip : Menu_Ptr; menuNumber : Integer) return  MenuItem_Ptr;
pragma IMPORT (C, ItemAddress, "ItemAddress");
procedure LendMenus (  fromwindow : Window_Ptr; towindow : Window_Ptr);
pragma IMPORT (C, LendMenus, "LendMenus");
function LockIBase (  dontknow : Integer) return Integer;
pragma IMPORT (C, LockIBase, "LockIBase");
function LockPubScreen ( name : Chars_Ptr) return  Screen_Ptr;
pragma IMPORT (C, LockPubScreen, "LockPubScreen");
function LockPubScreenList  return  List_Ptr;
pragma IMPORT (C, LockPubScreenList, "LockPubScreenList");
function MakeClass ( classID : Chars_Ptr;superClassID : Chars_Ptr; superClass_Ptr : IClass_Ptr; instanceSize : Integer; flags : Integer) return  IClass_Ptr;
pragma IMPORT (C, MakeClass, "MakeClass");
function MakeScreen (  screen : Screen_Ptr) return INTEGER;
pragma IMPORT (C, MakeScreen, "MakeScreen");
function ModifyIDCMP (  window : Window_Ptr; flags : Integer) return Boolean;
pragma IMPORT (C, ModifyIDCMP, "ModifyIDCMP");
procedure ModifyProp (  gadget : Gadget_Ptr; window : Window_Ptr; requester : Requester_Ptr; flags : Integer; horizPot : Integer; vertPot : Integer; horizBody : Integer; vertBody : Integer);
pragma IMPORT (C, ModifyProp, "ModifyProp");
procedure MoveScreen (  screen : Screen_Ptr;dx : Integer;dy : Integer);
pragma IMPORT (C, MoveScreen, "MoveScreen");
procedure MoveWindow (  window : Window_Ptr;dx : Integer;dy : Integer);
pragma IMPORT (C, MoveWindow, "MoveWindow");
procedure MoveWindowInFrontOf (  window : Window_Ptr; behindWindow : Window_Ptr);
pragma IMPORT (C, MoveWindowInFrontOf, "MoveWindowInFrontOf");
procedure NewModifyProp (  gadget : Gadget_Ptr; window : Window_Ptr; requester : Requester_Ptr; flags : Integer; horizPot : Integer; vertPot : Integer; horizBody : Integer; vertBody : Integer;numGad : Integer);
pragma IMPORT (C, NewModifyProp, "NewModifyProp");
function NextObject ( object_Ptr_Ptr : Integer_Ptr) return Integer_Ptr;
pragma IMPORT (C, NextObject, "NextObject");
function NextPubScreen (  screen : Screen_Ptr;namebuf : Chars_Ptr) return Chars_Ptr;
pragma IMPORT (C, NextPubScreen, "NextPubScreen");
function ObtainGIRPort (  gInfo : GadgetInfo_Ptr) return  RastPort_Ptr;
pragma IMPORT (C, ObtainGIRPort, "ObtainGIRPort");
procedure OffGadget (  gadget : Gadget_Ptr; window : Window_Ptr; requester : Requester_Ptr);
pragma IMPORT (C, OffGadget, "OffGadget");
procedure OffMenu (  window : Window_Ptr; menuNumber : Integer);
pragma IMPORT (C, OffMenu, "OffMenu");
procedure OnGadget (  gadget : Gadget_Ptr; window : Window_Ptr; requester : Requester_Ptr);
pragma IMPORT (C, OnGadget, "OnGadget");
procedure OnMenu (  window : Window_Ptr; menuNumber : Integer);
pragma IMPORT (C, OnMenu, "OnMenu");
procedure OpenIntuition ;
pragma IMPORT (C, OpenIntuition, "OpenIntuition");
function OpenScreen (  newScreen : NewScreen_Ptr) return  Screen_Ptr;
pragma IMPORT (C, OpenScreen, "OpenScreen");
function OpenWindow (  newWindow : NewWindow_Ptr) return  Window_Ptr;
pragma IMPORT (C, OpenWindow, "OpenWindow");
function OpenWorkBench  return Integer;
pragma IMPORT (C, OpenWorkBench, "OpenWorkBench");
function PointInImage (  point : Integer; image : Image_Ptr) return Boolean;
pragma IMPORT (C, PointInImage, "PointInImage");
procedure PrintIText (  rp : RastPort_Ptr; iText : IntuiText_Ptr;left : Integer;top : Integer);
pragma IMPORT (C, PrintIText, "PrintIText");
function PubScreenStatus (  screen : Screen_Ptr; statusFlags : Integer) return Integer_16;
pragma IMPORT (C, PubScreenStatus, "PubScreenStatus");
function QueryOverscan (  displayID : Integer; rect : Rectangle_Ptr;oScanType : Integer) return INTEGER;
pragma IMPORT (C, QueryOverscan, "QueryOverscan");
procedure RefreshGList (  gadgets : Gadget_Ptr; window : Window_Ptr; requester : Requester_Ptr;numGad : Integer);
pragma IMPORT (C, RefreshGList, "RefreshGList");
procedure RefreshGadgets (  gadgets : Gadget_Ptr; window : Window_Ptr; requester : Requester_Ptr);
pragma IMPORT (C, RefreshGadgets, "RefreshGadgets");
procedure RefreshWindowFrame (  window : Window_Ptr);
pragma IMPORT (C, RefreshWindowFrame, "RefreshWindowFrame");
procedure ReleaseGIRPort (  rp : RastPort_Ptr);
pragma IMPORT (C, ReleaseGIRPort, "ReleaseGIRPort");
function RemakeDisplay  return INTEGER;
pragma IMPORT (C, RemakeDisplay, "RemakeDisplay");
procedure RemoveClass (  class_Ptr : IClass_Ptr);
pragma IMPORT (C, RemoveClass, "RemoveClass");
function RemoveGList (  rem_Ptr : Window_Ptr; gadget : Gadget_Ptr;numGad : Integer) return Integer_16;
pragma IMPORT (C, RemoveGList, "RemoveGList");
function RemoveGadget (  window : Window_Ptr; gadget : Gadget_Ptr) return Integer_16;
pragma IMPORT (C, RemoveGadget, "RemoveGadget");
procedure ReportMouse ( flag : Integer; window : Window_Ptr);
pragma IMPORT (C, ReportMouse, "ReportMouse");
function Request (  requester : Requester_Ptr; window : Window_Ptr) return Boolean;
pragma IMPORT (C, Request, "Request");
function ResetMenuStrip (  window : Window_Ptr; menu : Menu_Ptr) return Boolean;
pragma IMPORT (C, ResetMenuStrip, "ResetMenuStrip");
function RethinkDisplay  return INTEGER;
pragma IMPORT (C, RethinkDisplay, "RethinkDisplay");
procedure ScreenDepth (  screen : Screen_Ptr; flags : Integer;reserved : Integer_Ptr);
pragma IMPORT (C, ScreenDepth, "ScreenDepth");
procedure ScreenPosition (  screen : Screen_Ptr; flags : Integer;x1 : Integer;y1 : Integer;x2 : Integer;y2 : Integer);
pragma IMPORT (C, ScreenPosition, "ScreenPosition");
procedure ScreenToBack (  screen : Screen_Ptr);
pragma IMPORT (C, ScreenToBack, "ScreenToBack");
procedure ScreenToFront (  screen : Screen_Ptr);
pragma IMPORT (C, ScreenToFront, "ScreenToFront");
procedure ScrollWindowRaster (  win : Window_Ptr;dx : Integer;dy : Integer;xMin : Integer;yMin : Integer;xMax : Integer;yMax : Integer);
pragma IMPORT (C, ScrollWindowRaster, "ScrollWindowRaster");
function SetDMRequest (  window : Window_Ptr; requester : Requester_Ptr) return Boolean;
pragma IMPORT (C, SetDMRequest, "SetDMRequest");
procedure SetDefaultPubScreen ( name : Chars_Ptr);
pragma IMPORT (C, SetDefaultPubScreen, "SetDefaultPubScreen");
function SetEditHook (  hook : Hook_Ptr) return  Hook_Ptr;
pragma IMPORT (C, SetEditHook, "SetEditHook");
function SetMenuStrip (  window : Window_Ptr; menu : Menu_Ptr) return Boolean;
pragma IMPORT (C, SetMenuStrip, "SetMenuStrip");
function SetMouseQueue (  window : Window_Ptr; queueLength : Integer) return INTEGER;
pragma IMPORT (C, SetMouseQueue, "SetMouseQueue");
procedure SetPointer (  window : Window_Ptr;pointer : Integer_16_Ptr;height : Integer;width : Integer;xOffset : Integer;yOffset : Integer);
pragma IMPORT (C, SetPointer, "SetPointer");
function SetPrefs (  preferences : Preferences_Ptr;size : Integer;inform : Integer) return  Preferences_Ptr;
pragma IMPORT (C, SetPrefs, "SetPrefs");
function SetPubScreenModes (  modes : Integer) return Integer_16;
pragma IMPORT (C, SetPubScreenModes, "SetPubScreenModes");
procedure SetWindowTitles (  window : Window_Ptr;windowTitle : Chars_Ptr;screenTitle : Chars_Ptr);
pragma IMPORT (C, SetWindowTitles, "SetWindowTitles");
procedure ShowTitle (  screen : Screen_Ptr;showIt : Integer);
pragma IMPORT (C, ShowTitle, "ShowTitle");
procedure SizeWindow (  window : Window_Ptr;dx : Integer;dy : Integer);
pragma IMPORT (C, SizeWindow, "SizeWindow");
function SysReqHandler (  window : Window_Ptr;idcmp_Ptr : Integer_Ptr;waitInput : Integer) return INTEGER;
pragma IMPORT (C, SysReqHandler, "SysReqHandler");
function TimedDisplayAlert (  alertNumber : Integer;string : Chars_Ptr; height : Integer; time : Integer) return Boolean;
pragma IMPORT (C, TimedDisplayAlert, "TimedDisplayAlert");
procedure UnlockIBase ( ibLock : Integer);
pragma IMPORT (C, UnlockIBase, "UnlockIBase");
procedure UnlockPubScreen ( name : Chars_Ptr; screen : Screen_Ptr);
pragma IMPORT (C, UnlockPubScreen, "UnlockPubScreen");
procedure UnlockPubScreenList ;
pragma IMPORT (C, UnlockPubScreenList, "UnlockPubScreenList");
function ViewAddress  return  View_Ptr;
pragma IMPORT (C, ViewAddress, "ViewAddress");
function ViewPortAddress (  window : Window_Ptr) return  ViewPort_Ptr;
pragma IMPORT (C, ViewPortAddress, "ViewPortAddress");
function WBenchToBack  return Boolean;
pragma IMPORT (C, WBenchToBack, "WBenchToBack");
function WBenchToFront  return Boolean;
pragma IMPORT (C, WBenchToFront, "WBenchToFront");
function WindowLimits (  window : Window_Ptr;widthMin : Integer;heightMin : Integer; widthMax : Integer; heightMax : Integer) return Boolean;
pragma IMPORT (C, WindowLimits, "WindowLimits");
procedure WindowToBack (  window : Window_Ptr);
pragma IMPORT (C, WindowToBack, "WindowToBack");
procedure WindowToFront (  window : Window_Ptr);
pragma IMPORT (C, WindowToFront, "WindowToFront");
procedure ZipWindow (  window : Window_Ptr);
pragma IMPORT (C, ZipWindow, "ZipWindow");

function NewObjectA (  class_Ptr : IClass_Ptr;classID : Chars_Ptr; tagList : TagListType) return Integer_Ptr;
function OpenScreenTagList (  newScreen : NewScreen_Ptr; tagList : TagListType) return  Screen_Ptr;
function OpenWindowTagList (  newWindow : NewWindow_Ptr; tagList : TagListType) return  Window_Ptr;
function SetAttrsA ( object : Object_Ptr; tagList : TagListType) return Integer;
function SetGadgetAttrsA (  gadget : Gadget_Ptr; window : Window_Ptr; requester : Requester_Ptr; tagList : TagListType) return Integer;
procedure SetWindowPointerA (  win : Window_Ptr; taglist : TagListType);

end Intuition_Intuition;

