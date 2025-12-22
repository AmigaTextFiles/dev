include "inc/exec/types.inc";
include "inc/graphics/gfx.inc";
include "inc/graphics/clip.inc";
include "inc/graphics/view.inc";
include "inc/graphics/rastport.inc";
include "inc/graphics/layers.inc";
include "inc/utility/tagitem.inc";

def DRI_VERSION = (2);

struct DrawInfo is
  dri_Version:uword;
  dri_NumPens:uword;
  dri_Pens:ulong;
  dri_Font:ulong;
  dri_Depth:uword;
  dri_Resolution:struct is
    X:uword;
    Y:uword;
  ;
  dri_Flags:ulong;
  dri_CheckMark:ulong;
  dri_AmigaKey:ulong;
  dri_Reserved[5]:ulong;
;

def DRIF_NEWLOOK = $00000001;

def DETAILPEN = ($0000);
def BLOCKPEN = ($0001);
def TEXTPEN = ($0002);
def SHINEPEN = ($0003);
def SHADOWPEN = ($0004);
def FILLPEN = ($0005);
def FILLTEXTPEN = ($0006);
def BACKGROUNDPEN = ($0007);
def HIGHLIGHTTEXTPEN = ($0008);

def BARDETAILPEN = ($0009);
def BARBLOCKPEN = ($000a);
def BARTRIMPEN = ($000b);

def NUMDRIPENS = ($000c);

def PEN_C3 = $fefc;
def PEN_C2 = $fefd;
def PEN_C1 = $fefe;
def PEN_C0 = $feff;

struct Screen is
  NextScreen:ulong;
  FirstWindow:ulong;
  LeftEdge,TopEdge:word;
  Width,Height:word;
  MouseY,MouseX:word;
  Flags:uword;
  Title:ulong;
  DefaultTitle:ulong;
  BarHeight,BarVBorder,BarHBorder,MenuVBorder,MenuHBorder:byte;
  WBorTop,WBorLeft,WBorRight,WBorBottom:byte;
  Font:ulong;
  ViewPort:ViewPort;
  RastPort:RastPort;
  BitMap:BitMap;
  LayerInfo:Layer_Info;
  FirstGadget:ulong;
  DetailPen,BlockPen:ubyte;
  SaveColor0:uword;
  BarLayer:ulong;
  ExtData:ulong;
  UserData:ulong;
;

def SCREENTYPE = $000f;

def WBENCHSCREEN = $0001;
def PUBLICSCREEN = $0002;
def CUSTOMSCREEN = $000f;

def SHOWTITLE = $0010;
def BEEPING = $0020;
def CUSTOMBITMAP = $0040;
def SCREENBEHIND = $0080;
def SCREENQUIET = $0100;
def SCREENHIRES = $0200;
def NS_EXTENDED = $1000;

def AUTOSCROLL = $4000;

def PENSHARED = $0400;

def STDSCREENHEIGHT = -1;
def STDSCREENWIDTH = -1;

def SA_Dummy = (TAG_USER+32);

def SA_Left = (SA_Dummy+$0001);
def SA_Top = (SA_Dummy+$0002);
def SA_Width = (SA_Dummy+$0003);
def SA_Height = (SA_Dummy+$0004);
def SA_Depth = (SA_Dummy+$0005);
def SA_DetailPen = (SA_Dummy+$0006);
def SA_BlockPen = (SA_Dummy+$0007);
def SA_Title = (SA_Dummy+$0008);
def SA_Colors = (SA_Dummy+$0009);
def SA_ErrorCode = (SA_Dummy+$000a);
def SA_Font = (SA_Dummy+$000b);
def SA_SysFont = (SA_Dummy+$000c);
def SA_Type = (SA_Dummy+$000d);
def SA_BitMap = (SA_Dummy+$000e);
def SA_PubName = (SA_Dummy+$000f);
def SA_PubSig = (SA_Dummy+$0010);
def SA_PubTask = (SA_Dummy+$0011);
def SA_DisplayID = (SA_Dummy+$0012);
def SA_DClip = (SA_Dummy+$0013);
def SA_Overscan = (SA_Dummy+$0014);
def SA_Obsolete1 = (SA_Dummy+$0015);
def SA_ShowTitle = (SA_Dummy+$0016);
def SA_Behind = (SA_Dummy+$0017);
def SA_Quiet = (SA_Dummy+$0018);
def SA_AutoScroll = (SA_Dummy+$0019);
def SA_Pens = (SA_Dummy+$001a);
def SA_FullPalette = (SA_Dummy+$001b);
def SA_ColorMapEntries = (SA_Dummy+$001c);
def SA_Parent = (SA_Dummy+$001d);
def SA_Draggable = (SA_Dummy+$001e);
def SA_Exclusive = (SA_Dummy+$001f);
def SA_SharePens = (SA_Dummy+$0020);
def SA_BackFill = (SA_Dummy+$0021);
def SA_Interleaved = (SA_Dummy+$0022);
def SA_Colors32 = (SA_Dummy+$0023);
def SA_VideoControl = (SA_Dummy+$0024);
def SA_FrontChild = (SA_Dummy+$0025);
def SA_BackChild = (SA_Dummy+$0026);
def SA_LikeWorkbench = (SA_Dummy+$0027);
def SA_Reserved = (SA_Dummy+$0028);
def SA_MinimizeISG = (SA_Dummy+$0029);

def OSERR_NOMONITOR = (1);
def OSERR_NOCHIPS = (2);
def OSERR_NOMEM = (3);
def OSERR_NOCHIPMEM = (4);
def OSERR_PUBNOTUNIQUE = (5);
def OSERR_UNKNOWNMODE = (6);
def OSERR_TOODEEP = (7);
def OSERR_ATTACHFAIL = (8);
def OSERR_NOTAVAILABLE = (9);

struct NewScreen is
  LeftEdge,TopEdge,Width,Height,Depth:word;
  DetailPen,BlockPen:ubyte;
  ViewModes:uword;
  Type:uword;
  Font:ulong;
  DefaultTitle:ulong;
  Gadgets:ulong;
  CustomBitMap:ulong;
;

struct ExtNewScreen is
  LeftEdge,TopEdge,Width,Height,Depth:word;
  DetailPen,BlockPen:ubyte;
  ViewModes:uword;
  Type:uword;
  Font:ulong;
  DefaultTitle:ulong;
  Gadgets:ulong;
  CustomBitMap:ulong;
  Extension:ulong;
;

def OSCAN_TEXT = (1);
def OSCAN_STANDARD = (2);
def OSCAN_MAX = (3);
def OSCAN_VIDEO = (4);

struct PubScreenNode is
  psn_Node:Node;
  psn_Screen:ulong;
  psn_Flags:uword;
  psn_Size:word;
  psn_VisitorCount:word;
  psn_SigTask:ulong;
  psn_SigBit:ubyte;
;

def PSNF_PRIVATE = ($0001);

def MAXPUBSCREENNAME = (139);

def SHANGHAI = $0001;
def POPPUBSCREEN = $0002;

def SDEPTH_TOFRONT = (0);
def SDEPTH_TOBACK = (1);
def SDEPTH_INFAMILY = (2);

def SPOS_RELATIVE = (0);
def SPOS_ABSOLUTE = (1);
def SPOS_MAKEVISIBLE = (2);
def SPOS_FORCEDRAG = (4);

struct ScreenBuffer is
  sb_BitMap:ulong;
  sb_DBufInfo:ulong;
;

def SB_SCREEN_BITMAP = 1;
def SB_COPY_BITMAP = 2;

