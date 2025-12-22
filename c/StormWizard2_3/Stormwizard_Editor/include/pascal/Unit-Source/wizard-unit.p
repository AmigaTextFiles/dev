{ Unit:               Wizard
  Language:           MaxonPascal, KickPascal

  Original C-Include: wizard.h 37.123 (10.05.96)
                      © 1996 HAAGE & PARTNER,  All Rights Reserved

  $VER:               1.1 (08.06.96)

  Author:             Falk Zuehlsdorff (ai036@rz.tu-ilmenau.de)
}

UNIT Wizard;

INTERFACE;

USES Intuition,Gadtools;

CONST WIZARDNAME            = "wizard.library";

      WZRD_TEXTPEN          = $8002;
      WZRD_SHINEPEN         = $8003;
      WZRD_SHADOWPEN        = $8004;
      WZRD_FILLPEN          = $8005;
      WZRD_FILLTEXTPEN      = $8006;
      WZRD_BACKGROUNDPEN    = $8007;
      WZRD_HIGHLIGHTTEXTPEN = $8008;
      WZRD_BARDETAILPEN     = $8009;           { OS V39 }
      WZRD_BARBLOCKPEN      = $800A;           { OS V39 }
      WZRD_BARTRIMPEN       = $800B;           { OS V39 }

      WZRDFRAME_NONE        = 0;
      WZRDFRAME_ICON        = 1;
      WZRDFRAME_BUTTON      = 2;
      WZRDFRAME_STRING      = 3;
      WZRDFRAME_DOUBLEICON  = 4;
      WZRDFRAME_SICON       = 5;
      WZRDFRAME_SBUTTON     = 6;
      WZRDFRAME_SSTRING     = 7;
      WZRDFRAME_SDOUBLEICON = 8;

      WZRDPLACE_LEFT        = $1;
      WZRDPLACE_RIGHT       = $2;
      WZRDPLACE_CENTER      = $10;

      WARROW_LEFT           = 0;
      WARROW_RIGHT          = 1;
      WARROW_UP             = 2;
      WARROW_DOWN           = 3;

      WGHF_IgnoreOS         = 1;
      WGHF_FullControl      = 2;

TYPE

{ WizardNode ------------------------------------------------------ }


      p_WizardNode          = ^WizardNode;

      WizardNode            = RECORD
                               Node   : MinNode;
                               Entrys : byte;
                               Flags  : byte;
                               Intern : array [0..38] of byte;
                              END;

{ Standard Node --------------------------------------------------- }
{ Diese Node ist für Listviews und Hierarchy                        }

     p_WizardDefaultNode    = ^WizardDefaultNode;

     WizardDefaultNode      = RECORD
                               WizardNode : WizardNode;
                               Intern : array [0..24] of byte;
                              END;

{------------------------------------------------------------------ }

     p_WizardWindowHandle   = ^WizardWindowHandle;
     p_winhaddress          = ^winhaddress;
     winhaddress            = p_WizardWindowHandle;

     WizardWindowHandle     = RECORD
                               Node              : MinNode;
                               Window            : p_Window;
                               MenuStrip         : p_Menu;
                               DrawInfo          : p_DrawInfo;
                               VisualInfo        : PTR;
                               ScreenTitle       : STR;
                               SizeImageWidth    : Integer;
                               SizeImageHeight   : Integer;
                               Objects           : MinList;
                               RootGadget        : p_Gadget;
                               RootTopGadget     : p_Gadget;
                               RootLeftGadget    : p_Gadget;
                               RootBottomGadget  : p_Gadget;
                               RootRightGadget   : p_Gadget;
                               UserStruct        : PTR;
                              END;

     p_WizardNewImage       = ^WizardNewImage;

     WizardNewImage         = RECORD
                               Flags       : word;
                               Name        : word; { immer auf NULL setzen ! }
                               Width       : word;
                               Height      : word;
                               Depth       : word;
                               Compression : word;
                               Reserved    : long;
                               ColorLength : long;
                               ImageLength : long;
                              END;

CONST WIF_Interleaved       =  4;
      WIFStandard           =  8;

{ Vimage-Struktur und seine Tags, sowie Kommandos ----------------- }

TYPE   p_WizardVImage       = ^WizardVImage;

       WizardVImage         = RECORD
                               Flags     : word;
                               Counter   : word;
                               MinWidth  : word;
                               MinHeight : word;
                               RelCoords : ^word;
                              END;

CONST WVIF_MinWidth         = 1;
      WVIF_MinHeight        = 2;
      WVIF_AreaInit         = 4;
      WVIF_Recursion        = 8;

      WVIB_MinWidth         = 0;
      WVIB_MinHeight        = 1;
      WVIB_AreaInit         = 2;
      WVIB_Recursion        = 3;

      WVICMD_END            = 0;
      WVICMD_COLOR          = 1;
      WVICMD_COLOR2         = 2;
      WVICMD_MOVE           = 3;
      WVICMD_DRAW           = 4;
      WVICMD_RECTFILL       = 5;
      WVICMD_WRITEPIXEL     = 6;
      WVICMD_IMAGE          = 7;
      WVICMD_TEXT           = 8;
      WVICMD_SETDRMD        = 9;
      WVICMD_TEXTIMAGE      = 10;
      WVICMD_TEXTMOVE       = 11;
      WVICMD_TAGCOLOR       = 12;
      WVICMD_TEXTPLACE      = 13;
      WVICMD_SETAFPT        = 14;
      WVICMD_SNAPCURSOR     = 15;
      WVICMD_SNAPX          = 16;
      WVICMD_SNAPY          = 17;
      WVICMD_TAGMOVE        = 18;
      WVICMD_TAGIMAGE       = 19;
      WVICMD_BITMAP_TO_RP   = 20;
      WVICMD_FILLBORDER     = 21;
      WVICMD_BEEP           = 22;
      WVICMD_AREAINIT       = 23;
      WVICMD_AREAMOVE       = 24;
      WVICMD_AREADRAW       = 25;
      WVICMD_AREAEND        = 26;
      WVICMD_TAGAREAPTRN    = 27;

{ Tags der wizard.library ----------------------------------------- }

      WZRD_TagDummy         = $80180000;

      WVIA_TagDummy         = (WZRD_TagDummy+100);

      WVIA_Text             = (WVIA_TagDummy+0);
      WVIA_TextFont         = (WVIA_TagDummy+1);
      WVIA_TextPlace        = (WVIA_TagDummy+2);
      WVIA_TextPen          = (WVIA_TagDummy+3);
      WVIA_TextStyles       = (WVIA_TagDummy+4);
      WVIA_TextHighLights   = (WVIA_TagDummy+5);
      WVIA_TextImages       = (WVIA_TagDummy+6);

      WVIA_TagImage         = (WVIA_TagDummy+7);
      WVIA_TagImageCode     = (WVIA_TagDummy+8);

      WVIA_ImageCode        = (WVIA_TagDummy+9);

      WVIA_Color0           = (WVIA_TagDummy+10);
      WVIA_Color1           = (WVIA_TagDummy+11);
      WVIA_Color2           = (WVIA_TagDummy+12);
      WVIA_Color3           = (WVIA_TagDummy+13);
      WVIA_Color4           = (WVIA_TagDummy+14);
      WVIA_Color5           = (WVIA_TagDummy+15);
      WVIA_Color6           = (WVIA_TagDummy+16);
      WVIA_Color7           = (WVIA_TagDummy+17);

      WVIA_TPoint0          = (WVIA_TagDummy+18);
      WVIA_TPoint1          = (WVIA_TagDummy+19);
      WVIA_TPoint2          = (WVIA_TagDummy+20);
      WVIA_TPoint3          = (WVIA_TagDummy+21);
      WVIA_TPoint4          = (WVIA_TagDummy+22);
      WVIA_TPoint5          = (WVIA_TagDummy+23);
      WVIA_TPoint6          = (WVIA_TagDummy+24);
      WVIA_TPoint7          = (WVIA_TagDummy+25);

      WVIA_AreaPtrn         = (WVIA_TagDummy+26);
      WVIA_TmpRas           = (WVIA_TagDummy+27);

      WVIA_BitMapWidth      = (WVIA_TagDummy+28);
      WVIA_BitMapHeight     = (WVIA_TagDummy+29);
      WVIA_BitMap0          = (WVIA_TagDummy+30);
      WVIA_BitMap1          = (WVIA_TagDummy+31);
      WVIA_BitMap2          = (WVIA_TagDummy+32);
      WVIA_BitMap3          = (WVIA_TagDummy+33);
      WVIA_BitMap4          = (WVIA_TagDummy+34);
      WVIA_BitMap5          = (WVIA_TagDummy+35);
      WVIA_BitMap6          = (WVIA_TagDummy+36);
      WVIA_BitMap7          = (WVIA_TagDummy+37);

      WVIA_PureText         = (WVIA_TagDummy+38);

      WVIA_TagAreaPtSz      = (WVIA_TagDummy+39);
      WVIA_TagAreaPtrn0     = (WVIA_TagDummy+40);
      WVIA_TagAreaPtrn1     = (WVIA_TagDummy+41);
      WVIA_TagAreaPtrn2     = (WVIA_TagDummy+42);
      WVIA_TagAreaPtrn3     = (WVIA_TagDummy+43);

{      Tags für den Aufruf von WZ_OpenSurface();      }

      SFH_Locale            = (WZRD_TagDummy+200);
      SFH_Catalog           = (WZRD_TagDummy+201);
      SFH_AutoInit          = (WZRD_TagDummy+202);

{      Tags für den Aufruf von WZ_CreateWindowObj();      }

      WWH_GadgetArray       = (WZRD_TagDummy+300);
      WWH_GadgetArraySize   = (WZRD_TagDummy+301);
      WWH_PreviousGadget    = (WZRD_TagDummy+302);
      WWH_StringHook        = (WZRD_TagDummy+303);
      WWH_StackSize         = (WZRD_TagDummy+304); { für WZ_AllocWindowHandle }

{      Classes in V1.0 }

      WCLASS_GROUPEND       = 0;

      WCLASS_LAYOUT         = 0;
      WCLASS_HGROUP         = 1;
      WCLASS_VGROUP         = 2;
      WCLASS_BUTTON         = 3;
      WCLASS_STRING         = 4;
      WCLASS_LABEL          = 5;
      WCLASS_CHECKBOX       = 6;
      WCLASS_MX             = 7;
      WCLASS_INTEGER        = 8;
      WCLASS_HSCROLLER      = 9;
      WCLASS_VSCROLLER      = 10;
      WCLASS_ARROW          = 11;
      WCLASS_LISTVIEW       = 12;
      WCLASS_MULTILISTVIEW  = 13;
      WCLASS_TOGGLE         = 14;
      WCLASS_LINE           = 15;
      WCLASS_COLORFIELD     = 16;
      WCLASS_ARGS           = 17;
      WCLASS_GAUGE          = 18;
      WCLASS_CYCLE          = 19;
      WCLASS_VECTORBUTTON   = 20;
      WCLASS_DATE           = 21;
      WCLASS_SPACE          = 22;
      WCLASS_IMAGE          = 23;
      WCLASS_IMAGEBUTTON    = 24;
      WCLASS_IMAGETOGGLE    = 25;
      WCLASS_IMAGEPOPUP     = 26;
      WCLASS_TEXTPOPUP      = 27;
      WCLASS_PALETTE        = 28;
      WCLASS_VECTORPOPUP    = 29;
      WCLASS_HIERARCHY      = 30;
      WCLASS_HSLIDER        = 31;
      WCLASS_VSLIDER        = 32;
      WCLASS_LAST           = 33;

{      Flags, die Sie in dem Tag WGA_Flags angeben können }

      WGF_GadgetHelp        = 2;      {(1<<1)}
      WGF_Disabled          = 256;    {(1<<8)}
      WGF_Immediate         = 4;      {(1<<2)}
      WGF_KeyControl        = 512;    {(1<<9)}
      WGRPF_EqualSize       = 32768;  {(1<<15)}
      WGRPF_DockMode        = 16384;  {(1<<14)}
      WSPCF_Transparent     = 32768;  {(1<<15)}
      WTGF_SimpleMode       = 32768;  {(1<<15)}
      WLVF_ReadOnly         = 32768;  {(1<<15)}
      WLVF_DoubleClicks     = 16384;  {(1<<14)}
      WSCF_NewLook          = 32768;  {(1<<15)}
      WITF_SimpleMode       = 32768;  {(1<<15)}
      WIPF_NewLook          = 32768;  {(1<<15)}
      WTPF_NewLook          = 32768;  {(1<<15)}
      WVPF_NewLook          = 32768;  {(1<<15)}
      WSLF_NewLook          = 32768;  {(1<<15)}

{      alle folgenden Tags sind Universal-Tags für alle Wizardgadgets }

      WGA_Label             = (WZRD_TagDummy+400);
      WGA_Label2            = (WZRD_TagDummy+401);
      WGA_TextFont          = (WZRD_TagDummy+402);
      WGA_Flags             = (WZRD_TagDummy+403);
      WGA_Priority          = (WZRD_TagDummy+404);
      WGA_RelHeight         = (WZRD_TagDummy+405);
      WGA_MinWidth          = (WZRD_TagDummy+406);
      WGA_MinHeight         = (WZRD_TagDummy+407);
      WGA_Link              = (WZRD_TagDummy+408);
      WGA_LinkData          = (WZRD_TagDummy+409);
      WGA_HelpText          = (WZRD_TagDummy+410);
      WGA_Config            = (WZRD_TagDummy+411);
      WGA_NewImage          = (WZRD_TagDummy+412);
      WGA_SelNewImage       = (WZRD_TagDummy+413);
      WGA_Group             = (WZRD_TagDummy+414);
      WGA_GroupPage         = (WZRD_TagDummy+415);
      WGA_Locale            = (WZRD_TagDummy+416);
      WGA_Screen            = (WZRD_TagDummy+417);
      WGA_Bounds            = (WZRD_TagDummy+418);

{      Notify - Tags }

      WNOTIFYA_Type         = (WZRD_TagDummy+450);

{      Class-Tags }

      WGROUPA_ActivePage    = (WZRD_TagDummy+500);
      WGROUPA_MaxPage       = (WZRD_TagDummy+501);
      WGROUPA_HBorder       = (WZRD_TagDummy+502);
      WGROUPA_VBorder       = (WZRD_TagDummy+503);
      WGROUPA_BHOffset      = (WZRD_TagDummy+504);
      WGROUPA_BVOffset      = (WZRD_TagDummy+505);
      WGROUPA_Space         = (WZRD_TagDummy+506);
      WGROUPA_VarSpace      = (WZRD_TagDummy+507);
      WGROUPA_FrameType     = (WZRD_TagDummy+508);

      WSTRINGA_MaxChars     = (WZRD_TagDummy+509);
      WSTRINGA_String       = (WZRD_TagDummy+510);

      WCHECKBOXA_Checked    = (WZRD_TagDummy+511);

      WMXA_Active           = (WZRD_TagDummy+512);
      WGROUPA_HighLights    = (WZRD_TagDummy+513);
      WGROUPA_HighlightPen  = (WZRD_TagDummy+514);

      WLABELA_FrameType     = (WZRD_TagDummy+515);
      WLABELA_Space         = (WZRD_TagDummy+516);
      WLABELA_BGPen         = (WZRD_TagDummy+517);
      WLABELA_TextPlace     = (WZRD_TagDummy+518);
      WLABELA_Lines         = (WZRD_TagDummy+519);

      WINTEGERA_Long        = (WZRD_TagDummy+520);
      WINTEGERA_MinLong     = (WZRD_TagDummy+521);
      WINTEGERA_MaxLong     = (WZRD_TagDummy+522);

      WSCROLLERA_Top        = (WZRD_TagDummy+523);
      WSCROLLERA_Visible    = (WZRD_TagDummy+524);
      WSCROLLERA_Total      = (WZRD_TagDummy+525);

      WSTRINGA_Justification  = (WZRD_TagDummy+526);
      WINTEGERA_Justification = (WZRD_TagDummy+527);

      WARROWA_Type          = (WZRD_TagDummy+528);

      WLISTVIEWA_Top         = (WZRD_TagDummy+534);
      WLISTVIEWA_Selected    = (WZRD_TagDummy+535);
      WLISTVIEWA_List        = (WZRD_TagDummy+536);
      WLISTVIEWA_Visible     = (WZRD_TagDummy+538);
      WLISTVIEWA_DoubleClick = (WZRD_TagDummy+539);

      WTOGGLEA_Checked      = (WZRD_TagDummy+540);

      WLINEA_Type           = (WZRD_TagDummy+541);
      WLINEA_Label          = (WZRD_TagDummy+542);

      WCOLORFIELDA_Pen      = (WZRD_TagDummy+543);

      WARGSA_TextPlace      = (WZRD_TagDummy+544);
      WARGSA_FrameType      = (WZRD_TagDummy+545);
      WARGSA_Arg0           = (WZRD_TagDummy+546);
      WARGSA_Arg1           = (WZRD_TagDummy+547);
      WARGSA_Arg2           = (WZRD_TagDummy+548);
      WARGSA_Arg3           = (WZRD_TagDummy+549);
      WARGSA_Arg4           = (WZRD_TagDummy+550);
      WARGSA_Arg5           = (WZRD_TagDummy+551);
      WARGSA_Arg6           = (WZRD_TagDummy+552);
      WARGSA_Arg7           = (WZRD_TagDummy+553);
      WARGSA_Arg8           = (WZRD_TagDummy+554);
      WARGSA_Arg9           = (WZRD_TagDummy+555);

      WGAUGEA_Total         = (WZRD_TagDummy+556);
      WGAUGEA_Current       = (WZRD_TagDummy+557);
      WGAUGEA_Format        = (WZRD_TagDummy+558);

      WCYCLEA_Active        = (WZRD_TagDummy+559);
      WCYCLEA_Labels        = (WZRD_TagDummy+560);

      WARROWA_Step          = (WZRD_TagDummy+561);

      WVECTORBUTTONA_Type   = (WZRD_TagDummy+562);

      WDATEA_Day            = (WZRD_TagDummy+563);
      WDATEA_Month          = (WZRD_TagDummy+564);
      WDATEA_Year           = (WZRD_TagDummy+565);

      WARGSA_Format         = (WZRD_TagDummy+566);

      WLABELA_HighlightPen  = (WZRD_TagDummy+567);

      WBUTTONA_Label        = (WZRD_TagDummy+568);

      WLABELA_HighLights    = (WZRD_TagDummy+569);
      WLABELA_Label         = (WZRD_TagDummy+570);

      WIMAGEA_BGPen         = (WZRD_TagDummy+571);
      WIMAGEA_FrameType     = (WZRD_TagDummy+572);
      WIMAGEA_HBorder       = (WZRD_TagDummy+573);
      WIMAGEA_VBorder       = (WZRD_TagDummy+574);
      WIMAGEA_NewImage      = (WZRD_TagDummy+575);

      WIMAGEBUTTONA_BGPen       = (WZRD_TagDummy+576);
      WIMAGEBUTTONA_SelBGPen    = (WZRD_TagDummy+577);
      WIMAGEBUTTONA_FrameType   = (WZRD_TagDummy+578);
      WIMAGEBUTTONA_HBorder     = (WZRD_TagDummy+579);
      WIMAGEBUTTONA_VBorder     = (WZRD_TagDummy+580);
      WIMAGEBUTTONA_NewImage    = (WZRD_TagDummy+581);
      WIMAGEBUTTONA_SelNewImage = (WZRD_TagDummy+582);

      WIMAGETOGGLEA_BGPen       = (WZRD_TagDummy+583);
      WIMAGETOGGLEA_SelBGPen    = (WZRD_TagDummy+584);
      WIMAGETOGGLEA_FrameType   = (WZRD_TagDummy+585);
      WIMAGETOGGLEA_HBorder     = (WZRD_TagDummy+586);
      WIMAGETOGGLEA_VBorder     = (WZRD_TagDummy+587);
      WIMAGETOGGLEA_NewImage    = (WZRD_TagDummy+588);
      WIMAGETOGGLEA_SelNewImage = (WZRD_TagDummy+589);
      WIMAGETOGGLEA_Checked     = (WZRD_TagDummy+590);

      WSTRINGA_Hook             = (WZRD_TagDummy+591);

      WIMAGEPOPUPA_BGPen     = (WZRD_TagDummy+593);
      WIMAGEPOPUPA_FrameType = (WZRD_TagDummy+594);
      WIMAGEPOPUPA_HBorder   = (WZRD_TagDummy+595);
      WIMAGEPOPUPA_VBorder   = (WZRD_TagDummy+596);
      WIMAGEPOPUPA_TextPlace = (WZRD_TagDummy+597);
      WIMAGEPOPUPA_NewImage  = (WZRD_TagDummy+598);
      WIMAGEPOPUPA_Labels    = (WZRD_TagDummy+599);
      WIMAGEPOPUPA_Selected  = (WZRD_TagDummy+600);

      WTEXTPOPUPA_TextPlace = (WZRD_TagDummy+601);
      WTEXTPOPUPA_Labels    = (WZRD_TagDummy+602);
      WTEXTPOPUPA_Selected  = (WZRD_TagDummy+603);
      WTEXTPOPUPA_Name      = (WZRD_TagDummy+604);

      WPALETTEA_Colors      = (WZRD_TagDummy+605);
      WPALETTEA_Selected    = (WZRD_TagDummy+606);
      WPALETTEA_Offset      = (WZRD_TagDummy+607);

      WGROUPA_BGPen          = (WZRD_TagDummy+608);
      WGROUPA_DockMinVisible = (WZRD_TagDummy+609);
      WGROUPA_Styles         = (WZRD_TagDummy+610);

      WLABELA_Styles          = (WZRD_TagDummy+611);

      WVECTORPOPUPA_Type      = (WZRD_TagDummy+612);
      WVECTORPOPUPA_Labels    = (WZRD_TagDummy+613);
      WVECTORPOPUPA_TextPlace = (WZRD_TagDummy+614);
      WVECTORPOPUPA_Selected  = (WZRD_TagDummy+615);

      WHIERARCHYA_ImageType   = (WZRD_TagDummy+617);
      WHIERARCHYA_ImageWidth  = (WZRD_TagDummy+618);
      WHIERARCHYA_Top         = (WZRD_TagDummy+619);
      WHIERARCHYA_List        = (WZRD_TagDummy+620);
      WHIERARCHYA_Selected    = (WZRD_TagDummy+621);
      WHIERARCHYA_Visible     = (WZRD_TagDummy+622);
      WHIERARCHYA_DoubleClick = (WZRD_TagDummy+623);

      WSLIDERA_Min            = (WZRD_TagDummy+627);
      WSLIDERA_Max            = (WZRD_TagDummy+628);
      WSLIDERA_Level          = (WZRD_TagDummy+629);

      WTOGGLEA_Label          = (WZRD_TagDummy+630);

      WLAYOUTA_RootGadget     = (WZRD_TagDummy+631);
      WLAYOUTA_Type           = (WZRD_TagDummy+632);
      WLAYOUTA_BorderLeft     = (WZRD_TagDummy+633);
      WLAYOUTA_BorderRight    = (WZRD_TagDummy+634);
      WLAYOUTA_BorderTop      = (WZRD_TagDummy+635);
      WLAYOUTA_BorderBottom   = (WZRD_TagDummy+636);
      WLAYOUTA_StackSwap      = (WZRD_TagDummy+637);

      WARGSA_TextPen          = (WZRD_TagDummy+638);
      WARGSA_BackgroundPen    = (WZRD_TagDummy+639);


{      Tags für WZ_InitNode();      }

      WNODEA_Flags            = (WZRD_TagDummy+1000);

      WNF_SELECTED            = 1;   {(1<<0)  Node ist selektiert, MultiListView  }
      WNF_TREE                = 32;  {(1<<5)  Das ist eine Node eines Baumes      }
      WNF_AUTOMATIC           = 64;  {(1<<6)  Baumkontrolle geht an BOOPSI-Object }
      WNF_VISIBLE             = 128; {(1<<7)  Baum dieser Node wird dargestellt   }

{      Tags für WZ_InitNodeEntry();      }

      WENTRYA_Type             = (WZRD_TagDummy+1100);

      WENTRYA_TextPen           = (WZRD_TagDummy+1101);
      WENTRYA_TextSPen          = (WZRD_TagDummy+1102);
      WENTRYA_TextStyle         = (WZRD_TagDummy+1103);
      WENTRYA_TextSStyle        = (WZRD_TagDummy+1104);
      WENTRYA_TextString        = (WZRD_TagDummy+1105);
      WENTRYA_TreeParentNode    = (WZRD_TagDummy+1106);
      WENTRYA_TreeChilds        = (WZRD_TagDummy+1107);
      WENTRYA_TreeString        = (WZRD_TagDummy+1108);
      WENTRYA_TreePen           = (WZRD_TagDummy+1109);       { V 38 }
      WENTRYA_TreeSPen          = (WZRD_TagDummy+1110);       { V 38 }
      WENTRYA_TreeStyle         = (WZRD_TagDummy+1111);       { V 38 }
      WENTRYA_TreeSStyle        = (WZRD_TagDummy+1112);       { V 38 }
      WENTRYA_TextFont          = (WZRD_TagDummy+1113);       { V 38 }
      WENTRYA_TextJustification = (WZRD_TagDummy+1114);       { V 38 }
      WENTRYA_TreeFont          = (WZRD_TagDummy+1115);       { V 38 }

      WNE_TEXT                  = 1;
      WNE_TREE                  = 3;

{======================================================================}

TYPE p_Long = ^Long;

Var WizardBase : Ptr;

LIBRARY WizardBase :

 -30  : FUNCTION  WZ_OpenSurfaceA(A0:STR;A1:PTR;A2:p_TagItem) : PTR;
 -36  : PROCEDURE WZ_CloseSurface(A0:PTR);
 -42  : FUNCTION  WZ_AllocWindowHandleA(D0:p_Screen;D1:Long;A0:PTR;A1:p_TagItem) : p_WizardWindowHandle;
 -48  : FUNCTION  WZ_CreateWindowObjA(A0:p_WizardWindowHandle;D0:Long;A1:p_TagItem) : p_NewWindow;
 -54  : FUNCTION  WZ_OpenWindowA(A0:p_WizardWindowHandle;A1:p_NewWindow;A2:p_TagItem) : p_Window;
 -60  : PROCEDURE WZ_CloseWindow(A0:p_WizardWindowHandle);
 -66  : PROCEDURE WZ_FreeWindowHandle(A0:p_WizardWindowHandle);
 -72  : PROCEDURE WZ_LockWindow(A0:p_WizardWindowHandle);
 -78  : FUNCTION  WZ_UnlockWindow(A0:p_WizardWindowHandle) : Long;
 -84  : PROCEDURE WZ_LockWindows(A0:PTR);
 -90  : PROCEDURE WZ_UnlockWindows(A0:PTR);
 -96  : FUNCTION  WZ_GadgetHelp(A0:p_WizardWindowHandle;A1:PTR) : STR;
 -102 : FUNCTION  WZ_GadgetConfig(A0:p_WizardWindowHandle;A1:p_gadget) : STR;
 -108 : FUNCTION  WZ_MenuHelp(A0:p_WizardWindowHandle;D0:Long) : STR;
 -114 : FUNCTION  WZ_MenuConfig(A0:p_WizardWindowHandle;D0:Long) : STR;
 -120 : FUNCTION  WZ_InitEasyStruct(A0:PTR;A1:p_EasyStruct;D0:Long;D1:Long) : p_EasyStruct;
 -126 : FUNCTION  WZ_SnapShotA(A0:PTR;A1:p_TagItem) : boolean;
 -132 : FUNCTION  WZ_GadgetKey(A0:p_WizardWindowHandle;D0:Long;D1:Long;A1:p_TagItem) : boolean;
 -138 : FUNCTION  WZ_DrawVImageA(A0:p_WizardVImage;D0,D1,D2,D3,D4:Integer;D5:p_RastPort;D6:p_DrawInfo;A1:p_TagItem) : boolean;
 -144 : FUNCTION  WZ_EasyRequestArgs(A0:PTR;A1:p_Window;D0:Long;A2:Ptr) : long;
 -150 : FUNCTION  WZ_GetNode(A0:p_Minlist;D0:Long) : p_WizardNode;
 -172 : FUNCTION  WZ_ListCount(A0:p_MinList) : Long;   
 -162 : FUNCTION  WZ_NewObjectA(D0:Long;A0:p_TagItem) : p_Gadget;
 -168 : FUNCTION  WZ_GadgetHelpMsg(A0:p_WizardWindowHandle;A1:p_winhaddress;A2:PTR;D0:Integer;D1:Integer;D2:Word) :boolean;
 -174 : FUNCTION  WZ_ObjectID(A0:Ptr;A2:p_Long;A1:STR) : boolean;
 -180 : PROCEDURE WZ_InitNodeA(A0:p_WizardNode;D0:Long;A1:p_TagItem);
 -186 : PROCEDURE WZ_InitNodeEntryA(A0:p_WizardNode;D0:Long;A1:p_TagItem);

end;

IMPLEMENTATION

end.




