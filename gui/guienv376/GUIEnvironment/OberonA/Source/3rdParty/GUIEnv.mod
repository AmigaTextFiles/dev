(****************************************************************************

$RCSfile: GUIEnv.mod $

$Revision: 1.8 $
    $Date: 1994/12/18 15:16:03 $

    Oberon-2 interface module for GUIEnvironment

    Oberon-A Oberon-2 Compiler V4.17 (Release 1.4 Update 2)

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany


****************************************************************************)
MODULE GUIEnv;

(* $P- Allow non-portable code *)


IMPORT K := Kernel,
       E := Exec,
       G := Graphics,
       I := Intuition,
       U := Utility;


CONST

  Name* = "guienv.library";     (* Library name *)
  Version* = 37;                (* min version / Revision 2 !*)


(* ======================================================================= *)
(*                               Error codes                               *)
(* ======================================================================= *)

CONST

  geDone             *=   0;   (* no error, everything done *)
  geMemoryErr        *=   1;   (* not enough memory *)
  geWindowErr        *=   2;   (* no window specified *)
  geVisualInfoErr    *=   3;   (* couldn't get VisualInfo *)
  geDrawInfoErr      *=   4;   (* couldn't get DrawInfo *)
  geGuideErr         *=  50;   (* couldn't display AmigaGuide node *)

  geGadContextErr    *= 100;   (* GadTools CreateContext failed *)
  geGadCreateErr     *= 101;   (* error calling CreateGadget/NewObject *)
  geGadTooManyErr    *= 102;   (* more than 256 gadgets *)
  geGadKeyTwiceErr   *= 103;   (* same key equivalent for two gadgets *)
  geGadUnknownKind   *= 104;   (* unknown gadget kind *)
  geGadChainErr      *= 105;   (* ChainStart/ChainEnd missing *)
  geGadHookErr       *= 106;   (* Hook function failed *)

  geMenuCreateErr    *= 200;   (* error calling CreateMenu *)
  geMenuStripErr     *= 201;   (* error calling SetMenuStrip *)
  geMenuLayoutErr    *= 202;   (* error calling LayoutMenus *)
  geMenuTooManyErr   *= 203;   (* more than 256 menu items *)


(* ======================================================================= *)
(*                         GE Hook functions                               *)
(* ======================================================================= *)

(* The GUIEnvironment hook functions:
   - The hook functions are implemented as amiga callback hooks as
     documented in the Utilities documentation
   - Before a hook functions is called, the A4 register is set
   - The A0 register points to Hook structure
   - The A1/A2 register are used as stated below

*)

(* ------------------------ return values -------------------------------- *)

  gehKeyShifted  *= 512;
  gehKeyUnknown  *= -1;

(* ------------------------ The hook functions --------------------------- *)

TYPE

         (* Hook function for key equivalents:

              A1      : Currently unused, set to NIL
              A2      : LONGINT : The ASCII character code
              RESULT  : LONGINT : gehKeyUnknown if the key is not a key
                                  equivalent or the number of the gadget,
                                  or the number of the gadget plus
                                  gehKeyShifted !

         *)

         (* Handle message hook

              A1, A2  : Currently unused, set to NIL
              RESULT  : LONGINT, handled as BOOLEAN
                        Return TRUE, if GUIEnv should not work on the
                        message anymore, otherwise FALSE


            Refresh hook

              A1, A2  : Currently unused, set to NIL
              RESULT  : Currently unused, set this always to 0 !

         *)

         (* Gadget event message hook

              A2      : Pointer to event gadget
              A1      : Currently unused, set to NIL
              RESULT  : LONGINT, handled as BOOLEAN
                        If you want to wait for further messages return
                        TRUE, otherwise FALSE to exit the message-loop.


            Menu event message hook

              A2      : Pointer to event menu item (if possible)
              A1      : Currently unused, set to NIL
              RESULT  : LONGINT, handled as BOOLEAN
                        If you want to wait for further messages return
                        TRUE, otherwise FALSE to exit the message-loop.


            Gadget creation hook

              A2      : Pointer to event gadget
              A1      : Currently unused, set to NIL
              RESULT  : LONGINT, handled as BOOLEAN
                        If your creation hook has done his work, return
                        TRUE, otherwise FALSE to stop creation !

         *)

(* ======================================================================= *)
(*                               Gadgets                                   *)
(* ======================================================================= *)

CONST
(* ----------------------- gadget kinds ---------------------------------- *)

  gegKinds                 *=  65535; (* GUIEnv gadgets *)
  gegProgressIndicatorKind *=  65536;
  gegBevelboxKind          *=  65537;
  gegBorderKind            *=  65538;

  gegBOOPSIKinds           *= 131071; (* BOOPSI gadgets *)
  gegBOOPSIPublicKind      *= 131072;
  gegBOOPSIPrivateKind     *= 131073;

(* ----------------------- gadget chain flags ---------------------------- *)

  gegChainUpNext     *= 0;  (* 16 bits *)
  gegChainUpPrev     *= 1;
  gegChainDownNext   *= 2;
  gegChainDownPrev   *= 3;


(* ----------------------- gadget description flags ---------------------- *)

CONST
  gegDistNorm    *=  0;  (* Normal distance *)
  gegDistAbs     *=  1;  (* absolute distance from an object *)
  gegDistRel     *=  2;  (* relative distance from an object *)
  gegDistPercent *=  3;  (* percentual distance *)

  gegObjBorder   *=  0;  (* window border *)
  gegObjGadget   *=  4;  (* gadget (standard is previous gadget) *)

  gegObjRight    *=  0;  (* distance from which part of the object *)
  gegObjBottom   *=  0;
  gegObjLeft     *= 32;
  gegObjTop      *= 32;

(* ----------------------- gadget tag values ----------------------------- *)

  gegACTIVATIONUP  *=  0;
  gegACTIVATIONDOWN*=  1;


  gegALLGADGETS    *= -1;

(* ----------------------- gadget tags ----------------------------------- *)

  gegBase *= U.tagUser + 016000H;
  gegText            *= gegBase +  1;
  gegFlags           *= gegBase +  2;
  gegFont            *= gegBase +  3;
  gegUserData        *= gegBase +  4;
  gegDescription     *= gegBase +  5;
  gegObjects         *= gegBase +  6;
  gegGuideNode       *= gegBase +  7;
  gegCatalogString   *= gegBase + 10;
  gegClass           *= gegBase + 11;
  gegVarAddress      *= gegBase + 12;
  gegHandleInternal  *= gegBase + 13;
  gegStartChain      *= gegBase + 14;
  gegEndChain        *= gegBase + 15;
  gegActivate        *= gegBase + 16;
  gegChainActivation *= gegBase + 17;
  gegStatus          *= gegBase + 19;
  gegUpAHook         *= gegBase + 20;
  gegDownAHook       *= gegBase + 21;
  gegCreationAHook   *= gegBase + 22;

  gegPIMaxValue      *= gegBase + 50;
  gegPICurrentValue  *= gegBase + 51;
  gegBBRecessed      *= gegBase + 52;

  gegDisable         *= gegBase + 100;
  gegEnable          *= gegBase + 101;
  gegSetVar          *= gegBase + 102;
  gegGetVar          *= gegBase + 103;
  gegActivateUp      *= gegBase + 104;
  gegActivateDown    *= gegBase + 105;

  gegAddress         *= gegBase + 200;
  gegLeftEdge        *= gegBase + 201;
  gegTopEdge         *= gegBase + 202;
  gegWidth           *= gegBase + 203;
  gegHeight          *= gegBase + 204;
  gegRedraw          *= gegBase + 205;


(* ----------------------- GUIGadgetInfo structure ------------------------ *)

TYPE

  GUIGadgetInfoPtr *= CPOINTER TO GUIGadgetInfo; (* gadget^.userData *)

  GUIGadgetInfo *= RECORD  (* a pointer to this structure is stored in
                             gadget^.userData *)
    userData - : E.APTR;    (* use this for own user data *)
    kind     - : LONGINT;   (* gadget kind *)

    gadgetClass - : E.APTR; (* The BOOPSI Gadget Class *)

    functionUp   - : U.HookPtr;
    functionDown - : U.HookPtr;

    guideNode- : E.STRPTR;  (* The AmigaGuide node for this gadget *)

  END;


(* ======================================================================= *)
(*                             Menu Items                                  *)
(* ======================================================================= *)

CONST
(* ---------------------- menu item tags --------------------------------- *)

  gemBase *= U.tagUser + 018000H;
  gemUserData        *= gemBase + 1;
  gemGuideNode       *= gemBase + 3;
  gemCatalogString   *= gemBase + 4;
  gemShortCut        *= gemBase + 5;
  gemFlags           *= gemBase + 6;
  gemMutualExclude   *= gemBase + 7;
  gemAHook           *= gemBase + 8;

(* ---------------------- GUIMenuInfo structure -------------------------- *)

TYPE

  GUIMenuInfoPtr *= CPOINTER TO GUIMenuInfo; (* menu^.userData *)

  GUIMenuInfo *= RECORD    (* a pointer to this structure is stored in
                              menuitem^.userData *)
    userData - : E.APTR;     (* use this for own user data *)

    function - : U.HookPtr;

    guideNode- : E.STRPTR;   (* The AmigaGuide node for this menuitem *)

  END;



(* ======================================================================= *)
(*                            GUIInfo                                      *)
(* ======================================================================= *)

(* -------------------------- GUIInfo structure -------------------------- *)

  GUIInfoPtr *= CPOINTER TO GUIInfo;
  GUIInfo *= RECORD
    window     - : I.WindowPtr;         (* pointer to the used Window *)
    screen     - : I.ScreenPtr;         (* pointer to window's screen *)
    visualInfo - : E.APTR;              (* pointer to screen's VisualInfo *)
    drawInfo   - : I.DrawInfoPtr;       (* pointer to a copy of DrawInfo *)
    localeInfo - : E.APTR;              (* pointer to locale environment *)

    menuFont - : G.TextAttrPtr;         (* pointer to menu-font. Is set to
                                           screens font. *)

    creationWidth  - : INTEGER;       (* window inner width *)
    creationHeight - : INTEGER;       (* window inner height *)

    msgPort  - : E.MsgPortPtr;        (* Pointer to IDCMP-Port *)

    intuiMsg - : I.IntuiMessagePtr;   (* Points to a copy of the
                                         FULL IntuiMessage even if it
                                         is extended (OS3.0+) *)

 (* Additional information about the message: *)
    msgClass - : SET;

    msgCode     - : INTEGER;
    msgBoolCode - : BOOLEAN;
    msgCharCode - : CHAR;

    msgGadget  - : I.GadgetPtr;

    msgItemAdr - : I.MenuItemPtr;

    msgGadNbr  - : INTEGER;

    msgMenuNum - : INTEGER;
    msgItemNum - : INTEGER;
    msgSubNum  - : INTEGER;

 (* Some user stuff: *)
    userData      - : E.APTR;         (* for own data *)
    compilerReg   - : E.APTR;         (* for compiler data reg *)

    gadgetGuide   - : E.APTR;         (* name & path for the guide *)
    menuGuide     - : E.APTR;         (* name & path for the guide *)

    catalogInfo   - : E.APTR;         (* points to the catalog given
                                         with the GUI_CatalogFile tag *)
    gadgetCatalogString - : LONGINT;  (* The number of the next string *)
    menuCatalogString   - : LONGINT;  (* in the catalog *)

    vanKeyHook    - : U.HookPtr;        (* Hook functions *)
    handleMsgHook - : U.HookPtr;
    refreshHook   - : U.HookPtr;

    hookInterface - : E.APTR;

    creationFont  - : G.TextAttrPtr;  (* GUIDefinition: text/gadget font *)
    textFont      - : G.TextAttrPtr;  (* Font for gadgets and text *)

  END;

CONST

(* --------------------------- GUI Tags ------------------------------------ *)

  guiBase *= U.tagUser + 015000H;
  guiTextFont            *= guiBase +  1;
  guiMenuFont            *= guiBase +  2;
  guiCreateError         *= guiBase +  4;
  guiUserData            *= guiBase +  5;
  guiCompilerReg         *= guiBase +  6;
  guiGadgetGuide         *= guiBase +  8;
  guiMenuGuide           *= guiBase +  9;
  guiCatalogFile         *= guiBase + 10;
  guiGadgetCatalogOffset *= guiBase + 11;
  guiMenuCatalogOffset   *= guiBase + 12;
  guiCreationWidth       *= guiBase + 13;
  guiCreationHeight      *= guiBase + 14;
  guiMsgPort             *= guiBase + 16;
  guiRefreshAHook        *= guiBase + 17;
  guiHandleMsgAHook      *= guiBase + 18;
  guiVanKeyAHook         *= guiBase + 19;
  guiHookInterface       *= guiBase + 20;
  guiCreationFont        *= guiBase + 21;
  guiPreserveWindow      *= guiBase + 22;

  guiRemoveMenu          *= guiBase + 100;
  guiRemoveGadgets       *= guiBase + 101;
  guiClearWindow         *= guiBase + 102;
  guiEmptyMsgPort        *= guiBase + 103;
  guiDoBeep              *= guiBase + 104;
  guiLock                *= guiBase + 105;  (* Requires ReqTools *)
  guiUnLock              *= guiBase + 106;  (* Requires ReqTools *)


(* -------------------- Preserve Window Flags ---------------------------- *)

  guiPWFull    *= 0;   (* Preserve the window and the min and max values *)
  guiPWSize    *= 1;   (* Preserve only the window *)
  guiPWMinMax  *= 2;   (* Preserve only the min and max values *)


(* ======================================================================= *)
(*                             Requester                                   *)
(* ======================================================================= *)

(* -------------------- Requester kinds ---------------------------------- *)

  gerGeneralKind *= 0;
  gerOKKind      *= 1;
  gerDoItKind    *= 2;
  gerYNCKind     *= 3;
  gerFileKind    *= 4;
  gerDirKind     *= 5;

  gerRTKind      *= 100;  (* Requires ReqTools *)
  gerRTOKKind    *= 101;
  gerRTDoItKind  *= 102;
  gerRTYNCKind   *= 103;
  gerRTFileKind  *= 104;
  gerRTDirKind   *= 105;

(* --------------------- Return values ----------------------------------- *)

  gerCancel *= 0;  (* gerYNCKind / gerDoItKind / gerOKKind /
                     gerFileKind / gerDirKind*)
  gerYes    *= 1;  (* gerYNCKind / gerDoItKind / gerFileKind / gerDirKind *)
  gerNo     *= 2;  (* gerYNCKind *)

(* --------------------- Requester tags ---------------------------------- *)

  gerBase *= U.tagUser + 017000H;
  gerGadgets        *= gerBase +  1;
  gerArgs           *= gerBase +  2;
  gerFlags          *= gerBase +  3;
  gerTitle          *= gerBase +  4;
  gerIDCMP          *= gerBase +  5;
  gerPattern        *= gerBase +  6;
  gerNameBuffer     *= gerBase +  7;
  gerFileBuffer     *= gerBase +  8;
  gerDirBuffer      *= gerBase +  9;
  gerSave           *= gerBase + 10;
  gerLocaleID       *= gerBase + 11;

(* ======================================================================= *)
(*                              Windows                                    *)
(* ======================================================================= *)

(* ---------------------- window tags ------------------------------------ *)

  gewBase *= U.tagUser + 019000H;
  gewOuterSize *= gewBase + 1;


(* --- Library Base variable -------------------------------------------- *)

TYPE GUIEnvBase * = E.Library;
     GUIEnvBasePtr * = CPOINTER TO GUIEnvBase;

VAR

  base *  : GUIEnvBasePtr;


(* --- Library Functions ------------------------------------------------ *)

  LIBCALL (base : GUIEnvBasePtr) OpenGUIFont *
          (name[8] : E.STRPTR;
           size[0] : INTEGER;
           font[9] : G.TextAttrPtr) : G.TextFontPtr;    -30;

  LIBCALL (base : GUIEnvBasePtr) CloseGUIFont *
          (font[8] : G.TextFontPtr);            -36;

  LIBCALL (base : GUIEnvBasePtr) OpenGUIScreenA *
          (id[0] : LONGINT;
           depth[1]: INTEGER;
           name[8] : E.STRPTR;
           tags[9] : ARRAY OF U.TagItem) : I.ScreenPtr;    -42;

  LIBCALL (base : GUIEnvBasePtr) OpenGUIScreen *
          (id[0] : LONGINT;
           depth[1]: INTEGER;
           name[8] : E.STRPTR;
           tags[9].. : U.Tag) : I.ScreenPtr;    -42;

  LIBCALL (base : GUIEnvBasePtr) OpenGUIWindowA *
          (left[0] : INTEGER;
           top[1]  : INTEGER;
           width[2]  : INTEGER;
           height[3] : INTEGER;
           name[8] : E.STRPTR;
           idcmpFlags[4]  : SET;
           windowFlags[5] : SET;
           screen[9] : I.ScreenPtr;
           tags[10]  : ARRAY OF U.TagItem) : I.WindowPtr;  -48;

  LIBCALL (base : GUIEnvBasePtr) OpenGUIWindow *
          (left[0] : INTEGER;
           top[1]  : INTEGER;
           width[2]  : INTEGER;
           height[3] : INTEGER;
           name[8] : E.STRPTR;
           idcmpFlags[4]  : SET;
           windowFlags[5] : SET;
           screen[9] : I.ScreenPtr;
           tags[10].. : U.Tag) : I.WindowPtr;  -48;

  LIBCALL (base : GUIEnvBasePtr) CloseGUIWindow *
          (window[8] : I.WindowPtr);                -54;

  LIBCALL (base : GUIEnvBasePtr) CloseGUIScreen *
          (screen[8] : I.ScreenPtr);                -60;

  LIBCALL (base : GUIEnvBasePtr) CreateGUIInfoA *
          (window[8] : I.WindowPtr;
           tags[9] : ARRAY OF U.TagItem) : GUIInfoPtr;  -66;

  LIBCALL (base : GUIEnvBasePtr) CreateGUIInfo *
          (window[8] : I.WindowPtr;
           tags[9].. : U.Tag) : GUIInfoPtr;  -66;

  LIBCALL (base : GUIEnvBasePtr) FreeGUIInfo *
          (gui[8] : GUIInfoPtr);                -72;

  LIBCALL (base : GUIEnvBasePtr) DrawGUIA *
          (gui[8] : GUIInfoPtr;
           tags[9]: ARRAY OF U.TagItem) : INTEGER;        -78;

  LIBCALL (base : GUIEnvBasePtr) DrawGUI *
          (gui[8] : GUIInfoPtr;
           tags[9]..: U.Tag) : INTEGER;        -78;

  LIBCALL (base : GUIEnvBasePtr) ChangeGUIA *
          (gui[8]  : GUIInfoPtr;
           tags[9] : ARRAY OF U.TagItem) : INTEGER;       -84;

  LIBCALL (base : GUIEnvBasePtr) ChangeGUI *
          (gui[8]  : GUIInfoPtr;
           tags[9].. : U.Tag) : INTEGER;       -84;

  LIBCALL (base : GUIEnvBasePtr) CreateGUIGadgetA *
          (gui[8] : GUIInfoPtr;
           left[0] : INTEGER;
           top[1]  : INTEGER;
           width[2]  : INTEGER;
           height[3] : INTEGER;
           kind[4] : LONGINT;
           tags[9] : ARRAY OF U.TagItem);                 -90;

  LIBCALL (base : GUIEnvBasePtr) CreateGUIGadget *
          (gui[8] : GUIInfoPtr;
           left[0] : INTEGER;
           top[1]  : INTEGER;
           width[2]  : INTEGER;
           height[3] : INTEGER;
           kind[4] : LONGINT;
           tags[9].. : U.Tag);                 -90;

  LIBCALL (base : GUIEnvBasePtr) CreateGUIMenuEntryA *
          (gui[8]  : GUIInfoPtr;
           type[0] : SHORTINT;
           text[9] : E.STRPTR;
           tags[10] : ARRAY OF U.TagItem);              -96;

  LIBCALL (base : GUIEnvBasePtr) CreateGUIMenuEntry *
          (gui[8]  : GUIInfoPtr;
           type[0] : SHORTINT;
           text[9] : E.STRPTR;
           tags[10].. : U.Tag);              -96;

  LIBCALL (base : GUIEnvBasePtr) WaitGUIMsg *
          (gui[8] : GUIInfoPtr);                -102;

  LIBCALL (base : GUIEnvBasePtr) GetGUIMsg *
          (gui[8] : GUIInfoPtr) : BOOLEAN;      -108;


  LIBCALL (base : GUIEnvBasePtr) SetGUIGadgetA *
          (gui[8] : GUIInfoPtr;
           nbr[0] : INTEGER;
           tags[9]: ARRAY OF U.TagItem);                  -114;

  LIBCALL (base : GUIEnvBasePtr) SetGUIGadget *
          (gui[8] : GUIInfoPtr;
           nbr[0] : INTEGER;
           tags[9]..: U.Tag);                  -114;

  LIBCALL (base : GUIEnvBasePtr) GetGUIGadget *
          (gui[8] : GUIInfoPtr;
           nbr[0] : INTEGER;
           attr[1]: LONGINT) : LONGINT;           -120;

  LIBCALL (base : GUIEnvBasePtr) GUIGadgetActionA *
          (gui[8] : GUIInfoPtr;
           tags[9]: ARRAY OF U.TagItem);                  -126;

  LIBCALL (base : GUIEnvBasePtr) GUIGadgetAction *
          (gui[8] : GUIInfoPtr;
           tags[9]..: U.Tag);                  -126;

  LIBCALL (base : GUIEnvBasePtr) GUIRequestA *
          (gui[8] : GUIInfoPtr;
           text[9] : E.STRPTR;
           kind[0] : LONGINT;
           tags[10] : ARRAY OF U.TagItem) : LONGINT;    -132;

  LIBCALL (base : GUIEnvBasePtr) GUIRequest *
          (gui[8] : GUIInfoPtr;
           text[9] : E.STRPTR;
           kind[0] : LONGINT;
           tags[10].. : U.Tag) : LONGINT;    -132;

  LIBCALL (base : GUIEnvBasePtr) ShowGuideNodeA *
          (gui[8]   : GUIInfoPtr;
           guide[9] : E.STRPTR;
           node[10] : E.STRPTR;
           tags[11] : ARRAY OF U.TagItem) : INTEGER; -138;

  LIBCALL (base : GUIEnvBasePtr) ShowGuideNode *
          (gui[8]   : GUIInfoPtr;
           guide[9] : E.STRPTR;
           node[10] : E.STRPTR;
           tags[11].. : U.Tag) : INTEGER; -138;

  LIBCALL (base : GUIEnvBasePtr) GetCatStr *
          (gui[8] : GUIInfoPtr;
           str[0] : LONGINT;
           def[9] : E.STRPTR) : E.STRPTR; -144;

  LIBCALL (base : GUIEnvBasePtr) GetLocStr *
          (gui[8] : GUIInfoPtr;
           str[0] : LONGINT;
           def[9] : E.STRPTR) : E.STRPTR; -150;



(* $L- Address globals through A4 *)

PROCEDURE* CloseLib (VAR rc : LONGINT);
BEGIN
  IF base # NIL THEN E.base.CloseLibrary (base) END;
END CloseLib;

PROCEDURE OpenLib * (mustOpen : BOOLEAN);
BEGIN
  IF base = NIL THEN
    base := E.base.OpenLibrary (Name, Version);
    IF base # NIL THEN K.SetCleanup(CloseLib)
    ELSIF mustOpen THEN HALT (100)
    END
  END
END OpenLib;


BEGIN (* GUIEnv *)
  base := NIL;
END GUIEnv.
