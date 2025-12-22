(*------------------------------------------
  :
  :Module.      BguiMacro.mod
  :Author.      Larry Kuhns [lak]
  :Address.     Cortland, Ohio
  :Revision.    $VER 41.7
  :Date.        02-Dec-1996
  :Copyright.   NONE
  :Language.    Oberon-2
  :Translator.  Amiga Oberon V3.11d (Converted to English)
  :Contents.
  :Imports.     AmigaOberon Amiga interface modules
  :Remarks.     BGUI macro definitions
  :Bugs.        None Known - but probably many
  :Usage.
  :History.     41.7   [lak] 02-Dec-1996 : Initial Release for BGUI
  :                                        Library V41.7
  :History.     41.71  [lak] 06-Dec-1996 : Changed LONGINT's to APTR's in
  :                                        listview macros.
--------------------------------------------*)

MODULE BguiMacro;

(*
**      $VER: libraries/bgui_macros.h 41.7 (11.11.96)
**      bgui.library macros.
**
**      (C) Copyright 1996 Ian J. Einman.
**      (C) Copyright 1993-1996 Jaba Development.
**      (C) Copyright 1993-1996 Jan van den Baard.
**      All Rights Reserved.
**
**      01.12.96 - Initial Release for BGUI V41.7 - Larry Kuhns
*)


IMPORT
  b  := Bgui,
  e  := Exec,
  i  := Intuition,
  u  := Utility,
  w  := Workbench,
  y  := SYSTEM;

(*****************************************************************************
**
**      General object creation macros.
*)

  PROCEDURE LabelObject*{"BguiMacro.LabelObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE LabelObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.labelImage, u.more, tags );
    END LabelObjectA;


  PROCEDURE FrameObject*{"BguiMacro.FrameObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE FrameObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.frameImage, u.more, tags );
    END FrameObjectA;


  PROCEDURE VectorObject*{"BguiMacro.VectorObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE VectorObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.vectorImage, u.more, tags );
    END VectorObjectA;


  PROCEDURE HGroupObject*{"BguiMacro.HGroupObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE HGroupObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.groupGadget, u.more, tags );
    END HGroupObjectA;


  PROCEDURE VGroupObject*{"BguiMacro.VGroupObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE VGroupObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.groupGadget, b.groupStyle, b.grStyleVertical, u.more, tags );
    END VGroupObjectA;


  PROCEDURE ButtonObject*{"BguiMacro.ButtonObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE ButtonObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.buttonGadget, u.more, tags );
    END ButtonObjectA;


  PROCEDURE ToggleObject*{"BguiMacro.ToggleObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE ToggleObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.buttonGadget, i.toggleSelect, e.true, u.more, tags );
    END ToggleObjectA;


  PROCEDURE CycleObject*{"BguiMacro.CycleObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE CycleObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject(  b.cycleGadget, u.more, tags );
    END CycleObjectA;


  PROCEDURE CheckBoxObject*{"BguiMacro.CheckBoxObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE CheckBoxObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.checkBoxGadget, u.more, tags );
    END CheckBoxObjectA;


  PROCEDURE InfoObject*{"BguiMacro.InfoObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE InfoObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.infoGadget, u.more, tags );
    END InfoObjectA;


  PROCEDURE StringObject*{"BguiMacro.StringObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE StringObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.stringGadget, u.more, tags );
    END StringObjectA;


  PROCEDURE PropObject*{"BguiMacro.PropObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE PropObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.propGadget, u.more, tags );
    END PropObjectA;


  PROCEDURE IndicatorObject*{"BguiMacro.IndicatorObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE IndicatorObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.indicatorGadget, u.more, tags );
    END IndicatorObjectA;


  PROCEDURE ProgressObject*{"BguiMacro.ProgressObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE ProgressObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.progressGadget, u.more, tags );
    END ProgressObjectA;


  PROCEDURE SliderObject*{"BguiMacro.SliderObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE SliderObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.sliderGadget, u.more, tags );
    END SliderObjectA;


  PROCEDURE PageObject*{"BguiMacro.PageObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE PageObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.pageGadget, u.more, tags );
    END PageObjectA;


  PROCEDURE MxObject*{"BguiMacro.MxObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE MxObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.mxGadget, u.more, tags );
    END MxObjectA;


  PROCEDURE ExternalObject*{"BguiMacro.ExternalObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE ExternalObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.externalGadget, i.gaLeft, 0, i.gaTop, 0, i.gaWidth, 0, i.gaHeight, 0, u.more, tags );
    END ExternalObjectA;


  PROCEDURE ListviewObject*{"BguiMacro.ListviewObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE ListviewObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.listviewGadget, u.more, tags );
    END ListviewObjectA;


  PROCEDURE SeparatorObject*{"BguiMacro.SeparatorObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE SeparatorObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.separatorGadget, u.more, tags );
    END SeparatorObjectA;


  PROCEDURE AreaObject*{"BguiMacro.AreaObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE AreaObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.areaGadget, u.more, tags );
    END AreaObjectA;


  PROCEDURE ViewObject*{"BguiMacro.ViewObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE ViewObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.viewGadget, u.more, tags );
    END ViewObjectA;


  PROCEDURE PaletteObject*{"BguiMacro.PaletteObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE PaletteObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.paletteGadget, u.more, tags );
    END PaletteObjectA;


  PROCEDURE PopButtonObject*{"BguiMacro.PopButtonObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE PopButtonObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.popButtonGadget, u.more, tags );
    END PopButtonObjectA;


  PROCEDURE WindowObject*{"BguiMacro.WindowObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE WindowObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.windowObject, u.more, tags );
    END WindowObjectA;


  PROCEDURE FileReqObject*{"BguiMacro.FileReqObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE FileReqObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.fileReqObject, u.more, tags );
    END FileReqObjectA;


  PROCEDURE CommodityObject*{"BguiMacro.CommodityObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE CommodityObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.commodityObject, u.more, tags );
    END CommodityObjectA;


  PROCEDURE ScreenReqObject*{"BguiMacro.ScreenReqObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE ScreenReqObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.screenReqObject, u.more, tags );
    END ScreenReqObjectA;


  PROCEDURE ARexxObject*{"BguiMacro.ARexxObjectA"} ( tags{9}.. : u.Tag): b.Object;
  PROCEDURE ARexxObjectA*( tags{9} : u.TagListPtr ): b.Object;
    BEGIN (* SaveReg+ *)
      RETURN b.NewObject( b.arexxObject, u.more, tags );
    END ARexxObjectA;

(*** 
#define EndObject       u.done

(* Typo *)
#define SeperatorObject b.NewObject( b.SeparatorGadget


(*****************************************************************************
**
**      Label creation.
*)

#define Label(l)                b.labLabel, l
#define UScoreLabel(l,u)        b.labLabel, l, b.labUnderscore, u
#define Style(s)                b.labStyle, s
#define Place(p)                b.labPlace, p


(*****************************************************************************
**
**      Frames.
*)

#define ButtonFrame             b.frmType, b.frTypeButton
#define RidgeFrame              b.frmType, b.frTypeRidge
#define DropBoxFrame            b.frmType, b.frTypeDropBox
#define NeXTFrame               b.frmType, b.frTypeNext
#define RadioFrame              b.frmType, b.frTypeRadioButton
#define XenFrame                b.frmType, b.frTypeXenButton
#define TabAboveFrame           b.frmType, b.frTypeTabAbove
#define TabBelowFrame           b.frmType, b.frTypeTabBelow
#define BorderFrame             b.frmType, b.frTypeBorder
#define FuzzButtonFrame         b.frmType, b.frTypeFuzzButton
#define FuzzRidgeFrame          b.frmType, b.frTypeFuzzRidge

(* For clarity. *)

#define StringFrame             b.frmType, b.frTypeRidge
#define MxFrame                 b.frmType, b.frTypeRadioButton

#define FrameTitle(t)           b.frmTitle, t

(* Built-in back fills *)

#define ShineRaster             b.frmBackfill, b.shineRaster
#define ShadowRaster            b.frmBackfill, b.shadowRaster
#define ShineShadowRaster       b.frmBackfill, b.shineShadowRaster
#define FillRaster              b.frmBackfill, b.fillRaster
#define ShineFillRaster         b.frmBackfill, b.shineFillRaster
#define ShadowFillRaster        b.frmBackfill, b.shadowFillRaster
#define ShineBlock              b.frmBackfill, b.shineBlock
#define ShadowBlock             b.frmBackfill, b.shadowBlock


(*****************************************************************************
**
**      Vector images.
*)

#define GetPath                 b.vitBuiltIn, b.builtinGetPath
#define GetFile                 b.vitBuiltIn, b.builtinGetFile
#define CheckMark               b.vitBuiltIn, b.builtinCheckMark
#define PopUp                   b.vitBuiltIn, b.builtinPopup
#define ArrowUp                 b.vitBuiltIn, b.builtinArrowUp
#define ArrowDown               b.vitBuiltIn, b.builtinArrowDown
#define ArrowLeft               b.vitBuiltIn, b.builtinArrowLeft
#define ArrowRight              b.vitBuiltIn, b.builtinArrowRight


(*****************************************************************************
**
**      Group class macros.
*)

#define StartMember             b.groupMember
#define EndMember               u.done, 0
#define Spacing(p)              b.groupSpacing, p
#define Offset(p)               b.groupOffset, p
#define HOffset(p)              b.groupHorizOffset, p
#define VOffset(p)              b.groupVertOffset, p
#define LOffset(p)              b.groupLeftOffset, p
#define ROffset(p)              b.groupRightOffset, p
#define TOffset(p)              b.groupTopOffset, p
#define BOffset(p)              b.groupBottomOffset, p
#define VarSpace(w)             b.groupSpaceObject, w
#define EqualWidth              b.groupEqualWidth, e.true
#define EqualHeight             b.groupEqualHeight, e.true

#define NormalSpacing           b.groupSpacing, b.grSpaceNormal
#define NormalHOffset           b.groupHorizOffset, b.grSpaceNormal
#define NormalVOffset           b.groupVertOffset, b.grSpaceNormal
#define NarrowSpacing           b.groupSpacing, b.grSpaceNarrow
#define NarrowHOffset           b.groupHorizOffset, b.grSpaceNarrow
#define NarrowVOffset           b.groupVertOffset, b.grSpaceNarrow
#define WideSpacing             b.groupSpacing, b.grSpaceWide
#define WideHOffset             b.groupHorizOffset, b.grSpaceWide
#define WideVOffset             b.groupVertOffset, b.grSpaceWide
#define NormalOffset            b.groupHorizOffset, b.grSpaceNormal,
                                b.groupVertOffset,  b.grSpaceNormal,

***)

(*****************************************************************************
**
**      Layout macros.
*)

(***
#define FixMinWidth             b.lgoFixMinWidth, e.true
#define FixMinHeight            b.lgoFixMinHeight, e.true
#define Weight(w)               b.lgoWeight, w
#define FixWidth(w)             b.lgoFixWidth, w
#define FixHeight(h)            b.lgoFixHeight, h
#define Align                   b.lgoAlign, e.true
#define FixMinSize(w,h)         b.lgoFixMinWidth,  e.true,
                                b.lgoFixMinHeight, e.true
#define FixSize(w,h)            b.lgoFixWidth, w,
                                b.lgoFixHeight, h
#define NoAlign                 b.lgoNoAlign, e.true
#define FixAspect(x,y)          lgoFixAspect, ((x) << 16) | (y)


(*****************************************************************************
**
**      Page class macros.
*)

#define PageMember              b.pageMember

***)


(*****************************************************************************
**
**      "Quick" button creation macros.
*)

PROCEDURE PrefButton*( label : e.LSTRPTR; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.buttonGadget,
                        b.labLabel, label,
                        i.gaID,     id,
                        u.done );
  END PrefButton;

PROCEDURE FuzzButton*( label : e.LSTRPTR; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.buttonGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.gaID,          id,
                        b.frmType,       b.frTypeFuzzButton,
                        u.done );
  END FuzzButton;

PROCEDURE Button*( label : e.LSTRPTR; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.buttonGadget,
                        b.labLabel, label,
                        i.gaID,     id,
                        b.frmType,  b.frTypeButton,
                        u.done );
  END Button;

PROCEDURE KeyButton*( label : e.LSTRPTR; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.buttonGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.gaID,          id,
                        b.frmType,       b.frTypeButton,
                        u.done );
  END KeyButton;

PROCEDURE PrefToggle*( label : e.LSTRPTR; state : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.buttonGadget,
                        i.gaToggleSelect, e.true,
                        b.labLabel,       label,
                        i.gaID,           id,
                        i.gaSelected,     state,
                        u.done );
  END PrefToggle;

PROCEDURE Toggle*( label : e.LSTRPTR; state : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.buttonGadget,
                        i.gaToggleSelect, e.true,
                        b.labLabel,       label,
                        i.gaID,           id,
                        i.gaSelected,     state,
                        b.frmType,        b.frTypeButton,
                        u.done );
  END Toggle;

PROCEDURE KeyToggle*( label : e.LSTRPTR; state : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.buttonGadget,
                        i.gaToggleSelect, e.true,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.gaID,          id,
                        i.gaSelected,    state,
                        b.frmType,       b.frTypeButton,
                        u.done )
  END KeyToggle;


PROCEDURE XenButton*( label : e.LSTRPTR; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.buttonGadget,
                        b.labLabel, label,
                        i.gaID,     id,
                        b.frmType,  b.frTypeXenButton,
                        u.done );
  END XenButton;

PROCEDURE XenKeyButton*( label : e.LSTRPTR; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.buttonGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.gaID,          id,
                        b.frmType,       b.frTypeXenButton,
                        u.done );
  END XenKeyButton;

PROCEDURE XenToggle*( label : e.LSTRPTR; state : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.buttonGadget,
                        i.gaToggleSelect, e.true,
                        b.labLabel,       label,
                        i.gaID,           id,
                        i.gaSelected,     state,
                        b.frmType,        b.frTypeXenButton,
                        u.done )
  END XenToggle;

PROCEDURE XenKeyToggle*( label : e.LSTRPTR; state : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.buttonGadget,
                        i.gaToggleSelect, e.true,
                        b.labLabel,       label,
                        b.labUnderscore,  y.VAL( LONGINT, ORD('_')),
                        i.gaID,           id,
                        i.gaSelected,     state,
                        b.frmType,        b.frTypeXenButton,
                        u.done )
  END XenKeyToggle;


(*****************************************************************************
**
**      "Quick" cycle creation macros.
*)

PROCEDURE PrefCycle*( label : e.LSTRPTR; labels : e.APTR; active : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.cycleGadget,
                        b.labLabel,  label,
                        i.gaID,      id,
                        b.cycLabels, labels,
                        b.cycActive, active,
                        u.done );
  END PrefCycle;

PROCEDURE Cycle*( label : e.LSTRPTR; labels : e.APTR; active : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.cycleGadget,
                        b.labLabel,  label,
                        i.gaID,      id,
                        b.frmType,   b.frTypeButton,
                        b.cycLabels, labels,
                        b.cycActive, active,
                        b.cycPopup,  e.false,
                        u.done );
  END Cycle;

PROCEDURE KeyCycle*( label : e.LSTRPTR; labels : e.APTR; active : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.cycleGadget,
                       b.labLabel,      label,
                       b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                       i.gaID,          id,
                       b.frmType,       b.frTypeButton,
                       b.cycLabels,     labels,
                       b.cycActive,     active,
                       b.cycPopup,      e.false,
                       u.done );
  END KeyCycle;

PROCEDURE XenCycle*( label : e.LSTRPTR; labels : e.APTR; active : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.cycleGadget,
                        b.labLabel,  label,
                        i.gaID,      id,
                        b.frmType,   b.frTypeXenButton,
                        b.cycLabels, labels,
                        b.cycActive, active,
                        b.cycPopup,  e.false,
                        u.done );
  END XenCycle;


PROCEDURE XenKeyCycle*( label : e.LSTRPTR; labels : e.APTR; active : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.cycleGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.gaID,          id,
                        b.frmType,       b.frTypeXenButton,
                        b.cycLabels,     labels,
                        b.cycActive,     active,
                        b.cycPopup,      e.false,
                        u.done );
  END XenKeyCycle;

PROCEDURE PopCycle*( label : e.LSTRPTR; labels : e.APTR; active : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.cycleGadget,
                        b.labLabel,  label,
                        i.gaID,      id,
                        b.frmType,   b.frTypeButton,
                        b.cycLabels, labels,
                        b.cycActive, active,
                        b.cycPopup,  e.true,
                        u.done );
  END PopCycle;

PROCEDURE KeyPopCycle*( label : e.LSTRPTR; labels : e.APTR; active : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.cycleGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.gaID,          id,
                        b.frmType,       b.frTypeButton,
                        b.cycLabels,     labels,
                        b.cycActive,     active,
                        b.cycPopup,      e.true,
                        u.done );
  END KeyPopCycle;

PROCEDURE XenPopCycle*( label : e.LSTRPTR; labels : e.APTR; active : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.cycleGadget,
                        b.labLabel,  label,
                        i.gaID,      id,
                        b.frmType,   b.frTypeXenButton,
                        b.cycLabels, labels,
                        b.cycActive, active,
                        b.cycPopup,  e.true,
                        u.done );
  END XenPopCycle;

PROCEDURE XenKeyPopCycle*( label : e.LSTRPTR; labels : e.APTR; active : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.cycleGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.gaID,          id,
                        b.frmType,       b.frTypeXenButton,
                        b.cycLabels,     labels,
                        b.cycActive,     active,
                        b.cycPopup,      e.true,
                        u.done );
  END XenKeyPopCycle;


(*****************************************************************************
**
**      "Quick" checkbox creation macros.
*)

PROCEDURE PrefCheckBox * ( label : e.LSTRPTR; state, id : LONGINT ) : b.Object;
  VAR obj : b.Object;
  BEGIN
    obj:=  b.NewObject( b.checkBoxGadget,
                        b.labLabel,   label,
                        i.gaID,       id,
                        i.gaSelected, state,
                        u.done );
(*  FixMinSize
           b.lgoFixMinWidth, e.true,
           b.lgoFixMinHeight, e.true,
*)
    RETURN obj;
  END PrefCheckBox;

PROCEDURE CheckBox * ( label : e.LSTRPTR; state, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.checkBoxGadget,
                        b.labLabel,   label,
                        i.gaID,       id,
                        b.frmType,    b.frTypeButton,
                        i.gaSelected, state,
                        u.done );
(* FixMinSize
           b.lgoFixMinWidth, e.true,
           b.lgoFixMinHeight, e.true;
*)
  END CheckBox;

PROCEDURE KeyCheckBox * ( label : e.LSTRPTR; state, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.checkBoxGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.gaID,          id,
                        b.frmType,       b.frTypeButton,
                        i.gaSelected,    state,
                        u.done );
(* FixMinSize
           b.lgoFixMinWidth, e.true,
           b.lgoFixMinHeight, e.true;
*)
  END KeyCheckBox;

PROCEDURE XenCheckBox * ( label : e.LSTRPTR; state, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.checkBoxGadget,
                        b.labLabel,   label,
                        i.gaID,       id,
                        b.frmType,    b.frTypeXenButton,
                        i.gaSelected, state,
                        u.done );
(* FixMinSize
           b.lgoFixMinWidth, e.true,
           b.lgoFixMinHeight, e.true;
*)
  END XenCheckBox;

PROCEDURE XenKeyCheckBox * ( label : e.LSTRPTR; state, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.checkBoxGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.gaID,          id,
                        b.frmType,       b.frTypeXenButton,
                        i.gaSelected,    state,
                        u.done );
(* FixMinSize
           b.lgoFixMinWidth, e.true,
           b.lgoFixMinHeight, e.true;
*)
  END XenKeyCheckBox;

PROCEDURE CheckBoxNF * ( label : e.LSTRPTR; state, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.checkBoxGadget,
                        b.labLabel,   label,
                        i.gaID,       id,
                        b.frmType,    b.frTypeButton,
                        b.frmFlags,  LONGSET{ b.frfEdgesOnly },
                        i.gaSelected, state,
                        u.done );
  END CheckBoxNF;

PROCEDURE KeyCheckBoxNF * ( label : e.LSTRPTR; state, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.checkBoxGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.gaID,          id,
                        b.frmType,       b.frTypeButton,
                        b.frmFlags,      LONGSET{ b.frfEdgesOnly },
                        i.gaSelected,    state,
                        u.done );
  END KeyCheckBoxNF;

PROCEDURE XenCheckBoxNF * ( label : e.LSTRPTR; state, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.checkBoxGadget,
                        b.labLabel,   label,
                        i.gaID,       id,
                        b.frmType,    b.frTypeXenButton,
                        b.frmFlags,   LONGSET{ b.frfEdgesOnly },
                        i.gaSelected, state,                                                                                       u.done );
  END XenCheckBoxNF;

PROCEDURE XenKeyCheckBoxNF * ( label : e.LSTRPTR; state, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.checkBoxGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.gaID,          id,
                        b.frmType,       b.frTypeXenButton,
                        b.frmFlags,      LONGSET{ b.frfEdgesOnly },
                        i.gaSelected,    state,
                        u.done );
  END XenKeyCheckBoxNF;


(*****************************************************************************
**
**      "Quick" info object creation macros.
*)

PROCEDURE InfoFixed*( label, text : e.LSTRPTR; args : LONGINT; numlines : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.infoGadget,
                        b.labLabel,         label,
                        b.frmType,          b.frTypeButton,
                        b.frmFlags,         LONGSET{ b.frfRecessed },
                        b.infoTextFormat,   text,
                        b.infoArgs,         args,
                        b.infoMinLines,     numlines,
                        b.infoFixTextWidth, e.true,
                        u.done );
  END InfoFixed;

PROCEDURE InfoObj*( label, text : e.LSTRPTR; args : LONGINT; numlines : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.infoGadget,
                        b.labLabel,       label,
                        b.frmType,        b.frTypeButton,
                        b.frmFlags,       LONGSET{ b.frfRecessed },
                        b.infoTextFormat, text,
                        b.infoArgs,       args,
                        b.infoMinLines,   numlines,
                        u.done );
  END InfoObj;


(*****************************************************************************
**
**      "Quick" string/integer creation macros.
*)

PROCEDURE PrefString * ( label, contents : e.LSTRPTR; maxchars : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.stringGadget,
                        b.labLabel,        label,
                        i.stringaTextVal,  contents,
                        i.stringaMaxChars, maxchars,
                        i.gaID,            id,
                        i.gaTabCycle,      e.true,
                        u.done );
  END PrefString;

PROCEDURE String * ( label, contents : e.LSTRPTR; maxchars : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.stringGadget,
                        b.labLabel,        label,
                        b.frmType,         b.frTypeRidge,
                        i.stringaTextVal,  contents,
                        i.stringaMaxChars, maxchars,
                        i.gaID,            id,
                        u.done );
  END String;

PROCEDURE KeyString * ( label, contents : e.LSTRPTR; maxchars : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.stringGadget,
                        b.labLabel,        label,
                        b.labUnderscore,   y.VAL( LONGINT, ORD('_')),
                        b.frmType,         b.frTypeRidge,
                        i.stringaTextVal,  contents,
                        i.stringaMaxChars, maxchars,
                        i.gaID,            id,
                        u.done );
  END KeyString;

PROCEDURE TabString * ( label, contents : e.LSTRPTR; maxchars : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.stringGadget,
                        b.labLabel,        label,
                        b.frmType,         b.frTypeRidge,
                        i.stringaTextVal,  contents,
                        i.stringaMaxChars, maxchars,
                        i.gaID,            id,
                        i.gaTabCycle,      e.true,
                        u.done );
  END TabString;

PROCEDURE TabKeyString * ( label, contents : e.LSTRPTR; maxchars : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.stringGadget,
                        b.labLabel,        label,
                        b.labUnderscore,   y.VAL( LONGINT, ORD('_')),
                        b.frmType,         b.frTypeRidge,
                        i.stringaTextVal,  contents,
                        i.stringaMaxChars, maxchars,
                        i.gaID,            id,
                        i.gaTabCycle,      e.true,
                        u.done );
  END TabKeyString;

PROCEDURE PrefInteger * ( label, contents : e.LSTRPTR; maxchars : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.stringGadget,
                        b.labLabel,        label,
                        i.stringaLongVal,  contents,
                        i.stringaMaxChars, maxchars,
                        i.gaID,            id,
                        i.gaTabCycle,      e.true,
                        u.done );
  END PrefInteger;

PROCEDURE Integer * ( label, contents : e.LSTRPTR; maxchars : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.stringGadget,
                        b.labLabel,        label,
                        b.frmType,         b.frTypeRidge,
                        i.stringaLongVal,  contents,
                        i.stringaMaxChars, maxchars,
                        i.gaID,            id,
                        u.done );
  END Integer;

PROCEDURE KeyInteger * ( label, contents : e.LSTRPTR; maxchars : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.stringGadget,
                        b.labLabel,        label,
                        b.labUnderscore,   y.VAL( LONGINT, ORD('_')),
                        b.frmType,         b.frTypeRidge,
                        i.stringaLongVal,  contents,
                        i.stringaMaxChars, maxchars,
                        i.gaID,            id,
                        u.done );
  END KeyInteger;

PROCEDURE TabInteger * ( label, contents : e.LSTRPTR; maxchars : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.stringGadget,
                        b.labLabel,        label,
                        b.frmType,         b.frTypeRidge,
                        i.stringaLongVal,  contents,
                        i.stringaMaxChars, maxchars,
                        i.gaID,            id,
                        i.gaTabCycle,      e.true,
                        u.done );
  END TabInteger;

PROCEDURE TabKeyInteger * ( label, contents : e.LSTRPTR; maxchars : LONGINT; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.stringGadget,
                        b.labLabel,        label,
                        b.labUnderscore,   y.VAL( LONGINT, ORD('_')),
                        b.frmType,         b.frTypeRidge,
                        i.stringaLongVal,  contents,
                        i.stringaMaxChars, maxchars,
                        i.gaID,            id,
                        i.gaTabCycle,      e.true,
                        u.done )
  END TabKeyInteger;

(*** LAK
(*
**      i.stringaPens & i.stringaActivePens pen-pack macro.
*)

#define PACKPENS(a,b) (((b<<8)&0xFF00)|((a)&0x00FF))
*** LAK *)


(*****************************************************************************
**
**      "Quick" scroller creation macros.
*)

PROCEDURE HorizScroller * ( label : e.LSTRPTR; top, total, visible, id : LONGINT ) : b.Object;
  (* $CopyArrays- *)
  BEGIN
    RETURN b.NewObject( b.propGadget,
                        b.labLabel,   label,
                        i.pgaTop,     top,
                        i.pgaTotal,   total,
                        i.pgaVisible, visible,
                        i.pgaFreedom, LONGSET{i.freeHoriz},
                        i.gaID,       id,
                        b.pgaArrows,  e.true,
                        u.done );
  END HorizScroller;

PROCEDURE VertScroller * ( label : e.LSTRPTR; top, total, visible, id : LONGINT ) : b.Object;
  (* $CopyArrays- *)
  BEGIN
    RETURN b.NewObject( b.propGadget,
                        b.labLabel,   label,
                        i.pgaTop,     top,
                        i.pgaTotal,   total,
                        i.pgaVisible, visible,
                        i.gaID,       id,
                        b.pgaArrows,  e.true,
                        u.done );
  END VertScroller;

PROCEDURE KeyHorizScroller * ( label : e.LSTRPTR; top, total, visible, id : LONGINT ) : b.Object;
  (* $CopyArrays- *)
  BEGIN
    RETURN b.NewObject( b.propGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.pgaTop,        top,
                        i.pgaTotal,      total,
                        i.pgaVisible,    visible,
                        i.pgaFreedom,    LONGSET{i.freeHoriz},
                        i.gaID,          id,
                        b.pgaArrows,     e.true,
                        u.done );
  END KeyHorizScroller;

PROCEDURE KeyVertScroller * ( label : e.LSTRPTR; top, total, visible, id : LONGINT ) : b.Object;
  (* $CopyArrays- *)
  BEGIN
    RETURN b.NewObject( b.propGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        i.pgaTop,        top,
                        i.pgaTotal,      total,
                        i.pgaVisible,    visible,
                        i.gaID,          id,
                        b.pgaArrows,     e.true,
                        u.done );
  END KeyVertScroller;


(*****************************************************************************
**
**      "Quick" indicator creation macros.
*)

PROCEDURE Indicator * ( min, max, level, just : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.indicatorGadget,
                        b.indicMin,           min,
                        b.indicMax,           max,
                        b.indicLevel,         level,
                        b.indicJustification, just,
                        u.done );
  END Indicator;

PROCEDURE IndicatorFormat *  (min, max, level, just : LONGINT; format : e.LSTRPTR ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.indicatorGadget,
                        b.indicMin,           min,
                        b.indicMax,           max,
                        b.indicLevel,         level,
                        b.indicJustification, just,
                        b.indicFormatString,  format,
                        u.done );
  END IndicatorFormat;


(*****************************************************************************
**
**      "Quick" progress creation macros.
*)

PROCEDURE HorizProgress * ( label : e.LSTRPTR; min, max, done : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.progressGadget,
                        b.labLabel,     label,
                        b.frmType,      b.frTypeButton,
                        b.frmFlags,     LONGSET{ b.frfRecessed },
                        b.progressMin,  min,
                        b.progressMax,  max,
                        b.progressDone, done,
                        u.done );
  END HorizProgress;

PROCEDURE VertProgress * ( label : e.LSTRPTR; min, max, done : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.progressGadget,
                        b.labLabel,         label,
                        b.frmType,          b.frTypeButton,
                        b.frmFlags,         LONGSET{ b.frfRecessed },
                        b.progressMin,      min,
                        b.progressMax,      max,
                        b.progressDone,     done,
                        b.progressVertical, e.true,
                        u.done );
  END VertProgress;

PROCEDURE HorizProgressFS * ( label : e.LSTRPTR; min, max, done : LONGINT; fstr : e.LSTRPTR ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.progressGadget,
                        b.labLabel,             label,
                        b.frmType,              b.frTypeButton,
                        b.frmFlags,             LONGSET{ b.frfRecessed },
                        b.progressMin,          min,
                        b.progressMax,          max,
                        b.progressDone,         done,
                        b.progressFormatString, fstr,
                        u.done );
  END HorizProgressFS;

PROCEDURE VertProgressFS * ( label : e.LSTRPTR; min, max, done : LONGINT; fstr : e.LSTRPTR ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.progressGadget,
                        b.labLabel,             label,
                        b.frmType,              b.frTypeButton,
                        b.frmFlags,             LONGSET{ b.frfRecessed },
                        b.progressMin,          min,
                        b.progressMax,          max,
                        b.progressDone,         done,
                        b.progressVertical,     e.true,
                        b.progressFormatString, fstr,
                        u.done );
  END VertProgressFS;


(*****************************************************************************
**
**      "Quick" slider creation macros.
*)

PROCEDURE HorizSlider * ( label : e.LSTRPTR; min, max, level ,id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.sliderGadget,
                        b.labLabel,    label,
                        b.sliderMin,   min,
                        b.sliderMax,   max,
                        b.sliderLevel, level,
                        i.gaID,        id,
                        u.done );
  END HorizSlider;

PROCEDURE VertSlider * ( label : e.LSTRPTR; min, max, level ,id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.sliderGadget,
                        b.labLabel,    label,
                        b.sliderMin,   min,
                        b.sliderMax,   max,
                        b.sliderLevel, level,
                        i.pgaFreedom,  LONGSET{i.freeVert},
                        i.gaID,        id,
                        u.done )
  END VertSlider;

PROCEDURE KeyHorizSlider * ( label : e.LSTRPTR; min, max, level ,id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.sliderGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        b.sliderMin,     min,
                        b.sliderMax,     max,
                        b.sliderLevel,   level,
                        i.gaID,          id,
                        u.done );
  END KeyHorizSlider;

PROCEDURE KeyVertSlider * ( label : e.LSTRPTR; min, max, level ,id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.sliderGadget,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        b.sliderMin,     min,
                        b.sliderMax,     max,
                        b.sliderLevel,   level,
                        i.pgaFreedom,    LONGSET{i.freeVert},
                        i.gaID,          id,
                        u.done );
  END KeyVertSlider;


(*****************************************************************************
**
**      "Quick" mx creation macros.
*)

PROCEDURE RightMx * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.groupStyle, b.grStyleVertical,
                        b.labLabel,   label,
                        b.mxLabels,   labels,
                        b.mxActive,   active,
                        i.gaID,       id,
                        u.done );
           (* FixMinSize
           b.lgoFixMinWidth,  e.true,
           b.lgoFixMinHeight, e.true;
           *)
  END RightMx;

PROCEDURE LeftMx * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.groupStyle,   b.grStyleVertical,
                        b.labLabel,     label,
                        b.mxLabels,     labels,
                        b.mxActive,     active,
                        b.mxLabelPlace, b.placeLeft,
                        i.gaID,         id,
                        u.done );
           (* FixMinSize
           b.lgoFixMinWidth,  e.true,
           b.lgoFixMinHeight, e.true;
           *)
  END LeftMx;

PROCEDURE RightMxKey * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.groupStyle,    b.grStyleVertical,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        b.mxLabels,      labels,
                        b.mxActive,      active,
                        i.gaID,          id,
                        u.done );
           (* FixMinSize
           b.lgoFixMinWidth, e.true,
           b.lgoFixMinHeight, e.true;
           *)
  END RightMxKey;

PROCEDURE LeftMxKey * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.groupStyle,    b.grStyleVertical,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        b.mxLabels,      labels,
                        b.mxActive,      active,
                        b.mxLabelPlace,  b.placeLeft,
                        i.gaID,          id,
                        u.done );
           (* FixMinSize
           b.lgoFixMinWidth, e.true,
           b.lgoFixMinHeight, e.true;
           *)
  END LeftMxKey;

PROCEDURE Tabs * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.mxTabsObject, e.true,
                        b.labLabel,     label,
                        b.mxLabels,     labels,
                        b.mxActive,     active,
                        i.gaID,         id,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END Tabs;

PROCEDURE TabsKey * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.mxTabsObject,  e.true,
                        b.labLabel,      label,
                        b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                        b.mxLabels,      labels,
                        b.mxActive,      active,
                        i.gaID,          id,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END TabsKey;

PROCEDURE TabsEqual * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.groupEqualWidth, e.true,
                        b.mxTabsObject,    e.true,
                        b.labLabel,        label,
                        b.mxLabels,        labels,
                        b.mxActive,        active,
                        i.gaID,            id,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END TabsEqual;

PROCEDURE TabsEqualKey * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.groupEqualWidth, e.true,
                        b.mxTabsObject,    e.true,
                        b.labLabel,        label,
                        b.labUnderscore,   y.VAL( LONGINT, ORD('_')),
                        b.mxLabels,        labels,
                        b.mxActive,        active,
                        i.gaID,            id,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END TabsEqualKey;

PROCEDURE USDTabs * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.mxTabsObject,     e.true,
                        b.labLabel,         label,
                        b.mxLabels,         labels,
                        b.mxActive,         active,
                        b.mxTabsUpsideDown, e.true,
                        i.gaID,             id,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END USDTabs;

PROCEDURE USDTabsKey * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.mxTabsObject,     e.true,
                        b.labLabel,         label,
                        b.labUnderscore,    y.VAL( LONGINT, ORD('_')),
                        b.mxLabels,         labels,
                        b.mxActive,         active,
                        b.mxTabsUpsideDown, e.true,
                        i.gaID,             id,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END USDTabsKey;

PROCEDURE USDTabsEqual * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.groupEqualWidth,  e.true,
                        b.mxTabsObject,     e.true,
                        b.labLabel,         label,
                        b.mxLabels,         labels,
                        b.mxActive,         active,
                        b.mxTabsUpsideDown, e.true,
                        i.gaID,             id,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END USDTabsEqual;

PROCEDURE USDTabsEqualKey * ( label : e.LSTRPTR; labels : e.APTR; active, id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.mxGadget,
                        b.groupEqualWidth,  e.true,
                        b.mxTabsObject,     e.true,
                        b.labLabel,         label,
                        b.labUnderscore,    y.VAL( LONGINT, ORD('_')),
                        b.mxLabels,         labels,
                        b.mxActive,         active,
                        b.mxTabsUpsideDown, e.true,
                        i.gaID,             id,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END USDTabsEqualKey;


(*****************************************************************************
**
**      "Quick" listview creation macros.
*)

PROCEDURE StrListview * ( label : e.LSTRPTR; strings : e.APTR; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.listviewGadget,
                        b.labLabel,        label,
                        i.gaID,            id,
                        b.listvEntryArray, strings,
                        u.done );
  END StrListview;

PROCEDURE StrListviewSorted * ( label : e.LSTRPTR; strings : e.APTR; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.listviewGadget,
                        b.labLabel,              label,
                        i.gaID,                  id,
                        b.listvEntryArray,       strings,
                        b.listvSortEntryArray,   e.true,
                        u.done );
  END StrListviewSorted;

PROCEDURE ReadStrListview * ( label : e.LSTRPTR; strings : e.APTR ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.listviewGadget,
                        b.labLabel,        label,
                        b.listvEntryArray, strings,
                        b.listvReadOnly,   e.true,
                        u.done );
  END ReadStrListview;

PROCEDURE ReadStrListviewSorted * ( label : e.LSTRPTR; strings : e.APTR ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.listviewGadget,
                        b.labLabel,            label,
                        b.listvEntryArray,     strings,
                        b.listvSortEntryArray, e.true,
                        b.listvReadOnly,       e.true,
                        u.done );
  END ReadStrListviewSorted;

PROCEDURE MultiStrListview * ( label : e.LSTRPTR; strings : e.APTR; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.listviewGadget,
                        b.labLabel,          label,
                        i.gaID,              id,
                        b.listvEntryArray,   strings,
                        b.listvMultiSelect,  e.true,
                        u.done );
  END MultiStrListview;

PROCEDURE MultiStrListviewSorted * ( label : e.LSTRPTR; strings : e.APTR; id : LONGINT ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.listviewGadget,
                        b.labLabel,            label,
                        i.gaID,                id,
                        b.listvEntryArray,     strings,
                        b.listvSortEntryArray, e.true,
                        b.listvMultiSelect,    e.true,
                        u.done );
  END MultiStrListviewSorted;


(*****************************************************************************
**
**     label bar creation macros.
*)

PROCEDURE VertSeparator * () : b.Object;
  BEGIN
    RETURN b.NewObject( b.separatorGadget,
                        u.done );
           (* FixMinWidth
           b.lgoFixMinWidth, e.true;
           *)
  END VertSeparator;

PROCEDURE VertThinSeparator * () : b.Object;
  BEGIN
    RETURN b.NewObject( b.separatorGadget,
                        b.sepThin, e.true,
                        u.done );
           (* FixMinWidth
           b.lgoFixMinWidth, e.true;
           *)
  END VertThinSeparator;

PROCEDURE HorizSeparator * () : b.Object;
  BEGIN
    RETURN b.NewObject( b.separatorGadget,
                        b.sepHoriz, e.true,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END HorizSeparator;

PROCEDURE TitleSeparator * ( t : e.LSTRPTR ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.separatorGadget,
                        b.sepHoriz, e.true,
                        b.sepTitle, t,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END TitleSeparator;

PROCEDURE HTitleSeparator * ( t : e.LSTRPTR ): b.Object;
  BEGIN
    RETURN b.NewObject( b.separatorGadget,
                        b.sepHoriz,     e.true,
                        b.sepTitle,     t,
                        b.sepHighlight, e.true,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END HTitleSeparator;

PROCEDURE CTitleSeparator * ( t : e.LSTRPTR ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.separatorGadget,
                        b.sepHoriz,       e.true,
                        b.sepTitle,       t,
                        b.sepCenterTitle, e.true,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END CTitleSeparator;

PROCEDURE CHTitleSeparator * ( t : e.LSTRPTR ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.separatorGadget,
                        b.sepHoriz,       e.true,
                        b.sepTitle,        t,
                        b.sepHighlight,   e.true,
                        b.sepCenterTitle, e.true,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END CHTitleSeparator;

PROCEDURE TitleSeparatorLeft * ( t : e.LSTRPTR ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.separatorGadget,
                        b.sepHoriz,     e.true,
                        b.sepTitle,     t,
                        b.sepTitleLeft, e.true,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END TitleSeparatorLeft;

PROCEDURE HTitleSeparatorLeft * ( t : e.LSTRPTR ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.separatorGadget,
                        b.sepHoriz,     e.true,
                        b.sepTitle,     t,
                        b.sepHighlight, e.true,
                        b.sepTitleLeft, e.true,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END HTitleSeparatorLeft;

PROCEDURE CTitleSeparatorLeft * ( t : e.LSTRPTR ) : b.Object;
  BEGIN
    RETURN b.NewObject( b.separatorGadget,
                        b.sepHoriz,       e.true,
                        b.sepTitle,       t,
                        b.sepCenterTitle, e.true,
                        b.sepTitleLeft,   e.true,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END CTitleSeparatorLeft;

PROCEDURE CHTitleSeparatorLeft * ( t : e.LSTRPTR ) : b.Object;
  (* $CopyArrays- *)
  BEGIN
    RETURN b.NewObject( b.separatorGadget,
                        b.sepHoriz,       e.true,
                        b.sepTitle,       t,
                        b.sepHighlight,   e.true,
                        b.sepCenterTitle, e.true,
                        b.sepTitleLeft,   e.true,
                        u.done );
           (* FixMinHeight
           b.lgoFixMinHeight, e.true;
           *)
  END CHTitleSeparatorLeft;

(***
(* Typos *);

#define VertSeperator           VertSeparator
#define VertThinSeperator       VertThinSeparator
#define HorizSeperator          HorizSeparator
#define TitleSeperator          TitleSeparator
#define HTitleSeperator         HTitleSeparator
#define CTitleSeperator         CTitleSeparator
#define CHTitleSeperator        CHTitleSeparator

(*****************************************************************************
**
**      Some simple menu macros.
*)

#define Title * (t)\
        { b.nmTitle, t, NIL, 0, 0, NIL }
#define Item(t,s,i)\
        { b.nmItem, t, s, 0, 0, (APTR)i }
#define ItemBar\
        { b.nmItem, b.nmBarlabel, NIL, 0, 0, NIL }
#define SubItem(t,s,i)\
        { b.nmSub, t, s, 0, 0, (APTR)i }
#define SubBar\
        { b.nmSub, b.nmBarlabel, NIL, 0, 0, NIL }
#define End\
        { b.nmEnd, NIL, NIL, 0, 0, NIL }
****)
(*****************************************************************************
**
**      Base class method macros.
*)

PROCEDURE AddMap  * {"BguiMacro.AddMapA"}( object, target : b.Object; map : e.APTR );
PROCEDURE AddMapA *                      ( object, target : b.Object; map : e.APTR ) : LONGINT;
  BEGIN
    RETURN  b.DOMethod( object, b.baseAddMap, target, map )
  END AddMapA;

PROCEDURE AddCondit  * {"BguiMacro.AddConditA"}( object, target : b.Object;
                                                 ttag, tdat,
                                                 ftag, fdat,
                                                 stag, sdat     : LONGINT  );
PROCEDURE AddConditA *                         ( object, target : b.Object;
                                                 ttag, tdat,
                                                 ftag, fdat,
                                                 stag, sdat     : LONGINT  ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( object, b.baseAddConditional, target, ttag, tdat, ftag, fdat, stag, sdat );
  END AddConditA;

PROCEDURE AddHook  * {"BguiMacro.AddHookA"}( object : b.Object; hook : u.HookPtr );
PROCEDURE AddHookA *                       ( object : b.Object; hook : u.HookPtr ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( object, b.baseAddHook,  hook );
  END AddHookA;

PROCEDURE RemMap  * {"BguiMacro.RemMapA"}( object, target : b.Object );
PROCEDURE RemMapA *                      ( object, target : b.Object ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( object, b.baseRemMap, target );
  END RemMapA;

PROCEDURE RemCond  * {"BguiMacro.RemCondA"}( object, target : b.Object );
PROCEDURE RemCondA *                       ( object, target : b.Object ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( object, b.baseRemConditional, target );
  END RemCondA;

PROCEDURE RemHook  * {"BguiMacro.RemHookA"}( object : b.Object; hook : u.HookPtr );
PROCEDURE RemHookA *                       ( object : b.Object; hook : u.HookPtr ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( object, b.baseRemHook, hook );
  END RemHookA;


(*****************************************************************************
**
**      Listview class method macros.
*)

PROCEDURE AddEntry * {"BguiMacro.AddEntryA"}( window : i.WindowPtr; object : b.Object; entry: e.APTR; how : LONGINT );
PROCEDURE AddEntryA *  ( window : i.WindowPtr; object : b.Object; entry: e.APTR; how : LONGINT ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmAddSingle, NIL, entry, how, LONGSET{});
  END AddEntryA;

PROCEDURE AddEntryVisible * {"BguiMacro.AddEntryVisibleA"}( window : i.WindowPtr; object : b.Object; entry: e.APTR; how : LONGINT );
PROCEDURE AddEntryVisibleA *  ( window : i.WindowPtr; object : b.Object; entry: e.APTR; how : LONGINT ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmAddSingle,
                             NIL, entry, how, LONGSET{b.lvasfMakeVisible} );
  END AddEntryVisibleA;

PROCEDURE AddEntrySelect * {"BguiMacro.AddEntrySelectA"}( window : i.WindowPtr; object : b.Object; entry: e.APTR; how : LONGINT );
PROCEDURE AddEntrySelectA * ( window : i.WindowPtr; object : b.Object; entry: e.APTR; how : LONGINT ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmAddSingle,
                             NIL, entry, how, LONGSET{b.lvasfSelect} );
  END AddEntrySelectA;

PROCEDURE InsertEntry * {"BguiMacro.InsertEntryA"}( window : i.WindowPtr; object : b.Object; entry: e.APTR; where : LONGINT );
PROCEDURE InsertEntryA * ( window : i.WindowPtr; object : b.Object; entry: e.APTR; where : LONGINT ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmInsertSingle,
                             NIL, where, entry, LONGSET{});
  END InsertEntryA;

PROCEDURE InsertEntryVisible * {"BguiMacro.InsertEntryVisibleA"}( window : i.WindowPtr; object : b.Object; entry: e.APTR; where : LONGINT );
PROCEDURE InsertEntryVisibleA * ( window : i.WindowPtr; object : b.Object; entry: e.APTR; where : LONGINT ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmInsertSingle,
                             NIL, where, entry, LONGSET{b.lvasfMakeVisible} );
  END InsertEntryVisibleA;

PROCEDURE InsertEntrySelect * {"BguiMacro.InsertEntrySelectA"}( window : i.WindowPtr; object : b.Object; entry: e.APTR; where : LONGINT );
PROCEDURE InsertEntrySelectA * ( window : i.WindowPtr; object : b.Object; entry: e.APTR; where : LONGINT ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmInsertSingle,
                             NIL, where, entry, LONGSET{b.lvasfSelect} );
  END InsertEntrySelectA;

PROCEDURE ClearList * {"BguiMacro.ClearListA"}( window : i.WindowPtr; object : b.Object );
PROCEDURE ClearListA * ( window : i.WindowPtr; object : b.Object ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmClear, NIL );
  END ClearListA;

PROCEDURE FirstEntry * ( object : b.Object ) : e.APTR;
  BEGIN
    RETURN b.DOMethod( object, b.lvmFirstEntry, NIL, NIL );
  END FirstEntry;

PROCEDURE FirstSelected * ( object : b.Object ) : e.APTR;
  BEGIN
    RETURN b.DOMethod( object, b.lvmFirstEntry, NIL, LONGSET{b.lvgefSelected});
  END FirstSelected;

PROCEDURE LastEntry * ( object : b.Object ) : e.APTR;
  BEGIN
    RETURN b.DOMethod( object, b.lvmLastEntry, NIL, NIL )
  END LastEntry;

PROCEDURE LastSelected * ( object : b.Object ) : e.APTR;
  BEGIN
    RETURN b.DOMethod( object, b.lvmLastEntry, NIL, LONGSET{b.lvgefSelected})
  END LastSelected;

PROCEDURE NextEntry * ( object : b.Object; last : e.APTR ) : e.APTR;
  BEGIN
    RETURN b.DOMethod( object, b.lvmNextEntry, last, 0 )
  END NextEntry;

PROCEDURE NextSelected * ( object : b.Object; last : e.APTR ) : e.APTR;
  BEGIN
    RETURN b.DOMethod( object, b.lvmNextEntry, last, LONGSET{b.lvgefSelected})
  END NextSelected;

PROCEDURE PrevEntry * ( object : b.Object; last : e.APTR ) : e.APTR;
  BEGIN
    RETURN b.DOMethod( object, b.lvmPrevEntry, last, 0 )
  END PrevEntry;

PROCEDURE PrevSelected * ( object : b.Object; last : LONGINT ) : e.APTR;
  BEGIN
    RETURN b.DOMethod( object, b.lvmPrevEntry, last, LONGSET{b.lvgefSelected})
  END PrevSelected;

PROCEDURE RemoveEntry * {"BguiMacro.RemoveEntryA"}( object : b.Object; entry : e.APTR );
PROCEDURE RemoveEntryA * ( object : b.Object; entry : e.APTR ) : e.APTR;
  BEGIN
    RETURN b.DOMethod( object, b.lvmRemEntry, NIL, entry )
  END RemoveEntryA;

PROCEDURE RemoveEntryVisible * {"BguiMacro.RemoveEntryVisibleA"}( window : i.WindowPtr; object : b.Object; entry : e.APTR );
PROCEDURE RemoveEntryVisibleA * ( window : i.WindowPtr; object : b.Object; entry : e.APTR ) : LONGINT;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmRemEntry, NIL, entry )
  END RemoveEntryVisibleA;

PROCEDURE RefreshList * {"BguiMacro.RefreshListA"}( window : i.WindowPtr; object : b.Object );
PROCEDURE RefreshListA * ( window : i.WindowPtr; object : b.Object ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmRefresh, NIL )
  END RefreshListA;

PROCEDURE RedrawList * {"BguiMacro.RedrawListA"}( window : i.WindowPtr; object : b.Object );
PROCEDURE RedrawListA * ( window : i.WindowPtr; object : b.Object ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmRedraw, NIL )
  END RedrawListA;

PROCEDURE SortList * {"BguiMacro.SortListA"}( window : i.WindowPtr; object : b.Object );
PROCEDURE SortListA * ( window : i.WindowPtr; object : b.Object ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmSort, NIL )
  END SortListA;

PROCEDURE LockList * {"BguiMacro.LockListA"}( object : b.Object );
PROCEDURE LockListA * ( object : b.Object ) : e.APTR;
  BEGIN
    RETURN b.DOMethod( object, b.lvmLockList, NIL )
  END LockListA;

PROCEDURE UnlockList * {"BguiMacro.UnlockListA"}( window : i.WindowPtr; object : b.Object );
PROCEDURE UnlockListA * ( window : i.WindowPtr; object : b.Object ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmUnlockList, NIL )
  END UnlockListA;

PROCEDURE MoveEntry * {"BguiMacro.MoveEntryA"}( window : i.WindowPtr; object : b.Object; entry, dir : e.APTR );
PROCEDURE MoveEntryA * ( window : i.WindowPtr; object : b.Object; entry, dir : e.APTR ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmMove, NIL, entry, dir )
  END MoveEntryA;

PROCEDURE MoveSelectedEntry * {"BguiMacro.MoveSelectedEntryA"}( window : i.WindowPtr; object : b.Object; dir : e.APTR );
PROCEDURE MoveSelectedEntryA * ( window : i.WindowPtr; object : b.Object; dir : e.APTR ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmMove, NIL, NIL, dir )
  END MoveSelectedEntryA;

PROCEDURE ReplaceEntry * {"BguiMacro.ReplaceEntryA"}( window : i.WindowPtr; object : b.Object; old, new : e.APTR );
PROCEDURE ReplaceEntryA * ( window : i.WindowPtr; object : b.Object; old, new : e.APTR ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmReplace, NIL, old, new )
  END ReplaceEntryA;

PROCEDURE RemoveSelected * {"BguiMacro.RemoveSelectedA"}( window : i.WindowPtr; object : b.Object );
PROCEDURE RemoveSelectedA * ( window : i.WindowPtr; object : b.Object ) : e.APTR;
  BEGIN
    RETURN b.DoGadgetMethod( object, window, NIL, b.lvmRemSelected, NIL )
  END RemoveSelectedA;


(*****************************************************************************
**
**      Window class method macros.
*)

PROCEDURE GadgetKey  * {"BguiMacro.GadgetKeyA"}( wobj : b.Object; gobj : b.Object; key : e.STRPTR );
PROCEDURE GadgetKeyA *                         ( wobj : b.Object; gobj : b.Object; key : e.STRPTR ): LONGINT;
  BEGIN
    RETURN b.DOMethod( wobj, b.wmGadgetKey, NIL, gobj, key );
  END GadgetKeyA;

PROCEDURE WindowOpen * ( wobj : b.Object ) : i.WindowPtr;
  BEGIN
    RETURN y.VAL( i.WindowPtr, b.DOMethod( wobj, b.wmOpen ));
  END WindowOpen;

PROCEDURE WindowClose  * {"BguiMacro.WindowCloseA"}( wobj : b.Object );
PROCEDURE WindowCloseA *                           ( wobj : b.Object ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( wobj, b.wmClose );
  END WindowCloseA;

PROCEDURE WindowBusy  * {"BguiMacro.WindowBusyA"}( wobj : b.Object );
PROCEDURE WindowBusyA *                          ( wobj : b.Object ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( wobj, b.wmSleep );
  END WindowBusyA;

PROCEDURE WindowReady  * {"BguiMacro.WindowReadyA"}( wobj : b.Object );
PROCEDURE WindowReadyA *                           ( wobj : b.Object ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( wobj, b.wmWakeup );
  END WindowReadyA;

PROCEDURE HandleEvent * ( wobj : b.Object ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( wobj, b.wmHandleIDCMP );
  END HandleEvent;

PROCEDURE DisableMenu  * {"BguiMacro.DisableMenuA"}( wobj : b.Object; id, set : LONGINT );
PROCEDURE DisableMenuA *                           ( wobj : b.Object; id, set : LONGINT ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( wobj, b.wmDisableMenu, id, set )
  END DisableMenuA;

PROCEDURE CheckItem  * {"BguiMacro.CheckItemA"}( wobj : b.Object; id, set : LONGINT );
PROCEDURE CheckItemA *                         ( wobj : b.Object; id, set : LONGINT ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( wobj, b.wmCheckItem, id, set )
  END CheckItemA;

PROCEDURE MenuDisabled  * {"BguiMacro.MenuDisabledA"}( wobj : b.Object; id : LONGINT );
PROCEDURE MenuDisabledA *                            ( wobj : b.Object; id : LONGINT ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( wobj, b.wmMenuDisabled, id )
  END MenuDisabledA;

PROCEDURE ItemChecked  * {"BguiMacro.ItemCheckedA"}( wobj : b.Object; id : LONGINT );
PROCEDURE ItemCheckedA *                           ( wobj : b.Object; id : LONGINT ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( wobj, b.wmItemChecked, id )
  END ItemCheckedA;

PROCEDURE GetAppMsg * ( wobj : b.Object) : w.AppMessagePtr;
  BEGIN
    RETURN y.VAL( w.AppMessagePtr, b.DOMethod( wobj, b.wmGetAppMsg ));
  END GetAppMsg;

PROCEDURE AddUpdate  * {"BguiMacro.AddUpdateA"}( wobj : b.Object; id: LONGINT; target, map : e.APTR );
PROCEDURE AddUpdateA *                         ( wobj : b.Object; id: LONGINT; target, map : e.APTR ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( wobj, b.wmAddUpdate, id, target, map )
  END AddUpdateA;

PROCEDURE GetSignalWindow * ( wobj : b.Object ) : i.WindowPtr;
  BEGIN
    RETURN y.VAL( i.WindowPtr, b.DOMethod( wobj, b.wmGetSignalWindow ));
  END GetSignalWindow;


(*****************************************************************************
**
**      Commodity class method macros.
*)

PROCEDURE AddHotkey * {"BguiMacro.AddHotkeyA"}( broker : b.Object;
                                                  desc : e.LSTRPTR;
                                                    id : LONGINT;
                                                 flags : LONGSET   );
PROCEDURE AddHotkeyA *                        ( broker : b.Object;
                                                  desc : e.LSTRPTR;
                                                    id : LONGINT;
                                                 flags : LONGSET   ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( broker, b.cmAddHotKey, desc, id, flags );
  END AddHotkeyA;

PROCEDURE  RemHotkey  * {"BguiMacro.RemHotkeyA"}( broker : b.Object; id : LONGINT );
PROCEDURE  RemHotkeyA *                         ( broker : b.Object; id : LONGINT ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( broker, b.cmRemHotKey, id );
  END RemHotkeyA;

PROCEDURE  DisableHotkey  * {"BguiMacro.DisableHotkeyA"}( broker : b.Object; id : LONGINT );
PROCEDURE  DisableHotkeyA *                             ( broker : b.Object; id : LONGINT ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( broker, b.cmDisableHotKey, id );
  END DisableHotkeyA;

PROCEDURE  EnableHotKey  * {"BguiMacro.EnableHotKeyA"}( broker : b.Object; id : LONGINT );
PROCEDURE  EnableHotKeyA *                            ( broker : b.Object; id : LONGINT ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( broker, b.cmEnableHotKey, id );
  END EnableHotKeyA;

PROCEDURE  EnableBroker  * {"BguiMacro.EnableBrokerA"}( broker : b.Object );
PROCEDURE  EnableBrokerA *                            ( broker : b.Object ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( broker, b.cmEnableBroker );
  END EnableBrokerA;

PROCEDURE  DisableBroker  * {"BguiMacro.DisableBrokerA"}( broker : b.Object );
PROCEDURE  DisableBrokerA *                             ( broker : b.Object ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( broker, b.cmDisableBroker );
  END DisableBrokerA;

PROCEDURE  MsgInfo  * {"BguiMacro.MsgInfoA"}( broker : b.Object;   (** Note: type and id are **)
                                              type,                (** pointes to LONGINT    **)
                                              id     : e.APTR;
                                              data   : e.APTR   );
PROCEDURE  MsgInfoA *                       ( broker : b.Object;
                                              type,
                                              id     : e.APTR;
                                              data   : e.APTR   ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( broker, b.cmMsgInfo, type, id, data );
  END MsgInfoA;


(*****************************************************************************
**
**      AslReq class method macros.
*)

PROCEDURE DoRequest*{"BguiMacro.DORequestA"}( object : b.Object );
PROCEDURE DORequestA*( object : b.Object ) : LONGINT;
  BEGIN
    RETURN b.DOMethod( object, b.aslmDoRequest );
  END DORequestA;

END BguiMacro.
