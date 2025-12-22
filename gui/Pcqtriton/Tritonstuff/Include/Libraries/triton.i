(*  REVISION HEADER
**
**  Program         :   Include:Libraries/triton.i
**  Copyright       :   Nils Sjoholm
**  Author          :   Nils Sjoholm
**                      nils.sjoholm@mailbox.swipnet.se
**
**  Creation Date   :   02 May 1996
**  Current version :   $VER: triton.i 1.0 (02 May 1996)
**
**  Remarks         :   This is a header file for PCQ Pascal.
**                      It's translated from Stefan Zeigers triton.h
**                      Triton.h and triton.library is
**                      (C) Coyright 1993-1995 Stefan Zeiger
**                      All Rights Reserved.
**
**  Translator      :   PCQ Pascal 1.2d
**                      (C) Patric Quaid
**
**
**  REVISION HISTORY
**
**  Date            Version      Comment
**  -----------     -------      ------------------------------------
**  02 May 1996     1.0          First version for triton 1.4
**
**
** END OF REVISION HEADER
*)

{///"Includes"}
{$I "Include:Exec/Types.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Intuition/IntuitionBase.i"}
{$I "Include:Intuition/Gadgetclass.i"}
{$I "Include:Intuition/Imageclass.i"}
{$I "Include:Intuition/Classusr.i"}
{$I "Include:Graphics/Gfx.i"}
{$I "Include:Graphics/Gfxbase.i"}
{$I "Include:Libraries/GadTools.i"}
{$I "Include:Libraries/Diskfont.i"}
{$I "Include:Utility/TagItem.i"}
{$I "Include:Exec/Lists.i"}
{$I "Include:Workbench/Startup.i"}
{$I "Include:Workbench/WorkBench.i"}
{///}


(* ****************************************************************************** *)

(* ------------------------------------------------------------------------------ *)
(* library name and version                                                       *)
(* ------------------------------------------------------------------------------ *)

CONST   TRITONNAME        = "triton.library";
        TRITON10VERSION   = 1;
        TRITON11VERSION   = 2;
        TRITON12VERSION   = 3;
        TRITON13VERSION   = 4;
        TRITON14VERSION   = 5;


TYPE    (* for readability *)

        BOOL            = Short;   (* has TO be SIZE(WORD), so no BOOLEANs      *)

(* ------------------------------------------------------------------------------ *)
(* Triton Message                                                                 *)
(* ------------------------------------------------------------------------------ *)

TYPE TR_Message = RECORD
         (* trm_Project   : TR_ProjectPtr; *) (* The project which triggered  *)
         trm_Project   : ADDRESS;       (* the message                  *)
         trm_Id        : Integer;       (* The object's ID              *)
         trm_Class     : Integer;       (* The Triton message class     *)
         trm_Data      : Integer;       (* The class-specific data      *)
         trm_Code      : Integer;       (* Currently only used BY       *)
                                        (* TRMS_KEYPRESSED              *)
         trm_Pad0      : Integer;       (* qualifier is only 16 Bit     *)
         trm_Qualifier : Integer;       (* Qualifiers                   *)
         trm_Seconds   : Integer;       (* \ Copy of system clock time  *)
         trm_Micros    : Integer;       (* / (Only where available! IF  *)
                                        (*    not set, seconds is NULL) *)
         (* trm_App       : TR_AppPtr; *)    (* The project's application    *)
         trm_App       : ADDRESS;
     END;                               (* End of TR_Message            *)
     TR_MessagePtr = ^TR_Message;

(* Message classes *)
CONST   TRMS_CLOSEWINDOW        = 1;  (* The window should be closed *)
        TRMS_ERROR              = 2;  (* An error occured. Error code in trm_Data *)
        TRMS_NEWVALUE           = 3;  (* Object's VALUE has changed. New VALUE in trm_Data *)
        TRMS_ACTION             = 4;  (* Object has triggered an action *)
        TRMS_ICONDROPPED        = 5;  (* Icon dropped over window (ID=0) or DropBox. AppMessage* in trm_Data *)
        TRMS_KEYPRESSED         = 6;  (* Key pressed. trm_Data contains ASCII code,  trm_Code raw code and *)
                                      (* trm_Qualifier contains qualifiers *)
        TRMS_HELP               = 7;  (* The user requested help for the specified ID *)
        TRMS_DISKINSERTED       = 8;  (* A disk has been inserted into a drive *)
        TRMS_DISKREMOVED        = 9;  (* A disk has been removed from a drive *)


(* ////////////////////////////////////////////////////////////////////// *)
(* //////////////////////////////////////////////// Triton error codes // *)
(* ////////////////////////////////////////////////////////////////////// *)

CONST   TRER_OK                 = 0;        (* No error *)

        TRER_ALLOCMEM           = 1;        (* Not enough memory *)
        TRER_OPENWINDOW         = 2;        (* Can't open window *)
        TRER_WINDOWTOOBIG       = 3;        (* Window would be too big for screen *)
        TRER_DRAWINFO           = 4;        (* Can't get screen's DrawInfo *)
        TRER_OPENFONT           = 5;        (* Can't open font *)
        TRER_CREATEMSGPORT      = 6;        (* Can't create message port *)
        TRER_INSTALLOBJECT      = 7;        (* Can't create an object *)
        TRER_CREATECLASS        = 8;        (* Can't create a class *)
        TRER_NOLOCKPUBSCREEN    = 9;        (* Can't lock public screen *)
        TRER_CREATEMENUS        = 12;       (* Error while creating the menus *)
        TRER_GT_CREATECONTEXT   = 14;       (* Can't create gadget context *)

        TRER_MAXERRORNUM        = 15;       (* PRIVATE! *)


(* ////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////// Object messages // *)
(* ////////////////////////////////////////////////////////////////////// *)

CONST   TROM_ACTIVATE  = 23;                 (* Activate an object *)


(* ////////////////////////////////////////////////////////////////////// *)
(* ///////////////////////////////////////// Tags for TR_OpenProject() // *)
(* ////////////////////////////////////////////////////////////////////// *)

(* Tag bases *)
CONST   TRTG_OAT              = (TAG_USER+$400);  (* Object attribute *)
        TRTG_OBJ              = (TAG_USER+$100);  (* Object ID *)
        TRTG_OAT2             = (TAG_USER+$80);   (* PRIVATE! *)
        TRTG_PAT              = (TAG_USER);        (* Project attribute *)

(* Window/Project *)
CONST   TRWI_Title              = (TRTG_PAT+$01); (* STRPTR: The window title *)
        TRWI_Flags              = (TRTG_PAT+$02); (* See below for window flags *)
        TRWI_Underscore         = (TRTG_PAT+$03); (* BYTE *: The underscore for menu and gadget shortcuts *)
        TRWI_Position           = (TRTG_PAT+$04); (* Window position,  see below *)
        TRWI_CustomScreen       = (TRTG_PAT+$05); (* STRUCT Screen * *)
        TRWI_PubScreen          = (TRTG_PAT+$06); (* STRUCT Screen *,  must have been locked! *)
        TRWI_PubScreenName      = (TRTG_PAT+$07); (* ADDRESS,  Triton is doing the locking *)
        TRWI_PropFontAttr       = (TRTG_PAT+$08); (* STRUCT TextAttr *: The proportional font *)
        TRWI_FixedWidthFontAttr = (TRTG_PAT+$09); (* STRUCT TextAttr *: The fixed-width font *)
        TRWI_Backfill           = (TRTG_PAT+$0A); (* The backfill type,  see below *)
        TRWI_ID                 = (TRTG_PAT+$0B); (* ULONG: The window ID *)
        TRWI_Dimensions         = (TRTG_PAT+$0C); (* STRUCT TR_Dimensions * *)
        TRWI_ScreenTitle        = (TRTG_PAT+$0D); (* STRPTR: The screen title *)
        TRWI_QuickHelp          = (TRTG_PAT+$0E); (* BOOL: Quick help active? *)

(* Menus *)
CONST   TRMN_Title              = (TRTG_PAT+$65); (* STRPTR: Menu *)
        TRMN_Item               = (TRTG_PAT+$66); (* STRPTR: Menu item *)
        TRMN_Sub                = (TRTG_PAT+$67); (* STRPTR: Menu subitem *)
        TRMN_Flags              = (TRTG_PAT+$68); (* See below for flags *)

(* General object attributes *)
CONST   TRAT_ID               = (TRTG_OAT2+$16);  (* The object's/menu's ID *)
        TRAT_Flags            = (TRTG_OAT2+$17);  (* The object's flags *)
        TRAT_Value            = (TRTG_OAT2+$18);  (* The object's value *)
        TRAT_Text             = (TRTG_OAT2+$19);  (* The object's text *)
        TRAT_Disabled         = (TRTG_OAT2+$1A);  (* Disabled object? *)
        TRAT_Backfill         = (TRTG_OAT2+$1B);  (* Backfill pattern *)
        TRAT_MinWidth         = (TRTG_OAT2+$1C);  (* Minimum width *)
        TRAT_MinHeight        = (TRTG_OAT2+$1D);  (* Minimum height *)


(* ////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////// Window flags // *)
(* ////////////////////////////////////////////////////////////////////// *)

CONST   TRWF_BACKDROP           = $00000001;     (* Create a backdrop borderless window *)
        TRWF_NODRAGBAR          = $00000002;     (* Don't use a dragbar *)
        TRWF_NODEPTHGADGET      = $00000004;     (* Don't use a depth-gadget *)
        TRWF_NOCLOSEGADGET      = $00000008;     (* Don't use a close-gadget *)
        TRWF_NOACTIVATE         = $00000010;     (* Don't activate window *)
        TRWF_NOESCCLOSE         = $00000020;     (* Don't send TRMS_CLOSEWINDOW when Esc is pressed *)
        TRWF_NOPSCRFALLBACK     = $00000040;     (* Don't fall back onto default PubScreen *)
        TRWF_NOZIPGADGET        = $00000080;     (* Don't use a zip-gadget *)
        TRWF_ZIPCENTERTOP       = $00000100;     (* Center the zipped window on the title bar *)
        TRWF_NOMINTEXTWIDTH     = $00000200;     (* Minimum window width not according to title text *)
        TRWF_NOSIZEGADGET       = $00000400;     (* Don't use a sizing-gadget *)
        TRWF_NOFONTFALLBACK     = $00000800;     (* Don't fall back to topaz.8 *)
        TRWF_NODELZIP           = $00001000;     (* Don't zip the window when Del is pressed *)
        TRWF_SIMPLEREFRESH      = $00002000;     (* *** OBSOLETE *** (V3+) *)
        TRWF_ZIPTOCURRENTPOS    = $00004000;     (* Will zip the window at the current position (OS3.0+) *)
        TRWF_APPWINDOW          = $00008000;     (* Create an AppWindow without using class_dropbox *)
        TRWF_ACTIVATESTRGAD     = $00010000;     (* Activate the first string gadget after opening the window *)
        TRWF_HELP               = $00020000;     (* Pressing <Help> will create a TRMS_HELP message (V4) *)
        TRWF_SYSTEMACTION       = $00040000;     (* System status messages will be sent (V4) *)


(* ////////////////////////////////////////////////////////////////////// *)
(* //////////////////////////////////////////////////////// Menu flags // *)
(* ////////////////////////////////////////////////////////////////////// *)

CONST   TRMF_CHECKIT            = $00000001;     (* Leave space for a checkmark *)
        TRMF_CHECKED            = $00000002;     (* Check the item (includes TRMF_CHECKIT) *)
        TRMF_DISABLED           = $00000004;     (* Ghost the menu/item *)


(* ////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////// Window positions // *)
(* ////////////////////////////////////////////////////////////////////// *)

CONST   TRWP_DEFAULT            = 0;              (* Let Triton choose a good position *)
        TRWP_BELOWTITLEBAR      = 1;              (* Left side of screen,  below title bar *)
        TRWP_CENTERTOP          = 1025;           (* Top of screen,  centered on the title bar *)
        TRWP_TOPLEFTSCREEN      = 1026;           (* Top left corner of screen *)
        TRWP_CENTERSCREEN       = 1027;           (* Centered on the screen *)
        TRWP_CENTERDISPLAY      = 1028;           (* Centered on the currently displayed clip *)
        TRWP_MOUSEPOINTER       = 1029;           (* Under the mouse pointer *)
        TRWP_ABOVECOORDS        = 2049;           (* Above coordinates from the dimensions STRUCT *)
        TRWP_BELOWCOORDS        = 2050;           (* Below coordinates from the dimensions STRUCT *)


(* ////////////////////////////////////////////////////////////////////// *)
(* //////////////////////////////////// Backfill types / System images // *)
(* ////////////////////////////////////////////////////////////////////// *)

CONST   TRBF_WINDOWBACK         = $00000000;     (* Window backfill *)
        TRBF_REQUESTERBACK      = $00000001;     (* Requester backfill *)

        TRBF_NONE               = $00000002;     (* No backfill (= Fill with BACKGROUNDPEN) *)
        TRBF_SHINE              = $00000003;     (* Fill with SHINEPEN *)
        TRBF_SHINE_SHADOW       = $00000004;     (* Fill with SHINEPEN + SHADOWPEN *)
        TRBF_SHINE_FILL         = $00000005;     (* Fill with SHINEPEN + FILLPEN *)
        TRBF_SHINE_BACKGROUND   = $00000006;     (* Fill with SHINEPEN + BACKGROUNDPEN *)
        TRBF_SHADOW             = $00000007;     (* Fill with SHADOWPEN *)
        TRBF_SHADOW_FILL        = $00000008;     (* Fill with SHADOWPEN + FILLPEN *)
        TRBF_SHADOW_BACKGROUND  = $00000009;     (* Fill with SHADOWPEN + BACKGROUNDPEN *)
        TRBF_FILL               = $0000000A;     (* Fill with FILLPEN *)
        TRBF_FILL_BACKGROUND    = $0000000B;     (* Fill with FILLPEN + BACKGROUNDPEN *)

        TRSI_USBUTTONBACK       = $00010002;     (* Unselected button backfill *)
        TRSI_SBUTTONBACK        = $00010003;     (* Selected button backfill *)


(* ////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////// Display Object flags // *)
(* ////////////////////////////////////////////////////////////////////// *)

(* General flags *)
CONST   TROF_RAISED             = $00000001;     (* Raised object *)
        TROF_HORIZ              = $00000002;     (* Horizontal object \ Works automatically *)
        TROF_VERT               = $00000004;     (* Vertical object   / in groups *)
        TROF_RIGHTALIGN         = $00000008;     (* Align object to the right border if available *)

(* Text flags for different kinds of text-related objects *)
CONST   TRTX_NOUNDERSCORE       = $00000100;     (* Don't interpret underscores *)
        TRTX_HIGHLIGHT          = $00000200;     (* Highlight text *)
        TRTX_3D                 = $00000400;     (* 3D design *)
        TRTX_BOLD               = $00000800;     (* Softstyle 'bold' *)
        TRTX_TITLE              = $00001000;     (* A title (e.g. of a group) *)
        TRTX_SELECTED           = $00002000;     (* PRIVATE! *)


(* ////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////// Menu entries // *)
(* ////////////////////////////////////////////////////////////////////// *)

CONST   TRMN_BARLABEL           = (-1);           (* A barlabel instead of text *)


(* ////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////// Tags for TR_CreateApp() // *)
(* ////////////////////////////////////////////////////////////////////// *)

CONST   TRCA_Name               = (TAG_USER+1);
        TRCA_LongName           = (TAG_USER+2);
        TRCA_Info               = (TAG_USER+3);
        TRCA_Version            = (TAG_USER+4);
        TRCA_Release            = (TAG_USER+5);
        TRCA_Date               = (TAG_USER+6);


(* ////////////////////////////////////////////////////////////////////// *)
(* ///////////////////////////////////////// Tags for TR_EasyRequest() // *)
(* ////////////////////////////////////////////////////////////////////// *)

CONST   TREZ_ReqPos             = (TAG_USER+1);
        TREZ_LockProject        = (TAG_USER+2);
        TREZ_Return             = (TAG_USER+3);
        TREZ_Title              = (TAG_USER+4);
        TREZ_Activate           = (TAG_USER+5);

(* ------------------------------------------------------------------------------ *)
(* The Application Structure                                                      *)
(* ------------------------------------------------------------------------------ *)

TYPE TR_App = RECORD (* This structure is PRIVATE! *)
         tra_MemPool    : Address;       (* The memory pool             *)
         tra_BitMask    : Integer;       (* Bits to Wait() for          *)
         tra_LastError  : Integer;       (* trer code of last error     *)
         tra_Name       : String;        (* Unique name                 *)
         tra_LongName   : String;        (* User-readable name          *)
         tra_Info       : String;        (* Info string                 *)
         tra_Version    : String;        (* Version                     *)
         tra_Release    : String;        (* Release                     *)
         tra_Date       : String;        (* Compilation date            *)
         tra_AppPort    : MsgPortPtr;    (* Application message port    *)
         tra_IdcmpPort  : MsgPortPtr;    (* IDCMP message port          *)
         tra_Prefs      : Address;       (* Pointer to Triton app prefs *)
         (* tra_LastProject: TR_ProjectPtr; *) (* Used FOR menu item linking  *)
         tra_LastProject : ADDRESS;
         tra_InputEvent : InputEventPtr; (* For RAWKEY conversion   *)
     END; (* TR_App *)
     TR_AppPtr = ^TR_App;


(* ------------------------------------------------------------------------------ *)
(* The Dimension Structure                                                        *)
(* ------------------------------------------------------------------------------ *)

TYPE TR_Dimensions = RECORD
         trd_Left          : Short;
         trd_Top           : Short;
         trd_Width         : Short;
         trd_Height        : Short;
         trd_Left2         : Short;
         trd_Top2          : Short;
         trd_Width2        : Short;
         trd_Height2       : Short;
         trd_Zoomed        : BOOL;
         reserved          : ARRAY [0..2] OF Short;
     END; (* TR_Dimensions *)
     TR_DimensionsPtr = ^TR_Dimensions;

(* ------------------------------------------------------------------------------ *)
(* The Projects Structure                                                         *)
(* ------------------------------------------------------------------------------ *)

TYPE TR_Project = RECORD                                       (* This structure is PRIVATE! *)
         trp_App                      : TR_AppPtr;            (* Our application            *)
         trp_Screen                   : ScreenPtr;            (* Our screen, always valid   *)

         trp_LockedPubScreen          : Integer;              (* Only valid if we're using  *)
                                                              (* a PubScreen                *)
         trp_ScreenTitle              : String;               (* The screen title           *)

         trp_Window                   : WindowPtr;            (* The window                 *)
         trp_Id                       : Integer;              (* The window ID              *)
         trp_AppWindow                : AppWindowPtr;         (* AppWindow for icon         *)
                                                              (* dropping                   *)

         trp_IdcmpFlags               : Integer;              (* The IDCMP flags            *)
         trp_Flags                    : Integer;              (* Triton window flags        *)

         trp_NewMenu                  : NewMenuPtr;           (* The newmenu stucture       *)
                                                              (* built by Triton            *)
         trp_NewMenuSize              : Integer;              (* The number of menu         *)
                                                              (* items in the list          *)
         trp_Menu                     : MenuPtr;              (* The menu structure         *)
         trp_NextSelect               : Short;                (* The next selected menu     *)
                                                              (* item                       *)

         trp_VisualInfo               : Address;              (* The VisualInfo of our      *)
                                                              (* window                     *)
         trp_DrawInfo                 : DrawInfoPtr;          (* DrawInfo of the screen     *)
         trp_UserDimensions           : TR_DimensionsPtr;     (* supplied dimensions        *)
         trp_Dimensions               : TR_DimensionsPtr;     (* Private dimensions         *)

         trp_WindowStdHeight          :Integer;         (* standard height of the window    *)
         trp_LeftBorder               : Integer;        (* left window border width         *)
         trp_RightBorder              : Integer;        (* right window border width        *)
         trp_TopBorder                : Integer;        (* top window border height         *)
         trp_BottomBorder             : Integer;        (* bottom window border height      *)
         trp_InnerWidth               : Integer;        (* inner width of the window        *)
         trp_InnerHeight              : Integer;        (* inner height of the window       *)
         trp_ZipDimensions            : ARRAY [0..3] OF Short;         (* The dimensions    *)
                                                        (* for the zipped window            *)
         trp_AspectFixing             : Short;          (*Pixel aspect correction factor    *)

         trp_ObjectList               : MinList;        (* The list of display objects      *)
         trp_MenuList                 : MinList;        (* The list of menus                *)
         trp_IdList                   : MinList;        (* The ID linking list              *)
                                                        (* (menus & objects)                *)
         trp_MemPool                  : Address;        (* memory pool for the lists        *)
         trp_HasObjects               : BOOL;           (* Do we have display objects?      *)

         trp_PropAttr                 : TextAttrPtr;    (* The proportional font            *)
                                                        (* attributes                       *)
         trp_FixedWidthAttr           : TextAttrPtr;    (* The fixed-width font             *)
                                                        (* attributes                       *)
         trp_PropFont                 : TextFontPtr;    (* The proportional font            *)
         trp_FixedWidthFont           : TextFontPtr;    (* The fixed-width font             *)
         trp_OpenedPropFont           : BOOL;           (* Have we opened the               *)
         trp_OpenedFixedWidthFont     : BOOL;           (* fonts ?                          *)
         trp_TotalPropFontHeight      : Short;          (* Height of prop font              *)
                                                        (* incl. underscore                 *)

         trp_BackfillType             : Integer;        (* The backfill type                *)
         trp_BackfillHook             : HookPtr;        (* The backfill hook                *)
         trp_GadToolsGadgetList       : GadgetPtr;      (* List of GadTools                 *)
                                                        (* gadgets                          *)
         trp_PrevGadget               : GadgetPtr;      (* Previous gadget                  *)
         trp_NewGadget                : NewGadgetPtr;   (* GadTools NewGadget               *)

         trp_InvisibleRequest         : RequesterPtr;   (* The invisible blocking requester *)
         trp_IsUserLocked             : BOOL;           (* Project locked by the user?      *)

         trp_CurrentID                : Integer;        (* currently keyboard-selected ID   *)
         trp_IsCancelDown             : BOOL;           (* Cancellation key pressed?        *)
         trp_IsShortcutDown           : BOOL;           (* Shortcut key pressed?            *)
         trp_Underscore               : Byte;           (* The underscore character         *)

         trp_EscClose                 : BOOL;           (* Close window on Esc ?            *)
         trp_DelZip                   : BOOL;           (* Zip window on Del ?              *)
         trp_PubScreenFallBack        : BOOL;           (* Fall back onto default public    *)
                                                        (* screen ?                         *)
         trp_FontFallBack             : BOOL;           (* Fall back to topaz.8 ?           *)

         trp_OldWidth                 : Short;          (* Old window width                 *)
         trp_OldHeight                : Short;          (* Old window height                *)

         trp_QuickHelpWindow          : WindowPtr;      (* The QuickHelp window             *)
         trp_TicksPassed              : Integer;        (* IntuiTicks passed since last     *)
                                                        (* MouseMove                        *)

     END;                                               (* End of TR_Projects               *)
     TR_ProjectPtr = ^TR_Project;


(* class_DisplayObject *)

CONST   TROB_DisplayObject      = (TRTG_OBJ+$3C); (* A basic display object *)

        TRDO_QuickHelpString    = (TRTG_OAT+$1E3);

(* class_Group *)

CONST   TRGR_Horiz              = (TAG_USER+201);  (* Horizontal group *)
        TRGR_Vert               = (TAG_USER+202);  (* Vertical group *)
        TRGR_End                = (TRTG_OAT2+$4B); (* End of a group *)

        TRGR_PROPSHARE          = $00000000;     (* Default: Divide objects proportionally *)
        TRGR_EQUALSHARE         = $00000001;     (* Divide objects equally *)
        TRGR_PROPSPACES         = $00000002;     (* Divide spaces proportionally *)
        TRGR_ARRAY              = $00000004;     (* Top-level array group *)

        TRGR_ALIGN              = $00000008;     (* Align resizeable objects in secondary dimension *)
        TRGR_CENTER             = $00000010;     (* Center unresizeable objects in secondary dimension *)

        TRGR_FIXHORIZ           = $00000020;     (* Don't allow horizontal resizing *)
        TRGR_FIXVERT            = $00000040;     (* Don't allow vertical resizing *)
        TRGR_INDEP              = $00000080;     (* Group is independant of surrounding array *)

(* class_Space *)

CONST   TROB_Space              = (TRTG_OBJ+$285); (* The spaces class *)

        TRST_NONE               = 1;              (* No space *)
        TRST_SMALL              = 2;              (* Small space *)
        TRST_NORMAL             = 3;              (* Normal space (default) *)
        TRST_BIG                = 4;              (* Big space *)

(* class_CheckBox *)

CONST   TROB_CheckBox           = (TRTG_OBJ+$2F); (* A checkbox gadget *)

(* class_Object *)

CONST   TROB_Object             = (TRTG_OBJ+$3D); (* A rootclass object *)

(* class_Cycle *)

CONST   TROB_Cycle              = (TRTG_OBJ+$36); (* A cycle gadget *)

        TRCY_MX                 = $00010000;     (* Unfold the cycle gadget to a MX gadget *)
        TRCY_RIGHTLABELS        = $00020000;     (* Put the labels to the right of a MX gadget *)

(* class_DropBox *)

CONST   TROB_DropBox            = (TRTG_OBJ+$38); (* An icon drop box *)

(* class_Scroller *)

CONST   TROB_Scroller           = (TRTG_OBJ+$35); (* A scroller gadget *)

        TRSC_Total              = (TRTG_OAT+$1E0);
        TRSC_Visible            = (TRTG_OAT+$1E1);

(* class_FrameBox *)

CONST   TROB_FrameBox           = (TRTG_OBJ+$32); (* A framing box *)

        TRFB_GROUPING           = $00000001;     (* A grouping box *)
        TRFB_FRAMING            = $00000002;     (* A framing box *)
        TRFB_TEXT               = $00000004;     (* A text container *)

(* class_Button *)

CONST   TROB_Button             = (TRTG_OBJ+$31); (* A BOOPSI button gadget *)

        TRBU_RETURNOK           = $00010000;     (* <Return> answers the button *)
        TRBU_ESCOK              = $00020000;     (* <Esc> answers the button *)
        TRBU_SHIFTED            = $00040000;     (* Shifted shortcut only *)
        TRBU_UNSHIFTED          = $00080000;     (* Unshifted shortcut only *)
        TRBU_YRESIZE            = $00100000;     (* Button resizeable in Y direction *)
        TRBT_TEXT               = 0;              (* Text button *)
        TRBT_GETFILE            = 1;              (* GetFile button *)
        TRBT_GETDRAWER          = 2;              (* GetDrawer button *)
        TRBT_GETENTRY           = 3;              (* GetEntry button *)

(* class_Line *)

CONST   TROB_Line               = (TRTG_OBJ+$2D); (* A simple line *)

(* class_Palette *)

CONST   TROB_Palette            = (TRTG_OBJ+$33); (* A palette gadget *)

(* class_Slider *)

CONST   TROB_Slider             = (TRTG_OBJ+$34); (* A slider gadget *)

        TRSL_Min                = (TRTG_OAT+$1DE);
        TRSL_Max                = (TRTG_OAT+$1DF);

(* class_Progress *)

CONST   TROB_Progress           = (TRTG_OBJ+$3A); (* A progress indicator *)

(* class_Text *)

CONST   TROB_Text               = (TRTG_OBJ+$30); (* A line of text *)

        TRTX_CLIPPED            = $00010000;     (* Text is clipped *)
(* class_Listview *)

CONST   TROB_Listview           = (TRTG_OBJ+$39); (* A listview gadget *)

        TRLV_Top                = (TRTG_OAT+$1E2);

        TRLV_READONLY           = $00010000;     (* A read-only list *)
        TRLV_SELECT             = $00020000;     (* You may select an entry *)
        TRLV_SHOWSELECTED       = $00040000;     (* Selected entry will be shown *)
        TRLV_NOCURSORKEYS       = $00080000;     (* Don't use arrow keys *)
        TRLV_NONUMPADKEYS       = $00100000;     (* Don't use numeric keypad keys *)
        TRLV_FWFONT             = $00200000;     (* Use the fixed-width font *)
        TRLV_NOGAP              = $00400000;     (* Don't leave a gap below the list *)

(* class_Image *)

CONST   TROB_Image              = (TRTG_OBJ+$3B); (* An image *)

        TRIM_BOOPSI             = $00010000;     (* Use a BOOPSI IClass image *)

(* class_String *)

CONST   TROB_String             = (TRTG_OBJ+$37); (* A string gadget *)

        TRST_INVISIBLE          = $00010000;     (* A password gadget -> invisible typing *)
        TRST_NORETURNBROADCAST  = $00020000;     (* <Return> keys will not be broadcast to the window *)

(* End of automatically assembled code *)


(* ////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////// The End // *)
(* ////////////////////////////////////////////////////////////////////// *)
         
var
  TritonBase : Address;

function TR_OpenProject(app : TR_AppPtr; taglist : TagItemPtr):TR_ProjectPtr;
    EXTERNAL;

PROCEDURE TR_CloseProject(project : TR_ProjectPtr);
    EXTERNAL;

function TR_FirstOccurance( ch : Integer): Integer;
    EXTERNAL;

function TR_NumOccurances(ch : Integer; str : string): Integer;
    EXTERNAL;

function TR_GetErrorString(num : Short): String;
    EXTERNAL;

PROCEDURE TR_SetAttribute(project : TR_ProjectPtr; ID, attribute, VALUE: Integer);
    EXTERNAL;

function TR_GetAttribute(project : TR_ProjectPtr; ID, attribute : Integer):Integer;
    EXTERNAL;

procedure TR_LockProject(project : TR_ProjectPtr);
    EXTERNAL;

Procedure TR_UnlockProject(project : TR_ProjectPtr);
    EXTERNAL;

function TR_AutoRequest(app : TR_AppPtr; lockproject : TR_ProjectPtr; wintags : TagItemPtr): Integer;
    EXTERNAL;

function TR_EasyRequest(app : TR_AppPtr; bodyfmt, gadfmt : String; taglist: TagItemPtr): Integer;
    EXTERNAL;

function TR_CreateApp(apptags : TagItemPtr): TR_AppPtr;
    EXTERNAL;

Procedure TR_DeleteApp(app: TR_AppPtr);
    EXTERNAL;

function TR_GetMsg(app : TR_AppPtr): TR_MessagePtr;
    EXTERNAL;

Procedure TR_ReplyMsg(message : TR_MessagePtr);
    EXTERNAL;

function TR_Wait(app : TR_AppPtr; otherbits : Integer): Integer;
    EXTERNAL;

Procedure TR_CloseWindowSafely(window : WindowPtr);
    EXTERNAL;

function TR_GetLastError(app: TR_AppPtr): Short;
    EXTERNAL;

function TR_LockScreen(project : TR_ProjectPtr): ScreenPtr;
    EXTERNAL;

Procedure TR_UnlockScreen(screen : ScreenPtr);
    EXTERNAL;

function TR_ObtainWindow(project : TR_ProjectPtr): WindowPtr;
    EXTERNAL;

Procedure TR_ReleaseWindow(window : WindowPtr);
    EXTERNAL;

function TR_SendMessage(project : TR_ProjectPtr; objectid, messageid: Integer; messagedata : Address): Integer;
    EXTERNAL;



