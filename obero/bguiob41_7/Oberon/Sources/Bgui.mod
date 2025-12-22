(*------------------------------------------
  :
  :Module.      Bgui.mod
  :Author.      Larry Kuhns [lak]
  :Address.     Cortland, Ohio
  :Revision.    $VER 41.7
  :Date.        02-Dec-1996
  :Copyright.   NONE
  :Language.    Oberon-2
  :Translator.  Amiga Oberon V3.11d (Converted to English)
  :Contents.
  :Imports.     AmigaOberon Amiga interface modules
  :Remarks.     BGUI Library Interface
  :Bugs.        None Known - but probably many
  :Usage.
  :History.     41.7   [lak] 02-Dec-1996 : Initial Release for BGUI
  :                                        Library V41.7
  :
--------------------------------------------*)

(* %CaseChk-  %NilChk-  *)
(* %RangeChk- %StackChk- %TypeChk-  %OvflChk- *)

MODULE Bgui;

(*
**      $VER: libraries/bgui.h 41.7 (11.11.96)
**      C header for the bgui.library.
**
**      bgui.Library structures and constants.
**
**      (C) Copyright 1996 Ian J. Einman.
**      (C) Copyright 1993-1996 Jaba Development.
**      (C) Copyright 1993-1996 Jan van den Baard.
**      All Rights Reserved.
*)


IMPORT
         Classface,
  e   := Exec,
  g   := Graphics,
  i   := Intuition,
  ih  := InputEvent,
  lo  := Locale,
  u   := Utility,
  y   := SYSTEM;


(*****************************************************************************
 *
 *      The attribute definitions in this header are all followed by
 *      a small comment. This comment can contain the following things:
 *
 *      I - Attribute can be set with OM_NEW
 *      S - Attribute can be set with OM_SET
 *      G - Attribute can be read with OM_GET
 *      N - Setting this attribute triggers a notification.
 *      U - Attribute can be set with OM_UPDATE.
 *)

(*****************************************************************************
 *
 *      Miscellanious library definitions.
 *)
CONST
  name    *= "bgui.library";
  minimum *= 37;
  version *= 41;

TYPE

  Object     *= i.ObjectPtr;

  dispatcher *= PROCEDURE ( class{8}   : i.IClassPtr;
                            obj{10}    : Object;
                            message{9} : i.MsgPtr    ):e.APTR;



(*****************************************************************************
**
**      Hook definitions - Added to make hook usage easier LAK - 11/30/96
*)
TYPE
  Hook      *= u.HookPtr;
  Args      *= UNTRACED POINTER TO ArgsDesc;
  ArgsDesc  *= STRUCT END;

  HookDef   *= PROCEDURE ( hook : u.HookPtr; object : Object; args : Args ):LONGINT;

  PROCEDURE MakeHook * ( VAR hook : u.Hook; entry: HookDef );
    BEGIN
      u.InitHook( y.ADR( hook ), y.VAL( u.HookFunc, entry ) );
    END MakeHook;


(*****************************************************************************
 *
 *      BGUI_GetClassPtr() and BGUI_NewObjectA() class ID's.
 *)

CONST

  labelImage        *= 0;
  frameImage        *= 1;
  vectorImage       *= 2;

(* 3 through 10 reserved. *)

  baseGadget        *= 11;
  groupGadget       *= 12;
  buttonGadget      *= 13;
  cycleGadget       *= 14;
  checkBoxGadget    *= 15;
  infoGadget        *= 16;
  stringGadget      *= 17;
  propGadget        *= 18;
  indicatorGadget   *= 19;
  viewGadget        *= 20;
  progressGadget    *= 21;
  sliderGadget      *= 22;
  listviewGadget    *= 23;
  mxGadget          *= 24;
  pageGadget        *= 25;
  externalGadget    *= 26;
  separatorGadget   *= 27;
  areaGadget        *= 28;
  radioButtonGadget *= 29;
  paletteGadget     *= 30;
  popButtonGadget   *= 31;

(* 32 through 39 reserved. *)

  windowObject      *= 40;
  fileReqObject     *= 41;
  commodityObject   *= 42;
  aslReqObject      *= 43;
  fontReqObject     *= 44;
  screenReqObject   *= 45;
  arexxObject       *= 46;

(* 47 through 99 reserved. *)

  notifyObject      *= 100;
  notifygObject     *= 101;

(* Typo *)
  seperatorGadget   *= separatorGadget;

(*****************************************************************************
 *
 *      BGUI requester definitions.
 *)
TYPE
  requestPtr *= UNTRACED POINTER TO request;
  request *= STRUCT
    flags        *: LONGSET;             (* See below.               *)
    title        *: e.LSTRPTR;           (* Requester title.         *)
    gadgetFormat *: e.LSTRPTR;           (* Gadget labels.           *)
    textFormat   *: e.LSTRPTR;           (* Body text format.        *)
    reqPos       *: INTEGER;             (* Requester position.      *)
    textAttr     *: g.TextAttrPtr;       (* Requester font.          *)
    underscore   *: CHAR;                (* Underscore indicator.    *)
    reserved0    *: ARRAY 3 OF SHORTINT; (* Set to 0!                *)
    screen       *: i.ScreenPtr;         (* Optional screen pointer. *)
    reserved1    *: ARRAY 4 OF LONGINT;  (* Set to 0!                *)
    END;

CONST
  reqfCenterWindow *= 0;  (* 1<<0 Center requester on the window.   *)
  reqfLockWindow   *= 1;  (* 1<<1 Lock the parent window.           *)
  reqfNoPattern    *= 2;  (* 1<<2 Don't use back-fill pattern.      *)
  reqfXenButtons   *= 3;  (* 1<<3 Use XEN style buttons.            *)
  reqfAutoAspect   *= 4;  (* 1<<4 Aspect-ratio dependant look.      *)
  reqfFastKeys     *= 5;  (* 1<<5 Return/Esc hotkeys.               *)
  reqfFuzzButtons  *= 6;  (* 1<<6 Use fuzz style buttons.           *)

(*****************************************************************************
 *
 *      BGUI localization definitions.
 *)
TYPE
  LocalePtr *= UNTRACED POINTER TO Locale;
  Locale *= STRUCT( d *: ArgsDesc )
    locale         *: lo.LocalePtr;   (* Locale to use.         *)
    catalog        *: lo.CatalogPtr;  (* Catalog to use.        *)
    localeStrHook  *: u.HookPtr;      (* Localization function. *)
    catalogStrHook *: u.HookPtr;      (* Localization function. *)
    userData       *: e.APTR;         (* For application use.   *)
    END;

  LocaleStrPr *= UNTRACED POINTER TO LocaleStr;
  LocaleStr *= STRUCT( d *: ArgsDesc )
    ID *: LONGINT;                   (* ID of locale string. *)
    END;

  CatalogStrPtr *= UNTRACED POINTER TO CatalogStr;
  CatalogStr *= STRUCT( d *: ArgsDesc )
    ID            *: LONGINT;        (* ID of locale string.        *)
    defaultString *: e.STRPTR;       (* Default string for this ID. *)
    END;

(*****************************************************************************
 *
 *      BGUI graphics definitions.
 *)
TYPE
  PatternPtr *= UNTRACED POINTER TO Pattern;
  Pattern *= STRUCT( d *: ArgsDesc )
    flags  *: LONGSET;     (* Flags see below).         *)
    left   *: INTEGER;     (* Offset into bitmap.      *)
    top    *: INTEGER;
    width  *: INTEGER;     (* Size of cut from bitmap. *)
    height *: INTEGER;
    bitMap *: g.BitMapPtr; (* Pattern bitmap.          *)
    object *: Object;      (* Datatype object.         *)
    END;

CONST

  pfRelativeOrigin *= 0;    (* 1<<0 Origin relative to box. *)

(*****************************************************************************
 *
 *      Tag and method bases.
 *
 *      Range 0x800F0000 - 0x800FFFFF is reserved for BGUI tags.
 *      Range 0x80020000 - 0x8002FFFF is reserved for imageclass tags.
 *      Range 0x80030000 - 0x8003FFFF is reserved for gadgetclass tags.
 *      Range 0x80040000 - 0x8004FFFF is reserved for icclass tags.
 *      Range 0x80080000 - 0x8008FFFF is reserved for gadtools and asl tags.
 *
 *      Range 0x000F0000 - 0x000FFFFF is reserved for BGUI methods.
 *      Range 0x00000001 - 0x0000FFFF is reserved for BOOPSI methods.
 *
 *      For custom classes, keep away from these ranges.  Values greater than
 *      0x80100000 for tags and 0x00100000 for methods are suggested.
 *)
CONST

  bguiTb *= 800F0000H;
  bguiMb *= 0F0000H;

(**** LAK

(*****************************************************************************
 *
 *      Class implementor information.
 *)

typedef ULONG  ( *FUNCPTR)();

typedef struct DispatcherFunction {
   ULONG       df_MethodID;
   HOOKFUNC    df_Func;
}  DPFUNC;
*** LAK *)
CONST
  dfEnd *= -1;


(* For use with the BGUI_MakeClass() call. *)
CONST
  classSuperClass     *= bguiTb + 10001;
  classSuperClassID   *= bguiTb + 10002;
  classSuperClassBGUI *= bguiTb + 10003;
  classClassID        *= bguiTb + 10004;
  classClassSize      *= bguiTb + 10005;
  classObjectSize     *= bguiTb + 10006;
  classFlags          *= bguiTb + 10007;
  classDispatcher     *= bguiTb + 10008;
  classDFTable        *= bguiTb + 10009;

TYPE
  ClassBasePtr *= UNTRACED POINTER TO ClassBase;
  ClassBase *= STRUCT
    library *: e.Library;
    class   *: i.ClassPtr;
    END;

(*****************************************************************************
 *
 *      "frameclass" - BOOPSI framing image.
 *
 *      Tags: 1 - 80    Methods: 21 - 40
 *)

CONST

  frmTagStart                 *= bguiTb + 1;
  frmType                     *= bguiTb + 1;  (* ISG-- *)
  frmCustomHook               *= bguiTb + 2;  (* ISG-- *)
  frmBackFillHook             *= bguiTb + 3;  (* ISG-- *)
  frmTitle                    *= bguiTb + 4;  (* ISG-- *)
  frmTextAttr                 *= bguiTb + 5;  (* ISG-- *)
  frmFlags                    *= bguiTb + 6;  (* ISG-- *)
  frmFrameWidth               *= bguiTb + 7;  (* ISG-- *)
  frmFrameHeight              *= bguiTb + 8;  (* ISG-- *)
  frmBackFill                 *= bguiTb + 9;  (* ISG-- *)
  frmEdgesOnly                *= bguiTb + 10; (* ISG-- *)
  frmRecessed                 *= bguiTb + 11; (* ISG-- *)
  frmCenterTitle              *= bguiTb + 12; (* ISG-- *)
  frmHighlightTitle           *= bguiTb + 13; (* ISG-- *)
  frmThinFrame                *= bguiTb + 14; (* ISG-- *)
  frmBackPen                  *= bguiTb + 15; (* ISG-- *) (* V39 *)
  frmSelectedBackPen          *= bguiTb + 16; (* ISG-- *) (* V39 *)
  frmBackDriPen               *= bguiTb + 17; (* ISG-- *) (* V39 *)
  frmSelectedBackDriPen       *= bguiTb + 18; (* ISG-- *) (* V39 *)
  frmTitleLeft                *= bguiTb + 19; (* ISG-- *) (* V40 *)
  frmTitleRight               *= bguiTb + 20; (* ISG-- *) (* V40 *)
  frmBackRasterPen            *= bguiTb + 21; (* ISG-- *) (* V41 *)
  frmBackRasterDriPen         *= bguiTb + 22; (* ISG-- *) (* V41 *)
  frmSelectedBackRasterPen    *= bguiTb + 23; (* ISG-- *) (* V41 *)
  frmSelectedBackRasterDriPen *= bguiTb + 24; (* ISG-- *) (* V41 *)
  frmTemplate                 *= bguiTb + 25; (* IS--- *) (* V41 *)
  frmTitleID                  *= bguiTb + 26; (* ISG-- *) (* V41 *)
  frmFillPattern              *= bguiTb + 27; (* ISG-- *) (* V41 *)
  frmSelectedFillPattern      *= bguiTb + 28; (* ISG-- *) (* V41 *)
  frmOuterOffsetLeft          *= bguiTb + 31; (* ISG-- *) (* V41 *)
  frmOuterOffsetRight         *= bguiTb + 32; (* ISG-- *) (* V41 *)
  frmOuterOffsetTop           *= bguiTb + 33; (* ISG-- *) (* V41 *)
  frmOuterOffsetBottom        *= bguiTb + 34; (* ISG-- *) (* V41 *)
  frmInnerOffsetLeft          *= bguiTb + 35; (* ISG-- *) (* V41 *)
  frmInnerOffsetRight         *= bguiTb + 36; (* ISG-- *) (* V41 *)
  frmInnerOffsetTop           *= bguiTb + 37; (* ISG-- *) (* V41 *)
  frmInnerOffsetBottom        *= bguiTb + 38; (* ISG-- *) (* V41 *)
  frmTagDone                  *= bguiTb + 80;

(* Back fill types *)
  standardFill      *= 0;
  shineRaster       *= 1;
  shadowRaster      *= 2;
  shineShadowRaster *= 3;
  fillRaster        *= 4;
  shineFillRaster   *= 5;
  shadowFillRaster  *= 6;
  shineBlock        *= 7;
  shadowBlock       *= 8;
  fillBlock         *= 9;

(* Flags *)
  frfEdgesOnly      *= 0;   (* 1<<0 *)
  frfRecessed       *= 1;   (* 1<<1 *)
  frfCenterTitle    *= 2;   (* 1<<2 *)
  frfHighlightTitle *= 3;   (* 1<<3 *)
  frfThinFrame      *= 4;   (* 1<<4 *)
  frfTitleLeft      *= 5;   (* 1<<5  V40 *)
  frfTitleRight     *= 6;   (* 1<<6  V40 *)

  frbEdgesOnly      *= 0;
  frbRecessed       *= 1;
  frbCenterTitle    *= 2;
  frbHighlightTitle *= 3;
  frbThinFrame      *= 4;
  frbTitleLeft      *= 5;   (* V40 *)
  frbTitleRight     *= 6;   (* V40 *)

(* Frame types *)
  frTypeCustom      *= 0;
  frTypeButton      *= 1;
  frTypeRidge       *= 2;
  frTypeDropBox     *= 3;
  frTypeNext        *= 4;
  frTypeRadioButton *= 5;
  frTypeXenButton   *= 6;
  frTypeTabAbove    *= 7;   (* V40 *)
  frTypeTabBelow    *= 8;   (* V40 *)
  frTypeBorder      *= 9;   (* V40 *)
  frTypeNone        *= 10;  (* V40 *)
  frTypeFuzzButton  *= 11;  (* V41 *)
  frTypeFuzzRidge   *= 12;  (* V41 *)


 fraMemBackfill     *= bguiMb + 21;

(* Backfill a specific rectangle with the backfill hook. *)
TYPE

  mBackfillPtr *= UNTRACED POINTER TO mBackfill;
  mBackfill *= STRUCT( msg *: i.Msg )  (* FRM_RENDER *)
    rPort    *: g.RastPortPtr;         (* RastPort ready for rendering *)
    drawInfo *: i.DrawInfoPtr;         (* All you need to render *)
    bounds   *: g.RectanglePtr;        (* Rendering bounds. *)
    state    *: LONGINT;               (* See intuition/imageclass.h *)
    END;

(*
 *      FRM_RENDER:
 *
 *      The message packet sent to both the FRM_CustomHook
 *      and FRM_BackFillHook routines. Note that this
 *      structure is READ-ONLY!
 *
 *      The hook is called as follows:
 *
 *              rc = hookFunc( REG(A0) struct Hook         *hook,
 *                             REG(A2) Object              *image_object,
 *                             REG(A1) struct FrameDrawMsg *fdraw );
 *)
CONST
  frmRender *= 1;    (* Render yourself *)

TYPE
  FrameDrawMsgPtr *= UNTRACED POINTER TO FrameDrawMsg;
  FrameDrawMsg *= STRUCT( msg *: i.Msg )  (* FRM_RENDER                   *)
    rPort      *: g.RastPortPtr;   (* RastPort ready for rendering *)
    drawInfo   *: i.DrawInfoPtr;   (* All you need to render       *)
    bounds     *: g.RectanglePtr;  (* Rendering bounds.            *)
    state      *: INTEGER;         (* See intuition/imageclass.h   *)
    (*
    ** The following fields are only defined under V41.
    *)
    horizontal *: SHORTINT;     (* Horizontal thickness *)
    vertical   *: SHORTINT;     (* Vertical thickness   *)
    END;

(*
 *      FRM_THICKNESS:
 *
 *      The message packet sent to the FRM_Custom hook.
 *
 *      The hook is called as follows:
 *
 *      rc = hookFunc( REG(A0) struct Hook              *hook,
 *                     REG(A2) Object                   *image_object,
 *                     REG(A1) struct ThicknessMsg      *thick );
 *)
CONST
  frmThickness *= 2;   (* Give the default frame thickness. *)

TYPE
  ThicknessPtr *= UNTRACED POINTER TO Thickness;
  Thickness *= STRUCT
    horizontal *: UNTRACED POINTER TO SHORTINT; (*Storage for horizontal *)
    vertical   *: UNTRACED POINTER TO SHORTINT; (*Storage for vertical *)
    END;

  mThicknessMsgPtr *= UNTRACED POINTER TO mThicknessMsgPtr;
  mThicknessMsg *= STRUCT( msg *: i.Msg )  (* FRM_THICKNESS *)
    thickness *: Thickness;
    thin      *: INTEGER;       (* BOOL Added in V38! *)
    END;

(* Possible hook return codes. *)
CONST
  frcOk      *= 0;   (* OK *)
  frcUnknown *= 1;   (* Unknown method *)


(*****************************************************************************
 *
 *      "labelclass" - BOOPSI labeling image.
 *
 *      Tags: 81 - 160          Methods: 1 - 20
 *)
CONST
  labTagStart          *= bguiTb + 81;
  labTextAttr          *= bguiTb + 81; (* ISG-- *)
  labStyle             *= bguiTb + 82; (* ISG-- *)
  labUnderscore        *= bguiTb + 83; (* ISG-- *)
  labPlace             *= bguiTb + 84; (* ISG-- *)
  labLabel             *= bguiTb + 85; (* ISG-- *)
  labFlags             *= bguiTb + 86; (* ISG-- *)
  labHighlight         *= bguiTb + 87; (* ISG-- *)
  labHighUScore        *= bguiTb + 88; (* ISG-- *)
  labPen               *= bguiTb + 89; (* ISG-- *)
  labSelectedPen       *= bguiTb + 90; (* ISG-- *)
  labDriPen            *= bguiTb + 91; (* ISG-- *)
  labSelectedDriPen    *= bguiTb + 92; (* ISG-- *)
  labLabelID           *= bguiTb + 93; (* ISG-- *) (* V41 *)
  labTemplate          *= bguiTb + 94; (* IS--- *) (* V41 *)
  labNoPlaceIn         *= bguiTb + 95; (* ISG-- *) (* V41.7 *)
  labSelectedStyle     *= bguiTb + 96; (* ISG-- *) (* V41.7 *)
  labFlipX             *= bguiTb + 97; (* ISG-- *) (* V41.7 *)
  labFlipY             *= bguiTb + 98; (* ISG-- *) (* V41.7 *)
  labFlipXY            *= bguiTb + 99; (* ISG-- *) (* V41.7 *)
  labTagDone           *= bguiTb + 160;

(* Flags *)
  labfHighlight  *= 0;   (* 1<<0 *) (* Highlight label        *)
  labfHighUScore *= 1;   (* 1<<1 *) (* Highlight underscoring *)
  labfFlipX      *= 2;   (* 1<<2 *) (* Flip across x axis     *)
  labfFlipY      *= 3;   (* 1<<3 *) (* Flip across y axis     *)
  labfFlipXY     *= 4;   (* 1<<4 *) (* Flip across x = y      *)

  labbHighlight  *= 0;   (* Highlight label        *)
  labbHighUScore *= 1;   (* Highlight underscoring *)
  labbFlipX      *= 2;   (* Flip across x axis     *)
  labbFlipY      *= 3;   (* Flip across y axis     *)
  labbFlipXY     *= 4;   (* Flip across x = y      *)

(* Label placement *)
  placeIn    *= 0;
  placeLeft  *= 1;
  placeRight *= 2;
  placeAbove *= 3;
  placeBelow *= 4;

(* New methods *)
(*
 *      The IM_EXTENT method is used to find out how many
 *      pixels the label extents the relative hitbox in
 *      either direction. Normally this method is called
 *      by the baseclass.
 *)

CONST

  imExtent *= bguiMb + 1;

TYPE

  LabelSizePtr *= UNTRACED POINTER TO LabelSize;
  LabelSize *= STRUCT
    width  *: UNTRACED POINTER TO INTEGER;   (* Storage width in pixels  *)
    height *: UNTRACED POINTER TO INTEGER;   (* Storage height in pixels *)
    END;

  mExtentPtr *= UNTRACED POINTER TO mExtent;
  mExtent *= STRUCT( msg *: i.Msg )   (* IM_EXTENT               *)
    rPort     *: g.RastPortPtr; (* RastPort                *)
    extent    *: i.IBoxPtr;     (* Storage for extentions. *)
    labelSize *: LabelSize;
    flags     *: SET;           (* See below.              *)
    END;

CONST

  extfMaximum *= 1;                 (* 1<<0 *) (* Request maximum extensions. *)


(*****************************************************************************
 *
 *      "vectorclass" - BOOPSI scalable vector image.
 *
 *      Tags: 161 - 240
 *
 *      Based on an idea found in the ObjectiveGadTools.library
 *      by Davide Massarenti.
 *)

CONST

  vitTagStart    *= bguiTb + 161;
  vitVectorArray *= bguiTb + 161;   (* ISG-- *)
  vitBuiltIn     *= bguiTb + 162;   (* ISG-- *)
  vitPen         *= bguiTb + 163;   (* ISG-- *)
  vitDriPen      *= bguiTb + 164;   (* ISG-- *)
  vitScaleWidth  *= bguiTb + 165;   (* --G-- *) (* V41 *)
  vitScaleHeight *= bguiTb + 166;   (* --G-- *) (* V41 *)
  vitTagDone     *= bguiTb + 240;

(*
 *      Command structure which can contain
 *      coordinates, data and command flags.
 *)

TYPE

  VectorItemPtr *= UNTRACED POINTER TO VectorItem;
  VectorItem *= STRUCT( d *: ArgsDesc )
    x     *: INTEGER;   (* X coordinate or data *)
    y     *: INTEGER;   (* Y coordinate         *)
    flags *: LONGSET;   (* See below            *)
    END;

(* Flags *)

CONST

  vifMove       *= 0;  (* 1<<0  *) (* Move to vc_x, vc_y               *)
  vifDraw       *= 1;  (* 1<<1  *) (* Draw to vc_x, vc_y               *)
  vifAreaStart  *= 2;  (* 1<<2  *) (* Start AreaFill at vc_x, vc_y     *)
  vifAreaEnd    *= 3;  (* 1<<3  *) (* End AreaFill at vc_x, vc_y       *)
  vifXrelRight  *= 4;  (* 1<<4  *) (* vc_x relative to right edge      *)
  vifYrelBottom *= 5;  (* 1<<5  *) (* vc_y relative to bottom edge     *)
  vifShadowPen  *= 6;  (* 1<<6  *) (* switch to SHADOWPEN, Move/Draw   *)
  vifShinePen   *= 7;  (* 1<<7  *) (* switch to SHINEPEN, Move/Draw    *)
  vifFillPen    *= 8;  (* 1<<8  *) (* switch to FILLPEN, Move/Draw     *)
  vifTextPen    *= 9;  (* 1<<9  *) (* switch to TEXTPEN, Move/Draw     *)
  vifColor      *= 10; (* 1<<10 *) (* switch to color in vc_x          *)
  vifLastItem   *= 11; (* 1<<11 *) (* last element of the element list *)
  vifScale      *= 12; (* 1<<12 *) (* X & Y are design width & height  *)
  vifDriPen     *= 13; (* 1<<13 *) (* switch to dripen vc_x            *)
  vifAolPen     *= 14; (* 1<<14 *) (* set area outline pen vc_x        *)
  vifAolDriPen  *= 15; (* 1<<15 *) (* set area outline dripen vc_x     *)
  vifEndOpen    *= 16; (* 1<<16 *) (* end area outline pen             *)

(* Built-in images. *)

  builtinGetPath     *= 1;
  builtinGetFile     *= 2;
  builtinCheckMark   *= 3;
  builtinPopup       *= 4;
  builtinArrowUp     *= 5;
  builtinArrowDown   *= 6;
  builtinArrowLeft   *= 7;
  builtinArrowRight  *= 8;
  builtinCycle       *= 9;  (* V41 *)
  builtinCycle2      *= 10; (* V41 *)
  builtinRadioButton *= 11; (* V41 *)

(* Design width and heights of the built-in images. *)

  getPathWidth     *= 20;
  getPathHeight    *= 14;
  getFileWidth     *= 20;
  getFileHeight    *= 14;
  checkMarkWidth   *= 24;
  checkMarkHeight  *= 11;
  popUpWidth       *= 15;
  popUpHeight      *= 13;
  arrowUpWidth     *= 16;
  arrowUpHeight    *= 9;
  arrowDownWidth   *= 16;
  arrowDownHeight  *= 9;
  arrowLeftWidth   *= 10;
  arrowLeftHeight  *= 12;
  arrowRightWidth  *= 10;
  arrowRightHeight *= 12;


(*****************************************************************************
 *
 *      "baseclass" - BOOPSI base gadget.
 *
 *      Tags: 241 - 320                 Methods: 41 - 80
 *
 *      This is a very important BGUI gadget class. All other gadget classes
 *      are sub-classed from this class. It will handle stuff like online
 *      help, notification, labels and frames etc. If you want to write a
 *      gadget class for BGUI be sure to subclass it from this class. That
 *      way your class will automatically inherit the same features.
 *)

CONST

  btTagstart        *= bguiTb + 241;
  btHelpfile        *= bguiTb + 241; (* ISG-- *)
  btHelpnode        *= bguiTb + 242; (* ISG-- *)
  btHelpline        *= bguiTb + 243; (* ISG-- *)
  btInhibit         *= bguiTb + 244; (* --G-- *)
  btHitBox          *= bguiTb + 245; (* --G-- *)
  btLabelObject     *= bguiTb + 246; (* -SG-- *)
  btFrameObject     *= bguiTb + 247; (* -SG-- *)
  btTextAttr        *= bguiTb + 248; (* ISG-- *)
  btNoRecessed      *= bguiTb + 249; (* -S--- *)
  btLabelClick      *= bguiTb + 250; (* ISG-- *)
  btHelpText        *= bguiTb + 251; (* ISG-- *)
  btToolTip         *= bguiTb + 252; (* ISG-- *) (* V40 *)
  btDragObject      *= bguiTb + 253; (* ISG-- *) (* V40 *)
  btDropObject      *= bguiTb + 254; (* ISG-- *) (* V40 *)
  btDragThreshold   *= bguiTb + 255; (* ISG-- *) (* V40 *)
  btDragQualifier   *= bguiTb + 256; (* ISG-- *) (* V40 *)
  btKey             *= bguiTb + 257; (* ISG-- *) (* V41.2 *)
  btRawKey          *= bguiTb + 258; (* ISG-- *) (* V41.2 *)
  btQualifier       *= bguiTb + 259; (* ISG-- *) (* V41.2 *)
  btHelpTextID      *= bguiTb + 260; (* ISG-- *) (* V41.3 *)
  btToolTipID       *= bguiTb + 261; (* ISG-- *) (* V41.3 *)
  btMouseActivation *= bguiTb + 262; (* ISG-- *) (* V41.5 *)
  btReserved1       *= bguiTb + 263; (* RESERVED *)
  btReserved2       *= bguiTb + 264; (* RESERVED *)
  btBuffer          *= bguiTb + 265; (* ISG-- *) (* V41.6 *)
  btLeftOffset      *= bguiTb + 266; (* ISG-- *) (* V41.6 *)
  btRightOffset     *= bguiTb + 267; (* ISG-- *) (* V41.6 *)
  btTopOffset       *= bguiTb + 268; (* ISG-- *) (* V41.6 *)
  btBottomOffset    *= bguiTb + 269; (* ISG-- *) (* V41.6 *)
  btHelpHook        *= bguiTb + 270; (* ISG-- *) (* V41.7 *)
  btTagDone         *= bguiTb + 320;

  mouseactRmbActive *= 0;   (* 1<<0 *)
  mouseactRmbReport *= 1;   (* 1<<1 *)
  mouseactMmbActive *= 2;   (* 1<<2 *)
  mouseactMmbReport *= 3;   (* 1<<3 *)

(* New methods *)

  baseAddMap *= bguiMb + 41;

(* Add an object to the maplist notification list. *)

TYPE

  mAddMapPtr *= UNTRACED POINTER TO mAddMap;
  mAddMap *= STRUCT( msg *: i.Msg )
    object     *: Object;
    mapList    *: u.TagItemPtr;
    END;

CONST

  baseAddConditional *= bguiMb + 42;

(* Add an object to the conditional notification list. *)

TYPE

  mAddConditionalPtr *= UNTRACED POINTER TO mAddConditional;
  mAddConditional *= STRUCT( msg *: i.Msg )
    object       *: Object;
    condition    *: u.TagItem;
    true         *: u.TagItem;
    false        *: u.TagItem;
    END;

CONST

  baseAddMethod *= bguiMb + 43;

(* Add an object to the method notification list. *)

TYPE

  mAddMethodPtr *= UNTRACED POINTER TO mAddMethod;
  mAddMethod *= STRUCT( msg *: i.Msg )
    object      *: Object;
    flags       *: LONGSET;
    size        *: LONGINT;
    methID      *: LONGINT;
    END;

CONST

  bamfNoGinfo   *= 0;      (* 1<<0 *) (* Do not send GadgetInfo. *)
  bamfNoInterim *= 1;      (* 1<<1 *) (* Skip interim messages.  *)

  baseRemMap         *= bguiMb + 44;
  baseRemConditional *= bguiMb + 45;
  baseRemMethod      *= bguiMb + 46;

(* Remove an object from a notification list. *)

TYPE

  mRemovePtr *= UNTRACED POINTER TO mRemove;
  mRemove *= STRUCT( msg *: i.Msg )
    object    *: Object;
    END;

CONST

  baseShowhelp *= bguiMb + 47;

(* Show attached online-help. *)

TYPE

  MousePtr *= UNTRACED POINTER TO Mouse;
  Mouse *= STRUCT
    x *: INTEGER;
    y *: INTEGER;
    END;

  mShowHelpPtr *= UNTRACED POINTER TO mShowHelp;
  mShowHelp *= STRUCT( msg *: i.Msg )
    window        *: i.WindowPtr;
    requester     *: i.RequesterPtr;
    mouse         *: Mouse;
    END;

CONST

  bmHelpOk      *= 0;        (* OK, no problems.           *)
  bmHelpNotMe   *= 1;        (* Mouse not over the object. *)
  bmHelpFailure *= 2;        (* Showing failed.            *)

  baseUnused1 *= bguiMb + 48;
  baseUnused2 *= bguiMb + 49;
  baseUnused3 *= bguiMb + 50;
  baseUnused4 *= bguiMb + 51;

  baseAddHook *= bguiMb + 52;

(* Add a hook to the hook-notification list. *)

TYPE

  mAddHookPtr *= UNTRACED POINTER TO mAddHook;
  mAddHook *= STRUCT( msg *: i.Msg )
    hook     *: u.HookPtr;
    END;

(* Remove a hook from the hook-notification list. *)

CONST

  baseRemHook  *= bguiMb + 53;

  baseDragging *= bguiMb + 54; (* V40 *)

(* Return codes for the BASE_DRAGGING method. *)

  bdrNone        *= 0;     (* Handle input yourself. *)
  bdrDragPrepare *= 1;     (* Prepare for dragging.  *)
  bdrDragging    *= 2;     (* Don't handle events.   *)
  bdrDrop        *= 3;     (* Image dropped.         *)
  bdrCancel      *= 4;     (* Drag canceled.         *)

  baseDragQuery *= bguiMb + 55;   (* V40 *)

(* For both BASE_DRAGQUERY and BASE_DRAGUPDATE. *)

TYPE

  mdpMousePtr *= UNTRACED POINTER TO mdpMouse;
  mdpMouse *= STRUCT
    x *: INTEGER;
    y *: INTEGER;
    END;

  mDragPointPtr *= UNTRACED POINTER TO mDragPoint;
  mDragPoint *= STRUCT( msg *: i.Msg )   (* BASE_DRAGQUERY   *)
    gInfo      *: i.GadgetInfoPtr;       (* GadgetInfo       *)
    source     *: Object;                (* Object querying. *)
    mouse      *: mdpMouse;              (* Mouse coords.    *)
    END;

(* Return codes for BASE_DRAGQUERY. *)

CONST

  bqrReject *= 0;                   (* Object will not accept drop. *)
  bqrAccept *= 1;                   (* Object will accept drop.     *)

  baseDragUpdate *= bguiMb + 56;    (* V40 *)

(* Return codes for BASE_DRAGUPDATE. *)

  burContinue *= 0;                 (* Continue drag. *)
  burAbort    *= 1;                 (* Abort drag. *)

  baseDropped *= bguiMb + 57;       (* V40 *)

(* Source object is dropped. *)

TYPE

  mDroppedPtr *= UNTRACED POINTER TO mDropped;
  mDropped *= STRUCT( msg *: i.Msg )
    gInfo        *: i.GadgetInfoPtr; (* GadgetInfo structure. *)
    source       *: Object;          (* Object dropped.       *)
    sourceWin    *: i.WindowPtr;     (* Source obj window.    *)
    sourceReq    *: i.RequesterPtr;  (* Source obj requester. *)
    END;

CONST

  baseDragActive   *= bguiMb + 58;   (* V40 *)
  baseDragInactive *= bguiMb + 59;   (* V40 *)

(* Used by both methods defined above. *)

TYPE

  mDragMsgPtr *= UNTRACED POINTER TO mDragMsg;
  mDragMsg *= STRUCT( msg *: i.Msg )
    gInfo  *: i.GadgetInfoPtr;   (* GadgetInfo structure. *)
    source *: Object;       (* Object being dragged. *)
    END;

CONST

  baseGetDragObject *= bguiMb + 60;  (* V40 *)


(* Obtain BitMap image to drag. *)

TYPE

  mGetDragObjectPtr *= UNTRACED POINTER TO mGetDragObject;
  mGetDragObject *= STRUCT( msg *: i.Msg )   (* BASE_GETDRAGOBJECT *)
    gInfo  *: i.GadgetInfoPtr;               (* GadgetInfo         *)
    bounds *: i.IBoxPtr;                     (* Bounds to buffer.  *)
    END;

CONST

  baseFreeDragObject *= bguiMb + 61; (* V40 *)

(* Free BitMap image being dragged. *)

TYPE

  mFreeDragObjectPtr *= UNTRACED POINTER TO mFreeDragObject;
  mFreeDragObject *= STRUCT( msg *: i.Msg )  (* BASE_FREEDRAGOBJECT *)
    gInfo         *: i.GadgetInfoPtr;        (* GadgetInfo          *)
    objBitMap     *: g.BitMapPtr;            (* BitMap to free.     *)
    END;

CONST

  baseInhibit *= bguiMb + 62;

(* Inhibit/uninhibit this object. *)

TYPE

  mInhibitPtr *= UNTRACED POINTER TO mInhibit;
  mInhibit *= STRUCT( msg *: i.Msg )   (* BASE_INHIBIT    *)
    inhibit *: LONGINT;                (* Inhibit on/off. *)
    END;

CONST

  baseFindKey *= bguiMb + 63; (* V41.2 *)

(* Locate object with this rawkey. *)

TYPE

  fkKeyPtr *= UNTRACED POINTER TO fkKey;
  fkKey *= STRUCT
    qual *: INTEGER;
    key  *: INTEGER;
    END;

  mFindKeyPtr *= UNTRACED POINTER TO mFindKey;
  mFindKey *= STRUCT( msg *: i.Msg )   (* BASE_FINDKEY *)
    key      *: fkKey;                 (* Key to find. *)
    END;

CONST

  baseKeyLabel *= bguiMb + 64; (* V41.2 *)

(* Attach key in this label to the object. *)

TYPE

  mKeyLabelPtr *= UNTRACED POINTER TO mKeyLabel;
  mKeyLabel *= STRUCT( msg *: i.Msg )  (* BASE_KEYLABEL *)
    END;

CONST

  baseLocalize *= bguiMb + 65;     (* V41.3 *)

(* Localize this object. *)

TYPE

  mLocalizePtr *= UNTRACED POINTER TO mLocalize;
  mLocalize *= STRUCT( msg *: i.Msg )  (* BASE_LOCALIZE *)
    locale    *: LocalePtr;
    END;


(*****************************************************************************
 *
 *      "groupclass" - BOOPSI group gadget.
 *
 *      Tags: 321 - 400                 Methods: 81 - 120
 *
 *      This class is the actual bgui.library layout engine. It will layout
 *      all members in a specific area.  Two group types are available,
 *      horizontal and vertical groups.
 *)

CONST

  groupStyle        *= bguiTb + 321; (* IS--- *)
  groupSpacing      *= bguiTb + 322; (* IS--- *)
  groupHorizOffset  *= bguiTb + 323; (* I---- *)
  groupVertOffset   *= bguiTb + 324; (* I---- *)
  groupLeftOffset   *= bguiTb + 325; (* I---- *)
  groupTopOffset    *= bguiTb + 326; (* I---- *)
  groupRightOffset  *= bguiTb + 327; (* I---- *)
  groupBottomOffset *= bguiTb + 328; (* I---- *)
  groupMember       *= bguiTb + 329; (* I---- *)
  groupSpaceObject  *= bguiTb + 330; (* I---- *)
  groupBackfill     *= bguiTb + 331; (* IS--- *)
  groupEqualWidth   *= bguiTb + 332; (* IS--- *)
  groupEqualHeight  *= bguiTb + 333; (* IS--- *)
  groupInverted     *= bguiTb + 334; (* I---- *)
  groupBackPen      *= bguiTb + 335; (* IS--- *) (* V40 *)
  groupBackDriPen   *= bguiTb + 336; (* IS--- *) (* V40 *)
  groupOffset       *= bguiTb + 337; (* I---- *) (* V41 *)
  groupHorizSpacing *= bguiTb + 338; (* IS--- *) (* V41.7 *)
  groupVertSpacing  *= bguiTb + 339; (* IS--- *) (* V41.7 *)
  groupLayoutHook   *= bguiTb + 340; (* I---- *) (* V41.7 *)

(* Object layout attributes. *)

  lgoTagStart     *= bguiTb + 381;
  lgoFixWidth     *= bguiTb + 381; (* I---- *)
  lgoFixHeight    *= bguiTb + 382; (* I---- *)
  lgoWeight       *= bguiTb + 383; (* IS--- *)
  lgoFixMinWidth  *= bguiTb + 384; (* I---- *)
  lgoFixMinHeight *= bguiTb + 385; (* I---- *)
  lgoAlign        *= bguiTb + 386; (* I---- *)
  lgoNoAlign      *= bguiTb + 387; (* I---- *) (* V38 *)
  lgoFixAspect    *= bguiTb + 388; (* IS--- *) (* V41 *)
  lgoVisible      *= bguiTb + 389; (* IS--- *) (* V41 *)
  lgoCustom       *= bguiTb + 400; (* IS--- *) (* V41.7 *)
  lgoTagDone      *= bguiTb + 400;

(* Default object weight. *)

  defaultWeight *= 50;

(* Group styles. *)

  grStyleHorizontal *= 0;
  grStyleVertical   *= 1;

(* Group spacings. *)
CONST
  grSpaceNarrow  *= -1;    (* ((ULONG)~0) *)    (* V41 *)
  grSpaceNormal  *= -2;    (* ((ULONG)~1) *)    (* V41 *)
  grSpaceWide    *= -3;    (* ((ULONG)~2) *)    (* V41 *)

(* New methods. *)

  grmAddMember *= bguiMb + 81;

(* Add a member to the group. *)

TYPE

  mAddMemberPtr *= UNTRACED POINTER TO mAddMember;
  mAddMember *= STRUCT( msg *: i.Msg )  (* GRM_ADDMEMBER            *)
    member     *: Object;               (* Object to add.           *)
    attr       *: LONGINT;              (* First of LGO attributes. *)
    END;

CONST

  grmRemMember *= bguiMb + 82;

(* Remove a member from the group. *)

TYPE

  mRemMemberPtr *= UNTRACED POINTER TO mRemMember;
  mRemMember *= STRUCT( msg *: i.Msg )  (* GRM_REMMEMBER     *)
    member     *: Object;               (* Object to remove. *)
    END;

CONST

  grmDimensions *= bguiMb + 83;

(* Ask an object it's dimensions information. *)

TYPE

  WidthHeightPtr *= UNTRACED POINTER TO WidthHeight;
  WidthHeight *= STRUCT
    width  *: UNTRACED POINTER TO INTEGER;
    height *: UNTRACED POINTER TO INTEGER;
    END;

  mDimensionsPtr *= UNTRACED POINTER TO mDimensions;
  mDimensions *= STRUCT( msg *: i.Msg )  (* GRM_DIMENSIONS *)
    gInfo       *: i.GadgetInfoPtr;      (* Can be NULL! *)
    rPort       *: g.RastPortPtr;        (* Ready for calculations. *)
    minSize     *: WidthHeight;          (* Storage for dimensions. *)
    flags       *: LONGSET;              (* See below. *)
    maxSize     *: WidthHeight;          (* Storage for dimensions. *)
    END;

(* Flags *)

CONST

  gdimfNoFrame *= 0;     (* 1<<0 *) (* Don't take frame width/height
                                         into consideration.           *)
  gdimfNoOffset *= 1;    (* 1<<1 *) (* No inner offset from the frame. *)
  gdimfMaximums *= 2;    (* 1<<2 *) (* The grmd_MaxSize is requested.  *)

  grmAddSpaceMember *= bguiMb + 84;

(* Add a weight controlled spacing member. *)

TYPE

  mAddSpaceMemberPtr *= UNTRACED POINTER TO mAddSpaceMember;
  mAddSpaceMember *= STRUCT( msg *: i.Msg )   (* GRM_ADDSPACEMEMBER *)
    weight     *: LONGINT;                    (* Object weight.     *)
    END;

CONST

  grmInsertMember *= bguiMb + 85;

(* Insert a member in the group. *)

TYPE

  mInsertMemberPtr *= UNTRACED POINTER TO mInsertMember;
  mInsertMember *= STRUCT( msg *: i.Msg )  (* GRM_INSERTMEMBER         *)
    member     *: Object;                  (* Member to insert.        *)
    pred       *: Object;                  (* Insert after this member *)
    attr       *: LONGINT;                 (* First of LGO attributes. *)
    END;

CONST

  grmReplaceMember *= bguiMb + 86;     (* V40 *)

(* Replace a member in the group. *)

TYPE
  mReplaceMemberPtr *= UNTRACED POINTER TO mReplaceMember;
  mReplaceMember *= STRUCT( msg *: i.Msg )  (* GRM_REPLACEMEMBER        *)
    memberA     *: Object;                  (* Object to replace.       *)
    memberB     *: Object;                  (* Object which replaces.   *)
    attr        *: LONGINT;                 (* First of LGO attributes. *)
    END;

CONST

  grmWhichObject *= bguiMb + 87;     (* V40 *)

(* Locate object under these coords. *)

TYPE
  woCoordsPtr *= UNTRACED POINTER TO woCoords;
  woCoords *= STRUCT
    x *: INTEGER;
    y *: INTEGER;
    END;

  mWhichObjectPtr *= UNTRACED POINTER TO mWhichObject;
  mWhichObject *= STRUCT( msg *: i.Msg )  (* GRM_WHICHOBJECT *)
    coords     *: woCoords;               (* The coords.     *)
    END;


(*****************************************************************************
 *
 *      "buttonclass" - BOOPSI button gadget.
 *
 *      Tags: 401 - 480                 Methods: 121 - 160
 *
 *      GadTools style button gadget.
 *
 *      GA_Selected has been made gettable (OM_GET) for toggle-select
 *      buttons. (ISGNU)
 *)
CONST
  buttonUnused1        *= bguiTb + 401;   (* *)
  buttonUnused0        *= bguiTb + 402;   (* *)
  buttonImage          *= bguiTb + 403;   (* IS--U *)
  buttonSelectedImage  *= bguiTb + 404;   (* IS--U *)
  buttonEncloseImage   *= bguiTb + 405;   (* I---- *) (* V39 *)
  buttonVector         *= bguiTb + 406;   (* IS--U *) (* V41 *)
  buttonSelectedVector *= bguiTb + 407;   (* IS--U *) (* V41 *)
  buttonSelectOnly     *= bguiTb + 408;   (* I---- *) (* V41 *)


(*****************************************************************************
 *
 *      "checkboxclass" - BOOPSI checkbox gadget.
 *
 *      Tags: 481 - 560                 Methods: 161 - 200
 *
 *      GadTools style checkbox gadget.
 *
 *      GA_Selected has been made gettable (OM_GET). (ISGNU)
 *)


(*****************************************************************************
 *
 *      "cycleclass" - BOOPSI cycle gadget.
 *
 *      Tags: 561 - 640                 Methods: 201 - 240
 *
 *      GadTools style cycle gadget.
 *)

CONST
  cycLabels    *= bguiTb + 561;    (* I---- *)
  cycActive    *= bguiTb + 562;    (* ISGNU *)
  cycPopup     *= bguiTb + 563;    (* I---- *)
  cycPopActive *= bguiTb + 564;    (* I---- *) (* V40 *)


(*****************************************************************************
 *
 *      "infoclass" - BOOPSI information gadget.
 *
 *      Tags: 641 - 720                 Methods: 241 - 280
 *
 *      Text gadget which supports different colors, text styles and
 *      text positioning.
 *)

CONST
  infoTextFormat   *= bguiTb + 641;    (* IS--U *)
  infoArgs         *= bguiTb + 642;    (* IS--U *)
  infoMinLines     *= bguiTb + 643;    (* I---- *)
  infoFixTextWidth *= bguiTb + 644;    (* I---- *)
  infoHorizOffset  *= bguiTb + 645;    (* I---- *)
  infoVertOffset   *= bguiTb + 646;    (* I---- *)

(* Command sequences. *)

  iseqB         *= "\eb";            (* Bold         *)
  iseqI         *= "\ei";            (* Italics      *)
  iseqU         *= "\eu";            (* Underlined   *)
  iseqN         *= "\en";            (* Normal       *)
  iseqC         *= "\ec";            (* Centered     *)
  iseqR         *= "\er";            (* Right        *)
  iseqL         *= "\el";            (* Left         *)
  iseqText      *= "\ed2";           (* TEXTPEN      *)
  iseqShine     *= "\ed3";           (* SHINEPEN     *)
  iseqShadow    *= "\ed4";           (* SHADOWPEN    *)
  iseqFill      *= "\ed5";           (* FILLPEN      *)
  iseqFillText  *= "\ed6";           (* FILLTEXTPEN  *)
  iseqHighlight *= "\ed8";           (* HIGHLIGHTPEN *)

  iseqFont      *= "\021f%08lx\022";  (* Set Font     *)
  iseqImage     *= "\021i%08lx\022";  (* Draw Image   *)

(*****************************************************************************
 *
 *      "listviewclass" - BOOPSI listview gadget.
 *
 *      Tags: 721 - 800                 Methods: 281 - 320
 *
 *      GadTools style listview gadget.
 *)


CONST
  listvTagStart              *= bguiTb + 721;
  listvResourceHook          *= bguiTb + 721; (* ISG-- *)
  listvDisplayHook           *= bguiTb + 722; (* ISG-- *)
  listvCompareHook           *= bguiTb + 723; (* ISG-- *)
  listvTop                   *= bguiTb + 724; (* ISG-U *)
  listvListFont              *= bguiTb + 725; (* I-G-- *)
  listvReadOnly              *= bguiTb + 726; (* I-G-- *)
  listvMultiSelect           *= bguiTb + 727; (* ISG-U *)
  listvEntryArray            *= bguiTb + 728; (* I---- *)
  listvSelect                *= bguiTb + 729; (* -S--U *)
  listvMakeVisible           *= bguiTb + 730; (* -S--U *)
  listvEntry                 *= bguiTb + 731; (* ---N- *)
  listvSortEntryArray        *= bguiTb + 732; (* I---- *)
  listvEntryNumber           *= bguiTb + 733; (* ---N- *)
  listvTitleHook             *= bguiTb + 734; (* ISG-- *)
  listvLastClicked           *= bguiTb + 735; (* --G-- *)
  listvThinFrames            *= bguiTb + 736; (* ISG-- *)
  listvLastClickedNum        *= bguiTb + 737; (* --G-- *) (* V38 *)
  listvNewPosition           *= bguiTb + 738; (* ---N- *) (* V38 *)
  listvNumEntries            *= bguiTb + 739; (* --G-- *) (* V38 *)
  listvMinEntriesShown       *= bguiTb + 740; (* I---- *) (* V38 *)
  listvSelectMulti           *= bguiTb + 741; (* -S--U *) (* V39 *)
  listvSelectNotVisible      *= bguiTb + 742; (* -S--U *) (* V39 *)
  listvSelectMultiNotVisible *= bguiTb + 743; (* -S--U *) (* V39 *)
  listvMultiSelectNoShift    *= bguiTb + 744; (* ISG-U *) (* V39 *)
  listvDeselect              *= bguiTb + 745; (* -S--U *) (* V39 *)
  listvDropSpot              *= bguiTb + 746; (* --G-- *) (* V40 *)
  listvShowDropSpot          *= bguiTb + 747; (* ISG-- *) (* V40 *)
  listvViewBounds            *= bguiTb + 748; (* --G-- *) (* V40 *)
  listvCustomDisable         *= bguiTb + 749; (* ISG-- *) (* V40 *)
  listvFilterHook            *= bguiTb + 750; (* ISG-- *) (* V41 *)
  listvColumns               *= bguiTb + 751; (* I-G-U *) (* V41 *)
  listvColumnWeights         *= bguiTb + 752; (* IS--U *) (* V41 *)
  listvDragColumns           *= bguiTb + 753; (* ISG-U *) (* V41 *)
  listvTitle                 *= bguiTb + 754; (* ISG-U *) (* V41 *)
  listvPropObject            *= bguiTb + 755; (* ISG-- *) (* V41 *)
  listvPreClear              *= bguiTb + 756; (* ISG-- *) (* V41 *)
  listvLastColumn            *= bguiTb + 757; (* --G-- *) (* V41 *)
  listvLayoutHook            *= bguiTb + 758; (* IS--U *) (* V41 *)

(*
 *      LISTV_Select magic numbers.
 *)

CONST
  listvSelectFirst    *= -1;    (* V38 *)
  listvSelectLast     *= -2;    (* V38 *)
  listvSelectNext     *= -3;    (* V38 *)
  listvSelectPrevious *= -4;    (* V38 *)
  listvSelectTop      *= -5;    (* V38 *)
  listvSelectPageUp   *= -6;    (* V38 *)
  listvSelectPageDown *= -7;    (* V38 *)
  listvSelectAll      *= -8;    (* V39 *)

(*
 *      The LISTV_ResourceHook is called as follows:
 *
 *      rc = hookFunc( REG(A0) struct Hook              *hook,
 *                     REG(A2) Object                   *lv_object,
 *                     REG(A1) struct lvResource        *message );
 *)

TYPE

  ResourcePtr *= UNTRACED POINTER TO Resource;
  Resource *= STRUCT( d: ArgsDesc )
    command *: INTEGER;
    entry   *: e.APTR;
    END;

(* LISTV_ResourceHook commands. *)

CONST
  lvrcMake *= 1;                   (* Build the entry. *)
  lvrcKill *= 2;                   (* Kill the entry.  *)

(*
 *      The LISTV_DisplayHook and the LISTV_TitleHook are called as follows:
 *
 *      rc = hookFunc( REG(A0) struct Hook             *hook,
 *                     REG(A2) Object                  *lv_object,
 *                     REG(A1) struct lvRender         *message );
 *)

TYPE

  RenderPtr *= UNTRACED POINTER TO Render;
  Render *= STRUCT( d *: ArgsDesc )
    rPort    *: g.RastPortPtr;    (* RastPort to render in. *)
    drawInfo *: i.DrawInfoPtr;    (* All you need to render. *)
    bounds   *: g.Rectangle;      (* Bounds to render in. *)
    entry    *: e.APTR;           (* Entry to render. *)
    state    *: INTEGER;          (* See below. *)
    flags    *: SET;              (* None defined yet. *)
    column   *: INTEGER;          (* Column to render. *)
    END;

(* Rendering states. *)

CONST
  lvrsNormal           *= 0;
  lvrsSelected         *= 1;
  lvrsNormalDisabled   *= 2;
  lvrsSelectedDisabled *= 3;

(*
 *      The LISTV_CompareHook is called as follows:
 *
 *      rc = hookFunc( REG(A0) struct Hook              *hook,
 *                     REG(A2) Object                   *lv_object,
 *                     REG(A1) struct lvCompare         *message );
 *)

TYPE

  ComparePtr *= UNTRACED POINTER TO Compare;
  Compare *= STRUCT( d *: ArgsDesc )
    entryA *: e.APTR;     (* First entry.  *)
    entryB *: e.APTR;     (* Second entry. *)
    END;

  LayoutPtr *= UNTRACED POINTER TO Layout;
  Layout *= STRUCT( d *: ArgsDesc )
    id          *: INTEGER;                        (* GA_ID of list.        *)
    column      *: INTEGER;                        (* Column to layout.     *)
    listWidth   *: INTEGER;                        (* Width of list.        *)
    entryHeight *: INTEGER;                        (* Height of entries.    *)
    flags       *: UNTRACED POINTER TO LONGSET;    (* Flag storage.         *)
    minWidth    *: UNTRACED POINTER TO INTEGER;    (* Minimum column width. *)
    maxWidth    *: UNTRACED POINTER TO INTEGER;    (* Maximum column width. *)
    END;

CONST
  lvlfPreClear  *= 0; (* 1<<0 *)
  lvlfDraggable *= 1; (* 1<<1 *)
  lvlfHidden    *= 2; (* 1<<2 *)

(* New Methods. *)

  lvmAddEntries *= bguiMb + 281;

(* Add listview entries. *)

TYPE
  mAddEntriesPtr *= UNTRACED POINTER TO mAddEntries;
  mAddEntries *= STRUCT( msg *: i.Msg )            (* LVM_ADDENTRIES  *)
    gInfo     *: i.GadgetInfoPtr;                  (* GadgetInfo      *)
    entries   *: UNTRACED POINTER TO e.APTR;       (* Entries to add. *)
    how       *: LONGINT;                          (* How to add it.  *)
    END;

(* Where to add the entries. *)

CONST
  lvapHead   *= 1;
  lvapTail   *= 2;
  lvapSorted *= 3;

  lvmAddSingle *= bguiMb + 282;

(* Add a single entry. *)

TYPE
  mAddSinglePtr *= UNTRACED POINTER TO mAddSingle;
  mAddSingle *= STRUCT( msg *: i.Msg )  (* LVM_ADDSINGLE *)
    gInfo    *: i.GadgetInfoPtr;        (* GadgetInfo    *)
    entry    *: e.APTR;                 (* Entry to add. *)
    how      *: LONGINT;                (* See above.    *)
    flags    *: LONGSET;                (* See below.    *)
    END;

(* Flags. *)

CONST
  lvasfMakeVisible *= 0;   (* 1<<0 *) (* Make entry visible.      *)
  lvasfSelect      *= 1;   (* 1<<1 *) (* Select entry.            *)
  lvasfMultiSelect *= 2;   (* 1<<2 *) (* Multi-select entry.  V40 *)
  lvasfNotVisible  *= 3;   (* 1<<3 *) (* Do not make visible. V40 *)

(* Clear the entire list. ( Uses a lvmCommand structure as defined below.) *)

  lvmClear *= bguiMb + 283;

  lvmFirstEntry *= bguiMb + 284;
  lvmLastEntry  *= bguiMb + 285;
  lvmNextEntry  *= bguiMb + 286;
  lvmPrevEntry  *= bguiMb + 287;

(* Get an entry. *)

TYPE
  mGetEntryPtr *= UNTRACED POINTER TO mGetEntry;
  mGetEntry *= STRUCT( msg *: i.Msg )  (* Any of the above. *)
    previous *: e.APTR;                (* Previous entry.   *)
    flags    *: LONGSET;               (* See below.        *)
    END;

(* Flags *)

CONST
  lvgefSelected *= 0;     (* 1<<0 *) (* Get selected entries. *)

  lvmRemEntry *= bguiMb + 288;

(* Remove an entry. *)

TYPE
  mRemEntryPtr *= UNTRACED POINTER TO mRemEntry;
  mRemEntry *= STRUCT( msg *: i.Msg )  (* LVM_REMENTRY     *)
    gInfo    *: i.GadgetInfoPtr;       (* GadgetInfo       *)
    entry    *: e.APTR;                (* Entry to remove. *)
    END;

CONST
  lvmRefresh    *= bguiMb + 289;
  lvmSort       *= bguiMb + 290;
  lvmLockList   *= bguiMb + 291;
  lvmUnlockList *= bguiMb + 292;

(* Refresh/Sort list. *)

TYPE
  mCommandPtr *= UNTRACED POINTER TO mCommand;
  mCommand *= STRUCT( msg *: i.Msg )  (* LVM_REFRESH *)
    gInfo    *: i.GadgetInfoPtr;      (* GadgetInfo  *)
    END;


CONST
  lvmMove *= bguiMb + 293;           (* V38 *)

(* Move an entry in the list. *)

TYPE
  mMovePtr *= UNTRACED POINTER TO mMove;
  mMove *= STRUCT( msg *: i.Msg )      (* LVM_MOVE *)
    gInfo     *: i.GadgetInfoPtr;      (* GadgetInfo *)
    entry     *: e.APTR;               (* Entry to move *)
    direction *: LONGINT;              (* See below *)
    newPos    *: LONGINT;              (* New position. V40 *)
    END;

(* Move directions. *)
CONST
  lvMoveUp     *= 0;              (* Move entry up.            *)
  lvMoveDown   *= 1;              (* Move entry down.          *)
  lvMoveTop    *= 2;              (* Move entry to the top.    *)
  lvMoveBottom *= 3;              (* Move entry to the bottom. *)
  lvMoveNewPos *= 4;              (* Move to new position. V40 *)


  lvmReplace *= bguiMb + 294;     (* V39 *)

(* Replace an entry by another. *)

TYPE
  mReplacePtr *= UNTRACED POINTER TO mReplace;
  mReplace *= STRUCT( msg *: i.Msg )  (* LVM_REPLACE       *)
    gInfo    *: i.GadgetInfoPtr;      (* GadgetInfo        *)
    oldEntry *: e.APTR;               (* Entry to replace. *)
    newEntry *: e.APTR;               (* New entry.        *)
    END;

CONST
  lvmRedraw        *= bguiMb + 295; (* V40 *)

  lvmInsertEntries *= bguiMb + 296; (* V40 *)

(* Insert listview entries. *)

TYPE
  mInsertEntriesPtr *= UNTRACED POINTER TO mInsertEntries;
  mInsertEntries *= STRUCT( msg *: i.Msg )  (* LVM_INSERTENTRIES *)
    gInfo    *: i.GadgetInfoPtr;            (* GadgetInfo        *)
    pos      *: LONGINT;                    (* Position.         *)

    entries  *: UNTRACED POINTER TO e.APTR; (* Entries to insert.*)
    END;

CONST
  lvmInsertSingle *= bguiMb + 297; (* V40 *)

(* Insert a single entry. *)

TYPE
  mInsertSinglePtr *= UNTRACED POINTER TO mInsertSingle;
  mInsertSingle *= STRUCT( msg *: i.Msg )  (* LVM_INSERTSINGLE  *)
    gInfo    *: i.GadgetInfoPtr;           (* GadgetInfo        *)
    pos      *: LONGINT;                   (* Position.         *)
    entry    *: e.APTR;                    (* Entry to insert.  *)
    flags    *: LONGSET;                   (* See LVM_ADDSINGLE *)
    END;

CONST
  lvmRemSelected  *= bguiMb + 298; (* V40 *)

  lvmRedrawSingle *= bguiMb + 299; (* V41.7 *)

(* Redraw a single entry or column. *)
TYPE
  mRedrawSinglePtr *= UNTRACED POINTER TO mRedrawSingle;
  mRedrawSingle *= STRUCT( msg *: i.Msg )  (* LVM_REDRAWSINGLE  *)
    gInfo    *: i.GadgetInfoPtr;           (* GadgetInfo.       *)
    entry    *: e.APTR;                    (* Entry to redraw.  *)
    column   *: LONGINT;                   (* Column to redraw. *)
    flags    *: LONGSET;                   (* See below.        *)
    END;

CONST
  lvrfAllColumns *= 1;
  lvrfAllEntries *= 2;


  lvmFilter *= bguiMb + 300; (* V41 *)

(* Filter the list entries. *)

TYPE
  mFilterPtr *= UNTRACED POINTER TO mFilter;
  mFilter *= STRUCT( msg *: i.Msg )  (* LVM_FILTER *)
    flags    *: LONGSET;             (* See below. *)
    END;

CONST
  lvffAll    *= 1;
  lvffNot    *= 2;
  lvffSorted *= 4;
  lvffNone   *= LONGSET{ lvffAll, lvffNot };

  lvmFilterSwap *= bguiMb + 301; (* V41 *)


(*****************************************************************************
 *
 *      "progressclass" - BOOPSI progression gadget.
 *
 *      Tags: 801 - 880                 Methods: 321 - 360
 *
 *      Progression indicator fuel guage.
 *)
CONST
  progressMin          *= bguiTb + 801;    (* IS--- *)
  progressMax          *= bguiTb + 802;    (* IS--- *)
  progressDone         *= bguiTb + 803;    (* ISGNU *)
  progressVertical     *= bguiTb + 804;    (* I---- *)
  progressDivisor      *= bguiTb + 805;    (* I---- *)
  progressFormatString *= bguiTb + 806;    (* I---- *) (* V40 *)


(*****************************************************************************
 *
 *      "propclass" - BOOPSI proportional gadget.
 *
 *      Tags: 881 - 960                 Methods: 361 - 400
 *
 *      GadTools style scroller gadget.
 *)
CONST
  pgaArrows    *= bguiTb + 881;    (* I---- *)
  pgaArrowSize *= bguiTb + 882;    (* I---- *)
  pgaUnused1   *= bguiTb + 883;    (* *)
  pgaThinFrame *= bguiTb + 884;    (* I---- *)
  pgaXenFrame  *= bguiTb + 885;    (* I---- *)
  pgaNoFrame   *= bguiTb + 886;    (* I---- *) (* V40 *)


(*****************************************************************************
 *
 *      "stringclass" - BOOPSI string gadget.
 *
 *      Tags: 961 - 1040                Methods: 401 - 440
 *
 *      GadTools style string/integer gadget.
 *)
CONST
  stringaUnused1         *= bguiTb + 961;    (* *)
  stringaUnused2         *= bguiTb + 962;    (* *)
  stringaMinCharsVisible *= bguiTb + 963;    (* I---- *) (* V39 *)
  stringaIntegerMin      *= bguiTb + 964;    (* IS--U *) (* V39 *)
  stringaIntegerMax      *= bguiTb + 965;    (* IS--U *) (* V39 *)
  stringaStringInfo      *= bguiTb + 966;    (* --G-- *) (* V40 *)

  smFormatString         *= bguiMb + 401;    (* V39 *)

(* Format the string contents. *)
TYPE
  mFormatStringPtr *= UNTRACED POINTER TO mFormatString;
  mFormatString *= STRUCT( msg *: i.Msg )     (* SM_FORMAT_STRING *)
    gInfo    *: i.GadgetInfoPtr;              (* GadgetInfo *)
    fStr     *: e.STRPTR;                     (* Format string *)
    arg1     *: LONGINT;                      (* Format arg *)
        (* ULONG           Arg2; *)
        (* ... *)
  END;


(*****************************************************************************
 *
 *      "viewclass" - BOOPSI view object.                            -- V41 --
 *
 *      Tags: 1041 - 1120               Methods: 441 - 480
 *
 *      Gadget to view a clipped portion of another object.
 *)

CONST
  viewX               *= bguiTb + 1041;    (* ISG-U *)
  viewY               *= bguiTb + 1042;    (* ISG-U *)
  viewMinWidth        *= bguiTb + 1043;    (* I-G-- *)
  viewMinHeight       *= bguiTb + 1044;    (* I-G-- *)
  viewObject          *= bguiTb + 1045;    (* ISG-U *)
  viewNoDisposeObject *= bguiTb + 1046;    (* ISG-U *)
  viewScaleWidth      *= bguiTb + 1047;    (* ISG-U *)
  viewScaleHeight     *= bguiTb + 1048;    (* ISG-U *)


(*****************************************************************************
 *
 *      "pageclass" - BOOPSI paging gadget.
 *
 *      Tags: 1121 - 1200               Methods: 481 - 520
 *
 *      Gadget to handle pages of gadgets.
 *)

CONST
  pageActive     *= bguiTb + 1121;    (* ISGNU *)
  pageMember     *= bguiTb + 1122;    (* I---- *)
  pageNoBufferRP *= bguiTb + 1123;    (* I---- *)
  pageInverted   *= bguiTb + 1124;    (* I---- *)


(*****************************************************************************
 *
 *      "mxclass" - BOOPSI mx gadget.
 *
 *      Tags: 1201 - 1280               Methods: 521 - 560
 *
 *      GadTools style mx gadget.
 *)

CONST
  mxLabels         *= bguiTb + 1201;    (* I---- *)
  mxActive         *= bguiTb + 1202;    (* ISGNU *)
  mxLabelPlace     *= bguiTb + 1203;    (* I---- *)
  mxDisableButton  *= bguiTb + 1204;    (* IS--U *)
  mxEnableButton   *= bguiTb + 1205;    (* IS--U *)
  mxTabsObject     *= bguiTb + 1206;    (* I---- *)
  mxTabsTextAttr   *= bguiTb + 1207;    (* I---- *)
  mxTabsUpsideDown *= bguiTb + 1208;    (* I---- *) (* V40 *)
  mxTabsBackFill   *= bguiTb + 1209;    (* I---- *) (* V40 *)
  mxTabsBackPen    *= bguiTb + 1210;    (* I---- *) (* V40 *)
  mxTabsBackDriPen *= bguiTb + 1211;    (* I---- *) (* V40 *)
  mxLabelsID       *= bguiTb + 1212;    (* I---- *) (* V41 *)
  mxSpacing        *= bguiTb + 1213;    (* I---- *) (* V41 *)


(*****************************************************************************
 *
 *      "sliderclass" - BOOPSI slider gadget.
 *
 *      Tags: 1281 - 1360               Methods: 561 - 600
 *
 *      GadTools style slider gadget.
 *)

CONST
  sliderMin       *= bguiTb + 1281;    (* IS--U *)
  sliderMax       *= bguiTb + 1282;    (* IS--U *)
  sliderLevel     *= bguiTb + 1283;    (* ISGNU *)
  sliderThinFrame *= bguiTb + 1284;    (* I---- *)
  sliderXenFrame  *= bguiTb + 1285;    (* I---- *)
  sliderNoFrame   *= bguiTb + 1286;    (* I---- *) (* V40 *)


(*****************************************************************************
 *
 *      "indicatorclass" - BOOPSI indicator gadget.
 *
 *      Tags: 1361 - 1440               Methods: ??
 *
 *      Textual level indicator gadget.
 *)

CONST
  indicTagStart      *= bguiTb + 1361;
  indicMin           *= bguiTb + 1361;    (* ISG-U *)
  indicMax           *= bguiTb + 1362;    (* ISG-U *)
  indicLevel         *= bguiTb + 1363;    (* ISG-U *)
  indicFormatString  *= bguiTb + 1364;    (* ISG-U *)
  indicJustification *= bguiTb + 1365;    (* ISG-U *)

(* Justification *)
  idjLeft   *= 0;
  idjCenter *= 1;
  idjRight  *= 2;


(*****************************************************************************
 *
 *      "externalclass" - BGUI external class interface.
 *
 *      Tags: 1441 - 1500               Methods: ??
 *)

CONST

  extClass     *= bguiTb + 1441;    (* I---- *)
  extClassID   *= bguiTb + 1442;    (* I---- *)
  extMinWidth  *= bguiTb + 1443;    (* I---- *)
  extMinHeight *= bguiTb + 1444;    (* I---- *)
  extTrackAttr *= bguiTb + 1445;    (* I---- *)
  extObject    *= bguiTb + 1446;    (* --G-- *)
  extNoRebuild *= bguiTb + 1447;    (* I---- *)


(*****************************************************************************
 *
 *      "separatorclass" - BOOPSI separator class.
 *
 *      Tags: 1501 - 1580               Methods: ??
 *)

CONST
  sepHoriz       *= bguiTb + 1501;    (* I---- *)
  sepTitle       *= bguiTb + 1502;    (* I---- *)
  sepThin        *= bguiTb + 1503;    (* I---- *)
  sepHighlight   *= bguiTb + 1504;    (* I---- *)
  sepCenterTitle *= bguiTb + 1505;    (* I---- *)
  sepRecessed    *= bguiTb + 1506;    (* I---- *) (* V39 *)
  sepTitleLeft   *= bguiTb + 1507;    (* I---- *) (* V40 *)
  sepTitleRight  *= bguiTb + 1508;    (* I---- *) (* V40 *)

(* BGUI_TB+1581 through BGUI_TB+1760 reserved. *)

(*****************************************************************************
 *
 *      "windowclass" - BOOPSI window class.
 *
 *      Tags: 1761 - 1860               Methods: 601 - 660
 *
 *      This class creates and maintains an intuition window.
 *)

CONST
  windowTagStart       *= bguiTb + 1761;
  windowPosition       *= bguiTb + 1761;    (* IS--- *)
  windowScaleWidth     *= bguiTb + 1762;    (* IS--- *)
  windowScaleHeight    *= bguiTb + 1763;    (* IS--- *)
  windowLockWidth      *= bguiTb + 1764;    (* I---- *)
  windowLockHeight     *= bguiTb + 1765;    (* I---- *)
  windowPosRelBox      *= bguiTb + 1766;    (* I---- *)
  windowBounds         *= bguiTb + 1767;    (* ISG-- *)

(* BGUI_TB+1768 through BGUI_TB+1770 reserved *)
  windowDragbar        *= bguiTb + 1771;    (* I---- *)
  windowSizeGadget     *= bguiTb + 1772;    (* I---- *)
  windowCloseGadget    *= bguiTb + 1773;    (* I---- *)
  windowDepthGadget    *= bguiTb + 1774;    (* I---- *)
  windowSizeBottom     *= bguiTb + 1775;    (* I---- *)
  windowSizeRight      *= bguiTb + 1776;    (* I---- *)
  windowActivate       *= bguiTb + 1777;    (* I---- *)
  windowRMBTrap        *= bguiTb + 1778;    (* I---- *)
  windowSmartRefresh   *= bguiTb + 1779;    (* I---- *)
  windowReportMouse    *= bguiTb + 1780;    (* I---- *)
  windowBorderless     *= bguiTb + 1781;    (* I---- *) (* V39 *)
  windowBackdrop       *= bguiTb + 1782;    (* I---- *) (* V39 *)
  windowShowTitle      *= bguiTb + 1783;    (* I---- *) (* V39 *)

(* BGUI_TB+1784 through BGUI_TB+1790 reserved. *)
  windowIDCMP          *= bguiTb + 1791;    (* I---- *)
  windowSharedPort     *= bguiTb + 1792;    (* IS--- *)
  windowTitle          *= bguiTb + 1793;    (* ISGNU *)
  windowScreenTitle    *= bguiTb + 1794;    (* ISGNU *)
  windowMenuStrip      *= bguiTb + 1795;    (* I-G-- *)
  windowMasterGroup    *= bguiTb + 1796;    (* I---- *)
  windowScreen         *= bguiTb + 1797;    (* IS--- *)
  windowPubScreenName  *= bguiTb + 1798;    (* IS--- *)
  windowUserPort       *= bguiTb + 1799;    (* --G-- *)
  windowSigMask        *= bguiTb + 1800;    (* --G-- *)
  windowIDCMPHook      *= bguiTb + 1801;    (* IS--- *)
  windowVerifyHook     *= bguiTb + 1802;    (* IS--- *)
  windowIDCMPHookBits  *= bguiTb + 1803;    (* IS--- *)
  windowVerifyHookBits *= bguiTb + 1804;    (* IS--- *)
  windowFont           *= bguiTb + 1805;    (* ISG-- *)
  windowFallBackFont   *= bguiTb + 1806;    (* IS--- *)
  windowHelpFile       *= bguiTb + 1807;    (* IS--- *)
  windowHelpNode       *= bguiTb + 1808;    (* IS--- *)
  windowHelpLine       *= bguiTb + 1809;    (* IS--- *)
  windowAppWindow      *= bguiTb + 1810;    (* I---- *)
  windowAppMask        *= bguiTb + 1811;    (* --G-- *)
  windowUniqueID       *= bguiTb + 1812;    (* IS--- *)
  windowWindow         *= bguiTb + 1813;    (* --G-- *)
  windowHelpText       *= bguiTb + 1814;    (* IS--- *)
  windowNoBufferRP     *= bguiTb + 1815;    (* I---- *)
  windowAutoAspect     *= bguiTb + 1816;    (* I-G-- *)
  windowPubScreen      *= bguiTb + 1817;    (* IS--- *) (* V39 *)
  windowCloseOnEsc     *= bguiTb + 1818;    (* IS--- *) (* V39 *)
  windowActNext        *= bguiTb + 1819;    (* ----- *) (* V39 *)
  windowActPrev        *= bguiTb + 1820;    (* ----- *) (* V39 *)
  windowNoVerify       *= bguiTb + 1821;    (* -S--- *) (* V39 *)
  windowMenuFont       *= bguiTb + 1822;    (* IS--- *) (* V40 *)
  windowToolTicks      *= bguiTb + 1823;    (* ISG-U *) (* V40 *)
  windowLBorderGroup   *= bguiTb + 1824;    (* I---- *) (* V40 *)
  windowTBorderGroup   *= bguiTb + 1825;    (* I---- *) (* V40 *)
  windowRBorderGroup   *= bguiTb + 1826;    (* I---- *) (* V40 *)
  windowBBorderGroup   *= bguiTb + 1827;    (* I---- *) (* V40 *)
  windowTitleZip       *= bguiTb + 1828;    (* I---- *) (* V40 *)
  windowAutoKeyLabel   *= bguiTb + 1829;    (* I---- *) (* V41 *)
  windowTitleID        *= bguiTb + 1830;    (* ISG-- *) (* V41 *)
  windowScreenTitleID  *= bguiTb + 1831;    (* ISG-- *) (* V41 *)
  windowHelpTextID     *= bguiTb + 1832;    (* ISG-- *) (* V41 *)
  windowLocale         *= bguiTb + 1833;    (* IS--- *) (* V41 *)
  windowCatalog        *= bguiTb + 1834;    (* IS--- *) (* V41 *)

(* Possible window positions. *)

  posCenterScreen *= 0;                    (* Center on the screen   *)
  posCenterMouse  *= 1;                    (* Center under the mouse *)
  posTopLeft      *= 2;                    (* Top-left of the screen *)

(* New methods *)

  wmOpen        *= bguiMb + 601;           (* Open the window         *)
  wmClose       *= bguiMb + 602;           (* Close the window        *)
  wmSleep       *= bguiMb + 603;           (* Put the window to sleep *)
  wmWakeup      *= bguiMb + 604;           (* Wake the window up      *)
  wmHandleIDCMP *= bguiMb + 605;           (* Call the IDCMP handler  *)

(* Pre-defined WM_HANDLEIDCMP return codes. *)

  wmhiCloseWindow *= ASH( 1, 16 );                (* The close gadget was clicked    *)
  wmhiNoMore      *= ASH( 2, 16 );                (* No more messages                *)
  wmhiInactive    *= ASH( 3, 16 );                (* The window was de-activated     *)
  wmhiActive      *= ASH( 4, 16 );                (* The window was activated        *)
  wmhiIgnore      *= -1;               (* ~0L *)  (* Like it say's: ignore           *)
  wmhiRMB         *= ASH( 1, 24 );                (* The object was activated by RMB *)
  wmhiMMB         *= ASH( 1, 25 );                (* The object was activated by MMB *)

  wmGadgetKey     *= bguiMb + 606;

(* Add a hotkey to a gadget. *)

TYPE
  mGadgetKeyPtr *= UNTRACED POINTER TO mGadgetKey;
  mGadgetKey *= STRUCT( msg *: i.Msg )  (* WM_GADGETKEY             *)
    requester *: i.RequesterPtr;        (* When used in a requester *)
    object    *: Object;                (* Object to activate       *)
    key       *: e.STRPTR;              (* Key that triggers activ. *)
    END;

CONST
  wmKeyActive *= bguiMb + 607;
  wmKeyInput  *= bguiMb + 608;

(* Send with the WM_KEYACTIVE and WM_KEYINPUT methods. *)

TYPE

  mKeyInputPtr *= UNTRACED POINTER TO mKeyInput;
  mKeyInput *= STRUCT( msg *: i.Msg )         (* WM_KEYACTIVE/WM_KEYINPUT       *)
    gInfo    *: i.GadgetInfoPtr;              (* GadgetInfo                     *)
    iEvent   *: ih.InputEventPtr;             (* Input event                    *)
    id       *: UNTRACED POINTER TO LONGINT;  (* Storage for the object ID      *)
    key      *: e.STRPTR;                     (* Key that triggered activation. *)
    END;

(* Possible WM_KEYACTIVE and WM_KEYINPUT return codes. *)
CONST
  wmkfMeActive *= 0;               (* Object went active.      *)

  wmkfCancel   *= 0;   (* 1<<0 *)   (* Key activation canceled. *)
  wmkfVerify   *= 1;   (* 1<<1 *)   (* Key activation confirmed *)
  wmkfActivate *= 2;   (* 1<<2 *)   (* ActivateGadget() object  *)

  wmKeyInactive *= bguiMb + 609;

(* De-activate a key session. *)

TYPE
  mKeyInActivePtr *= UNTRACED POINTER TO mKeyInActive;
  mKeyInActive *= STRUCT( msg *: i.Msg )  (* WM_KEYINACTIVE *)
    gInfo    *: i.GadgetInfoPtr;          (* GadgetInfo     *)
    END;

CONST
  wmDisableMenu *= bguiMb + 610;
  wmCheckItem   *= bguiMb + 611;

(* Disable/Enable a menu or Set/Clear a checkit item. *)

TYPE
  mMenuActionPtr *= UNTRACED POINTER TO mMenuAction;
  mMenuAction *= STRUCT( msg *: i.Msg )  (* WM_DISABLEMENU/WM_CHECKITEM *)
    menuID   *: LONGINT;                 (* Menu it's ID                *)
    set      *: LONGINT;                 (* TRUE = set, FALSE = clear   *)
    END;

CONST
  wmMenuDisabled *= bguiMb + 612;
  wmItemChecked  *= bguiMb + 613;

TYPE
  mMenuQueryPtr *= UNTRACED POINTER TO mMenuQuery;
  mMenuQuery *= STRUCT( msg *: i.Msg )  (* WM_MENUDISABLED/WM_ITEMCHECKED *)
    menuID   *: LONGINT;                (* Menu it's ID                   *)
    END;

CONST
  wmTabCycleOrder *= bguiMb + 614;

(* Set the tab-cycling order. *)
TYPE
  mTabCycleOrderPtr *= UNTRACED POINTER TO mTabCycleOrder;
  mTabCycleOrder *= STRUCT( msg *: i.Msg )  (* WM_TABCYCLE_ORDER *)
    object1  *: Object;
    (* Object         *Object2; *)
    (* ...  *)
    (* NULL *)
    END;

(* Obtain the app message. *)
CONST
  wmGetAppMsg *= bguiMb + 615;

  wmAddUpdate *= bguiMb + 616;

(* Add object to the update notification list. *)

TYPE
  mAddUpdatePtr *= UNTRACED POINTER TO mAddUpdate;
  mAddUpdate *= STRUCT( msg *: i.Msg )  (* WM_ADDUPDATE         *)
    sourceID *: LONGINT;                (* ID of source object. *)
    target   *: Object;                 (* Target object.       *)
    mapList  *: u.TagItemPtr;           (* Attribute map-list.  *)
    END;

CONST
  wmReportID *= bguiMb + 617; (* V38 *)

(* Report a return code from a IDCMP/Verify hook. *)

TYPE
  mReportIDPtr *= UNTRACED POINTER TO mReportID;
  mReportID *= STRUCT( msg *: i.Msg )  (* WM_REPORT_ID        *)
    id       *: LONGINT;               (* ID to report.       *)
    flags    *: LONGSET;               (* See below.          *)
    sigTask  *: e.TaskPtr;             (* Task to signal. V40 *)
  END;

(* Flags *)
CONST
  wmrifDoubleClick *= 0;  (* 1<<0 *) (* Simulate double-click.    *)
  wmrifTask        *= 1;  (* 1<<1 *) (* Task to signal valid. V40 *)

(* Get the window which signalled us. *)
CONST
  wmGetSignalWindow *= bguiMb + 618;    (* V39 *)

  wmRemoveObject    *= bguiMb + 619;    (* V40 *)

(* Remove an object from the window key and/or tabcycle list. *)

TYPE
  mRemoveObjectPtr *= UNTRACED POINTER TO mRemoveObject;
  mRemoveObject *= STRUCT( msg *: i.Msg )  (* WM_REMOVE_OBJECT  *)
    object   *: Object;                    (* Object to remove. *)
    flags    *: LONGSET;                   (* See below.        *)
    END;

(* Flags *)
CONST
  wmrofKeyList   *= 0;  (* 1<<0 *) (* Remove from key-list. *)
  wmrofCycleList *= 1;  (* 1<<1 *) (* Remove from cycle list. *)

CONST
  wmWhichobject *= bguiMb + 620; (* V40 *)


(*****************************************************************************
 *
 *      "commodityclass" - BOOPSI commodity class.
 *
 *      Tags: 1861 - 1940               Methods: 661 - 700
 *)

CONST
  commName        *= bguiTb + 1861;    (* I---- *)
  commTitle       *= bguiTb + 1862;    (* I---- *)
  commDescription *= bguiTb + 1863;    (* I---- *)
  commUnique      *= bguiTb + 1864;    (* I---- *)
  commNotify      *= bguiTb + 1865;    (* I---- *)
  commShowHide    *= bguiTb + 1866;    (* I---- *)
  commPriority    *= bguiTb + 1867;    (* I---- *)
  commSigMask     *= bguiTb + 1868;    (* --G-- *)
  commErrorCode   *= bguiTb + 1869;    (* --G-- *)

(* New Methods. *)

  cmAddHotKey *= bguiMb + 661;

(* Add a hot-key to the broker. *)

TYPE
  mAddHotkeyPtr *= UNTRACED POINTER TO mAddHotkey;
  mAddHotkey *= STRUCT( msg *: i.Msg )   (* CM_ADDHOTKEY           *)
   inputDescription *: e.STRPTR;         (* Key input description. *)
   keyID            *: LONGINT;          (* Key command ID.        *)
   flags            *: LONGSET;          (* See below.             *)
   END;

(* Flags. *)
CONST
  cahfDisabled *= 0;         (* 1<<0 *) (* The key is added but won't work. *)

  cmRemHotKey     *= bguiMb + 662;      (* Remove a key.  *)
  cmDisableHotKey *= bguiMb + 663;      (* Disable a key. *)
  cmEnableHotKey  *= bguiMb + 664;      (* Enable a key.  *)

(* Do a key command. *)

TYPE

  mDoKeyCommand *= STRUCT( msg *: i.Msg )  (* See above.     *)
    keyID    *: LONGINT;                   (* ID of the key. *)
    END;

CONST
  cmEnableBroker  *= bguiMb + 665;      (* Enable broker.  *)
  cmDisableBroker *= bguiMb + 666;      (* Disable broker. *)

  cmMsgInfo       *= bguiMb + 667;

(* Obtain info from a CxMsg. *)

TYPE
  cmiInfoPtr *= UNTRACED POINTER TO cmiInfo;
  cmiInfo *= STRUCT
    type *: UNTRACED POINTER TO LONGINT; (* Storage for CxMsgType() result. *)
    iD   *: UNTRACED POINTER TO LONGINT; (* Storage for CxMsgID() result.   *)
    data *: UNTRACED POINTER TO LONGINT; (* Storage for CxMsgData() result. *)
  END;

  mMsgInfoPtr *= UNTRACED POINTER TO mMsgInfo;
  mMsgInfo *= STRUCT( msg *: i.Msg )     (* CM_MSGINFO        *)
    info   *: cmiInfo;                   (* cmiInfo structure *)
    END;

(* Possible CM_MSGINFO return codes. *)
CONST
  cmmiNoMore    *= -1;            (* ~0L *)   (* No more messages.            *)
  cmmiKill      *= ASH( 1, 16 );              (* Remove yourself. V40         *)
  cmmiDisable   *= ASH( 2, 16 );                     (* You have been disabled. V40  *)
  cmmiEnable    *= ASH( 3, 16 );                     (* You have been enabled. V40   *)
  cmmiUnique    *= ASH( 4, 16 );               (* Unique violation ocured. V40 *)
  cmmiAppear    *= ASH( 5, 16 );               (* Show yourself. V40           *)
  cmmiDisappear *= ASH( 6, 16 );               (* Hide yourself. V40           *)

(*
 *      CM_ADDHOTKEY error codes obtainable using
 *      the COMM_ErrorCode attribute.
 *)
CONST
  cmerrOk          *= 0;               (* OK. No problems.               *)
  cmerrNoMemory    *= 1;               (* Out of memory.                 *)
  cmerrKeyidInUse  *= 2;               (* Key ID already used.           *)
  cmerrKeyCreation *= 3;               (* Key creation failure.          *)
  cmerrCxObjError  *= 4;               (* CxObjError() reported failure. *)

(*****************************************************************************
 *
 *      "aslreqclass" - BOOPSI Asl filerequester classes (file, font, screen)
 *
 *      Tags: 1941 - 2020               Methods: 701 - 740
 *)
CONST
  aslReqTagStart         *= bguiTb + 1941;
  fileReqDrawer          *= bguiTb + 1941;    (* ISG-- *)
  fileReqFile            *= bguiTb + 1942;    (* ISG-- *)
  fileReqPattern         *= bguiTb + 1943;    (* ISG-- *)
  fileReqPath            *= bguiTb + 1944;    (* --G-- *)
  aslReqLeft             *= bguiTb + 1945;    (* --G-- *)
  aslReqTop              *= bguiTb + 1946;    (* --G-- *)
  aslReqWidth            *= bguiTb + 1947;    (* --G-- *)
  aslReqHeight           *= bguiTb + 1948;    (* --G-- *)
  fileReqMultiHook       *= bguiTb + 1949;    (* IS--- *) (* V40 *)
  aslReqType             *= bguiTb + 1950;    (* I-G-- *) (* V41 *)
  aslReqRequester        *= bguiTb + 1951;    (* --G-- *) (* V41 *)

  fontReqTextAttr        *= bguiTb + 1980;    (* ISG-- *) (* V41 *)
  fontReqName            *= bguiTb + 1981;    (* ISG-- *) (* V41 *)
  fontReqSize            *= bguiTb + 1982;    (* ISG-- *) (* V41 *)
  fontReqStyle           *= bguiTb + 1983;    (* ISG-- *) (* V41 *)
  fontReqFlags           *= bguiTb + 1984;    (* ISG-- *) (* V41 *)
  fontReqFrontPen        *= bguiTb + 1985;    (* ISG-- *) (* V41 *)
  fontReqBackPen         *= bguiTb + 1986;    (* ISG-- *) (* V41 *)
  fontReqDrawMode        *= bguiTb + 1987;    (* ISG-- *) (* V41 *)

  screenReqDisplayID     *= bguiTb + 1990;    (* ISG-- *) (* V41 *)
  screenReqDisplayWidth  *= bguiTb + 1991;    (* ISG-- *) (* V41 *)
  screenReqDisplayHeight *= bguiTb + 1992;    (* ISG-- *) (* V41 *)
  screenReqDisplayDepth  *= bguiTb + 1993;    (* ISG-- *) (* V41 *)
  screenReqOverscanType  *= bguiTb + 1994;    (* ISG-- *) (* V41 *)
  screenReqAutoScroll    *= bguiTb + 1995;    (* ISG-- *) (* V41 *)


(*
 *      In addition to the above defined attributes are all
 *      ASL filerequester attributes ISG-U.
 *)

(*
 *      Error codes which the SetAttrs() and DoMethod()
 *      call's can return.
 *)
CONST
  aslReqOk         *= 0;                     (* OK. No problems.                *)
  aslReqCancel     *= 1;                     (* The requester was cancelled.    *)
  aslReqErrorNoMem *= 2;                     (* Out of memory.                  *)
  aslReqErrorNoReq *= 3;                     (* Unable to allocate a requester. *)

(* New Methods *)

  aslmDoRequest *= bguiMb + 701;             (* Show Requester. *)
(*
 * The following three methods are only needed by class implementors.
 *)

  aslmAllocRequest *= bguiMb + 702;         (* AllocRequester() *)
  aslmRequest      *= bguiMb + 703;         (* Request()        *)
  aslmFreeRequest  *= bguiMb + 704;         (* FreeRequester()  *)

(*
 *      These are required for backwards compatibility with old code.
 *      Use the new identifiers instead.
 *)

CONST
  frqLeft        *= aslReqLeft;
  frqTop         *= aslReqTop;
  frqWidth       *= aslReqWidth;
  frqHeight      *= aslReqHeight;
  frqDrawer      *= fileReqDrawer;
  frqFile        *= fileReqFile;
  frqPattern     *= fileReqPattern;
  frqPath        *= fileReqPath;
  frqMultiHook   *= fileReqMultiHook;
  frqOk          *= aslReqOk;
  frqCancel      *= aslReqCancel;
  frqErrorNoMem  *= aslReqErrorNoMem;
  frqErrorNoFreq *= aslReqErrorNoReq;
  frmDorequest   *= aslmDoRequest;


(*****************************************************************************
 *
 *      "areaclass" - BOOPSI area gadget.
 *
 *      Tags: 2021 - 2100               Methods: 741-780
 *
 *      AREA_MinWidth and AREA_MinHeight are required attributes.
 *      Just pass the minimum area size you need here.
 *)
CONST
  areaMinWidth  *= bguiTb + 2021;     (* I---- *) (* V41 *)
  areaMinHeight *= bguiTb + 2022;     (* I---- *) (* V41 *)
  areaAreaBox   *= bguiTb + 2023;     (* --G-- *) (* V41 *)

(*****************************************************************************
 *
 *      "paletteclass" - BOOPSI palette class.
 *
 *      Tags: 2101 - 2180               Methods: 781-820
 *)
CONST
  paletteDepth        *= bguiTb + 2101;    (* I---- *) (* V41.7 *)
  paletteColorOffset  *= bguiTb + 2102;    (* I---- *) (* V41.7 *)
  palettePenTable     *= bguiTb + 2103;    (* I---- *) (* V41.7 *)
  paletteCurrentColor *= bguiTb + 2104;    (* ISGNU *) (* V41.7 *)

(*****************************************************************************
 *
 *      "popbuttonclass" - BOOPSI popbutton class.
 *
 *      Tags: 2181 - 2260               Methods: 821-860
 *)
CONST
  pmbImage       *= bguiTb + 2181;    (* IS--- *) (* V41.7 *)
  pmbMenuEntries *= bguiTb + 2182;    (* IS--- *) (* V41.7 *)
  pmbMenuNumber  *= bguiTb + 2183;    (* --GN- *) (* V41.7 *)
  pmbPopPosition *= bguiTb + 2184;    (* I---- *) (* V41.7 *)
                                      (*
** All labelclass attributes are usable at create time (I).
** The vectorclass attributes are usable at create time and
** with OM_SET (IS).
**)

(*
** An array of these structures define
** the menu labels.
**)

TYPE
  PopMenuPtr *= UNTRACED POINTER TO PopMenu;
  PopMenu *= STRUCT( d *: ArgsDesc )
    label         *: e.APTR;        (* Menu text, NULL terminates array. *)
    flags         *: SET;           (* See below. *)
    mutualExclude *: LONGSET;       (* Mutual-exclusion. *)
    END;

(* Flags *)
CONST
  pmfCheckIt  *= 0;   (* 1<<0 *) (* Checkable toggle item. *)
  pmfChecked  *= 1;   (* 1<<1 *) (* The item is checked. *)
  pmfDisabled *= 2;   (* 1<<2 *) (* The item is disabled. NMC:Added *)

(*
** Special menu entry.
**)
CONST
  pmbBarLabel *= -1;  (* (UBYTE * )~0;  *)

(* New Methods *)
CONST
  pmbmCheckStatus  *= bguiMb + 821;
  pmbmCheckMenu    *= bguiMb + 822;
  pmbmUncheckMenu  *= bguiMb + 823;
  pmbmEnableItem   *= bguiMb + 824;
  pmbmDisableItem  *= bguiMb + 825;
  pmbmEnableStatus *= bguiMb + 826;

TYPE
  mBmCommandPtr *= UNTRACED POINTER TO mBmCommand;
  mBmCommand *= STRUCT( msg *: i.Msg )
    menuNumber *: LONGINT;     (* Menu to perform action on. *)
    END;

(*
**
**  BGUI Library Finctions
**
*)

VAR
  base *: e.LibraryPtr;

PROCEDURE GetClassPtr         *{base,-001EH}( num{0} : LONGINT ) : i.IClassPtr;

PROCEDURE NewObject           *{base,-0024H}(  num{0}  : LONGINT;
                                              tags{8}..: u.Tag ) : Object;

PROCEDURE NewObjectA          *{base,-0024H}(  num{0} : LONGINT;
                                              tags{8} : ARRAY OF u.TagItem ) : Object;

PROCEDURE Request             *{base,-002AH}(     win{8}   : i.WindowPtr;
                                                 reqt{9}   : requestPtr;
                                                 args{10}..: u.Tag       ) : LONGINT;

PROCEDURE RequestA            *{base,-002AH}(     win{8}  : i.WindowPtr;
                                                  req{9}  : requestPtr;
                                                 args{10} : ARRAY OF u.TagItem ): LONGINT;

PROCEDURE Help                *{base,-0030H}(  win{8}  : i.WindowPtr;
                                              name{9}  : ARRAY OF CHAR;
                                              node{10} : ARRAY OF CHAR;
                                              line{0}  : LONGINT        ) : LONGINT;

PROCEDURE LockWindow          *{base,-0036H}( win{8} : i.WindowPtr ): e.APTR;

PROCEDURE UnlockWindow        *{base,-003CH}( lock{8} : e.APTR );

PROCEDURE DoGadgetMethod      *{base,-0042H}( object{8}   : Object;
                                                 win{9}   : i.WindowPtr;
                                                 req{10}  : i.RequesterPtr;
                                                 msg{11}..: u.Tag ) : e.APTR;

PROCEDURE DoGadgetMethodA     *{base,-0042H}( object{8}  : Object;
                                                 win{9}  : i.WindowPtr;
                                                 req{10} : i.RequesterPtr;
                                                 msg{11} : i.Msg ) : e.APTR;

(* Added in V40.4 *)

PROCEDURE AllocBitMap         *{base,-0054H}(  width{0} : LONGINT;
                                              height{1} : LONGINT;
                                               depth{2} : LONGINT;
                                               flags{3} : LONGSET;
                                              friend{8} : g.BitMapPtr ): g.BitMapPtr;

PROCEDURE FreeBitMap          *{base,-005AH}( bitmap{8} : g.BitMapPtr );

PROCEDURE CreateRPortBitMap   *{base,-0060H}(  rport{8} : g.RastPortPtr;
                                               width{0} : LONGINT;
                                              height{1} : LONGINT;
                                               depth{2} : LONGINT       ): g.RastPortPtr;


PROCEDURE FreeRPortBitMap     *{base,-0066H}( rport{8} : g.RastPortPtr );


(* Added in V40.8 *)

PROCEDURE InfoTextSize        *{base,-006CH}(     rp{8}  : g.RastPortPtr;
                                                text{9}  : ARRAY OF CHAR;
                                               width{10} : e.APTR;
                                              height{11} : e.APTR         );

PROCEDURE InfoText            *{base,-0072H}(       rp{8}  : g.RastPortPtr;
                                                  text{9}  : ARRAY OF CHAR;
                                                bounds{10} : i.IBoxPtr;
                                              drawInfo{11} : i.DrawInfoPtr );


(* Added in V41.3 *)

PROCEDURE GetLocaleStr        *{base,-0078H}( bl{8} : LocalePtr;
                                              id{0} : LONGINT ): e.STRPTR;

PROCEDURE GetCatalogStr       *{base,-007EH}(  bl{8} : LocalePtr;
                                               id{0} : LONGINT;
                                              def{9} : ARRAY OF CHAR ): e.STRPTR;

(* Added in V41.4 *)

PROCEDURE FillRectPattern     *{base,-0084H}( rport{9} : g.RastPortPtr;
                                               bpat{8} : PatternPtr;
                                                 x1{0} : LONGINT;
                                                 y1{1} : LONGINT;
                                                 x2{2} : LONGINT;
                                                 y2{3} : LONGINT );

(* Added in V41.6 *)

PROCEDURE PostRender          *{base,-008AH}(  cl{8}  : i.IClassPtr;
                                              obj{10} : Object;
                                               gpr{9} : RenderPtr    );


(* Added in V41.7 *)

PROCEDURE MakeClass           *{base,-0090H}( tags{8}..: u.Tag ) : i.IClassPtr;

PROCEDURE MakeClassA          *{base,-0090H}( tags{8} : ARRAY OF u.TagItem ) : i.IClassPtr;

PROCEDURE FreeClass           *{base,-0096H}( cl{8} : i.IClassPtr ): e.APTR;

PROCEDURE PackStructureTags   *{base,-009CH}(  pack{8} : e.APTR;
                                                tab{9} : e.APTR;
                                              tags{10} : ARRAY OF u.TagItem ): LONGINT;

PROCEDURE UnpackStructureTags *{base,-00A2H}( pack{8}  : e.APTR;
                                               tab{9}  : e.APTR;
                                              tags{10} : ARRAY OF u.TagItem ): LONGINT;


PROCEDURE DoMethod * {"_a_DoMethodA"} ( obj{10} : Object; msg{9}..: u.Tag );
PROCEDURE DOMethod * {"_a_DoMethodA"} ( obj{10} : Object; msg{9}..: u.Tag ) : LONGINT;


BEGIN

  base := e.OpenLibrary( name, minimum );
  IF base=NIL THEN
    IF i.DisplayAlert( 0, "\x00\x64\x14missing bgui.library V37\o\o", 50 ) THEN END;
    HALT(0)
  END;

CLOSE

  IF base # NIL THEN e.CloseLibrary( base ) END;

END Bgui.
