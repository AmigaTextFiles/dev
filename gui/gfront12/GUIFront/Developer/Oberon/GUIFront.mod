(*------------------------------------------

  :Module.      GUIFront.mod
  :Author.      Volker Stolz, <Vok@TinDrum.tng.oche.de>
  :Address.     Kückstr. 54; 52499 Baesweiler; Germany
  :Date.        01-Oct-1995
  :Copyright.   This module is © 1995 by Volker Stolz.
  :Copyright.   It may be distributed freely as long as it remains unchanged.
  :Language.    Oberon-2
  :Translator.  Amiga Oberon V3.11d

  :Contents.    Interface to Michael Berg`s guifront.library

  :Remarks.     Remember to check "base # NIL" and library-version !
  :Remarks.     Private data is not exported.

  :Remarks.     Please report any bugs & suggestions to
  :Remarks.     <Vok@TinDrum.tng.oche.de> (Volker Stolz) or to
  :Remarks.     <mberg@datashopper.dk> (Michael Berg).

  :History.     v0.1 01-Oct-1995 : first release to M. Berg

  :Version.     $VER: GUIFront.mod 38.1 (01.10.95) Oberon 3.11d

--------------------------------------------*)
MODULE GUIFront;

IMPORT
  ASL *,
  E   *: Exec,
  U   *: Utility,
  I   *: Intuition,
  GT  *: GadTools;

CONST
  GUIFrontName    *= "guifront.library";
  GUIFrontVersion *= 38;

CONST
(* Tags for CreateGUIAppA() *)
  gfaAuthor              *= U.user;    (* Author of software (70 chars max) *)
  gfaDate                *= U.user+1;  (* Date of release (14 chars max) *)
  gfaLongDesc            *= U.user+2;  (* Longer description (70 chars max) *)
  gfaVersion             *= U.user+3;  (* Version information (20 chars max) *)
  gfaVisualUpdateSigTask *= U.user+4;  (* Task to signal when prefs change (defaults to FindTask(0)) *)
  gfaVisualUpdateSigBit  *= U.user+5;  (* Signal to send task when prefs change *)

CONST
(* Tags for CreateGUIA() *)
  guiInitialOrientation *= U.user;
  guiInitialSpacing     *= U.user+1;
  guiLocaleFunc         *= U.user+2;
  guiExtendedError      *= U.user+3;
  guiUserData           *= U.user+4;
  guiOpenGUI            *= U.user+5;
  guiExtraIDCMP         *= U.user+6;
  guiWindowTitle        *= U.user+7;
  guiWindow             *= U.user+8;   (* Read-only *)
  guiBackfill           *= U.user+9;   (* Please backfill this window *)
  guiNewMenu            *= U.user+10;
  guiNewMenuLoc         *= U.user+11;
  guiMenuStrip          *= U.user+12;  (* Read-only *)
  guiActualFont         *= U.user+13;  (* Read-only *)
  guiScreenTitle        *= U.user+14;
  guiLeftEdge           *= U.user+15;
  guiTopEdge            *= U.user+16;
  guiHelp               *= U.user+17;  (* Not currently implemented *)
  (* V38 *)
  guiGroupMask          *= U.user+18;  (* Group masking bits *)
  guiGadgetMask         *= U.user+19;  (* Gadget masking bits *)
  guiLockGUI            *= U.user+20;  (* Like LockGUI() *)

CONST
(* Extended error report from CreateGUIA() (via GUI_ExtendedError) *)
  gfErrUnkown                 *= 100;  (* Unknown error *)
  gfErrNotEnoughMemory        *= 101;
  gfErrMissingLocalizer       *= 102;  (* Found GS_LocaleFunc but no GUI_Localizer *)
  gfErrGUITooWide             *= 103;
  gfErrGUITooTall             *= 104;
  gfErrCantFindScreen         *= 105;  (* Can`t find or open require screen *)
  gfErrMissingGadgetSpecArray *= 106;  (* GUIL_GadgetSpecID used but no GUI_GadgetSpecArray supplied *)
  gfErrCantFindGadgetSpecID   *= 107;  (* Unable to locate gadget with this ID *)
  gfErrUnknownLayoutTag       *= 108;  (* Layout tag list contains garbage *)
  gfErrCantOpenWindow         *= 109;  (* Unable to open gui (GUI_OpenGUI) *)
  gfErrCantCreateMenus        *= 110;  (* Unable to create or layout menus *)

TYPE
  ExtErrorData *= STRUCT
                    errorCode *: E.ULONG;
                    errorData *: E.ULONG;
                  END;

CONST
(* Tags for gadget layout lists *)
  guiLVertGroup        *=  1;
  guiLHorizGroup       *=  2;
  guiLGadgetSpec       *=  3;
  guiLGadgetSpecID     *=  4;
  guiLFrameType        *=  5;          (* See below *)
  guiLHFrameOffset     *=  6;
  guiLVFrameOffset     *=  7;
  guiLFlags            *=  8;          (* See below *)
  guiLFrameHeadline    *=  9;
  guiLFrameHeadlineLoc *= 10;          (* Localized - will call your localizer function *)
  (* V38 *)
  guiLGadgetMask       *= 11;          (* Set current gadget masking value *)
  guiLGroupMask        *= 12;          (* Set masking value for current group *)

(* GUILFlags *)
CONST
(* Extension methods *)                (* Members maintain their relative size *)
  guiLFPropShare   *= 0;               (* All members forced to equally share all available space *)
  guiLFEqualShare  *= 1;               (* All members forced to equal size *)
  guiLFEqualSize   *= 2;
(* Secondary dimension adjustments *)
  guiLFEqualWidth  *= 3;
  guiLFEqualHeight *= guiLFEqualWidth;

(* Special label layout *)
  guiLFLabelAlign  *= 4;

(* FrameType *)
  guiLFTNormal      *= 1;
  guiLFTRecess      *= 2;
  guiLFTRidge       *= 3;              (* NeXT style *)
  guiLFTIconDropBox *= 4;              (* Not implemented *)

TYPE
(* GadgetSpec *)
  GadgetSpec *= STRUCT
                  kind      *: E.ULONG;
                  minWidth,
                  minHeight *: E.UWORD;
                  ng        *: GT.NewGadget;
                  tags      *: U.TagItemPtr;
                  flags     *: SET;                (* See below *)
                  private    : ARRAY 5 OF E.ULONG; (* Hands off ! :-) *)
                  gadget    *: I.GadgetPtr;        (* Valid when gadget has been created - Read only! *)
                END;
  GadgetSpecPtr *= UNTRACED POINTER TO GadgetSpec;

CONST
(* GadgetSpec-Flags *)
  gsNoWidthExtend   *= 0;              (* Lock hitbox width *)
  gsNoHeightExtend  *= 1;              (* Lock hitbox height *)
  gsLocalized       *= 2;              (* Call localizer with this gadget *)
  gsBoldLabel       *= 3;              (* Render label in bold-face *)
  gsDefaultTags     *= 4;              (* Supply reasonable default tags *)

TYPE
(* Hook message (GS_LocaleFunc hook) *)
  LocaleHookMsgData *= STRUCT END;

  StringIDData *= STRUCT (dummy *: LocaleHookMsgData)
                    stringID *: E.ULONG;
                  END;

  GadgetSpecData *= STRUCT (dummy *: LocaleHookMsgData)
                      lhmdGadgetSpec *: GadgetSpecPtr;
                    END;

  NewMenuData *= STRUCT (dummy *: LocaleHookMsgData)
                   lhmdNewMenu *: GT.NewMenuPtr;
                 END;

  LocaleHookMsg *= STRUCT
                     kind *: E.UWORD;  (* What are we trying to localize here ? *)
        (* Your hook should look at the following union, localize the item in
          question (lhm_Kind tells you which), and return the localized
          string.
        *)
                     data *: LocaleHookMsgData;
                   END;

CONST
(* LocalHookMsg.kind *)
  lhmkStringID   *= 0;                 (* Obtain generic catalog string *)
  lhmkGadgetSpec *= 1;                 (* Return localized GadgetSpec string *)
  lhmkNewMenu    *= 2;                 (* Return localized NewMenu string *)

TYPE
(* Black-box access to private structures *)
  GUIFront       *= STRUCT END;        (* Per-gui anchor structure *)
  GUIFrontPtr    *= UNTRACED  POINTER TO GUIFront;

  GUIFrontApp    *= STRUCT END;        (* Per-application anchor structure *)
  GUIFrontAppPtr *= UNTRACED  POINTER TO GUIFrontApp;

CONST
(*GUIFront bonus kinds *)
  getAltKind *= 8000H;

(* Gadget creation tags for getAltKind *)
  altImage        *= U.user;           (* See enum below *)
  altAslTags      *= U.user+1;         (* (Utility.TagItemPtr) Tag items for ASL requester *)
  altAslRequester *= U.user+2;         (* (BOOL) Enable automatic ASL requester *)
  altXenMode       = U.user+3;         (* Do not use *)
  altFrameColor    = U.user+4;         (* Do not use *)

CONST
(* Image Types (altImage) *)
  altiGetMisc       *= 0;              (* Arrow down with line (get anything) *)
  altiGetDir        *= 1;              (* Folder image (get directory or volume) *)
  altiGetFile       *= 2;              (* Paper image (get a file) *)
  altiGetFont       *= 3;              (* Character image *)
  altiGetScreenMode *= 4;              (* Monitor image (well, kinda looks like a monitor :-) *)

(*** Preferences related stuff ***)

TYPE
(* Black-box access to preferences nodes (all fields are private) *)
  PrefsHandle *= STRUCT END;
  PrefsHandlePtr *= UNTRACED POINTER TO PrefsHandle;

CONST
(* Tags for GetPrefAttrA() and SetPrefAttrA() *)

(* Flags *)
  prfGadgetScreenFont   *= U.user;     (* BOOL *)
  prfFrameScreenFont    *= U.user+ 1;  (* BOOL *)
(* Backfill control magic *)
  prfAllowBackfill      *= U.user+ 2;  (* BOOL *)
  prfBackfillFGPen      *= U.user+ 3;  (* UWORD *)
  prfBackfillBGPen      *= U.user+ 4;  (* UWORD *)
(* Frametype preferences (per supported gadgetkind *)
  prfFrameStyleQuery    *= U.user+ 5;

  prfXenFrameColor      *= U.user+ 6;  (* UWORD *)
  prfGadgetFontYSize    *= U.user+ 7;  (* UWORD *)
  prfGadgetFontName     *= U.user+ 8;  (* max 50 chars *)
  prfFrameFontName      *= U.user+ 9;  (* max 50 chars *)
  prfFrameFontYSize     *= U.user+10;  (* UWORD *)
  prfFrameFontBold      *= U.user+11;  (* BOOL *)
  prfFrameFontItalics   *= U.user+12;  (* BOOL *)
  prfFrameFont3D        *= U.user+13;  (* BOOL *)
  prfFrameFontFGPen     *= U.user+14;  (* UWORD *)
  prfFrameFontCenter    *= U.user+15;  (* BOOL *)
  prfFrameFontCentering *= U.user+16;  (* see prffc below *)

(* Miscellaneous *)
  prfSimpleRefresh      *= U.user+17;  (* BOOL *)

(* Application Info (READ ONLY!) *)
  prfAuthor             *= U.user+18;  (* max 70 chars *)
  prfDate               *= U.user+19;  (* max 14 chars *)
  prfLongDesc           *= U.user+20;  (* max 70 chars *)
  prfVersion            *= U.user+21;  (* max 20 chars *)

(* Public Screen tags (V38) *)
  prfPubScreenType      *= U.user+22;  (* UWORD *)
  prfPubScreenName      *= U.user+23;  (* LSTRPTR *)

CONST
(* Frame headline centering *)
  prffcLeft   *= 0;                    (* Left aligned *)
  prffcCenter *= 1;                    (* Centered *)
  prffcRight  *= 2;                    (* Right aligned *)

TYPE
  FrameStyleQuery *= STRUCT
                       gadgetKind *: LONGINT; (* As passed to CreateGadgetA() *)
                       xen        *: BOOLEAN; (* TRUE: Xen, FALSE : Normal *)
                     END;

CONST
(* Tags for GF_GetGUIAppAttrA()/GF_SetGUIAppAttrA() *)
  guiaWindowPort *= U.user;            (* Read only *)
  guiaUserData   *= U.user+1;          (* Free for application use *)

CONST
(* Tags for GF_GetPubScreenAttrA()/GF_SetPubScreenAttrA() (V38) *)
  psaDisplayID      *= U.user;         (* ULONG *)
  psaWidth          *= U.user+ 1;      (* UWORD *)
  psaHeight         *= U.user+ 2;      (* UWORD *)
  psaDepth          *= U.user+ 3;      (* UWORD *)
  psaOverscan       *= U.user+ 4;      (* UWORD *)
  psaDraggable      *= U.user+ 5;      (* BOOL *)
  psaInterleaved    *= U.user+ 6;      (* BOOL *)
  psaAutoScroll     *= U.user+ 7;      (* BOOL *)
  psaLeaveOpen      *= U.user+ 8;      (* BOOL *)
  psaShowTitle      *= U.user+ 9;      (* BOOL *)
  psaBehind         *= U.user+10;      (* BOOL *)
  psaQuiet          *= U.user+11;      (* BOOL *)
  psaSharePens      *= U.user+12;      (* BOOL *)
  psaExclusive      *= U.user+13;      (* BOOL *)
  psaMakeDefault    *= U.user+14;      (* BOOL *)
  psaPopPubScreen   *= U.user+15;      (* BOOL *)
  psaShanghai       *= U.user+16;      (* BOOL *)
  psaScreenTitle    *= U.user+17;      (* max 139 chars *)
  psaScreenFont     *= U.user+18;      (* max 50 chars *)
  psaScreenFontSize *= U.user+19;      (* UWORD *)

TYPE
  AppID *= ARRAY 50 OF CHAR;

VAR
  base -: E.LibraryPtr;

PROCEDURE CreateGUIApp *{base,-30} (name{8} : E.STRPTR; tag1{9}.. : U.Tag) : GUIFrontAppPtr;
PROCEDURE CreateGUIAppA *{base,-30} (name{8} : E.STRPTR; tagList{9} : ARRAY OF U.TagItem) : GUIFrontAppPtr;
PROCEDURE DestroyGUIApp *{base,-36} (app{8} : GUIFrontAppPtr);

PROCEDURE GetGUIAppAttr *{base,-42} (app{8} : GUIFrontAppPtr; tag1{9}.. : U.Tag) : E.ULONG;
PROCEDURE GetGUIAppAttrA *{base,-42} (app{8} : GUIFrontAppPtr; tagList{9} : ARRAY OF U.TagItem) : E.ULONG;
PROCEDURE SetGUIAppAttr *{base,-48} (app{8} : GUIFrontAppPtr; tag1{9}.. : U.Tag) : E.ULONG;
PROCEDURE SetGUIAppAttrA *{base,-48} (app{8} : GUIFrontAppPtr; tagList{9} : ARRAY OF U.TagItem) : E.ULONG;

PROCEDURE DestroyGUI *{base,-54} (gui{8} : GUIFrontPtr);
PROCEDURE CreateGUI *{base,-60} (app{8} : GUIFrontAppPtr; layout{9} : E.ULONG; gSpec{10} : ARRAY OF GadgetSpecPtr; tag1{11}.. : U.Tag) : GUIFrontPtr;
PROCEDURE CreateGUIA *{base,-60} (app{8} : GUIFrontAppPtr; layout{9} : E.ULONG; gSpec{10} : ARRAY OF GadgetSpecPtr; tagList{11} : ARRAY OF U.TagItem) : GUIFrontPtr;

PROCEDURE GetGUIAttr *{base,-66} (gui{8} : GUIFrontPtr; tag1{9}.. : U.Tag) : E.ULONG;
PROCEDURE GetGUIAttrA *{base,-66} (gui{8} : GUIFrontPtr; tagList{9} : ARRAY OF U.TagItem) : E.ULONG;

PROCEDURE SetGUIAttr *{base,-72} (gui{8} : GUIFrontPtr; tag1{9}.. : U.Tag) : E.ULONG;
PROCEDURE SetGUIAttrA *{base,-72} (gui{8} : GUIFrontPtr; tagList{9} : ARRAY OF U.TagItem) : E.ULONG;

PROCEDURE GetIMsg *{base,-78} (app{8} : GUIFrontAppPtr) : I.IntuiMessagePtr;
PROCEDURE Wait *{base,-84} (app{8} : GUIFrontAppPtr; other{0} : E.ULONG) : E.ULONG;
PROCEDURE ReplyIMsg *{base,-90} (msg{8} : I.IntuiMessagePtr);

PROCEDURE SetAliasKey *{base,-96} (gui{8} : GUIFrontPtr; rawkey{0} : E.UBYTE; gadgetID{1} : E.UWORD) : BOOLEAN;

PROCEDURE BeginRefresh *{base,-102} (gui{8} : GUIFrontPtr);
PROCEDURE EndRefresh *{base,-108} (gui{8} : GUIFrontPtr; all{0} : BOOLEAN);

PROCEDURE SetGadgetAttrs *{base,-114} (gui{8} : GUIFrontPtr; gad{9} : I.GadgetPtr; tag1{10}.. : U.Tag);
PROCEDURE SetGadgetAttrsA *{base,-114} (gui{8} : GUIFrontPtr; gad{9} : I.GadgetPtr; tagList{10} : ARRAY OF U.TagItem);
PROCEDURE GetGadgetAttrs *{base,-120} (gui{8} : GUIFrontPtr; gad{9} : I.GadgetPtr; tag1{10}.. : U.Tag) : E.ULONG;
PROCEDURE GetGadgetAttrsA *{base,-120} (gui{8} : GUIFrontPtr; gad{9} : I.GadgetPtr; tagList{10} : ARRAY OF U.TagItem) : E.ULONG;

PROCEDURE LockGUI *{base,-126} (gui{8} : GUIFrontPtr);
PROCEDURE UnlockGUI *{base,-132} (gui{8} : GUIFrontPtr);
PROCEDURE LockGUIApp *{base,-138} (app{8} : GUIFrontAppPtr);
PROCEDURE UnlockGUIApp *{base,-144} (app{8} : GUIFrontAppPtr);

PROCEDURE LoadPrefs *{base,-150} (name{8} : ARRAY OF CHAR) : BOOLEAN;
PROCEDURE SavePrefs *{base,-156} (name{8} : ARRAY OF CHAR) : BOOLEAN;
PROCEDURE LockPrefsList *{base,-162};
PROCEDURE UnlockPrefsList *{base,-168};
PROCEDURE FirstPrefsNode *{base,-174} () : PrefsHandlePtr;
PROCEDURE NextPrefsNode *{base,-180} (handle{8} : PrefsHandlePtr) : PrefsHandlePtr;
PROCEDURE CopyAppID *{base,-186} (handle{8} : PrefsHandlePtr; VAR buffer{9} : AppID);
PROCEDURE GetPrefsAttr *{base,-192} (appID{8} : AppID; tag1{9}.. : U.Tag);
PROCEDURE GetPrefsAttrA *{base,-192} (appID{8} : AppID; tagList{9} : ARRAY OF U.TagItem);
PROCEDURE SetPrefsAttr *{base,-198} (appID{8} : AppID; tag1{9}.. : U.Tag);
PROCEDURE SetPrefsAttrA *{base,-198} (appID{8} : AppID; tagList{9} : ARRAY OF U.TagItem);
PROCEDURE DeletePrefs *{base,-204} (appID{8} : AppID) : BOOLEAN;
PROCEDURE DefaultPrefs *{base,-210} (appID{8} : AppID) : BOOLEAN;
PROCEDURE NotifyPrefsChange *{base,-216} (task{8} : E.TaskPtr; signals{0} : E.ULONG) : BOOLEAN;
PROCEDURE EndNotifyPrefsChange *{base,-222} (task{8} : E.TaskPtr);

PROCEDURE AslRequest *{base,-228} (req{8} : ASL.ASLRequesterPtr; tag1{9}.. : U.Tag) : BOOLEAN;
PROCEDURE AslRequestTags *{base,-228} (req{8} : ASL.ASLRequesterPtr; tagList{9} : ARRAY OF U.TagItem) : BOOLEAN;
PROCEDURE EasyRequest *{base,-234} (app{0} : GUIFrontAppPtr; win{1} : I.WindowPtr; easyStruct{8} : I.EasyStructPtr; idcmpPtr{9} : E.ULONG ;tag1{10}.. : U.Tag) : LONGINT;
PROCEDURE EasyRequestArgs *{base,-234} (app{0} : GUIFrontAppPtr; win{1} : I.WindowPtr; easyStruct{8} : I.EasyStructPtr; idcmpPtr{9} : E.ULONG; tagList{10} : U.Tag) : LONGINT;
PROCEDURE ProcessListView *{base,-240} (gui{8} : GUIFrontPtr; gadgetSpec{9} : GadgetSpecPtr; iMsg{10} : I.IntuiMessagePtr; ordinal{11} : E.UWORD) : BOOLEAN;

(* New in 37.3 *)
PROCEDURE SignalPrefsVChange *{base,-246} (appID{8} : AppID);

(* New in 38.1 *)
PROCEDURE GetPubScreenAttr *{base,-252} (appID{8} : AppID; tag1{9}.. : U.Tag) : E.ULONG;
PROCEDURE GetPubScreenAttrA *{base,-252} (appID{8} : AppID; tagList{9} : ARRAY OF U.TagItem) : E.ULONG;
PROCEDURE SetPubScreenAttr *{base,-258} (appID{8} : AppID; tag1{9}.. : U.Tag) : E.ULONG;
PROCEDURE SetPubScreenAttrA *{base,-258} (appID{8} : AppID; tagList{9} : ARRAY OF U.TagItem) : E.ULONG;

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

(* Remember : YOU are to check "base # NIL" and library-version !!! *)

BEGIN
  base:=E.OpenLibrary(GUIFrontName,0);

CLOSE
  IF base # NIL THEN E.CloseLibrary(base); END;

END GUIFront.
