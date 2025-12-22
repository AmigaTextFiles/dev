IMPLEMENTATION MODULE MuiMacros;

(*$ NilChk-  EntryClear-  Align- *)
(*$ SET Locale *)
(*$ CLEAR MUIOBSOLETE *)
(*$ SET MUI3  *)

(****************************************************************************
**
** $VER: MuiMacros.mod 3.8 (29.1.97)
**
** The following updates have been done by
**
**   Olaf "Olf" Peters <olf@informatik.uni-bremen.de>
**
** $HISTORY:
**
**  29.1.97  3.7   : updated for MUI 3.7 release
**  13.8.96  3.6   : updated for MUI 3.6 release
**  21.2.96  3.3   : updated for MUI 3.3 release
**  23.1.96  3.2   : updated for MUI 3.2 release
** 18.11.95  3.1   : updated for MUI 3.1 release
**  17.9.95  2.3   : updated to MUI 2.3
**
****************************************************************************)

(****************************************************************************
**
**      MUI Macros 2.0
**
**      Converted to Modula by Christian "Kochtopf" Scholz
**
**      $Id: MuiMacros.mod,v 1.10 1996/08/14 23:23:49 olf Exp olf $
**
**/// "$Log: MuiMacros.mod,v $
 * Revision 1.10  1996/08/14  23:23:49  olf
 * bumped to MUI 3.6
 *
 * Revision 1.9  1996/08/14  01:39:07  olf
 * MUI 3.5
 *
 * Revision 1.8  1996/02/21  17:43:01  olf
 * MUI 3.3 release
 *
 * Revision 1.7  1996/02/07  10:00:28  olf
 * · when using MUIOBSOLETE=TRUE in MuiMacros, the TagBuffer was too small.
 *     Fixed. (Marc Ewert)
 *
 * Revision 1.6  1996/01/25  20:24:36  olf
 * revised for MUI 3.2
 *
 * Revision 1.5  1995/12/15  16:37:53  olf
 * - applied changes from Stefan Schulz
 * - cleanup of IMPORT section
 *"
# Revision 1.4  1995/12/04  17:30:31  olf
# MUI-Interfaces 3.1.1
#
# Revision 1.3  1995/11/18  16:46:18  olf
# MUI Release 3.1
#
# Revision 1.2  1995/10/23  17:06:34  olf
# *** empty log message ***
#
# Revision 1.1  1995/09/25  15:32:52  olf
# Initial revision
#
# Revision 1.8  1994/08/18  18:59:25  Kochtopf
# changed img-argument in PopButton from ARRAY to APTR.
# changed implementation of SimpleButton for -MUIOBSOLETE
#
# Revision 1.7  1994/08/11  16:59:45  Kochtopf
# *** empty log message ***
#
# Revision 1.6  1994/06/27  22:06:41  Kochtopf
# put some Macros in MUIOBSOLETE-Parenthesis, because one should
# now use mMakeObj.
#
# Revision 1.5  1994/02/15  21:14:05  Kochtopf
# neue Macros fuer Pop* und Register definiert,
# HCenter und VCenter neu
# PopUp entfernt und durch PopButton ersetzt.
# neue Label-Macros LLabel eingefuehrt (aus mui.h)
#
# Revision 1.4  1994/02/09  14:50:03  Kochtopf
# Versionsnummer in 2.0 geaendert.
#
**\\\
****************************************************************************)

FROM SYSTEM     IMPORT ADDRESS, ADR, TAG, CAST, SETREG, REG;
FROM MuiD       IMPORT APTR, StrPtr ;
FROM MuiSupport IMPORT DoMethod;
FROM Storage    IMPORT ALLOCATE;

IMPORT
  ed : ExecD,
  id : IntuitionD,
  il : IntuitionL,
  m  : MuiD,
  ml : MuiL,
  R  : Reg,
  ud : UtilityD ;

VAR

(*$ IF MUIOBSOLETE *)
  buffer  : ARRAY [0..18] OF LONGINT;      (* for the tags *)
(*$ ELSE *)
  buffer  : ARRAY [0..10]  OF LONGINT;      (* for the tags *)
(*$ ENDIF *)

(*///  "MUI-Object-Generation" *)
(*
**
**  MUI - Object Generation
**
*)

PROCEDURE WindowObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcWindow), tags);
    END WindowObject;

PROCEDURE ImageObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcImage), tags);
    END ImageObject;

PROCEDURE BitmapObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcBitmap), tags);
    END BitmapObject;

PROCEDURE BodychunkObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcBodychunk), tags);
    END BodychunkObject;

PROCEDURE ApplicationObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcApplication), tags);
    END ApplicationObject;

PROCEDURE NotifyObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcNotify), tags);
    END NotifyObject;

PROCEDURE TextObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcText), tags);
    END TextObject;

PROCEDURE RectangleObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcRectangle), tags);
    END RectangleObject;

PROCEDURE ListObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcList), tags);
    END ListObject;

PROCEDURE PropObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcProp), tags);
    END PropObject;

PROCEDURE StringObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcString), tags);
    END StringObject;

PROCEDURE ScrollbarObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcScrollbar), tags);
    END ScrollbarObject;

PROCEDURE ListviewObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcListview), tags);
    END ListviewObject;

PROCEDURE RadioObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcRadio), tags);
    END RadioObject;

PROCEDURE VolumelistObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcVolumelist), tags);
    END VolumelistObject;

PROCEDURE FloattextObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcFloattext), tags);
    END FloattextObject;

PROCEDURE DirlistObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcDirlist), tags);
    END DirlistObject;

PROCEDURE ScrmodelistObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcScrmodelist), tags);
    END ScrmodelistObject;

PROCEDURE SliderObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcSlider), tags);
    END SliderObject;

PROCEDURE CycleObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcCycle), tags);
    END CycleObject;

PROCEDURE GaugeObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcGauge), tags);
    END GaugeObject;

PROCEDURE BoopsiObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcBoopsi), tags);
    END BoopsiObject;

PROCEDURE ScaleObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcScale), tags);
    END ScaleObject;

PROCEDURE GroupObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcGroup), tags);
    END GroupObject;

PROCEDURE VGroup(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcGroup), tags);
    END VGroup;

PROCEDURE HGroup(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcGroup), TAG(buffer, m.maGroupHoriz, ed.LTRUE, ud.tagMore, tags, ud.tagEnd));
    END HGroup;

PROCEDURE ColGroup(cols : LONGCARD; tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcGroup), TAG(buffer, m.maGroupColumns, cols, ud.tagMore, tags, ud.tagEnd));
    END ColGroup;

PROCEDURE RowGroup(rows : LONGCARD; tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcGroup), TAG(buffer, m.maGroupRows, rows, ud.tagMore, tags, ud.tagEnd));
    END RowGroup;

PROCEDURE PageGroup(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcGroup),TAG(buffer, m.maGroupPageMode, ed.LTRUE, ud.tagMore, tags, ud.tagEnd));
    END PageGroup;

PROCEDURE ColorfieldObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcColorfield), tags);
    END ColorfieldObject;

PROCEDURE ColoradjustObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcColoradjust), tags);
    END ColoradjustObject;

PROCEDURE PaletteObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcPalette), tags);
    END PaletteObject;

PROCEDURE VirtgroupObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcVirtgroup), tags);
    END VirtgroupObject;

PROCEDURE ScrollgroupObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcScrollgroup), tags);
    END ScrollgroupObject;

PROCEDURE VGroupV(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcVirtgroup), tags);
    END VGroupV;

PROCEDURE HGroupV(tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcVirtgroup), TAG(buffer, m.maGroupHoriz, ed.LTRUE, ud.tagMore, tags, ud.tagEnd));
    END HGroupV;

PROCEDURE ColGroupV(cols : LONGCARD; tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcVirtgroup), TAG(buffer, m.maGroupColumns, cols, ud.tagMore, tags, ud.tagEnd));
    END ColGroupV;

PROCEDURE RowGroupV(rows : LONGCARD; tags : ud.TagItemPtr) : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcVirtgroup), TAG(buffer, m.maGroupRows, rows, ud.tagMore, tags, ud.tagEnd));
    END RowGroupV;

PROCEDURE PageGroupV(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcVirtgroup),TAG(buffer, m.maGroupPageMode, ed.LTRUE, ud.tagMore, tags, ud.tagEnd));
    END PageGroupV;

PROCEDURE PopString(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcPopstring), tags);
    END PopString;

PROCEDURE PopObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcPopobject), tags);
    END PopObject;

PROCEDURE PopAsl(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcPopasl), tags);
    END PopAsl;

(*$ IF MUI3 *)

PROCEDURE PendisplayObject(tags : ud.TagItemPtr) : APTR ;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcPendisplay), tags) ;
    END PendisplayObject ;

PROCEDURE PoppenObject(tags : ud.TagItemPtr) : APTR ;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcPoppen), tags);
    END PoppenObject ;

(*$ ENDIF *)

PROCEDURE Register(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcRegister), tags);
    END Register;

PROCEDURE MenuStripObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcMenustrip), tags);
    END MenuStripObject;

PROCEDURE MenuObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcMenu), tags);
    END MenuObject;

(*$ IF Locale *)
PROCEDURE MenuObjectT(name : StrPtr; tags : ud.TagItemPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE MenuObjectT(name : ARRAY OF CHAR; tags : ud.TagItemPtr) : APTR;
(*$ ENDIF *)
    BEGIN
         (*$ IF Locale *)
         RETURN ml.mNewObject(ADR(m.mcMenu), TAG(buffer, m.maMenuTitle, name, ud.tagMore, tags, ud.tagEnd));
         (*$ ELSE *)
         RETURN ml.mNewObject(ADR(m.mcMenu), TAG(buffer, m.maMenuTitle, ADR(name), ud.tagMore, tags, ud.tagEnd));
         (*$ ENDIF *)
    END MenuObjectT;

PROCEDURE MenuItemObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcMenuitem), tags);
    END MenuItemObject;


(*$ IF MUI3 *)

PROCEDURE AboutmuiObject(tags : ud.TagItemPtr) : APTR;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcAboutmui), tags);
    END AboutmuiObject;

PROCEDURE BalanceObject(tags : ud.TagItemPtr) : APTR ;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcBalance), tags);
    END BalanceObject;

PROCEDURE KnobObject(tags : ud.TagItemPtr) : APTR ;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcKnob), tags);
    END KnobObject;

PROCEDURE LevelmeterObject(tags : ud.TagItemPtr) : APTR ;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcLevelmeter), tags);
    END LevelmeterObject;

PROCEDURE NumericbuttonObject(tags : ud.TagItemPtr) : APTR ;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcNumericbutton), tags);
    END NumericbuttonObject;

PROCEDURE NumericObject(tags : ud.TagItemPtr) : APTR ;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcNumeric), tags);
    END NumericObject;

PROCEDURE PenadjustObject(tags : ud.TagItemPtr) : APTR ;
    BEGIN
         RETURN ml.mNewObject(ADR(m.mcPenadjust), tags);
    END PenadjustObject;

(*$ ENDIF *)


(*\\\*)
(*///  "MakeID" *)
(*
**  MakeID
**  Generate an ID out of a 4-char-string.
**  Use it the as WindowID ! (look in MuiTest for an example!)
*)

PROCEDURE MakeID (name : ShortString): LONGINT;

    BEGIN
        RETURN ORD(name[0])+
               ORD(name[1])*256+
               ORD(name[2])*65536+
               ORD(name[3])*16777216;
    END MakeID;
(*\\\*)
(*///  "Hook-Support" *)
(*
**  Hook-Support functions
**  1. the dispatcher
**  2. the MakeHook-Function
**
*)

PROCEDURE HookEntry(hook{R.A0}  : ud.HookPtr;
                    object{R.A2}: ADDRESS;
                    args{R.A1}  : ADDRESS)     : ADDRESS;
    (*$SaveA4+*)
    BEGIN
        SETREG (R.A4, hook^.data);
        RETURN CAST(HookDef,hook^.subEntry)(hook, object, args);
    END HookEntry;

PROCEDURE MakeHook(entry:HookDef; VAR hook : ud.HookPtr);

    BEGIN
            ALLOCATE(hook,SIZE(ud.Hook));
            hook^.node.succ  := NIL;
            hook^.node.pred  := NIL;
            hook^.entry      := HookEntry;
            hook^.subEntry   := CAST(ADDRESS,entry);
            hook^.data       := REG(R.A4);
    END MakeHook;
(*\\\*)
(*///  "Spacing-Macros" *)
(*
**
**  Spacing Macros
**
*)
(*///  "HV-Space" *)
PROCEDURE HVSpace() : APTR;
    BEGIN
        RETURN ml.mNewObject(ADR(m.mcRectangle), NIL);
    END HVSpace;
(*\\\*)
(*///  "Hspace" *)
PROCEDURE HSpace(x : LONGCARD) : APTR;
    BEGIN
        IF x#0 THEN
                RETURN ml.mNewObject(ADR(m.mcRectangle),
                                     TAG(buffer,
                                        m.maFixWidth,     x,
                                        m.maVertWeight,   0,
                                        ud.tagEnd));
                ELSE
                RETURN ml.mNewObject(ADR(m.mcRectangle),
                                     TAG(buffer,
                                        m.maVertWeight,   0,
                                        ud.tagEnd));
                END;
    END HSpace;
(*\\\*)
(*///  "VSpace" *)
PROCEDURE VSpace(x : LONGCARD) : APTR;
    BEGIN
        IF x#0 THEN
                RETURN ml.mNewObject(ADR(m.mcRectangle),
                                     TAG(buffer,
                                        m.maFixHeight,     x,
                                        m.maHorizWeight,   0,
                                        ud.tagEnd));
                ELSE
                RETURN ml.mNewObject(ADR(m.mcRectangle),
                                     TAG(buffer,
                                        m.maHorizWeight,   0,
                                        ud.tagEnd));
                END;
    END VSpace;
(*\\\*)
(*///  "HCenter" *)
PROCEDURE HCenter(obj : APTR) : APTR;
    BEGIN
        RETURN HGroup(TAG(buffer,
                    m.maGroupSpacing,      0,
                    Child,                  HSpace(0),
                    Child,                  obj,
                    Child,                  HSpace(0),
                    ud.tagEnd));
    END HCenter;
(*\\\*)
(*///  "VCenter" *)
PROCEDURE VCenter(obj : APTR) : APTR;
    BEGIN
        RETURN VGroup(TAG(buffer,
                    m.maGroupSpacing,      0,
                    Child,                  VSpace(0),
                    Child,                  obj,
                    Child,                  VSpace(0),
                    ud.tagEnd));
    END VCenter;
(*\\\*)
(*\\\*)
(*///  "PopButton" *)
(*
**
**  PopUp-Button
**
**  to be used for Popup-Objects
**
*)

PROCEDURE PopButton(img : APTR) : APTR;
    BEGIN
        RETURN ml.MakeObject(m.moPopButton, TAG(buffer, img));
    END PopButton;
(*\\\*)

(*$ IF MUIOBSOLETE *)

(*
**
** String-Object
**
** Makes a simple String-Gadget
**
*)

(*///  "StringObjects" *)
(*$ IF Locale *)
PROCEDURE String(contents : StrPtr; maxlen : LONGINT) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE String(contents : ARRAY OF CHAR; maxlen : LONGINT) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN StringObject(TAG(buffer,
                            m.maFrame,            m.mvFrameString,
                            m.maStringMaxLen,     maxlen,
                            (*$ IF Locale *)
                                m.maStringContents,   contents,
                            (*$ ELSE *)
                                m.maStringContents,   ADR(contents),
                            (*$ ENDIF *)
                            ud.tagEnd));
    END String;
(*$ IF Locale *)
PROCEDURE KeyString(contents : StrPtr; maxlen : LONGINT; key : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE KeyString(contents : ARRAY OF CHAR; maxlen : LONGINT; key : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN StringObject(TAG(buffer,
                            m.maFrame,             m.mvFrameString,
                            m.maStringMaxLen,      maxlen,
                            (*$ IF Locale *)
                                m.maStringContents,    contents,
                            (*$ ELSE *)
                                m.maStringContents,    ADR(contents),
                            (*$ ENDIF *)
                            m.maControlChar,       key,
                            ud.tagEnd));
    END KeyString;
(*\\\*)

(*
**
** Checkmark
**
*)

(*///  "Checkmarks" *)
PROCEDURE Checkmark(selected : BOOLEAN) : APTR;
    BEGIN
        RETURN ImageObject( TAG(buffer,
                            m.maFrame,            m.mvFrameImageButton,
                            m.maInputMode,        m.mvInputModeToggle,
                            m.maImageSpec,        m.miCheckMark,
                            m.maImageFreeVert,    ed.LTRUE,
                            m.maSelected,         selected,
                            m.maBackground,       m.miButtonBack,
                            m.maShowSelState,     ed.LFALSE,
                            ud.tagEnd));
    END Checkmark;

PROCEDURE KeyCheckmark(selected : BOOLEAN; key : CHAR) : APTR;
    BEGIN
        RETURN ImageObject( TAG(buffer,
                            m.maFrame,            m.mvFrameImageButton,
                            m.maInputMode,        m.mvInputModeToggle,
                            m.maImageSpec,        m.miCheckMark,
                            m.maImageFreeVert,    ed.LTRUE,
                            m.maSelected,         selected,
                            m.maBackground,       m.miButtonBack,
                            m.maShowSelState,     ed.LFALSE,
                            m.maControlChar,      key,
                            ud.tagEnd));
    END KeyCheckmark;

(*\\\*)

(*
**
** Buttons
**
*)

(*///  "Buttons" *)

(*$ IF Locale *)
PROCEDURE Keybutton(name : StrPtr; key : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE Keybutton(name : ARRAY OF CHAR; key : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            m.maFrame,            m.mvFrameButton,
                            (*$ IF Locale *)
                                m.maTextContents,     name,
                            (*$ ELSE *)
                                m.maTextContents,     ADR(name),
                            (*$ ENDIF *)
                            m.maFont,             m.mvFontButton,
                            m.maTextPreParse,     ADR("\033c"),
                            m.maTextSetMax,       FALSE,
                            m.maTextHiChar,       key,
                            m.maControlChar,      key,
                            m.maInputMode,        m.mvInputModeRelVerify,
                            m.maBackground,       m.miButtonBack,
                            ud.tagEnd));

    END Keybutton;

(*\\\*)

(*
**
**  Radio Object
**
*)

(*///  "RadioObjects" *)
(*$ IF Locale *)
PROCEDURE Radio(name : StrPtr; array : APTR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE Radio(name : ARRAY OF CHAR; array : APTR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN RadioObject( TAG(buffer,
                            m.maFrame,             m.mvFrameGroup,
                            (*$ IF Locale *)
                                m.maFrameTitle,        name,
                            (*$ ELSE *)
                                m.maFrameTitle,        ADR(name),
                            (*$ ENDIF *)
                            m.maRadioEntries,      array,
                            ud.tagEnd));
    END Radio;

(*$ IF Locale *)
PROCEDURE KeyRadio(name : StrPtr; array : APTR; key : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE KeyRadio(name : ARRAY OF CHAR; array : APTR; key : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN RadioObject( TAG(buffer,
                            m.maFrame,             m.mvFrameGroup,
                            (*$ IF Locale *)
                                m.maFrameTitle,        name,
                            (*$ ELSE *)
                                m.maFrameTitle,        ADR(name),
                            (*$ ENDIF *)
                            m.maTextHiChar,        key,
                            m.maControlChar,       key,
                            m.maRadioEntries,      array,
                            ud.tagEnd));
    END KeyRadio;

(*\\\*)

(*
**
**  Cycle-Objects
**
*)

(*///  "Cycle" *)
PROCEDURE Cycle(array : APTR) : APTR;
    BEGIN
        RETURN CycleObject(TAG(buffer,
                            m.maCycleEntries,      array,
                            m.maFont,              m.mvFontButton,
                            ud.tagEnd));
    END Cycle;


PROCEDURE KeyCycle(array : APTR; key : CHAR) : APTR;
    BEGIN
        RETURN CycleObject(TAG(buffer,
                            m.maCycleEntries,      array,
                            m.maControlChar,       key,
                            m.maFont,              m.mvFontButton,
                            ud.tagEnd));
    END KeyCycle;
(*\\\*)

(*
**
**  Slider-Objects
**
*)

(*///  "Slider" *)
PROCEDURE Slider(min,max,level : LONGINT; horiz : BOOLEAN) : APTR;
    BEGIN
        RETURN SliderObject(TAG(buffer,
                            m.maGroupHoriz,        horiz,
(*$ IF MUI3 *)
                            m.maNumericValue,      level,
                            m.maNumericMax,        max,
                            m.maNumericMin,        min,
(*$ ELSE *)
                            m.maSliderLevel,       level,
                            m.maSliderMax,         max,
                            m.maSliderMin,         min,
(*$ ENDIF *)
                            ud.tagEnd));
    END Slider;

PROCEDURE KeySlider(min,max,level : LONGINT; horiz : BOOLEAN;
                        key : CHAR) : APTR;
    BEGIN
        RETURN SliderObject(TAG(buffer,
                            m.maGroupHoriz,        horiz,
(*$ IF MUI3 *)
                            m.maNumericValue,      level,
                            m.maNumericMax,        max,
                            m.maNumericMin,        min,
(*$ ELSE *)
                            m.maSliderLevel,       level,
                            m.maSliderMax,         max,
                            m.maSliderMin,         min,
(*$ ENDIF *)
                            m.maControlChar,       key,
                            ud.tagEnd));
    END KeySlider;
(*\\\*)

(*$ ENDIF *) (* MUIOBSOLETE *)

(*/// "Simplebutton" *)

(*$ IF Locale *)
PROCEDURE Simplebutton(name : StrPtr) : APTR;
    BEGIN
        RETURN ml.MakeObject(m.moButton, TAG(buffer, name));
    END Simplebutton;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE Simplebutton(name : ARRAY OF CHAR) : APTR;
    BEGIN
        RETURN ml.MakeObject(m.moButton, TAG(buffer, ADR(name)));
    END Simplebutton;
(*$ ENDIF *) (* Locale *)
(*\\\*)

(*
**
** Label Objects
**
*)

(*///  "LabelX" *)
(*$ IF Locale *)
PROCEDURE Label(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE Label(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  0, ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), 0, ud.tagEnd)) ;
(*$ ENDIF *)
    END Label;

(*$ IF Locale *)
PROCEDURE Label1(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE Label1(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  m.MOLabelFlagSet{m.singleFrame}, ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), m.MOLabelFlagSet{m.singleFrame}, ud.tagEnd)) ;
(*$ ENDIF *)
    END Label1;

(*$ IF Locale *)
PROCEDURE Label2(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE Label2(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  m.MOLabelFlagSet{m.doubleFrame}, ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), m.MOLabelFlagSet{m.doubleFrame}, ud.tagEnd)) ;
(*$ ENDIF *)
    END Label2;
(*\\\*)
(*///  "LLabelX" *)
(*$ IF Locale *)
PROCEDURE LLabel(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE LLabel(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  m.MOLabelFlagSet{m.leftAligned}, ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), m.MOLabelFlagSet{m.leftAligned}, ud.tagEnd)) ;
(*$ ENDIF *)
    END LLabel;


(*$ IF Locale *)
PROCEDURE LLabel1(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE LLabel1(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  m.MOLabelFlagSet{m.leftAligned, m.singleFrame}, ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), m.MOLabelFlagSet{m.leftAligned, m.singleFrame}, ud.tagEnd)) ;
(*$ ENDIF *)
    END LLabel1;


(*$ IF Locale *)
PROCEDURE LLabel2(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE LLabel2(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  m.MOLabelFlagSet{m.leftAligned, m.doubleFrame}, ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), m.MOLabelFlagSet{m.leftAligned, m.doubleFrame}, ud.tagEnd)) ;
(*$ ENDIF *)
    END LLabel2;
(*\\\*)
(*///  "CLabelX" *)
(*$ IF Locale *)
PROCEDURE CLabel(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE CLabel(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  m.MOLabelFlagSet{m.centered}, ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), m.MOLabelFlagSet{m.centered}, ud.tagEnd)) ;
(*$ ENDIF *)
    END CLabel;


(*$ IF Locale *)
PROCEDURE CLabel1(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE CLabel1(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  m.MOLabelFlagSet{m.centered, m.singleFrame}, ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), m.MOLabelFlagSet{m.centered, m.singleFrame}, ud.tagEnd)) ;
(*$ ENDIF *)
    END CLabel1;


(*$ IF Locale *)
PROCEDURE CLabel2(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE CLabel2(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  m.MOLabelFlagSet{m.centered, m.doubleFrame}, ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), m.MOLabelFlagSet{m.centered, m.doubleFrame}, ud.tagEnd)) ;
(*$ ENDIF *)
    END CLabel2;
(*\\\*)

(*///  "KeyLabelX" *)
(*$ IF Locale *)
PROCEDURE KeyLabel(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE KeyLabel(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  HiChar, ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), HiChar, ud.tagEnd)) ;
(*$ ENDIF *)
    END KeyLabel;


(*$ IF Locale *)
PROCEDURE KeyLabel1(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE KeyLabel1(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.singleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.singleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END KeyLabel1;


(*$ IF Locale *)
PROCEDURE KeyLabel2(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE KeyLabel2(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END KeyLabel2;
(*\\\*)
(*///  "KeyLLabelX" *)
(*$ IF Locale *)
PROCEDURE KeyLLabel(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE KeyLLabel(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.leftAligned}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.leftAligned}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END KeyLLabel;


(*$ IF Locale *)
PROCEDURE KeyLLabel1(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE KeyLLabel1(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.leftAligned, m.singleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.leftAligned, m.singleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END KeyLLabel1;


(*$ IF Locale *)
PROCEDURE KeyLLabel2(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE KeyLLabel2(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.leftAligned, m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.leftAligned, m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END KeyLLabel2;
(*\\\*)
(*///  "KeyCLabelX" *)
(*$ IF Locale *)
PROCEDURE KeyCLabel(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE KeyCLabel(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.centered}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.centered}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END KeyCLabel;


(*$ IF Locale *)
PROCEDURE KeyCLabel1(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE KeyCLabel1(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.centered, m.singleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.centered, m.singleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END KeyCLabel1;


(*$ IF Locale *)
PROCEDURE KeyCLabel2(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE KeyCLabel2(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.centered, m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.centered, m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END KeyCLabel2;
(*\\\*)

(*$ IF MUI3 *)

(*///  "FreeX" *)
(*$ IF Locale *)
PROCEDURE FreeLabel(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeLabel(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert}), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert}), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeLabel;


(*$ IF Locale *)
PROCEDURE FreeLabel1(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeLabel1(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.singleFrame}), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.singleFrame}), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeLabel1;


(*$ IF Locale *)
PROCEDURE FreeLabel2(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeLabel2(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.doubleFrame}), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.doubleFrame}), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeLabel2;
(*\\\*)
(*///  "FreeLLabelX" *)
(*$ IF Locale *)
PROCEDURE FreeLLabel(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeLLabel(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned}), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned}), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeLLabel;


(*$ IF Locale *)
PROCEDURE FreeLLabel1(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeLLabel1(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned, m.singleFrame}), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned, m.singleFrame}), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeLLabel1;


(*$ IF Locale *)
PROCEDURE FreeLLabel2(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeLLabel2(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned, m.doubleFrame}), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned, m.doubleFrame}), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeLLabel2;
(*\\\*)
(*///  "FreeCLabelX" *)
(*$ IF Locale *)
PROCEDURE FreeCLabel(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeCLabel(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered}), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered}), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeCLabel;


(*$ IF Locale *)
PROCEDURE FreeCLabel1(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeCLabel1(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered}) + LONGCARD(m.moLabelSingleFrame), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered}) + LONGCARD(m.moLabelSingleFrame), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeCLabel1;


(*$ IF Locale *)
PROCEDURE FreeCLabel2(label : StrPtr) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeCLabel2(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered, m.doubleFrame}), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered, m.doubleFrame}), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeCLabel2;
(*\\\*)

(*///  "FreeKeyX" *)
(*$ IF Locale *)
PROCEDURE FreeKeyLabel(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeKeyLabel(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeKeyLabel;


(*$ IF Locale *)
PROCEDURE FreeKeyLabel1(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeKeyLabel1(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.singleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.singleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeKeyLabel1;


(*$ IF Locale *)
PROCEDURE FreeKeyLabel2(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeKeyLabel2(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeKeyLabel2;
(*\\\*)
(*///  "FreeKeyLLabelX" *)
(*$ IF Locale *)
PROCEDURE FreeKeyLLabel(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeKeyLLabel(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeKeyLLabel;


(*$ IF Locale *)
PROCEDURE FreeKeyLLabel1(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeKeyLLabel1(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned, m.singleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned, m.singleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeKeyLLabel1;


(*$ IF Locale *)
PROCEDURE FreeKeyLLabel2(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeKeyLLabel2(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned, m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.leftAligned, m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeKeyLLabel2;
(*\\\*)
(*///  "FreeKeyCLabelX" *)
(*$ IF Locale *)
PROCEDURE FreeKeyCLabel(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeKeyCLabel(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeKeyCLabel;


(*$ IF Locale *)
PROCEDURE FreeKeyCLabel1(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeKeyCLabel1(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered}) + LONGCARD(m.moLabelSingleFrame) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered}) + LONGCARD(m.moLabelSingleFrame) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeKeyCLabel1;


(*$ IF Locale *)
PROCEDURE FreeKeyCLabel2(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)(*$ CopyDyn- *)
PROCEDURE FreeKeyCLabel2(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
(*$ IF Locale *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer,     label,  CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered, m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ELSE *)
        RETURN ml.MakeObject(m.moLabel, TAG(buffer, ADR(label), CAST(LONGCARD, m.MOLabelFlagSet{m.freeVert, m.centered, m.doubleFrame}) + LONGCARD(HiChar), ud.tagEnd)) ;
(*$ ENDIF *)
    END FreeKeyCLabel2;
(*\\\*)

(*$ ENDIF *)

(*
**
** Controlling Objects
**
** Note : get didn't work in previous releases
**
*)

(*///  "set, get,...." *)

PROCEDURE get(obj : APTR; attr : LONGCARD; store : ADDRESS);
    BEGIN DoMethod(obj,TAG(buffer, id.omGET, attr, store));
    END get;

PROCEDURE set(obj : APTR; attr : LONGCARD; value : LONGINT);
    VAR dummy : APTR;
    BEGIN dummy := il.SetAttrsA(obj, TAG(buffer,attr,value,ud.tagEnd));
    END set;

PROCEDURE setmutex(obj : APTR; n : LONGINT);
    BEGIN set(obj,m.maRadioActive,n);
    END setmutex;

PROCEDURE setcycle(obj : APTR; n : LONGINT);
    BEGIN set(obj,m.maCycleActive,n);
    END setcycle;

(*$ IF Locale *)
PROCEDURE setstring(obj : APTR; s : StrPtr);
    BEGIN set(obj,m.maStringContents,s);
    END setstring;
(*$ ELSE *) (*$ CopyDyn- *)
PROCEDURE setstring(obj : APTR; s : ARRAY OF CHAR);
    BEGIN set(obj,m.maStringContents,ADR(s));
    END setstring;
(*$ ENDIF *)

PROCEDURE setcheckmark(obj : APTR; b : BOOLEAN);
    BEGIN
        IF b THEN set(obj,m.maSelected,1);
             ELSE set(obj,m.maSelected,0);
             END;
    END setcheckmark;

PROCEDURE setslider(obj : APTR; l : LONGINT);
    BEGIN
(*$ IF MUI3 *)
      set(obj,m.maNumericValue,l);
(*$ ELSE *)
      set(obj,m.maSliderLevel,l);
(*$ ENDIF *)
    END setslider;

(*\\\*)
(*///  "NoteClose" *)
(*
** NoteClose (app,obj,ID)
*)
PROCEDURE NoteClose(app : APTR; obj : APTR; ID  : LONGINT);
    BEGIN DoMethod(obj,TAG(buffer, m.mmNotify,m.maWindowCloseRequest,ed.LTRUE, app,2,m.mmApplicationReturnID,ID));
    END NoteClose;
(*\\\*)
(*///  "NoteButton" *)
(*
**  Notebutton (app,obj,ID)
*)
PROCEDURE NoteButton(app : APTR; obj : APTR; ID  : LONGINT);
    BEGIN DoMethod(obj,TAG(buffer, m.mmNotify,m.maPressed, ed.LFALSE, app,2,m.mmApplicationReturnID,ID));
    END NoteButton;
(*\\\*)
(*///  "RemMember" *)
(*
** RemMember (obj,member)
*)

PROCEDURE RemMember(obj : APTR; member : APTR);
    BEGIN DoMethod(obj,TAG(buffer, id.omREMMEMBER, member));
    END RemMember;
(*\\\*)
(*///  "AddMember" *)
(*
** AddMember (obj,member)
*)

PROCEDURE AddMember(obj : APTR; member : APTR);
    BEGIN DoMethod(obj,TAG(buffer, id.omADDMEMBER, member));
    END AddMember;
(*\\\*)

END MuiMacros.







