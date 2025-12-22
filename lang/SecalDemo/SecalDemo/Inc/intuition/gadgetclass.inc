include "inc/exec/types.inc";
include "inc/intuition/intuition.inc";
include "inc/utility/tagitem.inc";

def GA_Dummy = (TAG_USER+$30000);

def GA_Left = (GA_Dummy+$0001);
def GA_RelRight = (GA_Dummy+$0002);
def GA_Top = (GA_Dummy+$0003);
def GA_RelBottom = (GA_Dummy+$0004);
def GA_Width = (GA_Dummy+$0005);
def GA_RelWidth = (GA_Dummy+$0006);
def GA_Height = (GA_Dummy+$0007);
def GA_RelHeight = (GA_Dummy+$0008);
def GA_Text = (GA_Dummy+$0009);
def GA_Image = (GA_Dummy+$000a);
def GA_Border = (GA_Dummy+$000b);
def GA_SelectRender = (GA_Dummy+$000c);
def GA_Highlight = (GA_Dummy+$000d);
def GA_Disabled = (GA_Dummy+$000e);
def GA_GZZGadget = (GA_Dummy+$000f);
def GA_ID = (GA_Dummy+$0010);
def GA_UserData = (GA_Dummy+$0011);
def GA_SpecialInfo = (GA_Dummy+$0012);
def GA_Selected = (GA_Dummy+$0013);
def GA_EndGadget = (GA_Dummy+$0014);
def GA_Immediate = (GA_Dummy+$0015);
def GA_RelVerify = (GA_Dummy+$0016);
def GA_FollowMouse = (GA_Dummy+$0017);
def GA_RightBorder = (GA_Dummy+$0018);
def GA_LeftBorder = (GA_Dummy+$0019);
def GA_TopBorder = (GA_Dummy+$001a);
def GA_BottomBorder = (GA_Dummy+$001b);
def GA_ToggleSelect = (GA_Dummy+$001c);
def GA_SysGadget = (GA_Dummy+$001d);
def GA_SysGType = (GA_Dummy+$001e);
def GA_Previous = (GA_Dummy+$001f);
def GA_Next = (GA_Dummy+$0020);
def GA_DrawInfo = (GA_Dummy+$0021);
def GA_IntuiText = (GA_Dummy+$0022);
def GA_LabelImage = (GA_Dummy+$0023);
def GA_TabCycle = (GA_Dummy+$0024);
def GA_GadgetHelp = (GA_Dummy+$0025);
def GA_Bounds = (GA_Dummy+$0026);
def GA_RelSpecial = (GA_Dummy+$0027);

def PGA_Dummy = (TAG_USER+$31000);

def PGA_Freedom = (PGA_Dummy+$0001);
def PGA_Borderless = (PGA_Dummy+$0002);
def PGA_HorizPot = (PGA_Dummy+$0003);
def PGA_HorizBody = (PGA_Dummy+$0004);
def PGA_VertPot = (PGA_Dummy+$0005);
def PGA_VertBody = (PGA_Dummy+$0006);
def PGA_Total = (PGA_Dummy+$0007);
def PGA_Visible = (PGA_Dummy+$0008);
def PGA_Top = (PGA_Dummy+$0009);
def PGA_NewLook = (PGA_Dummy+$000a);

def STRINGA_Dummy = (TAG_USER+$32000);
def STRINGA_MaxChars = (STRINGA_Dummy+$0001);
def STRINGA_Buffer = (STRINGA_Dummy+$0002);
def STRINGA_UndoBuffer = (STRINGA_Dummy+$0003);
def STRINGA_WorkBuffer = (STRINGA_Dummy+$0004);
def STRINGA_BufferPos = (STRINGA_Dummy+$0005);
def STRINGA_DispPos = (STRINGA_Dummy+$0006);
def STRINGA_AltKeyMap = (STRINGA_Dummy+$0007);
def STRINGA_Font = (STRINGA_Dummy+$0008);
def STRINGA_Pens = (STRINGA_Dummy+$0009);
def STRINGA_ActivePens = (STRINGA_Dummy+$000a);
def STRINGA_EditHook = (STRINGA_Dummy+$000b);
def STRINGA_EditModes = (STRINGA_Dummy+$000c);

def STRINGA_ReplaceMode = (STRINGA_Dummy+$000d);
def STRINGA_FixedFieldMode = (STRINGA_Dummy+$000e);
def STRINGA_NoFilterMode = (STRINGA_Dummy+$000f);
def STRINGA_Justification = (STRINGA_Dummy+$0010);
def STRINGA_LongVal = (STRINGA_Dummy+$0011);
def STRINGA_TextVal = (STRINGA_Dummy+$0012);
def STRINGA_ExitHelp = (STRINGA_Dummy+$0013);

def SG_DEFAULTMAXCHARS = (128);

def LAYOUTA_Dummy = (TAG_USER+$38000);

def LAYOUTA_LayoutObj = (LAYOUTA_Dummy+$0001);
def LAYOUTA_Spacing = (LAYOUTA_Dummy+$0002);
def LAYOUTA_Orientation = (LAYOUTA_Dummy+$0003);

def LORIENT_NONE = 0;
def LORIENT_HORIZ = 1;
def LORIENT_VERT = 2;

def GM_Dummy = (-1);
def GM_HITTEST = (0);
def GM_RENDER = (1);
def GM_GOACTIVE = (2);
def GM_HANDLEINPUT = (3);
def GM_GOINACTIVE = (4);
def GM_HELPTEST = (5);
def GM_LAYOUT = (6);

struct gpHitTest is
  MethodID:ulong;
  gpht_GInfo:ulong;

  gpht_Mouse:struct is
    X:word;
    Y:word;
  ;
;

def GMR_GADGETHIT = ($00000004);

def GMR_NOHELPHIT = ($00000000);
def GMR_HELPHIT = ($ffffffff);
def GMR_HELPCODE = ($00010000);

struct gpRender is
  MethodID:ulong;
  gpr_GInfo:ulong;
  gpr_RPort:ulong;
  gpr_Redraw:long;
;

def GREDRAW_UPDATE = (2);
def GREDRAW_REDRAW = (1);
def GREDRAW_TOGGLE = (0);

struct gpInput is
  MethodID:ulong;
  gpi_GInfo:ulong;
  gpi_IEvent:ulong;
  gpi_Termination:ulong;

  gpi_Mouse:struct is
    X:word;
    Y:word;
  ;
  gpi_TabletData:ulong;
;

def GMR_MEACTIVE = (0);
def GMR_NOREUSE = (1<<1);
def GMR_REUSE = (1<<2);
def GMR_VERIFY = (1<<3);

def GMR_NEXTACTIVE = (1<<4);
def GMR_PREVACTIVE = (1<<5);

struct gpGoInactive is
  MethodID:ulong;
  gpgi_GInfo:ulong;
  gpgi_Abort:ulong;
;

struct gpLayout is
  MethodID:ulong;
  gpl_GInfo:ulong;
  gpl_Initial:ulong;
;

