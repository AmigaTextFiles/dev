IMPLEMENTATION MODULE MuiMacros;

(*$ NilChk      := FALSE *)
(*$ EntryClear  := FALSE *)
(*$ LargeVars   := FALSE *)
(*$ StackParms  := FALSE *)
(*$ DEFINE Locale :=FALSE *)


(****************************************************************************
**
**      MUI Macros 2.0
**
**      Converted to Modula by Christian "Kochtopf" Scholz
**
**      $Id: MuiMacros.mod,v 1.4 1994/02/09 14:50:03 Kochtopf Exp $
**
**      $Log: MuiMacros.mod,v $
# Revision 1.4  1994/02/09  14:50:03  Kochtopf
# Versionsnummer in 2.0 geaendert.
#
**
****************************************************************************)

IMPORT  MD:MuiD;
IMPORT  ML:MuiL;
IMPORT  UD:UtilityD;
IMPORT  R;
FROM    MuiSupport IMPORT DoMethod;
FROM    UtilityD IMPORT tagEnd, tagMore, HookPtr, Hook;
FROM    SYSTEM IMPORT ADDRESS, ADR, TAG, CAST, SETREG, REG;
FROM    IntuitionL IMPORT SetAttrsA, GetAttr;
FROM    IntuitionD IMPORT omGET, omADDMEMBER, omREMMEMBER;
FROM    Storage IMPORT ALLOCATE;

VAR buffer  : ARRAY [0..50] OF LONGINT;      (* for the tags *)

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

(* Not implemented!
PROCEDURE ApplistObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcApplist), tags);
    END ApplistObject;

PROCEDURE DatatypeObject(tags : UD.TagItemPtr) : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcDatatype), tags);
    END DatatypeObject; 
*)

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

(* missing Defs!
PROCEDURE Popstring(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcPopstring), tags);
    END Popstring;

PROCEDURE Popobject(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcPopobject), tags);
    END Popobject;

PROCEDURE Popasl(tags : UD.TagItemPtr) : APTR;
    BEGIN
         RETURN ML.mNewObject(ADR(MD.mcPopasl), tags);
    END Popasl;
*)


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



(*
**
**  Spacing Macros
**
*)

PROCEDURE HVSpace() : APTR;
    BEGIN
        RETURN ML.mNewObject(ADR(MD.mcRectangle), NIL);
    END HVSpace;

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


(*
**
**  PopUp-Macro
**
*)

PROCEDURE Popup (object : APTR; 
                 hook : HookPtr; 
             VAR imageObj : APTR;
                 imgSpec : ADDRESS) : APTR;
    VAR
        dummy    : APTR;
        buffer   : ARRAY[0..20] OF LONGINT;

    BEGIN
        imageObj := ImageObject(TAG(buffer,
                        MD.maFrame,                 MD.mvFrameImageButton,
                        MD.maImageSpec,             imgSpec,
                        MD.maImageFontMatchWidth,   TRUE,
                        MD.maImageFreeVert,         TRUE,
                        MD.maInputMode,             MD.mvInputModeRelVerify,
                        MD.maBackground,            MD.miBACKGROUND,
                        tagEnd));

        dummy :=    HGroup(TAG(buffer,
                        MD.maGroupSpacing,      1,
                        Child,                  object,
                        Child,                  imageObj,
                        tagEnd));

        IF (dummy#NIL) AND (imageObj#NIL) THEN
            DoMethod(imageObj, TAG(buffer, MD.mmNotify,
                        MD.maPressed, FALSE,
                        dummy, 2,
                        MD.mmCallHook, hook));
                        RETURN dummy;
        END;
        RETURN 0;

    END Popup;


(*
**
** String-Object
**
** Makes a simple String-Gadget
**
*)


(*$ IF Locale *)
PROCEDURE String(contents : StrPtr; maxlen : LONGINT) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE String(contents : ARRAY OF CHAR; maxlen : LONGINT) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN StringObject(TAG(buffer,
                            MD.maFrame,            MD.mvFrameString,
                            MD.maStringMaxLen,     maxlen,
                            (*$ IF Locale *)
                                MD.maStringContents,   contents,
                            (*$ ELSE *)
                                MD.maStringContents,   ADR(contents),
                            (*$ ENDIF *)
                            tagEnd));
    END String;
(*$ IF Locale *)
PROCEDURE KeyString(contents : StrPtr; maxlen : LONGINT; key : CHAR) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE KeyString(contents : ARRAY OF CHAR; maxlen : LONGINT; key : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN StringObject(TAG(buffer,
                            MD.maFrame,             MD.mvFrameString,
                            MD.maStringMaxLen,      maxlen,
                            (*$ IF Locale *)
                                MD.maStringContents,    contents,
                            (*$ ELSE *)
                                MD.maStringContents,    ADR(contents),
                            (*$ ENDIF *)
                            MD.maControlChar,       key,
                            tagEnd));
    END KeyString;

(*
**
** Checkmark
**
*)

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

(*
**
** Buttons
**
*)

(*$ IF Locale *)
PROCEDURE Simplebutton(name : StrPtr) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE Simplebutton(name : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maFrame,            MD.mvFrameButton,
                            (*$ IF Locale *)
                                MD.maTextContents,     name,
                            (*$ ELSE *)
                                MD.maTextContents,     ADR(name),
                            (*$ ENDIF *)
                            MD.maTextPreParse,     ADR("\033c"),
                            MD.maTextSetMax,       FALSE,
                            MD.maInputMode,        MD.mvInputModeRelVerify,
                            MD.maBackground,       MD.miButtonBack,
                            tagEnd));

    END Simplebutton;

(*$ IF Locale *)
PROCEDURE Keybutton(name : StrPtr; key : CHAR) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE Keybutton(name : ARRAY OF CHAR; key : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maFrame,            MD.mvFrameButton,
                            (*$ IF Locale *)
                                MD.maTextContents,     name,
                            (*$ ELSE *)
                                MD.maTextContents,     ADR(name),
                            (*$ ENDIF *)
                            MD.maTextPreParse,     ADR("\033c"),
                            MD.maTextSetMax,       FALSE,
                            MD.maTextHiChar,       key,
                            MD.maControlChar,      key,
                            MD.maInputMode,        MD.mvInputModeRelVerify,
                            MD.maBackground,       MD.miButtonBack,
                            tagEnd));

    END Keybutton;



(*
**
**  Radio Object
**
*)

(*$ IF Locale *)
PROCEDURE Radio(name : StrPtr; array : APTR) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE Radio(name : ARRAY OF CHAR; array : APTR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN RadioObject( TAG(buffer,
                            MD.maFrame,             MD.mvFrameGroup,
                            (*$ IF Locale *)
                                MD.maFrameTitle,        name,
                            (*$ ELSE *)
                                MD.maFrameTitle,        ADR(name),
                            (*$ ENDIF *)
                            MD.maRadioEntries,      array,
                            tagEnd));
    END Radio;

(*$ IF Locale *)
PROCEDURE KeyRadio(name : StrPtr; array : APTR; key : CHAR) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE KeyRadio(name : ARRAY OF CHAR; array : APTR; key : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN RadioObject( TAG(buffer,
                            MD.maFrame,             MD.mvFrameGroup,
                            (*$ IF Locale *)
                                MD.maFrameTitle,        name,
                            (*$ ELSE *)
                                MD.maFrameTitle,        ADR(name),
                            (*$ ENDIF *)
                            MD.maTextHiChar,        key,
                            MD.maControlChar,       key,
                            MD.maRadioEntries,      array,
                            tagEnd));
    END KeyRadio;


(*
**
** Label Objects
**
*)

(*$ IF Locale *)
PROCEDURE Label(label : StrPtr) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE Label(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            (*$ IF Locale *)
                                MD.maTextContents,         label,
                            (*$ ELSE *)
                                MD.maTextContents,         ADR(label),
                            (*$ ENDIF *)
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            tagEnd));
    END Label;


(*$ IF Locale *)
PROCEDURE Label1(label : StrPtr) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE Label1(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            (*$ IF Locale *)
                                MD.maTextContents,         label,
                            (*$ ELSE *)
                                MD.maTextContents,         ADR(label),
                            (*$ ENDIF *)
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maFrame,                MD.mvFrameButton,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END Label1;


(*$ IF Locale *)
PROCEDURE Label2(label : StrPtr) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE Label2(label : ARRAY OF CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            (*$ IF Locale *)
                                MD.maTextContents,         label,
                            (*$ ELSE *)
                                MD.maTextContents,         ADR(label),
                            (*$ ENDIF *)
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maFrame,                MD.mvFrameString,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END Label2;


(*$ IF Locale *)
PROCEDURE KeyLabel(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE KeyLabel(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            (*$ IF Locale *)
                                MD.maTextContents,         label,
                            (*$ ELSE *)
                                MD.maTextContents,         ADR(label),
                            (*$ ENDIF *)
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maTextHiChar,           HiChar,
                            tagEnd));
    END KeyLabel;


(*$ IF Locale *)
PROCEDURE KeyLabel1(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE KeyLabel1(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            (*$ IF Locale *)
                                MD.maTextContents,         label,
                            (*$ ELSE *)
                                MD.maTextContents,         ADR(label),
                            (*$ ENDIF *)
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maTextHiChar,           HiChar,
                            MD.maFrame,                MD.mvFrameButton,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END KeyLabel1;


(*$ IF Locale *)
PROCEDURE KeyLabel2(label : StrPtr; HiChar : CHAR) : APTR;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE KeyLabel2(label : ARRAY OF CHAR; HiChar : CHAR) : APTR;
(*$ ENDIF *)
    BEGIN
        RETURN TextObject(  TAG(buffer,
                            MD.maTextPreParse,         ADR("\033r"),
                            (*$ IF Locale *)
                                MD.maTextContents,         label,
                            (*$ ELSE *)
                                MD.maTextContents,         ADR(label),
                            (*$ ENDIF *)
                            MD.maWeight,               0,
                            MD.maInnerLeft,            0,
                            MD.maInnerRight,           0,
                            MD.maTextHiChar,           HiChar,
                            MD.maFrame,                MD.mvFrameString,
                            MD.maFramePhantomHoriz,    TRUE,
                            tagEnd));
    END KeyLabel2;

(*
**
**  Cycle-Objects
**
*)

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


(*
**
**  Slider-Objects
**
*)

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



(*
**
** Controlling Objects
**
** Note : get didn't work in previous releases
**
*)

PROCEDURE get(obj : APTR; attr : LONGCARD; store : ADDRESS);
    BEGIN
        DoMethod(obj,TAG(buffer, omGET,
            attr, store));
    END get;

PROCEDURE set(obj : APTR; attr : LONGCARD; value : LONGINT);
    VAR dummy : APTR;
    BEGIN
        dummy:=SetAttrsA(obj, TAG(buffer,attr,value,tagEnd));
    END set;

PROCEDURE setmutex(obj : APTR; n : LONGINT);
    BEGIN
        set(obj,MD.maRadioActive,n);
    END setmutex;

PROCEDURE setcycle(obj : APTR; n : LONGINT);
    BEGIN
        set(obj,MD.maCycleActive,n);
    END setcycle;

(*$ IF Locale *)
PROCEDURE setstring(obj : APTR; s : StrPtr);
    BEGIN
        set(obj,MD.maStringContents,s);
    END setstring;
(*$ ELSE *)
(*$ CopyDyn := FALSE *)
PROCEDURE setstring(obj : APTR; s : ARRAY OF CHAR);
    BEGIN
        set(obj,MD.maStringContents,ADR(s));
    END setstring;
(*$ ENDIF *)

PROCEDURE setcheckmark(obj : APTR; b : BOOLEAN);
    BEGIN
        IF b THEN set(obj,MD.maSelected,1);
             ELSE set(obj,MD.maSelected,0);
             END;
    END setcheckmark;

PROCEDURE setslider(obj : APTR; l : LONGINT);
    BEGIN
        set(obj,MD.maSliderLevel,l);
    END setslider;


(*
** NoteClose (app,obj,ID)
*)

PROCEDURE NoteClose(app : APTR; 
                    obj : APTR; 
                    ID  : LONGINT);
    BEGIN
        DoMethod(obj,TAG(buffer,
                    MD.mmNotify,MD.maWindowCloseRequest,TRUE,
                    app,2,MD.mmApplicationReturnID,ID));
    END NoteClose;

(*
**  Notebutton (app,obj,ID)
*)

PROCEDURE NoteButton(app : APTR;
                     obj : APTR; 
                     ID  : LONGINT);
    BEGIN
        DoMethod(obj,TAG(buffer,
                        MD.mmNotify,MD.maPressed, FALSE,
                        app,2,MD.mmApplicationReturnID,ID));
    END NoteButton;

(*
** RemMember (obj,member)
*)

PROCEDURE RemMember(obj : APTR; member : APTR);
    BEGIN
        DoMethod(obj,TAG(buffer,
                    omREMMEMBER, member));
    END RemMember;

(*
** AddMember (obj,member)
*)

PROCEDURE AddMember(obj : APTR; member : APTR);
    BEGIN
        DoMethod(obj,TAG(buffer,
                    omADDMEMBER, member));
    END AddMember;

END MuiMacros.







