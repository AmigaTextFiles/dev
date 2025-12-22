IMPLEMENTATION MODULE MuiMacros;

(*$ NilChk      := FALSE EntryClear  := FALSE LargeVars   := FALSE StackParms  := FALSE *)

(****************************************************************************
**
**      MUI Macros 2.0
**
**      Converted to Modula by Christian "Kochtopf" Scholz
**
**      $Id: MuiMacros.def,v 1.8mb 1994/11/30 Stefan Schulz Exp $
**
**      $Log: MuiMacros.mod,v $
|
| Revision 1.8mb \30.11.1994\ by Stefan Schulz
| Special Version for GenCodeM2:
| - no dividing between MUIObsolete and non-MUIObsolete
| - only Localized Functioncalls
|
# Revision 1.8  1994/08/18  18:59:25  Kochtopf
# changed img-argument in PopButton from ARRAY to APTR.
# changed implementation of SimpleButton for -MUIOBSOLETE
#
# Revision 1.7  1994/08/11  16:59:45  Kochtopf
# *** empty log message ***
#
# Revision 1.6  1994/06/27  22:06:41  Kochtopf
# put some Macros in MUIObsolete-Parenthesis, because one should
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
**
****************************************************************************)

IMPORT  MD:MuiD;
IMPORT  ML:MuiL;
IMPORT  UD:UtilityD;
IMPORT  R;
FROM    MuiD IMPORT APTR, StrPtr;
FROM    MuiSupport IMPORT DoMethod;
FROM    UtilityD IMPORT tagEnd, tagMore, HookPtr, Hook;
FROM    SYSTEM IMPORT ADDRESS, ADR, TAG, CAST, SETREG, REG;
FROM    IntuitionL IMPORT SetAttrsA, GetAttr;
FROM    IntuitionD IMPORT omGET, omADDMEMBER, omREMMEMBER;
FROM    Storage IMPORT ALLOCATE;

VAR buffer  : ARRAY [0..50] OF LONGINT;      (* for the tags *)

(*{{{  "MUI-Object-Generation" *)
(*
**
**  MUI - Object Generation
**
*)

PROCEDURE WindowObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcWindow), tags);
    END WindowObject;

PROCEDURE ImageObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcImage), tags);
    END ImageObject;

PROCEDURE ApplicationObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcApplication), tags);
    END ApplicationObject;

PROCEDURE NotifyObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcNotify), tags);
    END NotifyObject;

PROCEDURE TextObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcText), tags);
    END TextObject;

PROCEDURE RectangleObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcRectangle), tags);
    END RectangleObject;

PROCEDURE ListObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcList), tags);
    END ListObject;

PROCEDURE PropObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcProp), tags);
    END PropObject;

PROCEDURE StringObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcString), tags);
    END StringObject;

PROCEDURE ScrollbarObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcScrollbar), tags);
    END ScrollbarObject;

PROCEDURE ListviewObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcListview), tags);
    END ListviewObject;

PROCEDURE RadioObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcRadio), tags);
    END RadioObject;

PROCEDURE VolumelistObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcVolumelist), tags);
    END VolumelistObject;

PROCEDURE FloattextObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcFloattext), tags);
    END FloattextObject;

PROCEDURE DirlistObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcDirlist), tags);
    END DirlistObject;

PROCEDURE ScrmodelistObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcScrmodelist), tags);
    END ScrmodelistObject;

PROCEDURE SliderObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcSlider), tags);
    END SliderObject;

PROCEDURE CycleObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcCycle), tags);
    END CycleObject;

PROCEDURE GaugeObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcGauge), tags);
    END GaugeObject;

PROCEDURE BoopsiObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcBoopsi), tags);
    END BoopsiObject;

PROCEDURE ScaleObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcScale), tags);
    END ScaleObject;

PROCEDURE GroupObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcGroup), tags);
    END GroupObject;

PROCEDURE VGroup(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcGroup), tags);
    END VGroup;

PROCEDURE HGroup(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcGroup), TAG(buffer, MD.maGroupHoriz, TRUE, tagMore, tags, tagEnd));
    END HGroup;

PROCEDURE ColGroup(cols : LONGCARD; tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcGroup), TAG(buffer, MD.maGroupColumns, cols, tagMore, tags, tagEnd));
    END ColGroup;

PROCEDURE RowGroup(rows : LONGCARD; tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcGroup), TAG(buffer, MD.maGroupRows, rows, tagMore, tags, tagEnd));
    END RowGroup;

PROCEDURE PageGroup(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcGroup),TAG(buffer, MD.maGroupPageMode, TRUE, tagMore, tags, tagEnd));
    END PageGroup;

PROCEDURE ColorfieldObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcColorfield), tags);
    END ColorfieldObject;

PROCEDURE ColoradjustObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcColoradjust), tags);
    END ColoradjustObject;

PROCEDURE PaletteObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcPalette), tags);
    END PaletteObject;

PROCEDURE VirtgroupObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcVirtgroup), tags);
    END VirtgroupObject;

PROCEDURE ScrollgroupObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcScrollgroup), tags);
    END ScrollgroupObject;

PROCEDURE VGroupV(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcVirtgroup), tags);
    END VGroupV;

PROCEDURE HGroupV(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcVirtgroup), TAG(buffer, MD.maGroupHoriz, TRUE, tagMore, tags, tagEnd));
    END HGroupV;

PROCEDURE ColGroupV(cols : LONGCARD; tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcVirtgroup), TAG(buffer, MD.maGroupColumns, cols, tagMore, tags, tagEnd));
    END ColGroupV;

PROCEDURE RowGroupV(rows : LONGCARD; tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcVirtgroup), TAG(buffer, MD.maGroupRows, rows, tagMore, tags, tagEnd));
    END RowGroupV;

PROCEDURE PageGroupV(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcVirtgroup),TAG(buffer, MD.maGroupPageMode, TRUE, tagMore, tags, tagEnd));
    END PageGroupV;

PROCEDURE PopString(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcPopstring), tags);
    END PopString;

PROCEDURE PopObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcPopobject), tags);
    END PopObject;

PROCEDURE PopAsl(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcPopasl), tags);
    END PopAsl;

PROCEDURE Register(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcRegister), tags);
    END Register;

PROCEDURE MenuStripObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcMenustrip), tags);
    END MenuStripObject;

PROCEDURE MenuObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcMenu), tags);
    END MenuObject;

PROCEDURE MenuObjectT(name : StrPtr; tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcMenu), TAG(buffer, MD.maMenuTitle, name, tagMore, tags, tagEnd));
    END MenuObjectT;

PROCEDURE MenuItemObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcMenuitem), tags);
    END MenuItemObject;


(*}}}*)
(*{{{  "MakeID" *)
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
(*}}}*)
(*{{{  "Hook-Support" *)
(*
**  Hook-Support functions
**  1. the dispatcher
**  2. the MakeHook-Function
**
*)

PROCEDURE HookEntry(hook{R.A0}  : HookPtr;
                    object{R.A2}: ADDRESS;
                    args{R.A1}  : ADDRESS)     : ADDRESS;
    (*$SaveA4:=TRUE*)
    BEGIN
        SETREG (R.A4, hook^.data);
        RETURN CAST(HookDef,hook^.subEntry)(hook, object, args);
    END HookEntry;

PROCEDURE MakeHook(entry:HookDef; VAR hook : HookPtr);

    BEGIN
            ALLOCATE(hook,SIZE(Hook));
            hook^.node.succ  := NIL;
            hook^.node.pred  := NIL;
            hook^.entry      := HookEntry;
            hook^.subEntry   := CAST(ADDRESS,entry);
            hook^.data       := REG(R.A4);
    END MakeHook;
(*}}}*)
(*{{{  "Spacing-Macros" *)
(*
**
**  Spacing Macros
**
*)
(*{{{  "HV-Space" *)
PROCEDURE HVSpace() : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcRectangle), NIL);
    END HVSpace;
(*}}}*)
(*{{{  "Hspace" *)
PROCEDURE HSpace(x : LONGCARD) : APTR;
    BEGIN
        IF x#0 THEN 
                RETURN ML.mNewObject(ADR(MD.mcRectangle),
                                     TAG(buffer,
                                        MD.maFixWidth,     x,
                                        MD.maVertWeight,   0,
                                        tagEnd));
                ELSE   
                RETURN ML.mNewObject(ADR(MD.mcRectangle),
                                     TAG(buffer,
                                        MD.maVertWeight,   0,
                                        tagEnd));
                END;
    END HSpace;
(*}}}*)
(*{{{  "VSpace" *)
PROCEDURE VSpace(x : LONGCARD) : APTR;
    BEGIN
        IF x#0 THEN 
                RETURN ML.mNewObject(ADR(MD.mcRectangle),
                                     TAG(buffer,
                                        MD.maFixHeight,     x,
                                        MD.maHorizWeight,   0,
                                        tagEnd));
                ELSE
                RETURN ML.mNewObject(ADR(MD.mcRectangle),
                                     TAG(buffer,
                                        MD.maHorizWeight,   0,
                                        tagEnd));
                END;
    END VSpace;
(*}}}*)
(*{{{  "HCenter" *)
PROCEDURE HCenter(obj : APTR) : APTR;
    BEGIN
        RETURN HGroup(TAG(buffer,
                    MD.maGroupSpacing,      0,
                    Child,                  HSpace(0),
                    Child,                  obj,
                    Child,                  HSpace(0),
                    tagEnd));
    END HCenter;
(*}}}*)
(*{{{  "VCenter" *)
PROCEDURE VCenter(obj : APTR) : APTR;
    BEGIN
        RETURN VGroup(TAG(buffer,
                    MD.maGroupSpacing,      0,
                    Child,                  VSpace(0),
                    Child,                  obj,
                    Child,                  VSpace(0),
                    tagEnd));
    END VCenter;
(*}}}*)
(*}}}*)
(*{{{  "PopButton" *)
(*
**
**  PopUp-Button
**
**  to be used for Popup-Objects
**
*)

PROCEDURE PopButton(img : APTR) : APTR;
    BEGIN
        RETURN ML.MakeObject(MD.moPopButton, TAG(buffer, img));
    END PopButton;
(*}}}*)

(*
**
** String-Object
**
** Makes a simple String-Gadget
**
*)

(*{{{  "StringObjects" *)
PROCEDURE String(contents : StrPtr; maxlen : LONGINT) : APTR;
    BEGIN
        RETURN StringObject(TAG(buffer,
                            MD.maFrame,            MD.mvFrameString,
                            MD.maStringMaxLen,     maxlen,
                            MD.maStringContents,   contents,
                            tagEnd));
    END String;
PROCEDURE KeyString(contents : StrPtr; maxlen : LONGINT; key : CHAR) : APTR;
    BEGIN
        RETURN StringObject(TAG(buffer,
                            MD.maFrame,             MD.mvFrameString,
                            MD.maStringMaxLen,      maxlen,
                            MD.maStringContents,    contents,
                            MD.maControlChar,       key,
                            tagEnd));
    END KeyString;
(*}}}*)

(*
**
** Checkmark
**
*)

(*{{{  "Checkmarks" *)
PROCEDURE Checkmark(selected : BOOLEAN) : APTR;
    BEGIN
        RETURN ImageObject( TAG(buffer,
                            MD.maFrame,            MD.mvFrameImageButton,
                            MD.maInputMode,        MD.mvInputModeToggle,
                            MD.maImageSpec,        MD.miCheckMark,
                            MD.maImageFreeVert,    TRUE,
                            MD.maSelected,         selected,
                            MD.maBackground,       MD.miButtonBack,
                            MD.maShowSelState,     FALSE,
                            tagEnd));
    END Checkmark;

PROCEDURE KeyCheckmark(selected : BOOLEAN; key : CHAR) : APTR;
    BEGIN
        RETURN ImageObject( TAG(buffer,
                            MD.maFrame,            MD.mvFrameImageButton,
                            MD.maInputMode,        MD.mvInputModeToggle,
                            MD.maImageSpec,        MD.miCheckMark,
                            MD.maImageFreeVert,    TRUE,
                            MD.maSelected,         selected,
                            MD.maBackground,       MD.miButtonBack,
                            MD.maShowSelState,     FALSE,
                            MD.maControlChar,      key,
                            tagEnd));
    END KeyCheckmark;

(*}}}*)

(*
**
** Buttons
**
*)

(*{{{  "Buttons" *)
PROCEDURE Keybutton(name : StrPtr; key : CHAR) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maFrame,            MD.mvFrameButton,
                            MD.maTextContents,     name,
                            MD.maTextPreParse,     ADR("\033c"),
                            MD.maTextSetMax,       FALSE,
                            MD.maTextHiChar,       key,
                            MD.maControlChar,      key,
                            MD.maInputMode,        MD.mvInputModeRelVerify,
                            MD.maBackground,       MD.miButtonBack,
                            tagEnd));

    END Keybutton;
PROCEDURE Simplebutton(name : StrPtr) : APTR;
    BEGIN
        RETURN ML.MakeObject(MD.moButton, TAG(buffer, name));
    END Simplebutton;

(*}}}*)

(*
**
**  Radio Object
**
*)

(*{{{  "RadioObjects" *)
PROCEDURE Radio(name : StrPtr; array : APTR) : APTR;
    BEGIN
        RETURN RadioObject( TAG(buffer,
                            MD.maFrame,             MD.mvFrameGroup,
                            MD.maFrameTitle,        name,
                            MD.maRadioEntries,      array,
                            tagEnd));
    END Radio;

PROCEDURE KeyRadio(name : StrPtr; array : APTR; key : CHAR) : APTR;
    BEGIN
        RETURN RadioObject( TAG(buffer,
                            MD.maFrame,             MD.mvFrameGroup,
                            MD.maFrameTitle,        name,
                            MD.maTextHiChar,        key,
                            MD.maControlChar,       key,
                            MD.maRadioEntries,      array,
                            tagEnd));
    END KeyRadio;

(*}}}*)

(*
**
**  Cycle-Objects
**
*)

(*{{{  "Cycle" *)
PROCEDURE Cycle(array : APTR) : APTR;
    BEGIN
        RETURN CycleObject(TAG(buffer,
                            MD.maCycleEntries,      array,
                            tagEnd));
    END Cycle;


PROCEDURE KeyCycle(array : APTR; key : CHAR) : APTR;
    BEGIN
        RETURN CycleObject(TAG(buffer,
                            MD.maCycleEntries,      array,
                            MD.maControlChar,       key,
                            tagEnd));
    END KeyCycle;
(*}}}*)

(*
**
**  Slider-Objects
**
*)

(*{{{  "Slider" *)
PROCEDURE Slider(min,max,level : LONGINT; horiz : BOOLEAN) : APTR;
    BEGIN
        RETURN SliderObject(TAG(buffer,
                            MD.maGroupHoriz,        horiz,
                            MD.maSliderLevel,       level,
                            MD.maSliderMax,         max,
                            MD.maSliderMin,         min,
                            tagEnd));
    END Slider;

PROCEDURE KeySlider(min,max,level : LONGINT; horiz : BOOLEAN;
                        key : CHAR) : APTR;
    BEGIN
        RETURN SliderObject(TAG(buffer,
                            MD.maGroupHoriz,        horiz,
                            MD.maSliderLevel,       level,
                            MD.maSliderMax,         max,
                            MD.maSliderMin,         min,
                            MD.maControlChar,       key,
                            tagEnd));
    END KeySlider;
(*}}}*)

(*
**
** Label Objects
**
*)

(*{{{  "LabelX" *)
PROCEDURE Label(label : StrPtr) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            tagEnd));
    END Label;

PROCEDURE Label1(label : StrPtr) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maFrame,                MD.mvFrameButton,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END Label1;

PROCEDURE Label2(label : StrPtr) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maFrame,                MD.mvFrameString,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END Label2;
(*}}}*)
(*{{{  "LLabelX" *)
PROCEDURE LLabel(label : StrPtr) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            tagEnd));
    END LLabel;


PROCEDURE LLabel1(label : StrPtr) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maFrame,                MD.mvFrameButton,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END LLabel1;


PROCEDURE LLabel2(label : StrPtr) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maFrame,                MD.mvFrameString,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END LLabel2;
(*}}}*)
(*{{{  "KeyLabelX" *)
PROCEDURE KeyLabel(label : StrPtr; HiChar : CHAR) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maTextHiChar,           HiChar,
                            tagEnd));
    END KeyLabel;


PROCEDURE KeyLabel1(label : StrPtr; HiChar : CHAR) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maTextHiChar,           HiChar,
                            MD.maFrame,                MD.mvFrameButton,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END KeyLabel1;


PROCEDURE KeyLabel2(label : StrPtr; HiChar : CHAR) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maTextHiChar,           HiChar,
                            MD.maFrame,                MD.mvFrameString,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END KeyLabel2;
(*}}}*)
(*{{{  "KeyLLabelX" *)
PROCEDURE KeyLLabel(label : StrPtr; HiChar : CHAR) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maTextHiChar,           HiChar,
                            tagEnd));
    END KeyLLabel;


PROCEDURE KeyLLabel1(label : StrPtr; HiChar : CHAR) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maTextHiChar,           HiChar,
                            MD.maFrame,                MD.mvFrameButton,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END KeyLLabel1;


PROCEDURE KeyLLabel2(label : StrPtr; HiChar : CHAR) : APTR;
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextContents,         label,
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maTextHiChar,           HiChar,
                            MD.maFrame,                MD.mvFrameString,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END KeyLLabel2;
(*}}}*)

(*
**
** Controlling Objects
**
** Note : get didn't work in previous releases
**
*)

(*{{{  "set, get,...." *)

PROCEDURE get(obj : APTR; attr : LONGCARD; store : ADDRESS);
    BEGIN DoMethod(obj,TAG(buffer, omGET, attr, store));
    END get;

PROCEDURE set(obj : APTR; attr : LONGCARD; value : LONGINT);
    VAR dummy : APTR;
    BEGIN dummy:=SetAttrsA(obj, TAG(buffer,attr,value,tagEnd));
    END set;

PROCEDURE nnset(obj : APTR; attr : LONGCARD; value : LONGINT);
    VAR dummy : APTR;
    BEGIN dummy:=SetAttrsA(obj, TAG(buffer,MD.maNoNotify,TRUE, attr,value,tagEnd));
    END nnset;

PROCEDURE setmutex(obj : APTR; n : LONGINT);
    BEGIN set(obj,MD.maRadioActive,n);
    END setmutex;

PROCEDURE setcycle(obj : APTR; n : LONGINT);
    BEGIN set(obj,MD.maCycleActive,n);
    END setcycle;

PROCEDURE setstring(obj : APTR; s : StrPtr);
    BEGIN set(obj,MD.maStringContents,s);
    END setstring;

PROCEDURE setcheckmark(obj : APTR; b : BOOLEAN);
    BEGIN
        IF b THEN set(obj,MD.maSelected,1);
             ELSE set(obj,MD.maSelected,0);
             END;
    END setcheckmark;

PROCEDURE setslider(obj : APTR; l : LONGINT);
    BEGIN set(obj,MD.maSliderLevel,l);
    END setslider;

(*}}}*)
(*{{{  "NoteClose" *)
(*
** NoteClose (app,obj,ID)
*)
PROCEDURE NoteClose(app : APTR; obj : APTR; ID  : LONGINT);
    BEGIN DoMethod(obj,TAG(buffer, MD.mmNotify,MD.maWindowCloseRequest,TRUE, app,2,MD.mmApplicationReturnID,ID));
    END NoteClose;
(*}}}*)
(*{{{  "NoteButton" *)
(*
**  Notebutton (app,obj,ID)
*)
PROCEDURE NoteButton(app : APTR; obj : APTR; ID  : LONGINT);
    BEGIN DoMethod(obj,TAG(buffer, MD.mmNotify,MD.maPressed, FALSE, app,2,MD.mmApplicationReturnID,ID));
    END NoteButton;
(*}}}*)
(*{{{  "RemMember" *)
(*
** RemMember (obj,member)
*)

PROCEDURE RemMember(obj : APTR; member : APTR);
    BEGIN DoMethod(obj,TAG(buffer, omREMMEMBER, member));
    END RemMember;
(*}}}*)
(*{{{  "AddMember" *)
(*
** AddMember (obj,member)
*)

PROCEDURE AddMember(obj : APTR; member : APTR);
    BEGIN DoMethod(obj,TAG(buffer, omADDMEMBER, member));
    END AddMember;
(*}}}*)

END MuiMacros.







